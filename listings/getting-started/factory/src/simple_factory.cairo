// ANCHOR: contract
pub use starknet::{ContractAddress, ClassHash};

#[starknet::interface]
pub trait ICounterFactory<TContractState> {
    /// Create a new counter contract from stored arguments
    fn create_counter(ref self: TContractState) -> ContractAddress;

    /// Create a new counter contract from the given arguments
    fn create_counter_at(ref self: TContractState, init_value: u128) -> ContractAddress;

    /// Update the argument
    fn update_init_value(ref self: TContractState, init_value: u128);

    /// Update the class hash of the Counter contract to deploy when creating a new counter
    fn update_counter_class_hash(ref self: TContractState, counter_class_hash: ClassHash);
}

#[starknet::contract]
pub mod CounterFactory {
    use starknet::{ContractAddress, ClassHash, SyscallResultTrait, syscalls::deploy_syscall};

    #[storage]
    struct Storage {
        /// Store the constructor arguments of the contract to deploy
        init_value: u128,
        /// Store the class hash of the contract to deploy
        counter_class_hash: ClassHash,
    }

    #[constructor]
    fn constructor(ref self: ContractState, init_value: u128, class_hash: ClassHash) {
        self.init_value.write(init_value);
        self.counter_class_hash.write(class_hash);
    }

    #[abi(embed_v0)]
    impl Factory of super::ICounterFactory<ContractState> {
        // ANCHOR: deploy
        fn create_counter_at(ref self: ContractState, init_value: u128) -> ContractAddress {
            // Contructor arguments
            let mut constructor_calldata: Array::<felt252> = array![init_value.into()];

            // Contract deployment
            let (deployed_address, _) = deploy_syscall(
                self.counter_class_hash.read(), 0, constructor_calldata.span(), false
            )
                .unwrap_syscall();

            deployed_address
        }
        // ANCHOR_END: deploy

        fn create_counter(ref self: ContractState) -> ContractAddress {
            self.create_counter_at(self.init_value.read())
        }

        fn update_init_value(ref self: ContractState, init_value: u128) {
            self.init_value.write(init_value);
        }

        fn update_counter_class_hash(ref self: ContractState, counter_class_hash: ClassHash) {
            self.counter_class_hash.write(counter_class_hash);
        }
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod tests {
    use super::{CounterFactory, ICounterFactoryDispatcher, ICounterFactoryDispatcherTrait};
    use starknet::{
        SyscallResultTrait, ContractAddress, ClassHash, contract_address_const,
        syscalls::deploy_syscall
    };

    // Define a target contract to deploy
    mod target {
        #[starknet::interface]
        pub trait ISimpleCounter<TContractState> {
            fn get_current_count(self: @TContractState) -> u128;
            fn increment(ref self: TContractState);
            fn decrement(ref self: TContractState);
        }

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
                    self.counter.read()
                }

                fn increment(ref self: ContractState) {
                    // Store counter value + 1
                    let mut counter: u128 = self.counter.read() + 1;
                    self.counter.write(counter);
                }
                fn decrement(ref self: ContractState) {
                    // Store counter value - 1
                    let mut counter: u128 = self.counter.read() - 1;
                    self.counter.write(counter);
                }
            }
        }
    }
    use target::{ISimpleCounterDispatcher, ISimpleCounterDispatcherTrait};

    /// Deploy a counter factory contract
    fn deploy_factory(
        counter_class_hash: ClassHash, init_value: u128
    ) -> ICounterFactoryDispatcher {
        let mut constructor_calldata: Array::<felt252> = array![
            init_value.into(), counter_class_hash.into()
        ];

        let (contract_address, _) = deploy_syscall(
            CounterFactory::TEST_CLASS_HASH.try_into().unwrap(),
            0,
            constructor_calldata.span(),
            false
        )
            .unwrap_syscall();

        ICounterFactoryDispatcher { contract_address }
    }

    #[test]
    fn test_deploy_counter_constructor() {
        let init_value = 10;

        let counter_class_hash: ClassHash = target::SimpleCounter::TEST_CLASS_HASH
            .try_into()
            .unwrap();
        let factory = deploy_factory(counter_class_hash, init_value);

        let counter_address = factory.create_counter();
        let counter = target::ISimpleCounterDispatcher { contract_address: counter_address };

        assert_eq!(counter.get_current_count(), init_value);
    }

    #[test]
    fn test_deploy_counter_argument() {
        let init_value = 10;
        let argument_value = 20;

        let counter_class_hash: ClassHash = target::SimpleCounter::TEST_CLASS_HASH
            .try_into()
            .unwrap();
        let factory = deploy_factory(counter_class_hash, init_value);

        let counter_address = factory.create_counter_at(argument_value);
        let counter = target::ISimpleCounterDispatcher { contract_address: counter_address };

        assert_eq!(counter.get_current_count(), argument_value);
    }

    #[test]
    fn test_deploy_multiple() {
        let init_value = 10;
        let argument_value = 20;

        let counter_class_hash: ClassHash = target::SimpleCounter::TEST_CLASS_HASH
            .try_into()
            .unwrap();
        let factory = deploy_factory(counter_class_hash, init_value);

        let mut counter_address = factory.create_counter();
        let counter_1 = target::ISimpleCounterDispatcher { contract_address: counter_address };

        counter_address = factory.create_counter_at(argument_value);
        let counter_2 = target::ISimpleCounterDispatcher { contract_address: counter_address };

        assert_eq!(counter_1.get_current_count(), init_value);
        assert_eq!(counter_2.get_current_count(), argument_value);
    }
}
