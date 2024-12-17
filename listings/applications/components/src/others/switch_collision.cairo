// [!region interface]
#[starknet::interface]
pub trait ISwitchCollision<TContractState> {
    fn set(ref self: TContractState, value: bool);
    fn get(ref self: TContractState) -> bool;
}
// [!endregion interface]

#[starknet::contract]
pub mod SwitchCollisionContract {
    use components::switchable::switchable_component;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    component!(path: switchable_component, storage: switch, event: SwitchableEvent);

    #[abi(embed_v0)]
    impl SwitchableImpl = switchable_component::Switchable<ContractState>;
    impl SwitchableInternalImpl = switchable_component::SwitchableInternalImpl<ContractState>;

    // [!region storage]
    #[storage]
    struct Storage {
        switchable_value: bool,
        #[substorage(v0)]
        switch: switchable_component::Storage,
    }
    // [!endregion storage]

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.switch._off();
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        SwitchableEvent: switchable_component::Event,
    }

    #[abi(embed_v0)]
    impl SwitchCollisionContract of super::ISwitchCollision<ContractState> {
        fn set(ref self: ContractState, value: bool) {
            self.switchable_value.write(value);
        }

        fn get(ref self: ContractState) -> bool {
            self.switchable_value.read()
        }
    }
}

#[cfg(test)]
mod switch_collision_tests {
    use components::switchable::{ISwitchableDispatcher, ISwitchableDispatcherTrait};
    use super::{
        SwitchCollisionContract, ISwitchCollisionDispatcher, ISwitchCollisionDispatcherTrait,
    };
    use starknet::SyscallResultTrait;
    use starknet::syscalls::deploy_syscall;

    fn deploy() -> (ISwitchCollisionDispatcher, ISwitchableDispatcher) {
        let (contract_address, _) = deploy_syscall(
            SwitchCollisionContract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false,
        )
            .unwrap_syscall();

        (
            ISwitchCollisionDispatcher { contract_address },
            ISwitchableDispatcher { contract_address },
        )
    }

    #[test]
    // [!region collision]
    fn test_collision() {
        let (mut contract, mut contract_iswitch) = deploy();

        assert_eq!(contract.get(), false);
        assert_eq!(contract_iswitch.is_on(), false);

        contract_iswitch.switch();
        assert_eq!(contract_iswitch.is_on(), true);
        assert_eq!(contract.get(), true);

        // `collision` between component storage 'value' and contract storage 'value'
        assert_eq!(contract.get(), contract_iswitch.is_on());

        contract.set(false);
        assert_eq!(contract.get(), contract_iswitch.is_on());
    }
    // [!endregion collision]
}
