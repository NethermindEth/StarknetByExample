#[derive(Copy, Serde, Drop)]
pub struct Time {
    pub hour: u8,
    pub minute: u8
}

#[starknet::interface]
pub trait ITime<TContractState> {
    fn set(ref self: TContractState, value: Time);
    fn get(self: @TContractState) -> Time;
}

#[starknet::contract]
pub mod TimeContract {
    use super::Time;
    use starknet::storage_access::StorePacking;
    use core::traits::{Into, TryInto, DivRem};
    use core::option::OptionTrait;
    use core::serde::Serde;

    #[storage]
    struct Storage {
        time: Time
    }

    impl TimePackable of StorePacking<Time, felt252> {
        fn pack(value: Time) -> felt252 {
            let msb: felt252 = 256 * value.hour.into();
            let lsb: felt252 = value.minute.into();
            return msb + lsb;
        }
        fn unpack(value: felt252) -> Time {
            let value: u16 = value.try_into().unwrap();
            let (q, r) = DivRem::div_rem(value, 256_u16.try_into().unwrap());
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
