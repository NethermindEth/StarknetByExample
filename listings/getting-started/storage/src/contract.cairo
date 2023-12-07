#[starknet::contract]
mod Contract {
    #[storage]
    struct Storage {
        a: u128,
        b: u8,
        c: u256
    }
}
