mod tests {
    use hash_solidity_compatible::contract::{SolidityHashExample, ISolidityHashExample};
    use starknet::{contract_address_const, testing::set_contract_address};

    fn setup() -> SolidityHashExample::ContractState {
        let mut state = SolidityHashExample::contract_state_for_testing();
        let contract_address = contract_address_const::<0x1>();
        set_contract_address(contract_address);
        state
    }

    #[test]
    fn get_same_hash_solidity() {
        let mut state = setup();
        let mut array: Array<u256> = array![];
        array.append(1);

        let hash_expected: u256 =
            0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6;
        let hash_received: u256 = state.hash_data(array.span());

        assert_eq!(hash_received, hash_expected);
    }
}
