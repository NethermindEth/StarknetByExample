use starknet::account::Call;

// IERC6 obtained from Open Zeppelin's cairo-contracts/src/account/interface.cairo
#[starknet::interface]
trait ISRC6<TState> {
    fn __execute__(self: @TState, calls: Array<Call>) -> Array<Span<felt252>>;
    fn __validate__(self: @TState, calls: Array<Call>) -> felt252;
    fn is_valid_signature(self: @TState, hash: felt252, signature: Array<felt252>) -> felt252;
}

#[starknet::contract(account)]
mod HelloAccount {
    use core::traits::Into;
    use starknet::VALIDATED;
    use starknet::account::Call;
    use starknet::get_caller_address;

    #[storage]
    struct Storage {} // Empty storage. No public key is stored.

    #[abi(embed_v0)]
    impl SRC6Impl of super::ISRC6<ContractState> {
        fn is_valid_signature(
            self: @ContractState, hash: felt252, signature: Array<felt252>
        ) -> felt252 {
            // No signature is required so any signature is valid.
            VALIDATED
        }
        fn __validate__(self: @ContractState, calls: Array<Call>) -> felt252 {
            let hash = 0;
            let mut signature: Array<felt252> = ArrayTrait::new();
            signature.append(0);
            self.is_valid_signature(hash, signature)
        }
        fn __execute__(self: @ContractState, calls: Array<Call>) -> Array<Span<felt252>> {
            let sender = get_caller_address();
            assert(sender.is_zero(), 'Account: invalid caller');
            let Call { to, selector, calldata } = calls.at(0);
            let _res = starknet::call_contract_syscall(*to, *selector, *calldata).unwrap();
            let mut res = ArrayTrait::new();
            res.append(_res);
            res
        }
    }
}
