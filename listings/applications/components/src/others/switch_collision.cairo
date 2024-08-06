// ANCHOR: interface
#[starknet::interface]
pub trait ISwitchCollision<TContractState> {
    fn set(ref self: TContractState, value: bool);
    fn get(ref self: TContractState) -> bool;
}
// ANCHOR_END: interface

#[starknet::contract]
pub mod SwitchCollisionContract {
    use components::switchable::switchable_component;

    component!(path: switchable_component, storage: switch, event: SwitchableEvent);

    #[abi(embed_v0)]
    impl SwitchableImpl = switchable_component::Switchable<ContractState>;
    impl SwitchableInternalImpl = switchable_component::SwitchableInternalImpl<ContractState>;

    // ANCHOR: storage
    #[storage]
    struct Storage {
        switchable_value: bool,
        #[substorage(v0)]
        switch: switchable_component::Storage,
    }
    // ANCHOR_END: storage

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
    use components::switchable::switchable_component::SwitchableInternalTrait;
    use components::switchable::{ISwitchable, ISwitchableDispatcher, ISwitchableDispatcherTrait};
    use super::{
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
    // ANCHOR: collision
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
// ANCHOR_END: collision
}
