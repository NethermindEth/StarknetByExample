mod tests {
    use hash_solidity_compatible::{
        hash_solidity_compatible::{SolidityHashExample, ISolidityHashExample}
    };
    use debug::PrintTrait;

    use starknet::{
        ContractAddress, get_contract_address, contract_address_const, call_contract_syscall,
        testing::{set_contract_address}
    };

    fn setup() -> SolidityHashExample::ContractState {
        let mut state = SolidityHashExample::contract_state_for_testing();
        let contract_address = contract_address_const::<0x1>();
        set_contract_address(contract_address);
        state
    }

    #[test]
    #[available_gas(2000000000)]
    fn get_same_hash_solidity() {
        let mut state = setup();
        let mut array: Array<u256> = ArrayTrait::new();
        array.append(1);

        let hashExpected: u256 = 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6;

        let hash = state.hash_data(array.span());
        let hashReceived: u256 = state.get_hashed_value();

        assert(hashReceived == hashExpected, 'hashReceived != hashExpected');
    }
}
