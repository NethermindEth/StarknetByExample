// [!region contract]
#[starknet::contract]
pub mod CountableContract {
    use components_dependencies::countable_internal_dep_switch::countable_component;
    use components::switchable::switchable_component;

    component!(path: countable_component, storage: counter, event: CountableEvent);
    component!(path: switchable_component, storage: switch, event: SwitchableEvent);

    #[abi(embed_v0)]
    impl CountableImpl = countable_component::Countable<ContractState>;
    #[abi(embed_v0)]
    impl SwitchableImpl = switchable_component::Switchable<ContractState>;
    impl SwitchableInternalImpl = switchable_component::SwitchableInternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        counter: countable_component::Storage,
        #[substorage(v0)]
        switch: switchable_component::Storage,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.switch._off();
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CountableEvent: countable_component::Event,
        SwitchableEvent: switchable_component::Event,
    }
}
// [!endregion contract]

#[cfg(test)]
mod tests {
    use super::CountableContract;
    use components::countable::{ICountableDispatcher, ICountableDispatcherTrait};
    use components::switchable::{ISwitchableDispatcher, ISwitchableDispatcherTrait};

    use starknet::syscalls::deploy_syscall;

    fn deploy() -> (ICountableDispatcher, ISwitchableDispatcher) {
        let (contract_address, _) = deploy_syscall(
            CountableContract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false,
        )
            .unwrap();

        (ICountableDispatcher { contract_address }, ISwitchableDispatcher { contract_address })
    }

    #[test]
    fn test_init() {
        let (mut counter, mut switch) = deploy();

        assert_eq!(counter.get(), 0);
        assert_eq!(switch.is_on(), false);
    }

    #[test]
    fn test_increment_switch_off() {
        let (mut counter, mut switch) = deploy();

        counter.increment();
        assert_eq!(counter.get(), 0);
        assert_eq!(switch.is_on(), false);
    }

    #[test]
    fn test_increment_switch_on() {
        let (mut counter, mut switch) = deploy();

        switch.switch();
        assert_eq!(switch.is_on(), true);

        counter.increment();
        assert_eq!(counter.get(), 1);

        // The counter turned the switch off.
        assert_eq!(switch.is_on(), false);
    }

    #[test]
    fn test_increment_multiple_switches() {
        let (mut counter, mut switch) = deploy();

        switch.switch();

        counter.increment();
        counter.increment(); // off
        counter.increment(); // off
        assert_eq!(counter.get(), 1);

        switch.switch();
        counter.increment();
        switch.switch();
        counter.increment();
        counter.increment();
        assert_eq!(counter.get(), 3);
    }
}
