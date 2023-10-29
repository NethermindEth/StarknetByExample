#[starknet::contract]
mod EventCounter {
    use starknet::{get_caller_address, ContractAddress};
    #[storage]
    struct Storage { }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CounterIncreased: CounterIncreased,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncreased {
        #[key]
        amount: u128
    }


    #[generate_trait]
    #[external(v0)]
    impl EventCounter of IEventCounter {   
        fn increment(ref self: ContractState, amount: u128) {
            self.emit(Event::CounterIncreased(CounterIncreased { amount }));
        }
    }
}