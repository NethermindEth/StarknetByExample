use starknet::ContractAddress;

#[starknet::interface]
pub trait ITokenBridge<TContractState> {
}

#[starknet::contract]
pub mod TokenBridge {
    use core::num::traits::zero::Zero;
    use starknet::{ContractAddress, get_caller_address, get_contract_address,};
    use starknet::storage::{
        Map, StoragePointerReadAccess, StoragePathEntry, StoragePointerWriteAccess
    };
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

    #[storage]
    struct Storage {
       
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Flipped: Flipped,
        Landed: Landed,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Flipped {
        pub flip_id: u64,
        pub flipper: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Landed {
        pub flip_id: u64,
        pub flipper: ContractAddress,
        pub side: Side
    }

    #[derive(Drop, Debug, PartialEq, Serde)]
    pub enum Side {
        Heads,
        Tails,
    }

    pub mod Errors {
        pub const INVALID_ADDRESS: felt252 = 'Invalid address';
        pub const TRANSFER_FAILED: felt252 = 'Transfer failed';
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
    ) {
        // self.eth_dispatcher.write(IERC20Dispatcher { contract_address: eth_address });
    }

    #[abi(embed_v0)]
    impl TokenBridge of super::ITokenBridge<ContractState> {
        
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        
    }
}
