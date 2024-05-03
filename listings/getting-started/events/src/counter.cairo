#[starknet::interface]
pub trait IEventCounter<TContractState> {
    fn increment(ref self: TContractState, amount: u128);
}

// ANCHOR: contract
#[starknet::contract]
pub mod EventCounter {
    use starknet::{get_caller_address, ContractAddress};

    #[storage]
    struct Storage {
        // Counter value
        counter: u128,
    }

    #[event]
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    // The event enum must be annotated with the `#[event]` attribute.
    // It must also derive atleast `Drop` and `starknet::Event` traits.
    pub enum Event {
        CounterIncreased: CounterIncreased,
        UserIncreaseCounter: UserIncreaseCounter
    }

    // By deriving the `starknet::Event` trait, we indicate to the compiler that
    // this struct will be used when emitting events.
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct CounterIncreased {
        pub amount: u128
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
            // ANCHOR: emit
            self.emit(Event::CounterIncreased(CounterIncreased { amount }));
            self
                .emit(
                    Event::UserIncreaseCounter(
                        UserIncreaseCounter {
                            user: get_caller_address(), new_value: self.counter.read()
                        }
                    )
                );
        // ANCHOR_END: emit
        }
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod tests {
    use super::{
        EventCounter,
        EventCounter::{
            counterContractMemberStateTrait, Event, CounterIncreased, UserIncreaseCounter
        },
        IEventCounterDispatcherTrait, IEventCounterDispatcher
    };
    use starknet::{
        ContractAddress, contract_address_const, SyscallResultTrait, syscalls::deploy_syscall
    };
    use starknet::testing::{set_contract_address, set_account_contract_address};

    #[test]
    fn test_increment_events() {
        let (contract_address, _) = deploy_syscall(
            EventCounter::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
        let mut contract = IEventCounterDispatcher { contract_address };
        let state = EventCounter::contract_state_for_testing();

        let amount = 10;
        let caller = contract_address_const::<'caller'>();

        // fake caller
        set_contract_address(caller);
        contract.increment(amount);
        // set back to the contract for reading state
        set_contract_address(contract_address);
        assert_eq!(state.counter.read(), amount);

        // Notice the order: the first event emitted is the first to be popped.
        /// ANCHOR: test_events
        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::CounterIncreased(CounterIncreased { amount }))
        );
        // ANCHOR_END: test_events
        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(
                Event::UserIncreaseCounter(UserIncreaseCounter { user: caller, new_value: amount })
            )
        );
    }
}
