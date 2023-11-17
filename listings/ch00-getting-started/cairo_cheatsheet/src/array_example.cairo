#[starknet::contract]
mod arrayExample {
    #[storage]
    struct Storage {}


    #[external(v0)]
    #[generate_trait]
    impl external of externalTrait {
        fn createArray(self: @ContractState, numOne: u32, numTwo: u32, numThree: u32) -> bool {
            let mut Arr = ArrayTrait::<u32>::new();
            Arr.append(numOne);
            Arr.append(numTwo);
            Arr.append(numThree);

            let ArrLength: usize = Arr.len();
            assert(ArrLength == 3, 'Array Length should be 3');

            let first_value = Arr.pop_front().unwrap();
            assert(first_value == numOne, 'Both values should match');

            let second_value = *Arr.at(0);
            assert(second_value == numTwo, 'Both values should match too');

            //Returns true if an array is empty, then false if it isn't.
            Arr.is_empty()
        }
    }
}
