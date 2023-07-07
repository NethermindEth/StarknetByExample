#[starknet::contract]
mod UpgradeableContract_V1 {
    use starknet::class_hash::ClassHash;
    use zeroable::Zeroable;
    use result::ResultTrait;
    use starknet::SyscallResult;

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

    #[generate_trait]
    #[external(v0)]
    impl UpgradeableContract of IUpgradeableContract {
        fn upgrade(ref self: ContractState, impl_hash: ClassHash) {
            assert(!impl_hash.is_zero(), 'Class hash cannot be zero');
            starknet::replace_class_syscall(impl_hash).unwrap_syscall();
            self.emit(Event::Upgraded(Upgraded { implementation: impl_hash }))
        }

        fn version(self: @ContractState) -> u8 {
            1
        }
    }
}
