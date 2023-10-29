#[starknet::contract]
mod typecasting_Example {
    use core::traits::Into;
    use traits::TryInto;
    use option::OptionTrait;

    #[storage]
    struct Storage {}


    #[external(v0)]
    #[generate_trait]
    impl external of externlalTrait {
        fn typeCasting(self: @ContractState, randNumber: u32) {
            let my_felt252 = 15;

            // Since a u32 might not fit in a u8 and a u16, we need to use try_into,
            // then unwrap the Option<T> type thats returned.
            let new_u8: u8 = randNumber.try_into().unwrap();
            let new_u16: u16 = randNumber.try_into().unwrap();

            let new_u32: u32 = randNumber;
            let new_u64: u64 = randNumber.into();
            let new_u128: u128 = randNumber.into();

            // Since a felt252 is smaller than a u256, we can use the into() method
            let new_u256: u256 = my_felt252.into();
            let new_felt252: felt252 = new_u16.into();

            //note a usize is smaller than a felt so we use the try_into
            let new_usize: usize = my_felt252.try_into().unwrap();

        }
    }
}
