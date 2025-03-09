// [!region component]
#[starknet::interface]
// [!region interface]
pub trait ISwitchable<TContractState> {
    fn is_on(self: @TContractState) -> bool;
    fn switch(ref self: TContractState);
}
// [!endregion interface]

#[starknet::component]
pub mod switchable_component {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    pub struct Storage {
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
        TContractState, +HasComponent<TContractState>,
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
        TContractState, +HasComponent<TContractState>,
    > of SwitchableInternalTrait<TContractState> {
        fn _off(ref self: ComponentState<TContractState>) {
            self.switchable_value.write(false);
        }
    }
}
// [!endregion component]

// [!region contract]
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
// [!endregion contract]

// [!region tests]
#[cfg(test)]
mod test {
    use super::{ISwitchableDispatcher, ISwitchableDispatcherTrait};
    use snforge_std::{
        ContractClassTrait, DeclareResultTrait, declare, spy_events, EventSpyAssertionsTrait,
    };
    use super::SwitchContract; // Used as a mock contract
    use super::switchable_component;

    fn deploy() -> ISwitchableDispatcher {
        let contract = declare("SwitchContract").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();
        ISwitchableDispatcher { contract_address }
    }

    #[test]
    fn test_constructor() {
        let switchable = deploy();
        assert_eq!(switchable.is_on(), false);
    }

    #[test]
    fn test_switch() {
        let switchable = deploy();
        let mut spy = spy_events();
        switchable.switch();
        assert_eq!(switchable.is_on(), true);

        spy
            .assert_emitted(
                @array![
                    (
                        switchable.contract_address,
                        SwitchContract::Event::SwitchableEvent(
                            switchable_component::Event::SwitchEvent(
                                switchable_component::SwitchEvent {},
                            ),
                        ),
                    ),
                ],
            );
    }

    #[test]
    fn test_multiple_switches() {
        let switchable = deploy();
        switchable.switch();
        assert_eq!(switchable.is_on(), true);
        switchable.switch();
        assert_eq!(switchable.is_on(), false);
        switchable.switch();
        assert_eq!(switchable.is_on(), true);
    }
}
// [!endregion tests]


