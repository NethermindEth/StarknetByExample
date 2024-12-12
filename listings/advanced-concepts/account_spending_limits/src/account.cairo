use starknet::account::Call;
use starknet::ContractAddress;

#[starknet::interface]
trait ISRC5<TContractState> {
    fn supports_interface(self: @TContractState, interface_id: felt252) -> bool;
}

#[starknet::interface]
trait ISRC6<TContractState> {
    fn __execute__(ref self: TContractState, calls: Array<Call>) -> Array<Span<felt252>>;
    fn __validate__(self: @TContractState, calls: Array<Call>) -> felt252;
    fn is_valid_signature(
        self: @TContractState, hash: felt252, signature: Array<felt252>
    ) -> felt252;
}

#[starknet::interface]
trait IDeployableAccount<TContractState> {
    fn __validate_deploy__(
        self: @TContractState, class_hash: felt252, salt: felt252, public_key: felt252,
    ) -> felt252;
}

#[starknet::interface]
trait IDeclarerAccount<TContractState> {
    fn __validate_declare__(self: @TContractState, class_hash: felt252) -> felt252;
}

// [!region interface]
#[starknet::interface]
pub trait ISpendingLimitsAccount<TContractState> {
    fn public_key(self: @TContractState) -> felt252;
    fn set_spending_limit(ref self: TContractState, token: ContractAddress, limit: SpendingLimit);
    fn get_spending_limit(self: @TContractState, token: ContractAddress) -> Option<SpendingLimit>;
    fn get_available_spending_amount(self: @TContractState, token: ContractAddress) -> u256;
}
// [!endregion interface]

const SRC5_ID: felt252 = 0x3f918d17e5ee77373b56385708f855659a07f75997f365cf87748628532a055;
const SRC6_ID: felt252 =
    1270010605630597976495846281167968799381097569185364931397797212080166453709;

// [!region spending_limit]
#[derive(Copy, Drop, Serde, starknet::Store)]
pub struct SpendingLimit {
    pub timestamp: u64,
    pub max_amount: u256,
}
// [!endregion spending_limit]

// [!region selectors]
mod Selectors {
    pub const TRANSFER: felt252 = 0x83afd3f4caedc6eebf44246fe54e38c95e3179a5ec9ea81740eca5b482d12e;
    pub const APPROVE: felt252 = 0x0219209e083275171774dab1df80982e9df2096516f06319c5c6d71ae0a8480c;
}
// [!endregion selectors]

#[starknet::contract(account)]
pub mod SpendingLimitsAccount {
    use super::{SpendingLimit, SRC5_ID, SRC6_ID, Selectors};
    use super::{ISRC5, ISRC6, IDeployableAccount, IDeclarerAccount, ISpendingLimitsAccount};
    use openzeppelin_token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
    use starknet::{ContractAddress, get_caller_address, get_contract_address};
    use starknet::{get_tx_info, VALIDATED, get_block_timestamp,};
    use starknet::{account::Call, syscalls::call_contract_syscall, SyscallResultTrait};
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use core::num::traits::Zero;

    // [!region storage]
    #[storage]
    struct Storage {
        public_key: felt252,
        spending_limit: Map<ContractAddress, Option<SpendingLimit>>,
        spent_amount: Map<ContractAddress, u256>,
    }
    // [!endregion storage]

    pub mod Errors {
        pub const UNAUTHORIZED: felt252 = 'Account: Unauthorized';
        pub const INVALID_CALLER: felt252 = 'Account: Invalid caller';
        pub const INVALID_SIGNATURE: felt252 = 'Account: Invalid tx signature';
        pub const INVALID_TX_VERSION: felt252 = 'Account: Invalid tx version';
        pub const ACTIVE_LIMIT_EXISTS: felt252 = 'Account: Active limit exists';
        pub const INVALID_LIMIT_TIMESTAMP: felt252 = 'Account: Invalid timestamp';
        pub const LIMIT_EXCEEDED: felt252 = 'Account: Limit exceeded';
    }

    // time_limit is in seconds
    #[constructor]
    fn constructor(ref self: ContractState, public_key: felt252) {
        self.public_key.write(public_key);
    }

    //
    // External
    //

    // [!region execute_validate]
    #[abi(embed_v0)]
    impl SRC6 of ISRC6<ContractState> {
        fn __execute__(ref self: ContractState, mut calls: Array<Call>) -> Array<Span<felt252>> {
            self._only_protocol();

            // Execute the call
            let mut res = array![];
            for call in calls {
                self._assert_valid_call(@call);
                self._execute_spending_call(@call);

                let Call { to, selector, calldata } = call;
                let syscall_res = call_contract_syscall(to, selector, calldata).unwrap_syscall();
                res.append(syscall_res);
            };
            res
        }

        fn __validate__(self: @ContractState, calls: Array<Call>) -> felt252 {
            self._only_protocol();

            // Check the signature
            self._validate_transaction();

            // Check the calls
            for call in calls {
                self._assert_valid_call(@call);
            };
            VALIDATED
        }
        // [!endregion execute_validate]

        fn is_valid_signature(
            self: @ContractState, hash: felt252, signature: Array<felt252>
        ) -> felt252 {
            if self._is_valid_signature(hash, signature.span()) {
                VALIDATED
            } else {
                0
            }
        }
    }

    #[abi(embed_v0)]
    impl SRC5 of ISRC5<ContractState> {
        fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
            interface_id == SRC5_ID || interface_id == SRC6_ID
        }
    }

    #[abi(embed_v0)]
    impl DeployableAccount of IDeployableAccount<ContractState> {
        fn __validate_deploy__(
            self: @ContractState, class_hash: felt252, salt: felt252, public_key: felt252,
        ) -> felt252 {
            self._only_protocol();
            self._validate_transaction()
            // Call the constructor
        }
    }

    #[abi(embed_v0)]
    impl DeclarerAccount of IDeclarerAccount<ContractState> {
        fn __validate_declare__(self: @ContractState, class_hash: felt252) -> felt252 {
            self._only_protocol();
            self._validate_transaction()
        }
    }

    // [!region accountimpl]
    #[abi(embed_v0)]
    impl SpendingLimitsAccount of ISpendingLimitsAccount<ContractState> {
        fn public_key(self: @ContractState) -> felt252 {
            self.public_key.read()
        }

        fn set_spending_limit(
            ref self: ContractState, token: ContractAddress, limit: SpendingLimit
        ) {
            assert(get_caller_address() == get_contract_address(), Errors::INVALID_CALLER);
            // Check that there's no active limit
            assert(!self._is_active_limit(token), Errors::ACTIVE_LIMIT_EXISTS);
            // Check that the limit is in the future
            assert(limit.timestamp > get_block_timestamp(), Errors::INVALID_LIMIT_TIMESTAMP);

            // Set the limit
            self.spending_limit.write(token, Option::Some(limit));
            // Reset the spent amount
            self.spent_amount.write(token, 0);
        }

        fn get_spending_limit(
            self: @ContractState, token: ContractAddress
        ) -> Option<SpendingLimit> {
            if let Option::Some(limit) = self.spending_limit.read(token) {
                if (self._is_active_limit(token)) {
                    return Option::Some(limit);
                }
            }
            Option::None
        }

        fn get_available_spending_amount(self: @ContractState, token: ContractAddress) -> u256 {
            match self.get_spending_limit(token) {
                Option::Some(limit) => limit.max_amount - self.spent_amount.read(token),
                Option::None => IERC20Dispatcher { contract_address: token }
                    .balance_of(get_contract_address()),
            }
        }
    }
    // [!endregion accountimpl]

    //
    // Internal
    //

    // [!region private]
    #[generate_trait]
    pub impl PrivateImpl of PrivateTrait {
        fn _is_spending_tx(self: @ContractState, selector: felt252) -> bool {
            selector == Selectors::TRANSFER || selector == Selectors::APPROVE
        }

        fn _is_active_limit(self: @ContractState, token: ContractAddress) -> bool {
            match self.spending_limit.read(token) {
                Option::Some(limit) => limit.timestamp > get_block_timestamp(),
                Option::None => false,
            }
        }

        fn _get_total_spent(
            self: @ContractState, to: ContractAddress, calldata: Span<felt252>
        ) -> u256 {
            let low: u128 = (*calldata[1]).try_into().unwrap();
            let high: u128 = (*calldata[2]).try_into().unwrap();
            let spend_amount: u256 = u256 { low, high };
            let spent_amount = self.spent_amount.read(to);
            // total spent
            spent_amount + spend_amount
        }

        fn _assert_valid_call(self: @ContractState, call: @Call) {
            let Call { to, selector, calldata } = *call;

            if let Option::Some(limit) = self.spending_limit.read(to) {
                // Is the limit active?
                if (!self._is_active_limit(to)) {
                    return;
                }
                // Is it a spending call?
                if (!self._is_spending_tx(selector)) {
                    return;
                }
                // Is the spending amount within the limit?
                assert(
                    self._get_total_spent(to, calldata) <= limit.max_amount, Errors::LIMIT_EXCEEDED
                );
                // Ok
            }
        }

        fn _execute_spending_call(ref self: ContractState, call: @Call) {
            let Call { to, selector, calldata } = *call;

            if let Option::Some(limit) = self.spending_limit.read(to) {
                // Is the limit active?
                if (!self._is_active_limit(to)) {
                    return;
                }
                // Is it a spending call?
                if (!self._is_spending_tx(selector)) {
                    return;
                }
                // Is the spending amount within the limit?
                let total_spent = self._get_total_spent(to, calldata);
                assert(total_spent <= limit.max_amount, Errors::LIMIT_EXCEEDED);

                // Mutate state
                self.spent_amount.write(to, total_spent);
            }
        }

        fn _only_protocol(self: @ContractState) {
            assert(get_caller_address().is_zero(), Errors::INVALID_CALLER);
        }

        fn _is_valid_signature(
            self: @ContractState, hash: felt252, signature: Span<felt252>
        ) -> bool {
            if signature.len() == 2_u32 {
                core::ecdsa::check_ecdsa_signature(
                    hash, self.public_key.read(), *signature.at(0_u32), *signature.at(1_u32)
                )
            } else {
                false
            }
        }

        fn _validate_transaction(self: @ContractState) -> felt252 {
            let tx_info = get_tx_info().unbox();
            let tx_hash = tx_info.transaction_hash;
            let signature = tx_info.signature;

            assert(self._is_valid_signature(tx_hash, signature), Errors::INVALID_SIGNATURE);
            VALIDATED
        }
    }
    // [!endregion private]
}
