// ANCHOR: component
#[starknet::interface]
// ANCHOR: interface
pub trait ISwitchable<TContractState> {
    fn is_on(self: @TContractState) -> bool;
    fn switch(ref self: TContractState);
}
// ANCHOR_END: interface

#[starknet::component]
pub mod switchable_component {
    #[storage]
    struct Storage {
        switchable_value: bool,
    }

    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub struct SwitchEvent {}

    #[event]
    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        SwitchEvent: SwitchEvent,
    }

    #[embeddable_as(Switchable)]
    impl SwitchableImpl<
        TContractState, +HasComponent<TContractState>
    > of super::ISwitchable<ComponentState<TContractState>> {
        fn is_on(self: @ComponentState<TContractState>) -> bool {
            self.switchable_value.read()
        }

        fn switch(ref self: ComponentState<TContractState>) {
            self.switchable_value.write(!self.switchable_value.read());
            self.emit(Event::SwitchEvent(SwitchEvent {}));
        }
    }

    #[generate_trait]
    pub impl SwitchableInternalImpl<
        TContractState, +HasComponent<TContractState>
    > of SwitchableInternalTrait<TContractState> {
        fn _off(ref self: ComponentState<TContractState>) {
            self.switchable_value.write(false);
        }
    }
}
// ANCHOR_END: component

// ANCHOR: contract
#[starknet::contract]
pub mod SwitchContract {
    use super::switchable_component;

    component!(path: switchable_component, storage: switch, event: SwitchableEvent);

    #[abi(embed_v0)]
    impl SwitchableImpl = switchable_component::Switchable<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        switch: switchable_component::Storage,
    }

    #[event]
    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        SwitchableEvent: switchable_component::Event,
    }

    // You can optionally use the internal implementation of the component as well
    impl SwitchableInternalImpl = switchable_component::SwitchableInternalImpl<ContractState>;

    #[constructor]
    fn constructor(ref self: ContractState) {
        // Internal function call
        self.switch._off();
    }
}
// ANCHOR_END: contract

// ANCHOR: tests
#[cfg(test)]
mod test {
    use super::SwitchContract; // Used as a mock contract
    use super::switchable_component::{Event, SwitchEvent};
    use super::{ISwitchableDispatcher, ISwitchableDispatcherTrait};
    use starknet::{syscalls::deploy_syscall, contract_address_const, ContractAddress};
    use starknet::SyscallResultTrait;

    fn deploy() -> (ISwitchableDispatcher, ContractAddress) {
        let (address, _) = deploy_syscall(
            SwitchContract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
        (ISwitchableDispatcher { contract_address: address }, address)
    }

    #[test]
    fn test_constructor() {
        let (switchable, _) = deploy();
        assert_eq!(switchable.is_on(), false);
    }

    #[test]
    fn test_switch() {
        let (switchable, contract_address) = deploy();
        switchable.switch();
        assert_eq!(switchable.is_on(), true);
        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(SwitchContract::Event::SwitchableEvent(SwitchEvent {}.into()))
        );
    }

    #[test]
    fn test_multiple_switches() {
        let (switchable, _) = deploy();
        switchable.switch();
        assert_eq!(switchable.is_on(), true);
        switchable.switch();
        assert_eq!(switchable.is_on(), false);
        switchable.switch();
        assert_eq!(switchable.is_on(), true);
    }
}
// ANCHOR_END: tests


