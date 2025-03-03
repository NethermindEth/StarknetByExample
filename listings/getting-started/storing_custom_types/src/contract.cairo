// [!region contract]
#[starknet::interface]
trait IStoringCustomType<TContractState> {
    fn set_person(ref self: TContractState, person: Person);
    fn set_name(ref self: TContractState, name: felt252);
}

// Deriving the starknet::Store trait
// allows us to store the `Person` struct in the contract's storage.
#[derive(Drop, Serde, Copy, starknet::Store)]
struct Person {
    age: u8,
    name: felt252,
}

#[starknet::contract]
mod StoringCustomType {
    use starknet::storage::StoragePointerWriteAccess;
    use super::Person;
    use super::IStoringCustomType;

    #[storage]
    struct Storage {
        person: Person,
    }

    #[abi(embed_v0)]
    impl StoringCustomType of IStoringCustomType<ContractState> {
        fn set_person(ref self: ContractState, person: Person) {
            self.person.write(person);
        }

        // [!region set_name]
        fn set_name(ref self: ContractState, name: felt252) {
            self.person.name.write(name);
        }
        // [!endregion set_name]
    }
}
// [!endregion contract]

#[cfg(test)]
mod tests {
    use super::{IStoringCustomTypeDispatcherTrait, IStoringCustomTypeDispatcher, Person};
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

    fn deploy() -> IStoringCustomTypeDispatcher {
        let contract = declare("StoringCustomType").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();
        IStoringCustomTypeDispatcher { contract_address }
    }


    #[test]
    fn can_call_set_person() {
        let mut contract = deploy();
        let person = Person { age: 10, name: 'Joe' };
        contract.set_person(person);
    }

    #[test]
    fn can_call_set_name() {
        let mut contract = deploy();
        contract.set_name('John');
    }
}
