#[starknet::interface]
trait ITime<TContractState> {
    fn set(ref self: TContractState, value: TimeContract::Time);
    fn get(self: @TContractState) -> TimeContract::Time;
}

#[starknet::contract]
mod TimeContract {
    use starknet::storage_access::StorePacking;
    use integer::{
        U8IntoFelt252, Felt252TryIntoU16, U16DivRem, u16_as_non_zero, U16IntoFelt252,
        Felt252TryIntoU8
    };
    use traits::{Into, TryInto, DivRem};
    use option::OptionTrait;
    use serde::Serde;

    #[storage]
    struct Storage {
        time: Time
    }

    #[derive(Copy, Serde, Drop)]
    struct Time {
        hour: u8,
        minute: u8
    }

    impl TimePackable of StorePacking<Time, felt252> {
        fn pack(value: Time) -> felt252 {
            let msb: felt252 = 256 * value.hour.into();
            let lsb: felt252 = value.minute.into();
            return msb + lsb;
        }
        fn unpack(value: felt252) -> Time {
            let value: u16 = value.try_into().unwrap();
            let (q, r) = U16DivRem::div_rem(value, u16_as_non_zero(256));
            let hour: u8 = Into::<u16, felt252>::into(q).try_into().unwrap();
            let minute: u8 = Into::<u16, felt252>::into(r).try_into().unwrap();
            return Time { hour, minute };
        }
    }

    #[abi(embed_v0)]
    impl TimeContract of super::ITime<ContractState> {
        fn set(ref self: ContractState, value: Time) {
            // This will call the pack method of the TimePackable trait
            // and store the resulting felt252
            self.time.write(value);
        }
        fn get(self: @ContractState) -> Time {
            // This will read the felt252 value from storage
            // and return the result of the unpack method of the TimePackable trait
            return self.time.read();
        }
    }
}
