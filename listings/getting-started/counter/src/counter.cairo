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
    use starknet::ContractAddress;
    use starknet::syscalls::deploy_syscall;
    use starknet::SyscallResultTrait;

    fn deploy(init_value: u128) -> ISimpleCounterDispatcher {
        let calldata: Array<felt252> = array![init_value.into()];
        let (address0, _) = deploy_syscall(
            SimpleCounter::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap_syscall();
        ISimpleCounterDispatcher { contract_address: address0 }
    }

    #[test]
    fn should_deploy() {
        let init_value = 10;
        let contract = deploy(init_value);

        let read_value = contract.get_current_count();
        assert(read_value == init_value, 'wrong init value');
    }

    #[test]
    #[available_gas(2000000000)]
    fn should_increment() {
        let init_value = 10;
        let contract = deploy(init_value);

        contract.increment();
        assert(contract.get_current_count() == init_value + 1, 'wrong increment value');

        contract.increment();
        contract.increment();
        assert(contract.get_current_count() == init_value + 3, 'wrong increment value');
    }

    #[test]
    #[available_gas(2000000000)]
    fn should_decrement() {
        let init_value = 10;
        let contract = deploy(init_value);

        contract.decrement();
        assert(contract.get_current_count() == init_value - 1, 'wrong decrement value');

        contract.decrement();
        contract.decrement();
        assert(contract.get_current_count() == init_value - 3, 'wrong decrement value');
    }

    #[test]
    #[available_gas(2000000000)]
    fn should_increment_and_decrement() {
        let init_value = 10;
        let contract = deploy(init_value);

        contract.increment();
        contract.decrement();
        assert(contract.get_current_count() == init_value, 'wrong value');

        contract.decrement();
        contract.increment();
        assert(contract.get_current_count() == init_value, 'wrong value');
    }
}
