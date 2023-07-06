#[starknet::interface]
trait ISimpleCounter<TContractState> {
    fn get_current_count(self: @TContractState) -> u256;
    fn increment(ref self: TContractState);
    fn decrement(ref self: TContractState);
}


#[starknet::contract]
mod simple_counter {
    #[storage]
    struct Storage {
        // Counter variable
        counter: u256,
    }

    #[external(v0)]
    impl SimpleCounterImpl of super::ISimpleCounter<ContractState> {
        fn get_current_count(self: @ContractState) -> u256 {
            return self.counter.read();
        }

        fn increment(ref self: ContractState) {
            // Store counter value + 1
            let mut counter: u256 = self.counter.read() + 1;
            self.counter.write(counter);
        }
        fn decrement(ref self: ContractState) {
            // Store counter value - 1
            let mut counter: u256 = self.counter.read() - 1;
            self.counter.write(counter);
        }
    }
}
