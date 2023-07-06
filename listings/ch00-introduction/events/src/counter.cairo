#[starknet::contract]
mod EventCounter {
    #[storage]
    struct Storage {
        // Counter value
        counter: u128,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CounterIncreased: CounterIncreased
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncreased {
        amount: u128
    }

    #[generate_trait]
    #[external(v0)]
    impl EventCounterImpl of EventCounterTrait {
        fn increment(ref self: ContractState) {
            let mut counter = self.counter.read();
            counter += 1;
            self.counter.write(counter);
            // Emit event
            self.emit(Event::CounterIncreased(CounterIncreased { amount: 1 }))
        }
    }
}
