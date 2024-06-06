// ANCHOR: contract
pub use starknet::{ContractAddress, ClassHash};

#[starknet::interface]
pub trait ICounterFactory<TContractState> {
    /// Create a new counter contract from stored arguments
    fn create_counter(ref self: TContractState) -> ContractAddress;

    /// Create a new counter contract from the given arguments
    fn create_counter_at(ref self: TContractState, init_value: u128) -> ContractAddress;

    /// Update the argument
    fn update_init_value(ref self: TContractState, new_init_value: u128);

    /// Update the class hash of the Counter contract to deploy when creating a new counter
    fn update_counter_class_hash(ref self: TContractState, new_class_hash: ClassHash);
}

#[starknet::contract]
pub mod CounterFactory {
    use components::ownable::ownable_component::OwnableInternalTrait;
    use core::starknet::event::EventEmitter;
    use starknet::{
        ContractAddress, ClassHash, SyscallResultTrait, syscalls::deploy_syscall, get_caller_address
    };
    use components::ownable::ownable_component;

    component!(path: ownable_component, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = ownable_component::Ownable<ContractState>;
    impl OwnableInternalImpl = ownable_component::OwnableInternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: ownable_component::Storage,
        /// Store the constructor arguments of the contract to deploy
        init_value: u128,
        /// Store the class hash of the contract to deploy
        counter_class_hash: ClassHash,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        #[flat]
        OwnableEvent: ownable_component::Event,
        ClassHashUpdated: ClassHashUpdated,
        CounterCreated: CounterCreated,
        InitValueUpdated: InitValueUpdated,
    }

    #[derive(Drop, starknet::Event)]
    struct ClassHashUpdated {
        previous_class_hash: ClassHash,
        new_class_hash: ClassHash,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterCreated {
        caller: ContractAddress,
        deployed_address: ContractAddress
    }

    #[derive(Drop, starknet::Event)]
    struct InitValueUpdated {
        previous_init_value: u128,
        new_init_value: u128,
    }

    #[constructor]
    fn constructor(ref self: ContractState, init_value: u128, class_hash: ClassHash) {
        self.init_value.write(init_value);
        self.counter_class_hash.write(class_hash);
        self.ownable._init(get_caller_address());
    }

    #[abi(embed_v0)]
    impl Factory of super::ICounterFactory<ContractState> {
        // ANCHOR: deploy
        fn create_counter_at(ref self: ContractState, init_value: u128) -> ContractAddress {
            // Contructor arguments
            let mut constructor_calldata: Array::<felt252> = array![init_value.into()];

            // Contract deployment
            let (deployed_address, _) = deploy_syscall(
                self.counter_class_hash.read(), 0, constructor_calldata.span(), false
            )
                .unwrap_syscall();

            let caller = get_caller_address();
            self.emit(Event::CounterCreated(CounterCreated { caller, deployed_address }));

            deployed_address
        }
        // ANCHOR_END: deploy

        fn create_counter(ref self: ContractState) -> ContractAddress {
            self.create_counter_at(self.init_value.read())
        }

        fn update_init_value(ref self: ContractState, new_init_value: u128) {
            self.ownable._assert_only_owner();
            let previous_init_value = self.init_value.read();
            self.init_value.write(new_init_value);
            self
                .emit(
                    Event::InitValueUpdated(
                        InitValueUpdated { previous_init_value, new_init_value }
                    )
                );
        }

        fn update_counter_class_hash(ref self: ContractState, new_class_hash: ClassHash) {
            self.ownable._assert_only_owner();
            let previous_class_hash = self.counter_class_hash.read();
            self.counter_class_hash.write(new_class_hash);
            self
                .emit(
                    Event::ClassHashUpdated(
                        ClassHashUpdated { previous_class_hash, new_class_hash }
                    )
                );
        }
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod tests;
mod campaign;