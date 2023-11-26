#[starknet::interface]
trait ILoopExample<TContractState> {
    fn gather_evens(ref self: TContractState, maxLimit: u32) -> Array<u32>;
}

#[starknet::contract]
mod LoopExample {
    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl External of super::ILoopExample<ContractState> {
        fn gather_evens(ref self: ContractState, maxLimit: u32) -> Array<u32> {
            let mut i: u32 = 0;
            let mut arr = ArrayTrait::new();
            loop {
                if i == maxLimit {
                    break;
                };
                if (i % 2 == 0) {
                    arr.append(i);
                }
                i += 1;
            };

            return arr;
        }
    }
}
