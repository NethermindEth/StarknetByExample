#[abi]
trait ICallee {
    fn set_x(x: u128) -> u128;
}


#[contract]
mod Caller {
    use super::{ICalleeDispatcher, ICalleeDispatcherTrait};
    use starknet::ContractAddress;

    #[external]
    fn set_x_from_address(addr: ContractAddress, x: u128) {
        let x = ICalleeDispatcher { contract_address: addr }.set_x(x);
    }
}
