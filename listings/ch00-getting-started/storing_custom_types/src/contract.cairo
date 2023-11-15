#[starknet::interface]
trait IStoringCustomType<TContractState> {
    fn set_person(ref self: TContractState);
    fn get_person(ref self: TContractState);
}

#[starknet::contract]
mod StoringCustomType {
    #[storage]
    struct Storage {
        person: Person
    }

    // Deriving the starknet::Store trait
    // allows us to store the `Person` struct in the contract's storage.
    #[derive(Drop, starknet::Store)]
    struct Person {
        age: u8,
        name: felt252
    }

    #[abi(per_item)]
    #[external(v0)]
    fn set_person(ref self: ContractState) {
        self.person.write(Person { age: 10, name: 'Joe' });
    }

    #[external(v0)]
    fn get_person(self: @ContractState) {
        self.person.read();
    }
}
