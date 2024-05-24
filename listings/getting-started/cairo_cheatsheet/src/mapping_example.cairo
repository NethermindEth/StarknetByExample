use starknet::ContractAddress;

#[starknet::interface]
trait IMappingExample<TContractState> {
    fn register_user(ref self: TContractState, student_add: ContractAddress, studentName: felt252);
    fn record_student_score(
        ref self: TContractState, student_add: ContractAddress, subject: felt252, score: u16
    );
    fn view_student_name(self: @TContractState, student_add: ContractAddress) -> felt252;
    fn view_student_score(
        self: @TContractState, student_add: ContractAddress, subject: felt252
    ) -> u16;
}

#[starknet::contract]
mod MappingContract {
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        students_name: LegacyMap::<ContractAddress, felt252>,
        students_result_record: LegacyMap::<(ContractAddress, felt252), u16>,
    }

    #[abi(embed_v0)]
    impl External of super::IMappingExample<ContractState> {
        fn register_user(
            ref self: ContractState, student_add: ContractAddress, studentName: felt252
        ) {
            self.students_name.write(student_add, studentName);
        }

        fn record_student_score(
            ref self: ContractState, student_add: ContractAddress, subject: felt252, score: u16
        ) {
            self.students_result_record.write((student_add, subject), score);
        }

        fn view_student_name(self: @ContractState, student_add: ContractAddress) -> felt252 {
            self.students_name.read(student_add)
        }

        fn view_student_score(
            self: @ContractState, student_add: ContractAddress, subject: felt252
        ) -> u16 {
            // for a 2D mapping its important to take note of the amount of brackets being used.
            self.students_result_record.read((student_add, subject))
        }
    }
}
