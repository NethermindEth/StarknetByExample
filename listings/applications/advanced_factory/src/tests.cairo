// use core::result::ResultTrait;
// use advanced_factory::{CounterFactory, ICounterFactoryDispatcher,
// ICounterFactoryDispatcherTrait};
// use starknet::{ContractAddress, ClassHash,};
// use snforge_std::{declare, ContractClass, ContractClassTrait};

// // Define a target contract to deploy
// use advanced_factory::simple_counter::{ISimpleCounterDispatcher, ISimpleCounterDispatcherTrait};

// /// Deploy a counter factory contract
// fn deploy_factory(counter_class_hash: ClassHash, init_value: u128) -> ICounterFactoryDispatcher {
//     let mut constructor_calldata: @Array::<felt252> = @array![
//         init_value.into(), counter_class_hash.into()
//     ];

//     let contract = declare("CounterFactory").unwrap();
//     let (contract_address, _) = contract.deploy(constructor_calldata).unwrap();

//     ICounterFactoryDispatcher { contract_address }
// }
// #[test]
// fn test_deploy_counter_constructor() {
//     let init_value = 10;

//     let counter_class_hash = declare("SimpleCounter").unwrap().class_hash;
//     let factory = deploy_factory(counter_class_hash, init_value);

//     let counter_address = factory.create_counter();
//     let counter = ISimpleCounterDispatcher { contract_address: counter_address };

//     assert_eq!(counter.get_current_count(), init_value);
// }

// #[test]
// fn test_deploy_counter_argument() {
//     let init_value = 10;
//     let argument_value = 20;

//     let counter_class_hash = declare("SimpleCounter").unwrap().class_hash;
//     let factory = deploy_factory(counter_class_hash, init_value);

//     let counter_address = factory.create_counter_at(argument_value);
//     let counter = ISimpleCounterDispatcher { contract_address: counter_address };

//     assert_eq!(counter.get_current_count(), argument_value);
// }

// #[test]
// fn test_deploy_multiple() {
//     let init_value = 10;
//     let argument_value = 20;

//     let counter_class_hash = declare("SimpleCounter").unwrap().class_hash;
//     let factory = deploy_factory(counter_class_hash, init_value);

//     let mut counter_address = factory.create_counter();
//     let counter_1 = ISimpleCounterDispatcher { contract_address: counter_address };

//     counter_address = factory.create_counter_at(argument_value);
//     let counter_2 = ISimpleCounterDispatcher { contract_address: counter_address };

//     assert_eq!(counter_1.get_current_count(), init_value);
//     assert_eq!(counter_2.get_current_count(), argument_value);
// }


