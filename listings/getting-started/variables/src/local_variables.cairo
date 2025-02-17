// [!region contract]
#[starknet::contract]
mod LocalVariablesContract {
    #[storage]
    struct Storage {}

    pub fn do_something(value: u32) -> u32 {
        // This variable is local to the current block.
        // It can't be accessed once it goes out of scope.
        let increment = 10;

        {
            // The scope of a code block allows for local variable declaration
            // We can access variables defined in higher scopes.
            let sum = value + increment;
            sum
        }
        // We can't access the variable `sum` here, as it's out of scope.
    }
}
// [!endregion contract]

#[cfg(test)]
mod test {
    use super::LocalVariablesContract::do_something;

    #[test]
    fn test_can_do_something() {
        let value = 10;
        assert_eq!(do_something(value), value + 10);
    }
}
