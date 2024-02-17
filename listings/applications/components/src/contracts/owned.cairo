// ANCHOR: contract
#[starknet::interface]
pub trait IOwned<TContractState> {
    fn do_something(ref self: TContractState);
}

#[starknet::contract]
pub mod OwnedContract {
    use components::ownable::{IOwnable, ownable_component, ownable_component::OwnableInternalTrait};

    component!(path: ownable_component, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = ownable_component::Ownable<ContractState>;
    impl OwnableInternalImpl = ownable_component::OwnableInternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: ownable_component::Storage,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.ownable._init(starknet::get_caller_address());
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        OwnableEvent: ownable_component::Event,
    }

    #[abi(embed_v0)]
    impl Owned of super::IOwned<ContractState> {
        fn do_something(ref self: ContractState) {
            self.ownable._assert_only_owner();
        // ...
        }
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod tests {
    use core::num::traits::Zero;
    use super::{OwnedContract, IOwnedDispatcher, IOwnedDispatcherTrait};
    use components::ownable::{IOwnable, IOwnableDispatcher, IOwnableDispatcherTrait};

    use starknet::{contract_address_const, ContractAddress};
    use starknet::testing::{set_caller_address, set_contract_address};
    use starknet::storage::StorageMemberAccessTrait;
    use starknet::SyscallResultTrait;
    use starknet::syscalls::deploy_syscall;

    fn deploy() -> (IOwnedDispatcher, IOwnableDispatcher) {
        let (contract_address, _) = deploy_syscall(
            OwnedContract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();

        (IOwnedDispatcher { contract_address }, IOwnableDispatcher { contract_address },)
    }

    #[test]
    #[available_gas(2000000)]
    fn test_init() {
        let owner = contract_address_const::<'owner'>();
        set_contract_address(owner);
        let (_, ownable) = deploy();

        assert(ownable.owner() == owner, 'wrong_owner');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_wrong_owner() {
        set_contract_address(contract_address_const::<'owner'>());
        let (_, ownable) = deploy();

        let not_owner = contract_address_const::<'not_owner'>();
        assert(ownable.owner() != not_owner, 'wrong_owner');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_do_something() {
        set_contract_address(contract_address_const::<'owner'>());
        let (contract, _) = deploy();

        contract.do_something();
    // Should not panic
    }

    #[test]
    #[available_gas(2000000)]
    #[should_panic]
    fn test_do_something_not_owner() {
        set_contract_address(contract_address_const::<'owner'>());
        let (contract, _) = deploy();

        set_contract_address(contract_address_const::<'not_owner'>());
        contract.do_something();
    }

    #[test]
    #[available_gas(2000000)]
    fn test_transfer_ownership() {
        set_contract_address(contract_address_const::<'initial'>());
        let (contract, ownable) = deploy();

        let new_owner = contract_address_const::<'new_owner'>();
        ownable.transfer_ownership(new_owner);

        assert(ownable.owner() == new_owner, 'wrong_owner');

        set_contract_address(new_owner);
        contract.do_something();
    }

    #[test]
    #[available_gas(2000000)]
    #[should_panic]
    fn test_transfer_ownership_not_owner() {
        set_contract_address(contract_address_const::<'initial'>());
        let (_, ownable) = deploy();

        set_contract_address(contract_address_const::<'not_owner'>());
        ownable.transfer_ownership(contract_address_const::<'new_owner'>());
    }

    #[test]
    #[available_gas(2000000)]
    #[should_panic]
    fn test_transfer_ownership_zero_error() {
        set_contract_address(contract_address_const::<'initial'>());
        let (_, ownable) = deploy();

        ownable.transfer_ownership(Zero::zero());
    }

    #[test]
    #[available_gas(2000000)]
    fn test_renounce_ownership() {
        set_contract_address(contract_address_const::<'owner'>());
        let (_, ownable) = deploy();

        ownable.renounce_ownership();
        assert(ownable.owner() == Zero::zero(), 'not_zero_owner');
    }

    #[test]
    #[available_gas(2000000)]
    #[should_panic]
    fn test_renounce_ownership_not_owner() {
        set_contract_address(contract_address_const::<'owner'>());
        let (_, ownable) = deploy();

        set_contract_address(contract_address_const::<'not_owner'>());
        ownable.renounce_ownership();
    }

    #[test]
    #[available_gas(2000000)]
    #[should_panic]
    fn test_renounce_ownership_previous_owner() {
        set_contract_address(contract_address_const::<'owner'>());
        let (contract, ownable) = deploy();

        ownable.renounce_ownership();

        contract.do_something();
    }
}
