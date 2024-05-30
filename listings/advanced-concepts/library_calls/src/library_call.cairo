// ANCHOR: library_dispatcher
#[starknet::interface]
pub trait IMathUtils<T> {
    fn add(ref self: T, x: u32, y: u32) -> u32;
    fn set_class_hash(ref self: T, class_hash: starknet::ClassHash);
}

// contract A
#[starknet::contract]
pub mod MathUtils {
    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl ImathUtilsImpl of super::IMathUtils<ContractState> {
        fn add(ref self: ContractState, x: u32, y: u32) -> u32 {
            x + y
        }

        fn set_class_hash(ref self: ContractState, class_hash: starknet::ClassHash) {}
    }
}


// contract B to make library call to the class of contract A
#[starknet::contract]
pub mod MathUtilsLibraryCall {
    use starknet::{class_hash::class_hash_const, ContractAddress};
    use super::{IMathUtilsDispatcherTrait, IMathUtilsLibraryDispatcher};

    #[storage]
    struct Storage {
        value: u32,
        lib_class_hash: starknet::ClassHash,
    }

    #[abi(embed_v0)]
    impl MathUtils of super::IMathUtils<ContractState> {
        fn add(ref self: ContractState, x: u32, y: u32) -> u32 {
            IMathUtilsLibraryDispatcher { class_hash: self.lib_class_hash.read() }.add(x, y)
        }

        #[abi(embed_v0)]
        fn set_class_hash(ref self: ContractState, class_hash: starknet::ClassHash) {
            self.lib_class_hash.write(class_hash);
        }
    }
}
// ANCHOR_END: library_dispatcher


