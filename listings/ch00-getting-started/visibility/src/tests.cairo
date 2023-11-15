// The purpose of these tests is to demonstrate the capability to store custom types in the contract's state.

mod tests {
    use visibility::{visibility::{IExampleContract, ExampleContract}};

    use starknet::{ContractAddress, get_contract_address, contract_address_const, call_contract_syscall, testing::{set_contract_address}};

    fn setup() -> ExampleContract::ContractState {
        let mut state = ExampleContract::contract_state_for_testing();
        let contract_address = contract_address_const::<0x1>();
        set_contract_address(contract_address);
        state
    }

    #[test]
    #[available_gas(2000000000)]
    fn can_call_set_and_get() {
        let mut state = setup();
        let init_value: u32 = 42;
        state.set(init_value);
        let received_value = state.get();

        assert(received_value == init_value, 'wrong value received');
    }


    #[test]
    #[should_panic]
    #[available_gas(2000000000)]
    fn cannot_call_private_read() {
        let mut state = setup();
        let init_value: u32 = 42;
        let contract_address = contract_address_const::<0x1>();
        let mut call_data: Array<felt252> = ArrayTrait::new();
        let mut res = starknet::call_contract_syscall(contract_address, selector!("_read_value"), call_data.span());
    }
}
