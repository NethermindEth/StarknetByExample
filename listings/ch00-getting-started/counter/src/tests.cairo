mod tests {
    use core::result::ResultTrait;
    use counter::contracts::{
        SimpleCounter, ISimpleCounterDispatcher, ISimpleCounterDispatcherTrait
    };
    use starknet::{deploy_syscall, ContractAddress};
    use starknet::class_hash::Felt252TryIntoClassHash;

    fn deploy(init_value: u128) -> ISimpleCounterDispatcher {
        let calldata: Array<felt252> = array![init_value.into()];
        let (address0, _) = deploy_syscall(
            SimpleCounter::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();
        ISimpleCounterDispatcher { contract_address: address0 }
    }

    #[test]
    #[available_gas(2000000000)]
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

