// [!region contract]
#[starknet::contract]
fn add_numbers(a: felt252, b: felt252) -> felt252 {
    let sum = a + b;
    sum
}
// [!endregion contract]
