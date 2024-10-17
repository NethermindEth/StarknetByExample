#[starknet::contract]
pub mod NonReceiverMock {
    #[storage]
    pub struct Storage {}

    #[external(v0)]
    fn nope(self: @ContractState) -> bool {
        false
    }
}
