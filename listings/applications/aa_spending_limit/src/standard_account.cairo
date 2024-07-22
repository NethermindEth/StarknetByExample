use starknet::account::Call;
use starknet::ContractAddress;

#[starknet::interface]
trait IAccount<T> {
    fn public_key(self: @T) -> felt252;
    fn get_time_limit(self: @T) -> u64;
    fn supports_interface(self: @T, interface_id: felt252) -> bool;
    fn is_valid_signature(self: @T, hash: felt252, signature: Array<felt252>) -> felt252;
    fn set_spending_limit(ref self: T, token_address: ContractAddress, _limit: u256);
    fn get_spending_limit_timestamp(self: @T, token_address: ContractAddress) -> u64;
    fn get_current_spending_limit(self: @T, token_address: ContractAddress) -> u256;
    fn get_spending_limit(self: @T, token_address: ContractAddress) -> u256;
    fn __execute__(ref self: T, calls: Array<Call>) -> Array<Span<felt252>>;
    fn __validate__(self: @T, calls: Array<Call>) -> felt252;
    fn __validate_declare__(self: @T, class_hash: felt252) -> felt252;
    fn __validate_deploy__(
        self: @T, class_hash: felt252, salt: felt252, public_key: felt252
    ) -> felt252;
}

#[derive(Copy, Drop, Serde, starknet::Store)]
struct SpendingLimit {
    exists: bool,
    timestamp: u64,
    limit: u256,
}

#[starknet::contract(account)]
mod Account {
    use core::traits::Into;
    use core::traits::TryInto;
    use super::{Call, IAccount, SpendingLimit};
    use core::Felt252TryIntoU128;
    use core::integer::u256_checked_sub;
    use starknet::{
        ContractAddress, get_caller_address, call_contract_syscall, get_tx_info, VALIDATED,
        get_block_timestamp, get_contract_address
    };
    use zeroable::Zeroable;
    use ecdsa::check_ecdsa_signature;

    const SRC6_TRAIT_ID: felt252 =
        1270010605630597976495846281167968799381097569185364931397797212080166453709; // hash of SNIP-6 trait

    const transfer_selector: felt252 =
        0x83afd3f4caedc6eebf44246fe54e38c95e3179a5ec9ea81740eca5b482d12e;

    const approve_selector: felt252 =
        0x0219209e083275171774dab1df80982e9df2096516f06319c5c6d71ae0a8480c;


    #[storage]
    struct Storage {
        public_key: felt252,
        spending_limit: LegacyMap<ContractAddress, SpendingLimit>,
        current_spending_limit: LegacyMap<ContractAddress, u256>,
        time_limit: u64,
    }

    //time_limit is in seconds
    #[constructor]
    fn constructor(ref self: ContractState, public_key: felt252, time_limit: u64) {
        self.public_key.write(public_key);
        self.time_limit.write(time_limit);
    }

    #[abi(embed_v0)]
    impl AccountImpl of IAccount<ContractState> {
        fn public_key(self: @ContractState) -> felt252 {
            self.public_key.read()
        }

        fn get_time_limit(self: @ContractState) -> u64 {
            self.time_limit.read()
        }

        fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
            interface_id == SRC6_TRAIT_ID
        }

        fn is_valid_signature(
            self: @ContractState, hash: felt252, signature: Array<felt252>
        ) -> felt252 {
            let is_valid = self.is_valid_signature_bool(hash, signature.span());
            if is_valid {
                VALIDATED
            } else {
                0
            }
        }

        fn set_spending_limit(
            ref self: ContractState, token_address: ContractAddress, _limit: u256
        ) {
            assert(get_caller_address() == get_contract_address(), 'Invalid caller');
            let timemstamp = get_block_timestamp();
            let new_limit: SpendingLimit = SpendingLimit {
                exists: true, limit: _limit, timestamp: timemstamp
            };
            self.spending_limit.write(token_address, new_limit);
            self.current_spending_limit.write(token_address, _limit);
        }

        fn get_current_spending_limit(
            self: @ContractState, token_address: ContractAddress
        ) -> u256 {
            self.current_spending_limit.read(token_address)
        }

        fn get_spending_limit_timestamp(
            self: @ContractState, token_address: ContractAddress
        ) -> u64 {
            self.spending_limit.read(token_address).timestamp
        }

        fn get_spending_limit(self: @ContractState, token_address: ContractAddress) -> u256 {
            let spending_limit = self.spending_limit.read(token_address);
            let current_timestamp: u64 = get_block_timestamp();
            let time_limit: u64 = self.time_limit.read();
            let timestamp: u64 = spending_limit.timestamp;

            if ((timestamp + time_limit) >= current_timestamp) {
                return self.current_spending_limit.read(token_address);
            }
            return spending_limit.limit;
        }

        fn __execute__(ref self: ContractState, mut calls: Array<Call>) -> Array<Span<felt252>> {
            assert(!calls.is_empty(), 'Account: No call data given');
            self.only_protocol();
            let mut res = ArrayTrait::new();
            loop {
                match calls.pop_front() {
                    Option::Some(call) => {
                        let Call { to, selector, calldata } = call;
                        let limit_exists: bool = self.spending_limit.read(to).exists;

                        if (self.is_spending_tx(selector) && limit_exists) {
                            let low: u128 = Felt252TryIntoU128::try_into(*calldata[1]).unwrap();
                            let high: u128 = Felt252TryIntoU128::try_into(*calldata[2]).unwrap();
                            let value: u256 = u256 { low, high };

                            //TODO: check if the limit updated when timestamp is greater than the limit
                            let mut current_limit: u256 = self.get_spending_limit(to);
                            current_limit -= value;
                            self.current_spending_limit.write(to, current_limit);
                            self.update_timestamp(to);
                        }
                        let _res = call_contract_syscall(to, selector, calldata).unwrap();
                        res.append(_res);
                    },
                    Option::None(_) => { break (); },
                };
            };
            res
        }

        fn __validate__(self: @ContractState, calls: Array<Call>) -> felt252 {
            self.only_protocol();
            self.validate_transaction()
        }

        fn __validate_declare__(self: @ContractState, class_hash: felt252) -> felt252 {
            self.only_protocol();
            self.validate_transaction()
        }

        fn __validate_deploy__(
            self: @ContractState, class_hash: felt252, salt: felt252, public_key: felt252
        ) -> felt252 {
            self.only_protocol();
            self.validate_transaction()
        }
    }

    #[generate_trait]
    impl PrivateImpl of PrivateTrait {
        fn only_protocol(self: @ContractState) {
            let sender: ContractAddress = get_caller_address();
            assert(sender.is_zero(), 'Account: invalid caller');
        }

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
            if (selector == transfer_selector || selector == approve_selector) {
                return true;
            }
            return false;
        }

        fn is_valid_signature_bool(
            self: @ContractState, hash: felt252, signature: Span<felt252>
        ) -> bool {
            let is_valid_length = signature.len() == 2_u32;
            if !is_valid_length {
                return false;
            }
            check_ecdsa_signature(
                hash, self.public_key.read(), *signature.at(0_u32), *signature.at(1_u32)
            )
        }

        fn validate_transaction(self: @ContractState) -> felt252 {
            let tx_info = get_tx_info().unbox();
            let tx_hash = tx_info.transaction_hash;
            let signature = tx_info.signature;

            let is_valid = self.is_valid_signature_bool(tx_hash, signature);
            assert(is_valid, 'Account: Incorrect tx signature');
            VALIDATED
        }

        fn execute_single_call(self: @ContractState, call: Call) -> Span<felt252> {
            let Call { to, selector, calldata } = call;
            call_contract_syscall(to, selector, calldata).unwrap()
        }

        fn execute_multiple_calls(
            self: @ContractState, mut calls: Array<Call>
        ) -> Array<Span<felt252>> {
            let mut res = ArrayTrait::new();
            loop {
                match calls.pop_front() {
                    Option::Some(call) => {
                        let _res = self.execute_single_call(call);
                        res.append(_res);
                    },
                    Option::None(_) => { break (); },
                };
            };
            res
        }
    }
}
