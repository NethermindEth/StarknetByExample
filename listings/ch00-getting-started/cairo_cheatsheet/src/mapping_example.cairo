#[starknet::contract]
mod mappingContract {
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        studentsName: LegacyMap::<ContractAddress, felt252>,
        studentsResultRecord: LegacyMap::<(ContractAddress, felt252), u16>,
    }

    #[external(v0)]
    #[generate_trait]
    impl external of externalTrait {
        fn registerUser(
            ref self: ContractState, studentAdd: ContractAddress, studentName: felt252
        ) {
            self.studentsName.write(studentAdd, studentName);
        }

        fn recordStudentScore(
            ref self: ContractState, studentAdd: ContractAddress, Subject: felt252, score: u16
        ) {
            self.studentsResultRecord.write((studentAdd, Subject), score);
        }

        fn viewStudentName(self: @ContractState, studentAdd: ContractAddress) -> felt252 {
            self.studentsName.read(studentAdd)
        }

        fn viewStudentScore(
            self: @ContractState, studentAdd: ContractAddress, Subject: felt252
        ) -> u16 {
            // for a 2D mapping its important to take note of the amount of brackets being used.
            self.studentsResultRecord.read((studentAdd, Subject))
        }
    }
}
