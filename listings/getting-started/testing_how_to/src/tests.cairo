#[cfg(test)]
mod tests {
    // Import the interface and dispatcher to be able to interact with the contract.
    use testing_how_to::contract::{
        ISimpleContract, SimpleContract, ISimpleContractDispatcher, ISimpleContractDispatcherTrait
    };

    // Import the deploy syscall to be able to deploy the contract.
    use starknet::{
        ContractAddress, get_caller_address, get_contract_address, contract_address_const
    };
    use starknet::SyscallResultTrait;
    use starknet::syscalls::deploy_syscall;

    // Use starknet test utils to fake the transaction context.
    use starknet::testing::{set_caller_address, set_contract_address};

    // Deploy the contract and return its dispatcher.
    fn deploy(initial_value: u32) -> ISimpleContractDispatcher {
        // Set up constructor arguments.
        let mut calldata = array![];
        initial_value.serialize(ref calldata);

        // Declare and deploy
        let (contract_address, _) = deploy_syscall(
            SimpleContract::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap_syscall();

        // Return the dispatcher.
        // The dispatcher allows to interact with the contract based on its interface.
        ISimpleContractDispatcher { contract_address }
    }

    #[test]
    #[available_gas(2000000000)]
    fn test_deploy() {
        let initial_value: u32 = 10;
        let contract = deploy(initial_value);

        assert(contract.get_value() == initial_value, 'wrong initial value');
        assert(contract.get_owner() == get_contract_address(), 'wrong owner');
    }

    #[test]
    #[available_gas(2000000000)]
    fn test_set_as_owner() {
        // Fake the caller address to address 1
        let owner = contract_address_const::<1>();
        set_contract_address(owner);

        let contract = deploy(10);
        assert(contract.get_owner() == owner, 'wrong owner');

        // Fake the contract address to address 1
        set_contract_address(owner);
        let new_value: u32 = 20;
        contract.set_value(new_value);

        assert(contract.get_value() == new_value, 'wrong value');
    }

    #[test]
    #[should_panic]
    #[available_gas(2000000000)]
    fn test_set_not_owner() {
        let owner = contract_address_const::<1>();
        set_contract_address(owner);

        let contract = deploy(10);

        let not_owner = contract_address_const::<2>();
        set_contract_address(not_owner);

        let new_value: u32 = 20;
        contract.set_value(new_value);
    }
}
