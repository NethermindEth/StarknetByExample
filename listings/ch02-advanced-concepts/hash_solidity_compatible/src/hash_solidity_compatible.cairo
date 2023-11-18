#[starknet::interface]
trait ISolidityHashExample<TContractState> {
    fn hash_data(ref self: TContractState, input_data: Span<u256>);
    fn get_hashed_value(self: @TContractState) -> u256;
}


#[starknet::contract]
mod SolidityHashExample {
    use keccak::{keccak_u256s_be_inputs};
    use array::Span;

    #[storage]
    struct Storage {
        hash_value: u256,
    }

    #[abi(embed_v0)]
    impl SolidityHashExample of super::ISolidityHashExample<ContractState> {
        fn hash_data(ref self: ContractState, input_data: Span<u256>) {
            let hashed = keccak_u256s_be_inputs(input_data);

            // Split the hashed value into two 128-bit segments
            let low: u128 = hashed.low;
            let high: u128 = hashed.high;

            // Reverse each 128-bit segment
            let reversed_low = integer::u128_byte_reverse(low);
            let reversed_high = integer::u128_byte_reverse(high);

            // Reverse merge the reversed segments back into a u256 value
            let compatible_hash = u256 {low: reversed_high, high: reversed_low};

            self.hash_value.write(compatible_hash);
        }

        fn get_hashed_value(self: @ContractState) -> u256 {
            self.hash_value.read()
        }
    }
}
