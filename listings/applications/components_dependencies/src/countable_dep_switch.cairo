// [!region contract]
#[starknet::component]
pub mod countable_component {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use components::countable::ICountable;
    use components::switchable::ISwitchable;

    #[storage]
    pub struct Storage {
        countable_value: u32,
    }

    // [!region impl]
    #[embeddable_as(Countable)]
    impl CountableImpl<
        TContractState, +HasComponent<TContractState>, +ISwitchable<TContractState>,
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
    // [!endregion impl]
}

// [!endregion contract]

#[starknet::contract]
mod MockContract {
    use super::countable_component;
    use components::switchable::ISwitchable;

    component!(path: countable_component, storage: counter, event: CountableEvent);

    #[storage]
    struct Storage {
        #[substorage(v0)]
        counter: countable_component::Storage,
        switch: bool,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CountableEvent: countable_component::Event,
    }

    #[abi(embed_v0)]
    impl CountableImpl = countable_component::Countable<ContractState>;
    #[abi(embed_v0)]
    impl Switchable of ISwitchable<ContractState> {
        fn switch(ref self: ContractState) {}

        fn is_on(self: @ContractState) -> bool {
            true
        }
    }
}


#[cfg(test)]
mod test {
    use super::MockContract;
    use components::countable::{ICountableDispatcher, ICountableDispatcherTrait};
    use starknet::syscalls::deploy_syscall;

    fn deploy_countable() -> ICountableDispatcher {
        let (contract_address, _) = deploy_syscall(
            MockContract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false,
        )
            .unwrap();
        ICountableDispatcher { contract_address: contract_address }
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
