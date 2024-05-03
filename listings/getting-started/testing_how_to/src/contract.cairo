// ANCHOR: contract
#[starknet::interface]
pub trait ISimpleContract<TContractState> {
    fn get_value(self: @TContractState) -> u32;
    fn get_owner(self: @TContractState) -> starknet::ContractAddress;
    fn set_value(ref self: TContractState, value: u32);
}

#[starknet::contract]
pub mod SimpleContract {
    use starknet::{get_caller_address, ContractAddress};

    #[storage]
    struct Storage {
        value: u32,
        owner: ContractAddress
    }

    #[constructor]
    pub fn constructor(ref self: ContractState, initial_value: u32) {
        self.value.write(initial_value);
        self.owner.write(get_caller_address());
    }

    #[abi(embed_v0)]
    pub impl SimpleContractImpl of super::ISimpleContract<ContractState> {
        fn get_value(self: @ContractState) -> u32 {
            self.value.read()
        }

        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }

        fn set_value(ref self: ContractState, value: u32) {
            assert(self.owner.read() == get_caller_address(), 'Not owner');
            self.value.write(value);
        }
    }
}
// ANCHOR_END: contract

// ANCHOR: tests
#[cfg(test)]
mod tests {
    // Import the interface and dispatcher to be able to interact with the contract.
    use super::{SimpleContract, ISimpleContractDispatcher, ISimpleContractDispatcherTrait};

    // Import the deploy syscall to be able to deploy the contract.
    use starknet::{SyscallResultTrait, syscalls::deploy_syscall};
    use starknet::{
        ContractAddress, get_caller_address, get_contract_address, contract_address_const
    };

    // Use starknet test utils to fake the contract_address
    use starknet::testing::set_contract_address;

    // Deploy the contract and return its dispatcher.
    fn deploy(initial_value: u32) -> ISimpleContractDispatcher {
        // Declare and deploy
        let (contract_address, _) = deploy_syscall(
            SimpleContract::TEST_CLASS_HASH.try_into().unwrap(),
            0,
            array![initial_value.into()].span(),
            false
        )
            .unwrap_syscall();

        // Return the dispatcher.
        // The dispatcher allows to interact with the contract based on its interface.
        ISimpleContractDispatcher { contract_address }
    }

    #[test]
    fn test_deploy() {
        let initial_value: u32 = 10;
        let contract = deploy(initial_value);

        assert_eq!(contract.get_value(), initial_value);
        assert_eq!(contract.get_owner(), get_contract_address());
    }

    #[test]
    fn test_set_as_owner() {
        // Fake the contract address to owner
        let owner = contract_address_const::<'owner'>();
        set_contract_address(owner);

        // When deploying the contract, the owner is the caller.
        let contract = deploy(10);
        assert_eq!(contract.get_owner(), owner);

        // As the current caller is the owner, the value can be set.
        let new_value: u32 = 20;
        contract.set_value(new_value);

        assert_eq!(contract.get_value(), new_value);
    }

    #[test]
    #[should_panic]
    fn test_set_not_owner() {
        let owner = contract_address_const::<'owner'>();
        set_contract_address(owner);
        let contract = deploy(10);

        // Fake the contract address to another address
        let not_owner = contract_address_const::<'not owner'>();
        set_contract_address(not_owner);

        // As the current caller is not the owner, the value cannot be set.
        let new_value: u32 = 20;
        contract.set_value(new_value);
    // Panic expected
    }

    #[test]
    #[available_gas(150000)]
    fn test_deploy_gas() {
        deploy(10);
    }
}
// ANCHOR_END: tests

// ANCHOR: tests_with_state
#[cfg(test)]
mod tests_with_states {
    // Only import the contract
    use super::SimpleContract;

    // For accessing storage variables and entrypoints,
    // we must import the contract member state traits and implementation.
    use SimpleContract::{
        SimpleContractImpl, valueContractMemberStateTrait, ownerContractMemberStateTrait
    };

    use starknet::contract_address_const;
    use starknet::testing::set_caller_address;
    use core::num::traits::Zero;

    #[test]
    fn test_standalone_state() {
        let mut state = SimpleContract::contract_state_for_testing();

        // As no contract was deployed, the constructor was not called on the state
        // - with valueContractMemberStateTrait
        assert_eq!(state.value.read(), 0);
        // - with SimpleContractImpl 
        assert_eq!(state.get_value(), 0);
        assert_eq!(state.owner.read(), Zero::zero());

        // We can still directly call the constructor to initialize the state.
        let owner = contract_address_const::<'owner'>();
        // We are not setting the contract address but the caller address here,
        // as we are not deploying the contract but directly calling the constructor function.
        set_caller_address(owner);

        let initial_value: u32 = 10;
        SimpleContract::constructor(ref state, initial_value);
        assert_eq!(state.get_value(), initial_value);
        assert_eq!(state.get_owner(), owner);

        // As the current caller is the owner, the value can be set.
        let new_value: u32 = 20;
        state.set_value(new_value);
        assert_eq!(state.get_value(), new_value);
    }

    // But we can also deploy the contract and interact with it using the dispatcher
    // as shown in the previous tests, and still use the state for testing.
    use super::{ISimpleContractDispatcher, ISimpleContractDispatcherTrait};
    use starknet::{
        ContractAddress, SyscallResultTrait, syscalls::deploy_syscall, testing::set_contract_address
    };

    #[test]
    fn test_state_with_contract() {
        let owner = contract_address_const::<'owner'>();
        let not_owner = contract_address_const::<'not owner'>();

        // Deploy as owner
        let initial_value: u32 = 10;
        set_contract_address(owner);
        let (contract_address, _) = deploy_syscall(
            SimpleContract::TEST_CLASS_HASH.try_into().unwrap(),
            0,
            array![initial_value.into()].span(),
            false
        )
            .unwrap_syscall();
        let mut contract = ISimpleContractDispatcher { contract_address };

        // create the state
        // - Set back as not owner
        set_contract_address(not_owner);
        let mut state = SimpleContract::contract_state_for_testing();
        // - Currently, the state is not 'linked' to the contract
        assert_ne!(state.get_value(), initial_value);
        assert_ne!(state.get_owner(), owner);
        // - Link the state to the contract by setting the contract address
        set_contract_address(contract.contract_address);
        assert_eq!(state.get_value(), initial_value);
        assert_eq!(state.get_owner(), owner);

        // Mutating the state from the contract change the testing state
        set_contract_address(owner);
        let new_value: u32 = 20;
        contract.set_value(new_value);
        set_contract_address(contract.contract_address);
        assert_eq!(state.get_value(), new_value);

        // Mutating the state from the testing state change the contract state
        set_caller_address(owner);
        state.set_value(initial_value);
        assert_eq!(contract.get_value(), initial_value);

        // Directly mutating the state allows to change state
        // in ways that are not allowed by the contract, such as changing the owner.
        let new_owner = contract_address_const::<'new owner'>();
        state.owner.write(new_owner);
        assert_eq!(contract.get_owner(), new_owner);

        set_caller_address(new_owner);
        state.set_value(new_value);
        assert_eq!(contract.get_value(), new_value);
    }
}
// ANCHOR_END: tests


