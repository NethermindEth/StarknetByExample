mod tests {
    use starknet::SyscallResultTrait;
    use starknet::{ContractAddress, ClassHash, contract_address_const};
    use starknet::syscalls::deploy_syscall;

    use factory::simple_factory::{
        CounterFactory, ICounterFactoryDispatcher, ICounterFactoryDispatcherTrait
    };
    use factory::target::{SimpleCounter, ISimpleCounterDispatcher, ISimpleCounterDispatcherTrait};

    /// Deploy a counter factory contract
    fn deploy_factory(
        counter_class_hash: ClassHash, init_value: u128
    ) -> ICounterFactoryDispatcher {
        // let caller_address: ContractAddress = contract_address_const::<'caller'>();
        // let deployed_contract_address = contract_address_const::<'market_factory'>();

        let mut constructor_calldata: Array::<felt252> = array![
            init_value.into(), counter_class_hash.into()
        ];

        let (factory_address, _) = deploy_syscall(
            CounterFactory::TEST_CLASS_HASH.try_into().unwrap(),
            0,
            constructor_calldata.span(),
            false
        )
            .unwrap_syscall();

        ICounterFactoryDispatcher { contract_address: factory_address }
    }

    #[test]
    #[available_gas(20000000)]
    fn test_deploy_counter_constructor() {
        let init_value = 10;

        let counter_class_hash: ClassHash = SimpleCounter::TEST_CLASS_HASH.try_into().unwrap();
        let factory = deploy_factory(counter_class_hash, init_value);

        let counter_address = factory.create_counter();
        let counter = ISimpleCounterDispatcher { contract_address: counter_address };

        assert(counter.get_current_count() == init_value, 'Incorrect initial value');
    }

    #[test]
    #[available_gas(20000000)]
    fn test_deploy_counter_argument() {
        let init_value = 10;
        let argument_value = 20;

        let counter_class_hash: ClassHash = SimpleCounter::TEST_CLASS_HASH.try_into().unwrap();
        let factory = deploy_factory(counter_class_hash, init_value);

        let counter_address = factory.create_counter_at(argument_value);
        let counter = ISimpleCounterDispatcher { contract_address: counter_address };

        assert(counter.get_current_count() == argument_value, 'Incorrect argument value');
    }

    #[test]
    #[available_gas(20000000)]
    fn test_deploy_multiple() {
        let init_value = 10;
        let argument_value = 20;

        let counter_class_hash: ClassHash = SimpleCounter::TEST_CLASS_HASH.try_into().unwrap();
        let factory = deploy_factory(counter_class_hash, init_value);

        let mut counter_address = factory.create_counter();
        let counter_1 = ISimpleCounterDispatcher { contract_address: counter_address };

        counter_address = factory.create_counter_at(argument_value);
        let counter_2 = ISimpleCounterDispatcher { contract_address: counter_address };

        assert(counter_1.get_current_count() == init_value, 'Incorrect initial value');
        assert(counter_2.get_current_count() == argument_value, 'Incorrect argument value');
    }
}
