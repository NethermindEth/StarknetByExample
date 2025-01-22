// [!region contract]
#[starknet::interface]
trait IEventCounter<TContractState> {
    fn increment(ref self: TContractState, amount: u128);
}

mod Events {
    // Events must derive the `starknet::Event` trait
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct CounterIncreased {
        pub amount: u128,
    }

    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct UserIncreaseCounter {
        // The `#[key]` attribute indicates that this event will be indexed.
        // You can also use `#[flat]` for nested structs.
        #[key]
        pub user: starknet::ContractAddress,
        pub new_value: u128,
    }
}

#[starknet::contract]
mod EventCounter {
    use super::IEventCounter;
    use super::Events::*;
    use starknet::get_caller_address;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        // Counter value
        counter: u128,
    }

    #[event]
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    // The event enum must be annotated with the `#[event]` attribute.
    // It must also derive at least the `Drop` and `starknet::Event` traits.
    pub enum Event {
        CounterIncreased: CounterIncreased,
        UserIncreaseCounter: UserIncreaseCounter,
    }

    #[abi(embed_v0)]
    impl EventCounter of IEventCounter<ContractState> {
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
        EventCounter::{Event, CounterIncreased, UserIncreaseCounter}, IEventCounterDispatcherTrait,
        IEventCounterDispatcher,
    };
    use starknet::contract_address_const;

    use snforge_std::{
        EventSpyAssertionsTrait, spy_events, start_cheat_caller_address, stop_cheat_caller_address,
        ContractClassTrait, DeclareResultTrait, declare,
    };

    fn deploy() -> IEventCounterDispatcher {
        let contract = declare("EventCounter").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();
        IEventCounterDispatcher { contract_address }
    }

    #[test]
    fn test_increment_events() {
        let mut contract = deploy();
        let amount = 10;
        let caller = contract_address_const::<'caller'>();

        // [!region test_events]
        let mut spy = spy_events();
        start_cheat_caller_address(contract.contract_address, caller);
        contract.increment(amount);
        stop_cheat_caller_address(contract.contract_address);

        spy
            .assert_emitted(
                @array![
                    (
                        contract.contract_address,
                        Event::CounterIncreased(CounterIncreased { amount }),
                    ),
                    (
                        contract.contract_address,
                        Event::UserIncreaseCounter(
                            UserIncreaseCounter { user: caller, new_value: amount },
                        ),
                    ),
                ],
            );
        // [!endregion test_events]
    }
}
