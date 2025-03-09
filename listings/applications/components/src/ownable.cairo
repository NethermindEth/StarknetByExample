// [!region component]
use starknet::ContractAddress;

#[starknet::interface]
pub trait IOwnable<TContractState> {
    fn owner(self: @TContractState) -> ContractAddress;
    fn transfer_ownership(ref self: TContractState, new: ContractAddress);
    fn renounce_ownership(ref self: TContractState);
}

pub mod Errors {
    pub const UNAUTHORIZED: felt252 = 'Not owner';
    pub const ZERO_ADDRESS_OWNER: felt252 = 'Owner cannot be zero';
    pub const ZERO_ADDRESS_CALLER: felt252 = 'Caller cannot be zero';
}

#[starknet::component]
pub mod ownable_component {
    use super::Errors;
    use starknet::{ContractAddress, get_caller_address};
    use core::num::traits::Zero;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    pub struct Storage {
        ownable_owner: ContractAddress,
    }

    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub struct OwnershipTransferredEvent {
        pub previous: ContractAddress,
        pub new: ContractAddress,
    }

    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub struct OwnershipRenouncedEvent {
        pub previous: ContractAddress,
    }

    #[event]
    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        OwnershipTransferredEvent: OwnershipTransferredEvent,
        OwnershipRenouncedEvent: OwnershipRenouncedEvent,
    }

    #[embeddable_as(Ownable)]
    pub impl OwnableImpl<
        TContractState, +HasComponent<TContractState>,
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
        TContractState, +HasComponent<TContractState>,
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
                    Event::OwnershipTransferredEvent(OwnershipTransferredEvent { previous, new }),
                );
        }

        fn _renounce_ownership(ref self: ComponentState<TContractState>) {
            let previous = self.ownable_owner.read();
            self.ownable_owner.write(Zero::zero());
            self.emit(Event::OwnershipRenouncedEvent(OwnershipRenouncedEvent { previous }));
        }
    }
}
// [!endregion component]

// [!region contract]
#[starknet::contract]
pub mod OwnedContract {
    use super::{ownable_component, ownable_component::OwnableInternalTrait};

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
    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        OwnableEvent: ownable_component::Event,
    }
}
// [!endregion contract]

#[cfg(test)]
mod test {
    use super::OwnedContract;
    use super::ownable_component;
    use super::{IOwnableDispatcher, IOwnableDispatcherTrait};
    use starknet::contract_address_const;
    use core::num::traits::Zero;
    use snforge_std::{
        ContractClassTrait, DeclareResultTrait, declare, spy_events,
        start_cheat_caller_address_global, EventSpyAssertionsTrait,
    };

    fn deploy() -> IOwnableDispatcher {
        let contract = declare("OwnedContract").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();
        IOwnableDispatcher { contract_address }
    }

    #[test]
    fn test_initial_state() {
        let owner = contract_address_const::<'owner'>();
        start_cheat_caller_address_global(owner);

        let ownable = deploy();
        assert_eq!(ownable.owner(), owner);
    }

    #[test]
    fn test_transfer_ownership() {
        let owner = contract_address_const::<'owner'>();
        start_cheat_caller_address_global(owner);

        let ownable = deploy();

        let mut spy = spy_events();
        let new_owner = contract_address_const::<'new_owner'>();
        ownable.transfer_ownership(new_owner);

        assert_eq!(ownable.owner(), new_owner);
        spy
            .assert_emitted(
                @array![
                    (
                        ownable.contract_address,
                        OwnedContract::Event::OwnableEvent(
                            ownable_component::Event::OwnershipTransferredEvent(
                                ownable_component::OwnershipTransferredEvent {
                                    previous: owner, new: new_owner,
                                },
                            ),
                        ),
                    ),
                ],
            );
    }

    #[test]
    #[should_panic]
    fn test_transfer_ownership_not_owner() {
        let ownable = deploy();

        start_cheat_caller_address_global(contract_address_const::<'not_owner'>());
        ownable.transfer_ownership(contract_address_const::<'new_owner'>());
    }

    #[test]
    #[should_panic]
    fn test_transfer_ownership_zero_error() {
        let ownable = deploy();
        ownable.transfer_ownership(Zero::zero());
    }

    #[test]
    fn test_renounce_ownership() {
        let owner = contract_address_const::<'owner'>();
        start_cheat_caller_address_global(owner);
        let ownable = deploy();

        let mut spy = spy_events();
        ownable.renounce_ownership();

        assert_eq!(ownable.owner(), Zero::zero());
        spy
            .assert_emitted(
                @array![
                    (
                        ownable.contract_address,
                        OwnedContract::Event::OwnableEvent(
                            ownable_component::Event::OwnershipRenouncedEvent(
                                ownable_component::OwnershipRenouncedEvent { previous: owner },
                            ),
                        ),
                    ),
                ],
            );
    }

    #[test]
    #[should_panic]
    fn test_renounce_ownership_not_owner() {
        let ownable = deploy();

        start_cheat_caller_address_global(contract_address_const::<'not_owner'>());
        ownable.renounce_ownership();
    }

    #[test]
    #[should_panic]
    fn test_renounce_ownership_previous_owner() {
        let ownable = deploy();

        ownable.renounce_ownership();
        ownable.transfer_ownership(contract_address_const::<'new_owner'>());
    }
}
