#[starknet::interface]
pub trait ISimpleCounter<TContractState> {
    fn get_current_count(self: @TContractState) -> u128;
    fn increment(ref self: TContractState);
    fn decrement(ref self: TContractState);
}

// ANCHOR: contract
#[starknet::contract]
pub mod SimpleCounter {
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
// ANCHOR_END: contract

#[cfg(test)]
mod test {
    use super::{SimpleCounter, ISimpleCounterDispatcher, ISimpleCounterDispatcherTrait};
    use starknet::{ContractAddress, SyscallResultTrait, syscalls::deploy_syscall};

    fn deploy(init_value: u128) -> ISimpleCounterDispatcher {
        let (contract_address, _) = deploy_syscall(
            SimpleCounter::TEST_CLASS_HASH.try_into().unwrap(),
            0,
            array![init_value.into()].span(),
            false
        )
            .unwrap_syscall();
        ISimpleCounterDispatcher { contract_address }
    }

    #[test]
    fn should_deploy() {
        let init_value = 10;
        let contract = deploy(init_value);

        let read_value = contract.get_current_count();
        assert_eq!(read_value, init_value);
    }

    #[test]
    fn should_increment() {
        let init_value = 10;
        let contract = deploy(init_value);

        contract.increment();
        assert_eq!(contract.get_current_count(), init_value + 1);

        contract.increment();
        contract.increment();
        assert_eq!(contract.get_current_count(), init_value + 3);
    }

    #[test]
    fn should_decrement() {
        let init_value = 10;
        let contract = deploy(init_value);

        contract.decrement();
        assert_eq!(contract.get_current_count(), init_value - 1);

        contract.decrement();
        contract.decrement();
        assert_eq!(contract.get_current_count(), init_value - 3);
    }

    #[test]
    fn should_increment_and_decrement() {
        let init_value = 10;
        let contract = deploy(init_value);

        contract.increment();
        contract.decrement();
        assert_eq!(contract.get_current_count(), init_value);

        contract.decrement();
        contract.increment();
        assert_eq!(contract.get_current_count(), init_value);
    }
}
