#[starknet::interface]
trait ISimpleStorage<T> {
    fn set(ref self: T, x: u128);
    fn get(self: @T) -> u128;
}

#[starknet::contract]
mod SimpleStorage {
    #[storage]
    struct Storage {
        stored_data: u128
    }

    #[abi(embed_v0)]
    impl SimpleStorage of super::ISimpleStorage<ContractState> {
        fn set(ref self: ContractState, x: u128) {
            self.stored_data.write(x);
        }

        fn get(self: @ContractState) -> u128 {
            self.stored_data.read()
        }
    }
}
