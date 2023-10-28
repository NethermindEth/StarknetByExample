#[starknet::contract]
mod loopExample {

use array::ArrayTrait;

    #[storage]
    struct Storage {}


    #[external(v0)]
    #[generate_trait]
    impl external of externlalTrait {

        fn merryGoRound(ref self: ContractState, maxLimit: u32) -> Array<u32> {
            let mut i: u32 = 0;
            let mut Arr = ArrayTrait::new();
            loop {
                if i == maxLimit {
                    break;
                };
                if (i % 2 == 0) {
                    Arr.append(i);
                }
                i += 1; 
            };

            return Arr;

        }
    }
}
