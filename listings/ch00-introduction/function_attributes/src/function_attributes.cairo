#[contract]
mod FunctionAttributes {

    struct Storage {
        _value: u32
    }

    // The `set` function is marked as external because it writes to storage (_value)
    // and can be called from outside the contract
    #[external]
    fn set(value: u32) {
        _value::write(value);
    }

    // The `get` function is marked as view because it doesn't write to storage
    // and can be called from outside the contrac
    #[view]
    fn get() -> u32 {
        // We can call an internal function from any functions within the contract
        _read_value()
    }

    // The `_read_value` function doesn't have any attributes, so it's an internal function
    // and can only be called from within the contract
    fn _read_value() -> u32 {
        _value::read()
    }

}
