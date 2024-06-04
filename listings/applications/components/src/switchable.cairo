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

    #[derive(Drop, starknet::Event)]
    struct SwitchEvent {}

    #[event]
    #[derive(Drop, starknet::Event)]
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

#[cfg(test)]
mod tests {
    use super::{
        switchable_component, ISwitchable, ISwitchableDispatcher, ISwitchableDispatcherTrait
    };
    use starknet::{ContractAddress, syscalls::deploy_syscall, SyscallResultTrait};

    // fn deploy() -> ISwitchableDispatcher {
    //     let (contract_address, _) = deploy_syscall(
    //         switchable_component::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
    //     )
    //         .unwrap_syscall();

    //         ISwitchableDispatcherr { contract_address }
    // }

    type TestingState = switchable_component::ComponentState<MockContract::ContractState>;

    // You can derive even `Default` on this type alias

    #[test]
    fn test_is_on() {
        let mut result: TestingState = Default::default();

        assert_eq!(result.is_on(), false);
    }
}

