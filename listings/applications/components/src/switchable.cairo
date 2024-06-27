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


#[starknet::contract]
mod MockContract {
    use super::switchable_component;

    component!(path: switchable_component, storage: switchable, event: SwitchableEvent);

    #[storage]
    struct Storage {
        #[substorage(v0)]
        switchable: switchable_component::Storage,
    }

    #[event]
    #[derive(Drop, Debug, PartialEq, starknet::Event)] 
    pub enum Event {
        SwitchableEvent: switchable_component::Event
    }

    #[abi(embed_v0)]
    impl SwitchableImpl = switchable_component::Switchable<ContractState>;
}

#[cfg(test)]
mod test {
    use super::MockContract;
    use super::switchable_component::{Event, SwitchEvent};
    use super::{ISwitchableDispatcher, ISwitchableDispatcherTrait};
    use starknet::{syscalls::deploy_syscall, contract_address_const, ContractAddress};
    use starknet::SyscallResultTrait;

    fn deploy_switchable() -> (ISwitchableDispatcher, ContractAddress) {
        let (address, _) = deploy_syscall(
            MockContract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
        (ISwitchableDispatcher { contract_address: address }, address)
    }

    #[test]
    fn test_constructor() {
        let (switchable, _) = deploy_switchable();
        assert_eq!(switchable.is_on(), false);
    }

    #[test]
    fn test_switch() {
        let (switchable, contract_address) = deploy_switchable();
        switchable.switch();
        assert_eq!(switchable.is_on(), true);
        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(MockContract::Event::SwitchableEvent(SwitchEvent { }.into())) 
        );
    }

    #[test]
    fn test_multiple_switches() {
        let (switchable, _) = deploy_switchable();
        switchable.switch();
        switchable.switch();
        switchable.switch();
        assert_eq!(switchable.is_on(), true);
    }

    #[test]
    fn test_toggle_back_and_forth() {
        let (switchable, _)= deploy_switchable();
        switchable.switch();
        assert_eq!(switchable.is_on(), true);
        switchable.switch();
        assert_eq!(switchable.is_on(), false);
        switchable.switch();
        assert_eq!(switchable.is_on(), true);
    }
}
