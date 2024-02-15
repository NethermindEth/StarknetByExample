#[starknet::component]
pub mod countable_component {
    use components::countable::ICountable;
    use components::switchable::ISwitchable;

    #[storage]
    struct Storage {
        countable_value: u32,
    }

    // ANCHOR: impl
    #[embeddable_as(Countable)]
    impl CountableImpl<
        TContractState, +HasComponent<TContractState>, +ISwitchable<TContractState>
    > of ICountable<ComponentState<TContractState>> {
        fn get(self: @ComponentState<TContractState>) -> u32 {
            self.countable_value.read()
        }

        fn increment(ref self: ComponentState<TContractState>) {
            if (self.get_contract().is_on()) {
                self.countable_value.write(self.countable_value.read() + 1);
            }
        }
    }
// ANCHOR_END: impl
}
