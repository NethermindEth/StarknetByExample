#[contract]
mod UpgradeableContract_V0 {
    use starknet::class_hash::ClassHash;
    use zeroable::Zeroable;
    use result::ResultTrait;
    use starknet::SyscallResult;

    struct Storage {}

    #[event]
    fn Upgraded(implementation: ClassHash) {}

    #[external]
    fn upgrade(impl_hash: ClassHash) {
        assert(!impl_hash.is_zero(), 'Class hash cannot be zero');
        starknet::replace_class_syscall(impl_hash).unwrap_syscall();
        Upgraded(impl_hash);
    }

    #[view]
    fn version() -> u8 {
        0
    }
}
