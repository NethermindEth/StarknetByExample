// ANCHOR: interface
use starknet::ContractAddress;

#[starknet::interface]
pub trait IOwnable<TContractState> {
    fn owner(self: @TContractState) -> ContractAddress;
    fn transfer_ownership(ref self: TContractState, new: ContractAddress);
    fn renounce_ownership(ref self: TContractState);
}
// ANCHOR_END: interface

// ANCHOR: component
pub mod Errors {
    pub const UNAUTHORIZED: felt252 = 'Not owner';
    pub const ZERO_ADDRESS_OWNER: felt252 = 'Owner cannot be zero';
    pub const ZERO_ADDRESS_CALLER: felt252 = 'Caller cannot be zero';
}

#[starknet::component]
pub mod ownable_component {
    use starknet::{ContractAddress, get_caller_address};
    use super::Errors;
    use core::num::traits::Zero;

    #[storage]
    struct Storage {
        ownable_owner: ContractAddress,
    }

    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct OwnershipTransferredEvent {
        pub previous: ContractAddress,
        pub new: ContractAddress
    }

    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct OwnershipRenouncedEvent {
        pub previous: ContractAddress
    }

    #[event]
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        OwnershipTransferredEvent: OwnershipTransferredEvent,
        OwnershipRenouncedEvent: OwnershipRenouncedEvent
    }

    #[embeddable_as(Ownable)]
    pub impl OwnableImpl<
        TContractState, +HasComponent<TContractState>
    > of super::IOwnable<ComponentState<TContractState>> {
        fn owner(self: @ComponentState<TContractState>) -> ContractAddress {
            self.ownable_owner.read()
        }

        fn transfer_ownership(ref self: ComponentState<TContractState>, new: ContractAddress) {
            self._assert_only_owner();
            self._transfer_ownership(new);
        }

        fn renounce_ownership(ref self: ComponentState<TContractState>) {
            self._assert_only_owner();
            self._renounce_ownership();
        }
    }

    #[generate_trait]
    pub impl OwnableInternalImpl<
        TContractState, +HasComponent<TContractState>
    > of OwnableInternalTrait<TContractState> {
        fn _assert_only_owner(self: @ComponentState<TContractState>) {
            let caller = get_caller_address();
            assert(caller.is_non_zero(), Errors::ZERO_ADDRESS_CALLER);
            assert(caller == self.ownable_owner.read(), Errors::UNAUTHORIZED);
        }

        fn _init(ref self: ComponentState<TContractState>, owner: ContractAddress) {
            assert(owner.is_non_zero(), Errors::ZERO_ADDRESS_OWNER);
            self.ownable_owner.write(owner);
        }

        fn _transfer_ownership(ref self: ComponentState<TContractState>, new: ContractAddress) {
            assert(new.is_non_zero(), Errors::ZERO_ADDRESS_OWNER);
            let previous = self.ownable_owner.read();
            self.ownable_owner.write(new);
            self
                .emit(
                    Event::OwnershipTransferredEvent(OwnershipTransferredEvent { previous, new })
                );
        }

        fn _renounce_ownership(ref self: ComponentState<TContractState>) {
            let previous = self.ownable_owner.read();
            self.ownable_owner.write(Zero::zero());
            self.emit(Event::OwnershipRenouncedEvent(OwnershipRenouncedEvent { previous }));
        }
    }
}
// ANCHOR_END: component

// ANCHOR: contract
#[starknet::contract]
mod MockContract {
    use super::{IOwnable, ownable_component, ownable_component::OwnableInternalTrait};

    component!(path: ownable_component, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = ownable_component::Ownable<ContractState>;

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
}
// ANCHOR_END: contract

#[cfg(test)]
mod test {
    use super::MockContract;
    use super::ownable_component::{Event, OwnershipRenouncedEvent, OwnershipTransferredEvent};
    use starknet::ContractAddress;
    use components::ownable::{IOwnableDispatcher, IOwnableDispatcherTrait};
    use core::traits::TryInto;
    use core::num::traits::Zero;
    use starknet::{ syscalls::deploy_syscall, SyscallResultTrait, contract_address_const};
    use starknet::testing::{set_caller_address, set_contract_address};
    use super::Errors;

    fn deploy() -> (IOwnableDispatcher, ContractAddress) {
        let caller = contract_address_const::<'caller'>();
        let (contract_address, _) = deploy_syscall(
            MockContract::TEST_CLASS_HASH.try_into().unwrap(), caller.into(), array![].span(), false
        )
            .unwrap_syscall();

        (IOwnableDispatcher { contract_address }, contract_address)
    }

    #[test]
    fn test_initial_state() {
        let owner = contract_address_const::<'owner'>();
        set_contract_address(owner);
        let (ownable, _) = deploy();

        assert(ownable.owner() == owner, 'wrong_owner');
    }

    #[test]
    fn test_transfer_ownership_by_owner() {
        set_contract_address(contract_address_const::<'initial'>());
        let (ownable, _) = deploy();
        let owner = contract_address_const::<'owner'>();
        ownable.transfer_ownership(owner);

        assert(ownable.owner() == owner, 'wrong_owner');
    }

    #[test]
    #[should_panic]
    fn test_transfer_ownership_not_owner() {
        set_contract_address(contract_address_const::<'initial'>());
        let (ownable, _) = deploy();

        set_contract_address(contract_address_const::<'not_owner'>());
        ownable.transfer_ownership(contract_address_const::<'new_owner'>());
    }

    #[test]
    #[should_panic]
    fn test_transfer_ownership_account_zero() {
        set_contract_address(contract_address_const::<'initial'>());
        let (ownable, _) = deploy();

        ownable.transfer_ownership(Zero::zero());
    }

    #[test]
    #[should_panic]
    fn test_transfer_ownership_by_zero() {
        set_contract_address(Zero::zero());
        let (ownable, _) = deploy();

        ownable.transfer_ownership(contract_address_const::<'new_owner'>());
    }

    #[test]
    fn test_renounce_ownership() {
        set_contract_address(contract_address_const::<'owner'>());
        let (ownable, _) = deploy();

        ownable.renounce_ownership();
        assert(ownable.owner() == Zero::zero(), 'not_zero_owner');
    }

    #[test]
    #[should_panic]
    fn test_renounce_ownership_previous_owner() {
        set_contract_address(contract_address_const::<'owner'>());
        let (ownable, _) = deploy();

        ownable.renounce_ownership();
        ownable.transfer_ownership(contract_address_const::<'new_owner'>());
    }

    #[test]
    #[should_panic]
    fn test_renounce_ownership_not_owner() {
        set_contract_address(contract_address_const::<'owner'>());
        let (ownable, _) = deploy();

        set_contract_address(contract_address_const::<'not_owner'>());
        ownable.renounce_ownership();
    }

    #[test]
    fn test_ownership_renounced_event(){
        let contract_address = contract_address_const::<'owner'>();
        set_contract_address(contract_address);
        let (ownable, address) = deploy();
        ownable.renounce_ownership();
        set_contract_address(address);
        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::OwnershipRenouncedEvent(OwnershipRenouncedEvent { previous:contract_address }))
        );
    }

    #[test]
    fn test_ownership_transferred_event(){
        let contract_address = contract_address_const::<'owner'>();
        set_contract_address(contract_address);
        let (ownable, address) = deploy();
        let owner = contract_address_const::<'owner'>();
        ownable.transfer_ownership(owner);
        set_contract_address(address);
        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::OwnershipTransferredEvent(OwnershipTransferredEvent { previous:contract_address, new:owner}))
        );
    }
}