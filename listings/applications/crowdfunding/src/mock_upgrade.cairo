#[starknet::contract]
pub mod MockContract {
    #[storage]
    struct Storage {}
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}
}
