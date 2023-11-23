#[starknet::contract]
mod listExample {
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


    #[external(v0)]
    #[generate_trait]
    impl external of externalTrait {
        fn add_in_amount(ref self: ContractState, number: u128) {
            let mut current_amount_list = self.amount.read();
            current_amount_list.append(number);
        }

        fn add_in_task(ref self: ContractState, description: felt252, status: felt252) {
            let new_task = Task { description: description, status: status };
            let mut current_tasks_list = self.tasks.read();
            current_tasks_list.append(new_task);
        }

        fn is_empty_list(ref self: ContractState) -> bool {
            let mut current_amount_list = self.amount.read();
            current_amount_list.is_empty()
        }

        fn list_length(ref self: ContractState) -> u32 {
            let mut current_amount_list = self.amount.read();
            current_amount_list.len()
        }

        fn get_from_index(ref self: ContractState, index: u32) -> u128 {
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

        fn array_conversion(ref self: ContractState) -> Array<u128> {
            let mut current_amount_list = self.amount.read();
            current_amount_list.array()
        }
    }
}
