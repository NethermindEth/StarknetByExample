#[starknet::interface]
trait ISimpleCounter<TContractState> {
    fn get_current_count(self: @TContractState) -> u128;
    fn increment(ref self: TContractState);
    fn decrement(ref self: TContractState);
}

#[starknet::contract]
mod SimpleCounter {
    #[storage]
    struct Storage {
        // Counter variable
        counter: u128,
    }

    #[constructor]
    fn constructor(ref self: ContractState, init_value: u128) {
        // Store initial value
        self.counter.write(init_value);
    }

    #[abi(embed_v0)]
    impl SimpleCounter of super::ISimpleCounter<ContractState> {
        fn get_current_count(self: @ContractState) -> u128 {
            return self.counter.read();
        }

        fn increment(ref self: ContractState) {
            // Store counter value + 1
            let counter = self.counter.read() + 1;
            self.counter.write(counter);
        }
        fn decrement(ref self: ContractState) {
            // Store counter value - 1
            let counter = self.counter.read() - 1;
            self.counter.write(counter);
        }
    }
}
