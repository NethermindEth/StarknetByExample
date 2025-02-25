use starknet::account::Call;
use starknet::ContractAddress;

#[starknet::interface]
trait ISRC6<TContractState> {
    fn __execute__(ref self: TContractState, calls: Array<Call>) -> Array<Span<felt252>>;
    fn __validate__(self: @TContractState, calls: Array<Call>) -> felt252;
    fn is_valid_signature(
        self: @TContractState, hash: felt252, signature: Array<felt252>,
    ) -> felt252;
}

#[starknet::interface]
trait ISRC5<TContractState> {
    fn supports_interface(self: @TContractState, interface_id: felt252) -> bool;
}

#[starknet::interface]
trait IDeployableAccount<TContractState> {
    fn __validate_deploy__(
        self: @TContractState, class_hash: felt252, public_key: felt252, time_limit: u64,
    ) -> felt252;
}

#[starknet::interface]
trait IDeclarerAccount<TContractState> {
    fn __validate_declare__(self: @TContractState, class_hash: felt252) -> felt252;
}

#[starknet::interface]
trait ISpendingLimitsAccount<TContractState> {
    fn public_key(self: @TContractState) -> felt252;
    fn get_time_limit(self: @TContractState) -> u64;
    fn set_spending_limit(ref self: TContractState, token_address: ContractAddress, _limit: u256);
    fn get_spending_limit_timestamp(self: @TContractState, token_address: ContractAddress) -> u64;
    fn get_current_spending_limit(self: @TContractState, token_address: ContractAddress) -> u256;
    fn get_spending_limit(self: @TContractState, token_address: ContractAddress) -> u256;
}

#[derive(Copy, Drop, Serde, starknet::Store)]
struct SpendingLimit {
    exists: bool,
    timestamp: u64,
    limit: u256,
}

#[starknet::contract(account)]
mod Account {
    use super::{
        ISRC6, ISRC5, IDeployableAccount, IDeclarerAccount, ISpendingLimitsAccount, SpendingLimit,
    };
    use starknet::{
        ContractAddress, get_caller_address, get_tx_info, VALIDATED, get_block_timestamp,
        get_contract_address, account::Call, syscalls::call_contract_syscall,
    };
    use starknet::storage::{
        Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePointerReadAccess,
        StoragePointerWriteAccess,
    };
    use core::num::traits::Zero;

    #[storage]
    struct Storage {
        public_key: felt252,
        spending_limit: Map<ContractAddress, SpendingLimit>,
        current_spending_limit: Map<ContractAddress, u256>,
        time_limit: u64,
    }
    const SRC6_TRAIT_ID: felt252 =
        1270010605630597976495846281167968799381097569185364931397797212080166453709;

    pub mod Selectors {
        pub const TRANSFER: felt252 =
            0x83afd3f4caedc6eebf44246fe54e38c95e3179a5ec9ea81740eca5b482d12e;
        pub const APPROVE: felt252 =
            0x0219209e083275171774dab1df80982e9df2096516f06319c5c6d71ae0a8480c;
    }

    pub mod Errors {
        pub const INVALID_CALLER: felt252 = 'Account: Invalid caller';
        pub const INVALID_SIGNATURE: felt252 = 'Account: Invalid tx signature';
        pub const INVALID_TX_VERSION: felt252 = 'Account: Invalid tx version';
        pub const UNAUTHORIZED: felt252 = 'Account: Unauthorized';
    }

    // time_limit is in seconds
    #[constructor]
    fn constructor(ref self: ContractState, public_key: felt252, time_limit: u64) {
        self.public_key.write(public_key);
        self.time_limit.write(time_limit);
    }

    //
    // External
    //

    #[abi(embed_v0)]
    impl SRC6 of ISRC6<ContractState> {
        fn __execute__(ref self: ContractState, mut calls: Array<Call>) -> Array<Span<felt252>> {
            self.only_protocol();

            let mut res = array![];
            for call in calls {
                let Call { to, selector, calldata } = call;

                let limit_exists: bool = self.spending_limit.read(to).exists;
                if (self.is_spending_tx(selector) && limit_exists) {
                    let low: u128 = (*calldata[1]).try_into().unwrap();
                    let high: u128 = (*calldata[2]).try_into().unwrap();
                    let value: u256 = u256 { low, high };

                    let mut current_limit: u256 = self.get_spending_limit(to);
                    current_limit -= value;
                    self.current_spending_limit.write(to, current_limit);
                    self.update_timestamp(to);
                }

                let syscall_res = call_contract_syscall(to, selector, calldata).unwrap();
                res.append(syscall_res);
            };
            res
        }

        fn __validate__(self: @ContractState, calls: Array<Call>) -> felt252 {
            self.only_protocol();
            self.validate_transaction()
        }

        fn is_valid_signature(
            self: @ContractState, hash: felt252, signature: Array<felt252>,
        ) -> felt252 {
            let is_valid = self._is_valid_signature(hash, signature.span());
            if is_valid {
                VALIDATED
            } else {
                0
            }
        }
    }

    #[abi(embed_v0)]
    impl SRC5 of ISRC5<ContractState> {
        fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
            interface_id == SRC6_TRAIT_ID
        }
    }

    #[abi(embed_v0)]
    impl DeployableAccount of IDeployableAccount<ContractState> {
        fn __validate_deploy__(
            self: @ContractState, class_hash: felt252, public_key: felt252, time_limit: u64,
        ) -> felt252 {
            self.only_protocol();
            self.validate_transaction()
        }
    }

    #[abi(embed_v0)]
    impl DeclarerAccount of IDeclarerAccount<ContractState> {
        fn __validate_declare__(self: @ContractState, class_hash: felt252) -> felt252 {
            self.only_protocol();
            self.validate_transaction()
        }
    }

    #[abi(embed_v0)]
    impl SpendingLimitsAccount of ISpendingLimitsAccount<ContractState> {
        fn public_key(self: @ContractState) -> felt252 {
            self.public_key.read()
        }

        fn get_time_limit(self: @ContractState) -> u64 {
            self.time_limit.read()
        }

        fn set_spending_limit(
            ref self: ContractState, token_address: ContractAddress, _limit: u256,
        ) {
            assert(get_caller_address() == get_contract_address(), 'Invalid caller');
            let timemstamp = get_block_timestamp();
            let new_limit: SpendingLimit = SpendingLimit {
                exists: true, limit: _limit, timestamp: timemstamp,
            };
            self.spending_limit.write(token_address, new_limit);
            self.current_spending_limit.write(token_address, _limit);
        }

        fn get_current_spending_limit(
            self: @ContractState, token_address: ContractAddress,
        ) -> u256 {
            self.current_spending_limit.read(token_address)
        }

        fn get_spending_limit_timestamp(
            self: @ContractState, token_address: ContractAddress,
        ) -> u64 {
            self.spending_limit.read(token_address).timestamp
        }

        fn get_spending_limit(self: @ContractState, token_address: ContractAddress) -> u256 {
            let spending_limit = self.spending_limit.read(token_address);
            let time_limit: u64 = self.time_limit.read();
            let current_timestamp: u64 = get_block_timestamp();

            if ((spending_limit.timestamp + time_limit) >= current_timestamp) {
                self.current_spending_limit.read(token_address)
            } else {
                spending_limit.limit
            }
        }
    }

    #[generate_trait]
    impl PrivateImpl of PrivateTrait {
        fn only_protocol(self: @ContractState) {
            let sender = get_caller_address();
            assert(sender.is_zero(), Errors::INVALID_CALLER);
        }

        // If the current block timestamp is past the time_limit,
        // The max new limit set by the account owner is written to the current spending limit.
        // And the current timestamp is updated.
        fn update_timestamp(ref self: ContractState, token_address: ContractAddress) {
            let mut spending_limit = self.spending_limit.read(token_address);
            let current_timestamp: u64 = get_block_timestamp();
            let time_limit: u64 = self.time_limit.read();
            let timestamp: u64 = spending_limit.timestamp;

            if ((timestamp + time_limit) < current_timestamp) {
                spending_limit.timestamp = current_timestamp;
                self.spending_limit.write(token_address, spending_limit);
            }
        }

        fn is_spending_tx(ref self: ContractState, selector: felt252) -> bool {
            selector == Selectors::TRANSFER || selector == Selectors::APPROVE
        }

        fn _is_valid_signature(
            self: @ContractState, hash: felt252, signature: Span<felt252>,
        ) -> bool {
            if signature.len() == 2_u32 {
                core::ecdsa::check_ecdsa_signature(
                    hash, self.public_key.read(), *signature.at(0_u32), *signature.at(1_u32),
                )
            } else {
                false
            }
        }

        fn validate_transaction(self: @ContractState) -> felt252 {
            let tx_info = get_tx_info().unbox();
            let tx_hash = tx_info.transaction_hash;
            let signature = tx_info.signature;

            assert(self._is_valid_signature(tx_hash, signature), Errors::INVALID_SIGNATURE);
            VALIDATED
        }
    }
}
