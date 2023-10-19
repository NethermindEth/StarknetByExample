use starknet::ContractAddress;

// We need to have the interface of the callee contract defined
// so that we can import the Dispatcher.
#[starknet::interface]
trait ICallee<TContractState> {
    fn set_value(ref self: TContractState, value: u128) -> u128;
}

#[starknet::contract]
mod Caller {
    // We import the Dispatcher of the called contract
    use super::{ICalleeDispatcher, ICalleeDispatcherTrait};
    use starknet::ContractAddress;

    #[storage]
    struct Storage {}

    #[abi(per_item)]
    #[generate_trait]
    impl ICallerImpl of ICaller {
        fn set_value_from_address(ref self: ContractState, addr: ContractAddress, value: u128) {
            ICalleeDispatcher { contract_address: addr }.set_value(value);
        }
    }
}
