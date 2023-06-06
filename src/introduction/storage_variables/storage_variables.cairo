#[contract]
mod StorageExample {
    // All storage variables are contained in a struct called Storage
    struct Storage {
        // Storage variable holding a number
        _value: u32
    }

    #[external]
    // You can write to storage variables by sending a transaction that
    // calls an external function
    fn set(value: u32) {
        _value::write(value);
    }

    #[view]
    // You can read from storage variables without sending transactions. 
    fn get() -> u32 {
        _value::read()
    }
}