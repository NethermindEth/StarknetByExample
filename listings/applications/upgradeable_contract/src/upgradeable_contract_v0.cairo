// [!region contract]
use starknet::class_hash::ClassHash;

#[starknet::interface]
pub trait IUpgradeableContract<TContractState> {
    fn upgrade(ref self: TContractState, impl_hash: ClassHash);
    fn version(self: @TContractState) -> u8;
}

#[starknet::contract]
pub mod UpgradeableContract_V0 {
    use starknet::class_hash::ClassHash;
    use starknet::SyscallResultTrait;
    use core::num::traits::Zero;

    #[storage]
    struct Storage {}


    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Upgraded: Upgraded
    }

    #[derive(Drop, starknet::Event)]
    struct Upgraded {
        implementation: ClassHash
    }

    #[abi(embed_v0)]
    impl UpgradeableContract of super::IUpgradeableContract<ContractState> {
        // [!region upgrade]
        fn upgrade(ref self: ContractState, impl_hash: ClassHash) {
            assert(!impl_hash.is_zero(), 'Class hash cannot be zero');
            starknet::syscalls::replace_class_syscall(impl_hash).unwrap_syscall();
            self.emit(Event::Upgraded(Upgraded { implementation: impl_hash }))
        }
        // [!endregion upgrade]
        fn version(self: @ContractState) -> u8 {
            0
        }
    }
}
// [!endregion contract]


