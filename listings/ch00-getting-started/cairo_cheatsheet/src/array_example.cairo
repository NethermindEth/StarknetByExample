#[starknet::contract]
mod arrayExample {
use option::OptionTrait;
use array::ArrayTrait;

    #[storage]
    struct Storage {}


    #[external(v0)]
    #[generate_trait]
    impl external of externlalTrait {

        fn createArray(self: @ContractState, numOne: u32, numTwo: u32, numThree: u32) -> bool {
            let mut Arr = ArrayTrait::<u32>::new();
            Arr.append(numOne);
            Arr.append(numTwo);
            Arr.append(numThree);

            let ArrLength: usize = Arr.len();
            let first_value = Arr.pop_front().unwrap();
            let second_value = *Arr.at(0);
            Arr.is_empty()
        }
    }
}
