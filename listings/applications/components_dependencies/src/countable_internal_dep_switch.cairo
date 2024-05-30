#[starknet::component]
pub mod countable_component {
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

#[starknet::contract]
mod MockContract{
    use super::countable_component;
    use components::switchable::ISwitchable;

    use components::switchable::switchable_component;
    use switchable_component::{SwitchableInternalImpl, SwitchableInternalTrait};


    component!(path: countable_component, storage: counter, event: CountableEvent);
    component!(path: switchable_component, storage: switch, event: SwitchableEvent);

    #[storage]
    struct Storage {
        #[substorage(v0)]
        counter: countable_component::Storage,
        #[substorage(v0)]
        switch: switchable_component::Storage,
        switched: bool,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CountableEvent: countable_component::Event,
        SwitchableEvent: switchable_component::Event,
    }
    

    #[abi(embed_v0)]
    impl CountableImpl = countable_component::Countable<ContractState>;
    
    #[abi(embed_v0)]
    impl Switchable of ISwitchable<ContractState> {
        fn switch(ref self: ContractState) {
            self.switched.write(!self.switched.read());
        }

        fn is_on(self: @ContractState) -> bool {
            self.switched.read()
        }
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.switched.write(true);
    }
  
}

#[cfg(test)]
mod test{
    use super::MockContract;
    use components::countable::{ICountableDispatcher, ICountableDispatcherTrait};
    use starknet::syscalls::deploy_syscall;
    use starknet::SyscallResultTrait;

    fn deploy_countable() -> ICountableDispatcher {
        let (address, _) = deploy_syscall(
            MockContract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
        ICountableDispatcher { contract_address: address }
}

    #[test]
    fn test_get() {
        let countable = deploy_countable();
        assert_eq!(countable.get(), 0);
    }

    #[test]
    fn test_increment() {
        let countable = deploy_countable();
        countable.increment();
        assert_eq!(countable.get(), 1);
    }
}