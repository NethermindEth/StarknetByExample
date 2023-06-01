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
    // You can read from storage variables by calling a view function.
    // You don't have to send a transaction for this.
    fn get() -> u32 {
        _value::read()
    }
}
