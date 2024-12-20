#[starknet::interface]
pub trait IEventCounter<TContractState> {
    fn increment(ref self: TContractState, amount: u128);
}

// [!region contract]
#[starknet::contract]
pub mod EventCounter {
    use starknet::{get_caller_address, ContractAddress};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        // Counter value
        pub counter: u128,
    }

    #[event]
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    // The event enum must be annotated with the `#[event]` attribute.
    // It must also derive at least the `Drop` and `starknet::Event` traits.
    pub enum Event {
        CounterIncreased: CounterIncreased,
        UserIncreaseCounter: UserIncreaseCounter,
    }

    // By deriving the `starknet::Event` trait, we indicate to the compiler that
    // this struct will be used when emitting events.
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct CounterIncreased {
        pub amount: u128,
    }

    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct UserIncreaseCounter {
        // The `#[key]` attribute indicates that this event will be indexed.
        // You can also use `#[flat]` for nested structs.
        #[key]
        pub user: ContractAddress,
        pub new_value: u128,
    }

    #[abi(embed_v0)]
    impl EventCounter of super::IEventCounter<ContractState> {
        fn increment(ref self: ContractState, amount: u128) {
            self.counter.write(self.counter.read() + amount);
            // Emit event
            // [!region emit]
            self.emit(Event::CounterIncreased(CounterIncreased { amount }));
            self
                .emit(
                    Event::UserIncreaseCounter(
                        UserIncreaseCounter {
                            user: get_caller_address(), new_value: self.counter.read(),
                        },
                    ),
                );
            // [!endregion emit]
        }
    }
}
// [!endregion contract]

#[cfg(test)]
mod tests {
    use super::{
        EventCounter, EventCounter::{Event, CounterIncreased, UserIncreaseCounter},
        IEventCounterDispatcherTrait, IEventCounterDispatcher,
    };
    use starknet::{contract_address_const, syscalls::deploy_syscall};
    use starknet::testing::set_contract_address;
    use starknet::storage::StoragePointerReadAccess;

    #[test]
    fn test_increment_events() {
        let (contract_address, _) = deploy_syscall(
            EventCounter::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false,
        )
            .unwrap();
        let mut contract = IEventCounterDispatcher { contract_address };
        let state = @EventCounter::contract_state_for_testing();

        let amount = 10;
        let caller = contract_address_const::<'caller'>();

        // fake caller
        set_contract_address(caller);
        contract.increment(amount);
        // set back to the contract for reading state
        set_contract_address(contract_address);
        assert_eq!(state.counter.read(), amount);

        // Notice the order: the first event emitted is the first to be popped.
        // [!region test_events]
        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::CounterIncreased(CounterIncreased { amount })),
        );
        // [!endregion test_events]
        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(
                Event::UserIncreaseCounter(UserIncreaseCounter { user: caller, new_value: amount }),
            ),
        );
    }
}
