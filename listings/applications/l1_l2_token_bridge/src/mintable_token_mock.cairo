#[starknet::contract]
pub mod MintableTokenMock {
    use core::num::traits::Zero;
    use starknet::event::EventEmitter;
    use starknet::{ContractAddress, get_caller_address};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    use l1_l2_token_bridge::contract::IMintableToken;

    #[storage]
    struct Storage {
        // The address of the L2 bridge contract. Only the bridge can
        // invoke burn and mint methods
        bridge: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Minted: Minted,
        Burned: Burned,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Minted {
        pub account: ContractAddress,
        pub amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Burned {
        pub account: ContractAddress,
        pub amount: u256,
    }

    pub mod Errors {
        pub const INVALID_ADDRESS: felt252 = 'Invalid address';
        pub const UNAUTHORIZED: felt252 = 'Unauthorized';
    }

    #[constructor]
    fn constructor(ref self: ContractState, bridge: ContractAddress) {
        assert(bridge.is_non_zero(), Errors::INVALID_ADDRESS);
        self.bridge.write(bridge);
    }

    #[abi(embed_v0)]
    impl MintableTokenMock of IMintableToken<ContractState> {
        fn mint(ref self: ContractState, account: ContractAddress, amount: u256) {
            self._assert_only_bridge();
            self.emit(Minted { account, amount });
        }

        fn burn(ref self: ContractState, account: ContractAddress, amount: u256) {
            self._assert_only_bridge();
            self.emit(Burned { account, amount });
        }
    }

    #[generate_trait]
    impl Internal of InternalTrait {
        fn _assert_only_bridge(self: @ContractState) {
            assert(get_caller_address() == self.bridge.read(), Errors::UNAUTHORIZED);
        }
    }
}
