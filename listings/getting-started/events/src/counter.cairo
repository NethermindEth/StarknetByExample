// ANCHOR: contract
#[starknet::interface]
pub trait IEventCounter<TContractState> {
    fn increment(ref self: TContractState);
}

#[starknet::contract]
pub mod EventCounter {
    use starknet::{get_caller_address, ContractAddress};

    #[storage]
    struct Storage {
        // Counter value
        counter: u128,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    // The event enum must be annotated with the `#[event]` attribute.
    // It must also derive the `Drop` and `starknet::Event` traits.
    enum Event {
        CounterIncreased: CounterIncreased,
        UserIncreaseCounter: UserIncreaseCounter
    }

    // By deriving the `starknet::Event` trait, we indicate to the compiler that
    // this struct will be used when emitting events.
    #[derive(Drop, starknet::Event)]
    struct CounterIncreased {
        amount: u128
    }

    #[derive(Drop, starknet::Event)]
    struct UserIncreaseCounter {
        // The `#[key]` attribute indicates that this event will be indexed.
        #[key]
        user: ContractAddress,
        new_value: u128,
    }

    #[abi(embed_v0)]
    impl EventCounter of super::IEventCounter<ContractState> {
        fn increment(ref self: ContractState) {
            let mut counter = self.counter.read();
            counter += 1;
            self.counter.write(counter);
            // Emit event
            // ANCHOR: emit
            self.emit(Event::CounterIncreased(CounterIncreased { amount: 1 }));
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


