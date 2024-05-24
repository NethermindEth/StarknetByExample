mod tests {
    use starknet::SyscallResultTrait;
    use struct_as_mapping_key::contract::{PetRegistry, Pet};
    use starknet::syscalls::deploy_syscall;

    #[starknet::interface]
    trait IPetRegistry<TContractState> {
        fn register_pet(ref self: TContractState, key: Pet, timestamp: u64);
        fn get_registration_date(self: @TContractState, key: Pet) -> u64;
    }

    #[test]
    #[available_gas(20000000)]
    fn test_e2e() {
        // Set up.
        let mut calldata: Array<felt252> = array![];
        let (address0, _) = deploy_syscall(
            PetRegistry::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap_syscall();
        let mut contract = IPetRegistryDispatcher { contract_address: address0 };

        let pet = Pet { name: 'Cute Labrador', age: 5, owner: 'Louis' };

        // Store a pet.
        contract.register_pet(pet, 1234);

        // Read the array.
        let registration_date = contract.get_registration_date(pet);
        assert(registration_date == 1234, 'registration_date');
    }
}
