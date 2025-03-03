mod tests {
    use crate::upgradeable_contract_v0::{
        UpgradeableContract_V0, IUpgradeableContractDispatcher as IUpgradeableContractDispatcher_v0,
        IUpgradeableContractDispatcherTrait as UpgradeableContractDispatcherTrait_v0,
        UpgradeableContract_V0::Upgraded,
    };
    use crate::upgradeable_contract_v1::{
        IUpgradeableContractDispatcher as IUpgradeableContractDispatcher_v1,
    };
    use snforge_std::{
        ContractClass, ContractClassTrait, DeclareResultTrait, declare, spy_events,
        EventSpyAssertionsTrait,
    };
    use core::num::traits::Zero;

    // deploy v0 contract
    fn deploy_v0() -> (IUpgradeableContractDispatcher_v0, ContractClass) {
        let contract = declare("UpgradeableContract_V0").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();

        (IUpgradeableContractDispatcher_v0 { contract_address }, *contract)
    }

    //  deploy v1 contract
    fn deploy_v1() -> (IUpgradeableContractDispatcher_v1, ContractClass) {
        let contract = declare("UpgradeableContract_V1").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();

        (IUpgradeableContractDispatcher_v1 { contract_address }, *contract)
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
        let (dispatcher, _) = deploy_v0();
        assert(dispatcher.version() == 0, 'incorrect version');
    }

    #[test]
    #[should_panic(expected: 'Class hash cannot be zero')]
    fn test_upgrade_when_classhash_is_zero() {
        let (dispatcher, _) = deploy_v0();
        dispatcher.upgrade(Zero::zero());
    }

    #[test]
    fn test_successful_upgrade_from_v0_to_v1() {
        let (dispatcher_v0, _) = deploy_v0();
        let (_, contract_class) = deploy_v1();

        let mut spy = spy_events();
        dispatcher_v0.upgrade(contract_class.class_hash);

        assert(dispatcher_v0.version() == 1, ' version did not upgrade');
        spy
            .assert_emitted(
                @array![
                    (
                        dispatcher_v0.contract_address,
                        UpgradeableContract_V0::Event::Upgraded(
                            Upgraded { implementation: contract_class.class_hash },
                        ),
                    ),
                ],
            );
    }
}
