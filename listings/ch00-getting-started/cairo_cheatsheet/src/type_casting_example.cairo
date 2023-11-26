use starknet::ContractAddress;

#[starknet::interface]
trait ITypecastingExample<TContractState> {
    fn type_casting(self: @TContractState, rand_number: u32);
}
#[starknet::contract]
mod TypecastingExample {
    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl External of super::ITypecastingExample<ContractState> {
        fn type_casting(self: @ContractState, rand_number: u32) {
            let my_felt252 = 15;

            // Since a u32 might not fit in a u8 and a u16, we need to use try_into,
            // then unwrap the Option<T> type thats returned.
            let new_u8: u8 = rand_number.try_into().unwrap();
            let new_u16: u16 = rand_number.try_into().unwrap();

            // since new_u32 is the of the same type (u32) as rand_number, we can directly assign them,
            // or use the .into() method.
            let new_u32: u32 = rand_number;

            // When typecasting from a smaller size to an equal or larger size we use the .into() method.
            // Note: u64 and u128 are larger than u32, so a u32 type will always fit into them.
            let new_u64: u64 = rand_number.into();
            let new_u128: u128 = rand_number.into();

            // Since a felt252 is smaller than a u256, we can use the into() method
            let new_u256: u256 = my_felt252.into();
            let new_felt252: felt252 = new_u16.into();

            //note a usize is smaller than a felt so we use the try_into
            let new_usize: usize = my_felt252.try_into().unwrap();
        }
    }
}
