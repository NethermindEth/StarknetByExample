#[starknet::interface]
trait ISwitchable<TContractState> {
    fn value(self: @TContractState) -> bool;
    fn switch(ref self: TContractState);
}

#[starknet::component]
mod switchable_component {
    #[storage]
    struct Storage {
        value: bool,
    }

    #[derive(Drop, starknet::Event)]
    struct SwitchEvent {}

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        SwitchEvent: SwitchEvent,
    }

    #[embeddable_as(Switchable)]
    impl SwitchableImpl<
        TContractState, +HasComponent<TContractState>
    > of super::ISwitchable<ComponentState<TContractState>> {
        fn value(self: @ComponentState<TContractState>) -> bool {
            self.value.read()
        }

        fn switch(ref self: ComponentState<TContractState>) {
            self.value.write(!self.value.read());
            self.emit(Event::SwitchEvent(SwitchEvent {}));
        }
    }

    #[generate_trait]
    impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {
        fn _off(ref self: ComponentState<TContractState>) {
            self.value.write(false);
        }
    }
}
