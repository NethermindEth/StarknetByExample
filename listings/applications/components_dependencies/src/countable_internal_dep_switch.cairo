#[starknet::component]
mod countable_component {
    use components::countable::ICountable;
    use components::switchable::ISwitchable;

    // Explicitly depends on a component and not a trait
    use components::switchable::switchable_component;
    use switchable_component::{SwitchableInternalImpl, SwitchableInternalTrait};

    #[storage]
    struct Storage {
        countable_value: u32,
    }

    #[generate_trait]
    impl GetSwitchable<
        TContractState,
        +HasComponent<TContractState>,
        +switchable_component::HasComponent<TContractState>,
        +Drop<TContractState>
    > of GetSwitchableTrait<TContractState> {
        fn get_switchable(
            self: @ComponentState<TContractState>
        ) -> @switchable_component::ComponentState<TContractState> {
            let contract = self.get_contract();
            switchable_component::HasComponent::<TContractState>::get_component(contract)
        }

        fn get_switchable_mut(
            ref self: ComponentState<TContractState>
        ) -> switchable_component::ComponentState<TContractState> {
            let mut contract = self.get_contract_mut();
            switchable_component::HasComponent::<TContractState>::get_component_mut(ref contract)
        }
    }

    #[embeddable_as(Countable)]
    impl CountableImpl<
        TContractState,
        +HasComponent<TContractState>,
        +ISwitchable<TContractState>,
        +switchable_component::HasComponent<TContractState>,
        +Drop<TContractState>
    > of ICountable<ComponentState<TContractState>> {
        fn get(self: @ComponentState<TContractState>) -> u32 {
            self.countable_value.read()
        }

        fn increment(ref self: ComponentState<TContractState>) {
            if (self.get_contract().is_on()) {
                self.countable_value.write(self.countable_value.read() + 1);

                // use the switchable component internal function
                let mut switch = self.get_switchable_mut();
                switch._off();
            }
        }
    }
}
