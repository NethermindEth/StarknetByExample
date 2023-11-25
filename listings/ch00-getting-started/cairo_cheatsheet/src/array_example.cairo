#[starknet::interface]
trait IArrayExample<TContractState> {
    fn createarray(self: @TContractState, num_one: u32, num_two: u32, num_three: u32) -> bool;
}

#[starknet::contract]
mod ArrayExample {
    #[storage]
    struct Storage {}


    #[abi(embed_v0)]
    impl External of super::IArrayExample<ContractState> {
        fn createarray(self: @ContractState, num_one: u32, num_two: u32, num_three: u32) -> bool {
            let mut arr = ArrayTrait::<u32>::new();
            arr.append(num_one);
            arr.append(num_two);
            arr.append(num_three);

            assert(arr.len() == 3, 'array length should be 3');

            let first_value = arr.pop_front().unwrap();
            assert(first_value == num_one, 'first value should match');

            let second_value = *arr.at(0);
            assert(second_value == num_two, 'second value should match');

            //Returns true if an array is empty, then false if it isn't.
            arr.is_empty()
        }
    }
}
