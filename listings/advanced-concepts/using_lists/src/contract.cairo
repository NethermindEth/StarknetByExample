#[starknet::interface]
trait IListExample<TContractState> {
    fn add_in_amount(ref self: TContractState, number: u128);
    fn add_in_task(ref self: TContractState, description: felt252, status: felt252);
    fn is_empty_list(self: @TContractState) -> bool;
    fn list_length(self: @TContractState) -> u32;
    fn get_from_index(self: @TContractState, index: u32) -> u128;
    fn set_from_index(ref self: TContractState, index: u32, number: u128);
    fn pop_front_list(ref self: TContractState);
    fn array_conversion(self: @TContractState) -> Array<u128>;
}

#[starknet::contract]
mod ListExample {
    use alexandria_storage::list::{List, ListTrait};

    #[storage]
    struct Storage {
        amount: List<u128>,
        tasks: List<Task>
    }

    #[derive(Copy, Drop, Serde, starknet::Store)]
    struct Task {
        description: felt252,
        status: felt252
    }


    #[abi(embed_v0)]
    impl ListExample of super::IListExample<ContractState> {
        fn add_in_amount(ref self: ContractState, number: u128) {
            let mut current_amount_list = self.amount.read();
            current_amount_list.append(number);
        }

        fn add_in_task(ref self: ContractState, description: felt252, status: felt252) {
            let new_task = Task { description: description, status: status };
            let mut current_tasks_list = self.tasks.read();
            current_tasks_list.append(new_task);
        }

        fn is_empty_list(self: @ContractState) -> bool {
            let mut current_amount_list = self.amount.read();
            current_amount_list.is_empty()
        }

        fn list_length(self: @ContractState) -> u32 {
            let mut current_amount_list = self.amount.read();
            current_amount_list.len()
        }

        fn get_from_index(self: @ContractState, index: u32) -> u128 {
            self.amount.read()[index]
        }

        fn set_from_index(ref self: ContractState, index: u32, number: u128) {
            let mut current_amount_list = self.amount.read();
            current_amount_list.set(index, number);
        }

        fn pop_front_list(ref self: ContractState) {
            let mut current_amount_list = self.amount.read();
            current_amount_list.pop_front();
        }

        fn array_conversion(self: @ContractState) -> Array<u128> {
            let mut current_amount_list = self.amount.read();
            current_amount_list.array()
        }
    }
}
