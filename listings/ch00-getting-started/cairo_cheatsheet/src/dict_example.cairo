#[starknet::contract]
mod dictExample {

use dict::Felt252DictTrait;


    #[storage]
    struct Storage {
        
    }


    #[external(v0)]
    #[generate_trait]
    impl external of externlalTrait {
        fn usersAge(self: @ContractState) {
            let mut records: Felt252Dict<u64> = Default::default();

            records.insert('Joe', 25);
            records.insert('rose', 30);

            let rose_age = records.get('rose');
            assert(rose_age == 30, 'age is not 30');

        }
    }
}
