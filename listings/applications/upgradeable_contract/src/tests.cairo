mod tests {
    use starknet::class_hash::ClassHash;

    use super::super::upgradeable_contract_v0::{
        UpgradeableContract_V0, IUpgradeableContractDispatcher as IUpgradeableContractDispatcher_v0,
        IUpgradeableContractDispatcherTrait as UpgradeableContractDispatcherTrait_v0,
        UpgradeableContract_V0::{Event, Upgraded}
    };

    use super::super::upgradeable_contract_v1::{
        UpgradeableContract_V1, IUpgradeableContractDispatcher as IUpgradeableContractDispatcher_v1,
        IUpgradeableContractDispatcherTrait as UpgradeableContractDispatcherTrait_v1
    };


    use starknet::{
        ContractAddress, SyscallResultTrait, syscalls::deploy_syscall, get_caller_address,
        contract_address_const
    };
    use core::num::traits::Zero;

    use starknet::testing::{set_contract_address, set_account_contract_address};

    // deploy v0 contract
    fn deploy_v0() -> (IUpgradeableContractDispatcher_v0, ContractAddress, ClassHash) {
        let (contract_address, _) = deploy_syscall(
            UpgradeableContract_V0::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
        (
            IUpgradeableContractDispatcher_v0 { contract_address },
            contract_address,
            UpgradeableContract_V0::TEST_CLASS_HASH.try_into().unwrap()
        )
    }

    //  deploy v1 contract 
    fn deploy_v1() -> (IUpgradeableContractDispatcher_v1, ContractAddress, ClassHash) {
        let (contract_address, _) = deploy_syscall(
            UpgradeableContract_V1::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
        (
            IUpgradeableContractDispatcher_v1 { contract_address },
            contract_address,
            UpgradeableContract_V1::TEST_CLASS_HASH.try_into().unwrap()
        )
    }

    #[test]
    fn test_deploy_v0() {
        deploy_v0();
    }

    #[test]
    fn test_deploy_v1() {
        deploy_v1();
    }

    #[test]
    fn test_version_from_v0() {
        let (dispatcher, _, _) = deploy_v0();
        assert(dispatcher.version() == 0, 'incorrect version');
    }

    #[test]
    #[should_panic(expected: ('Class hash cannot be zero', 'ENTRYPOINT_FAILED'))]
    fn test_upgrade_when_classhash_is_zero() {
        let (dispatcher_v0, _, _) = deploy_v0();
        dispatcher_v0.upgrade(Zero::zero());
    }

    #[test]
    fn test_succesful_upgrade_from_v0_to_v1() {
        let (dispatcher_v0, contract_address, _) = deploy_v0();
        let (_, _, class_hash) = deploy_v1();
        dispatcher_v0.upgrade(class_hash);
        // emit event
        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Upgraded(Upgraded { implementation: class_hash }))
        );

        assert(dispatcher_v0.version() == 1, ' version did not upgrade');
    }
}
