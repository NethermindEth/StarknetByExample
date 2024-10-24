use starknet::ContractAddress;
use starknet::account::Call;

#[starknet::interface]
pub trait ITimeLock<TState> {
    fn get_tx_id(self: @TState, call: Call, timestamp: u64) -> felt252;
    fn queue(ref self: TState, call: Call, timestamp: u64) -> felt252;
    fn execute(ref self: TState, call: Call, timestamp: u64) -> Span<felt252>;
    fn cancel(ref self: TState, tx_id: felt252);
}

#[starknet::contract]
pub mod TimeLock {
    use core::poseidon::{PoseidonTrait, poseidon_hash_span};
    use core::hash::{HashStateTrait, HashStateExTrait};
    use starknet::{
        ContractAddress, get_caller_address, get_block_timestamp, SyscallResultTrait, syscalls
    };
    use starknet::account::Call;
    use components::ownable::ownable_component;

    component!(path: ownable_component, storage: ownable, event: OwnableEvent);

    // Ownable
    #[abi(embed_v0)]
    impl OwnableImpl = ownable_component::Ownable<ContractState>;
    impl OwnableInternalImpl = ownable_component::OwnableInternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: ownable_component::Storage,
        queued: LegacyMap::<felt252, bool>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        #[flat]
        OwnableEvent: ownable_component::Event,
        Queue: Queue,
        Execute: Execute,
        Cancel: Cancel
    }

    #[derive(Drop, starknet::Event)]
    pub struct Queue {
        #[key]
        pub tx_id: felt252,
        pub call: Call,
        pub timestamp: u64
    }

    #[derive(Drop, starknet::Event)]
    pub struct Execute {
        #[key]
        pub tx_id: felt252,
        pub call: Call,
        pub timestamp: u64
    }

    #[derive(Drop, starknet::Event)]
    pub struct Cancel {
        #[key]
        pub tx_id: felt252
    }

    pub const MIN_DELAY: u64 = 10; // seconds
    pub const MAX_DELAY: u64 = 1000; // seconds
    pub const GRACE_PERIOD: u64 = 1000; // seconds

    pub mod Errors {
        pub const ALREADY_QUEUED: felt252 = 'TimeLock: already queued';
        pub const TIMESTAMP_NOT_IN_RANGE: felt252 = 'TimeLock: timestamp range';
        pub const NOT_QUEUED: felt252 = 'TimeLock: not queued';
        pub const TIMESTAMP_NOT_PASSED: felt252 = 'TimeLock: timestamp not passed';
        pub const TIMESTAMP_EXPIRED: felt252 = 'TimeLock: timestamp expired';
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.ownable._init(get_caller_address());
    }

    #[abi(embed_v0)]
    impl TimeLockImpl of super::ITimeLock<ContractState> {
        fn get_tx_id(self: @ContractState, call: Call, timestamp: u64) -> felt252 {
            PoseidonTrait::new()
                .update(call.to.into())
                .update(call.selector.into())
                .update(poseidon_hash_span(call.calldata))
                .update(timestamp.into())
                .finalize()
        }

        fn queue(ref self: ContractState, call: Call, timestamp: u64) -> felt252 {
            self.ownable._assert_only_owner();

            let tx_id = self.get_tx_id(self._copy_call(@call), timestamp);
            assert(!self.queued.read(tx_id), Errors::ALREADY_QUEUED);
            // ---|------------|---------------|-------
            //  block    block + min     block + max
            let block_timestamp = get_block_timestamp();
            assert(
                timestamp >= block_timestamp
                    + MIN_DELAY && timestamp <= block_timestamp
                    + MAX_DELAY,
                Errors::TIMESTAMP_NOT_IN_RANGE
            );

            self.queued.write(tx_id, true);
            self.emit(Queue { tx_id, call: self._copy_call(@call), timestamp });

            tx_id
        }

        fn execute(ref self: ContractState, call: Call, timestamp: u64) -> Span<felt252> {
            self.ownable._assert_only_owner();

            let tx_id = self.get_tx_id(self._copy_call(@call), timestamp);
            assert(self.queued.read(tx_id), Errors::NOT_QUEUED);
            // ----|-------------------|-------
            //  timestamp    timestamp + grace period
            let block_timestamp = get_block_timestamp();
            assert(block_timestamp >= timestamp, Errors::TIMESTAMP_NOT_PASSED);
            assert(block_timestamp <= timestamp + GRACE_PERIOD, Errors::TIMESTAMP_EXPIRED);

            self.queued.write(tx_id, false);

            let result = syscalls::call_contract_syscall(call.to, call.selector, call.calldata)
                .unwrap_syscall();

            self.emit(Execute { tx_id, call: self._copy_call(@call), timestamp });

            result
        }

        fn cancel(ref self: ContractState, tx_id: felt252) {
            self.ownable._assert_only_owner();

            assert(self.queued.read(tx_id), Errors::NOT_QUEUED);

            self.queued.write(tx_id, false);

            self.emit(Cancel { tx_id });
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn _copy_call(self: @ContractState, call: @Call) -> Call {
            Call { to: *call.to, selector: *call.selector, calldata: *call.calldata }
        }
    }
}
