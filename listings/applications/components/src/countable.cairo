// ANCHOR: component
#[starknet::interface]
pub trait ICountable<TContractState> {
    fn get(self: @TContractState) -> u32;
    fn increment(ref self: TContractState);
}

#[starknet::component]
pub mod countable_component {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    pub struct Storage {
        countable_value: u32,
    }

    #[embeddable_as(Countable)]
    impl CountableImpl<
        TContractState, +HasComponent<TContractState>
    > of super::ICountable<ComponentState<TContractState>> {
        fn get(self: @ComponentState<TContractState>) -> u32 {
            self.countable_value.read()
        }

        fn increment(ref self: ComponentState<TContractState>) {
            self.countable_value.write(self.countable_value.read() + 1);
        }
    }
}
// ANCHOR_END: component

#[starknet::contract]
mod CountableContract {
    use super::countable_component;

    component!(path: countable_component, storage: countable, event: CountableEvent);

    #[storage]
    struct Storage {
        #[substorage(v0)]
        countable: countable_component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CountableEvent: countable_component::Event
    }

    #[abi(embed_v0)]
    impl CountableImpl = countable_component::Countable<ContractState>;
}


#[cfg(test)]
mod test {
    use super::CountableContract;
    use super::{ICountableDispatcher, ICountableDispatcherTrait};
    use starknet::syscalls::deploy_syscall;
    use starknet::SyscallResultTrait;

    fn deploy_countable() -> ICountableDispatcher {
        let (address, _) = deploy_syscall(
            CountableContract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
        ICountableDispatcher { contract_address: address }
    }

    #[test]
    fn test_constructor() {
        let counter = deploy_countable();
        assert_eq!(counter.get(), 0);
    }

    #[test]
    fn test_increment() {
        let counter = deploy_countable();
        counter.increment();
        assert_eq!(counter.get(), 1);
    }

    #[test]
    fn test_multiple_increments() {
        let counter = deploy_countable();
        counter.increment();
        counter.increment();
        counter.increment();
        assert_eq!(counter.get(), 3);
    }
}
