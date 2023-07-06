use starknet::ContractAddress;
#[starknet::interface]
trait ICaller<TContractState> {
    fn set_value_from_address(ref self: TContractState, addr: ContractAddress, value: u128);
}

#[starknet::interface]
trait ICallee<TContractState> {
    fn set_value(ref self: TContractState, value: u128) -> u128;
}

#[starknet::contract]
mod Caller {
    use super::{ICalleeDispatcher, ICalleeDispatcherTrait};
    use starknet::ContractAddress;

    #[storage]
    struct Storage {}

    #[external(v0)]
    impl ICallerImpl of super::ICaller<ContractState> {
        fn set_value_from_address(ref self: ContractState, addr: ContractAddress, value: u128) {
            ICalleeDispatcher { contract_address: addr }.set_value(value);
        }
    }
}
