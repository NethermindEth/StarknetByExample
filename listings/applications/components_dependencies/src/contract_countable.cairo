// ANCHOR: contract
#[starknet::contract]
mod CountableContract {
    use components_dependencies::countable_dep_switch::countable_component;
    use components::switchable::ISwitchable;

    component!(path: countable_component, storage: counter, event: CountableEvent);

    #[abi(embed_v0)]
    impl CountableImpl = countable_component::Countable<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        counter: countable_component::Storage,
        switch: bool
    }

    // Implementation of the dependency:
    #[abi(embed_v0)]
    impl Switchable of ISwitchable<ContractState> {
        fn switch(ref self: ContractState) {
            self.switch.write(!self.switch.read());
        }

        fn is_on(self: @ContractState) -> bool {
            self.switch.read()
        }
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.switch.write(false);
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CountableEvent: countable_component::Event,
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod tests {
    use super::CountableContract;
    use components::countable::{ICountable, ICountableDispatcher, ICountableDispatcherTrait};
    use components::switchable::{ISwitchable, ISwitchableDispatcher, ISwitchableDispatcherTrait};

    use starknet::storage::StorageMemberAccessTrait;
    use starknet::SyscallResultTrait;
    use starknet::syscalls::deploy_syscall;

    fn deploy() -> (ICountableDispatcher, ISwitchableDispatcher) {
        let (contract_address, _) = deploy_syscall(
            CountableContract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();

        (ICountableDispatcher { contract_address }, ISwitchableDispatcher { contract_address },)
    }

    #[test]
    #[available_gas(2000000)]
    fn test_init() {
        let (mut counter, mut switch) = deploy();

        assert(counter.get() == 0, 'Counter != 0');
        assert(switch.is_on() == false, 'Switch != false');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_increment_switch_off() {
        let (mut counter, mut switch) = deploy();

        counter.increment();
        assert(counter.get() == 0, 'Counter incremented');
        assert(switch.is_on() == false, 'Switch != false');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_increment_switch_on() {
        let (mut counter, mut switch) = deploy();

        switch.switch();
        assert(switch.is_on() == true, 'Switch != true');

        counter.increment();
        assert(counter.get() == 1, 'Counter did not increment');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_increment_multiple_switches() {
        let (mut counter, mut switch) = deploy();

        switch.switch();

        counter.increment();
        counter.increment();
        counter.increment();
        assert(counter.get() == 3, 'Counter did not increment');

        switch.switch();
        counter.increment();
        counter.increment();
        counter.increment();

        switch.switch();

        counter.increment();
        counter.increment();
        counter.increment();
        assert(counter.get() == 6, 'Counter did not increment');
    }
}
