#[starknet::contract]
mod EventCounter {
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
        CounterIncreased: CounterIncreased
    }

    // By deriving the `starknet::Event` trait, we indicate to the compiler that
    // this struct will be used when emitting events.
    #[derive(Drop, starknet::Event)]
    struct CounterIncreased {
        amount: u128
    }

    #[generate_trait]
    #[external(v0)]
    impl EventCounter of IEventCounter {
        fn increment(ref self: ContractState) {
            let mut counter = self.counter.read();
            counter += 1;
            self.counter.write(counter);
            // Emit event
            self.emit(Event::CounterIncreased(CounterIncreased { amount: 1 }))
        }
    }
}
