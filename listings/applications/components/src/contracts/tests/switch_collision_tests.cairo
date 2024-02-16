mod switch_collision_tests {
    use components::switchable::switchable_component::SwitchableInternalTrait;
    use components::switchable::{ISwitchable, ISwitchableDispatcher, ISwitchableDispatcherTrait};

    use components::contracts::switch_collision::{
        SwitchCollisionContract, ISwitchCollisionDispatcher, ISwitchCollisionDispatcherTrait
    };

    use starknet::storage::StorageMemberAccessTrait;
    use starknet::SyscallResultTrait;
    use starknet::syscalls::deploy_syscall;

    fn deploy() -> (ISwitchCollisionDispatcher, ISwitchableDispatcher) {
        let (contract_address, _) = deploy_syscall(
            SwitchCollisionContract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();

        (
            ISwitchCollisionDispatcher { contract_address },
            ISwitchableDispatcher { contract_address },
        )
    }

    #[test]
    #[available_gas(2000000)]
    // ANCHOR: collision
    fn test_collision() {
        let (mut contract, mut contract_iswitch) = deploy();

        assert(contract.get() == false, 'value !off');
        assert(contract_iswitch.is_on() == false, 'switch !off');

        contract_iswitch.switch();
        assert(contract_iswitch.is_on() == true, 'switch !on');
        assert(contract.get() == true, 'value !on');

        // `collision` between component storage 'value' and contract storage 'value'
        assert(contract.get() == contract_iswitch.is_on(), 'value != switch');

        contract.set(false);
        assert(contract.get() == contract_iswitch.is_on(), 'value != switch');
    }
// ANCHOR_END: collision
}
