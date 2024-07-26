#[starknet::contract]
pub mod MockRandomness {
    use pragma_lib::abi::IRandomness;
    use pragma_lib::types::RequestStatus;
    use starknet::{ContractAddress, ClassHash, get_caller_address, get_contract_address};
    use core::num::traits::zero::Zero;
    use core::poseidon::PoseidonTrait;
    use core::hash::{HashStateTrait, HashStateExTrait};
    use coin_flip::contract::{IPragmaVRFDispatcher, IPragmaVRFDispatcherTrait};
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

    #[storage]
    struct Storage {
        eth_dispatcher: IERC20Dispatcher,
        next_request_id: u64
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}

    pub mod Errors {
        pub const INVALID_ADDRESS: felt252 = 'Invalid address';
        pub const TRANSFER_FAILED: felt252 = 'Transfer failed';
    }

    #[constructor]
    fn constructor(ref self: ContractState, eth_address: ContractAddress) {
        assert(eth_address.is_non_zero(), Errors::INVALID_ADDRESS);
        self.eth_dispatcher.write(IERC20Dispatcher { contract_address: eth_address });
    }

    #[abi(embed_v0)]
    impl MockRandomness of IRandomness<ContractState> {
        fn request_random(
            ref self: ContractState,
            seed: u64,
            callback_address: ContractAddress,
            callback_fee_limit: u128,
            publish_delay: u64,
            num_words: u64,
            calldata: Array<felt252>
        ) -> u64 {
            let caller = get_caller_address();
            let this = get_contract_address();
            let eth_dispatcher = self.eth_dispatcher.read();
            let success = eth_dispatcher.transfer_from(caller, this, callback_fee_limit.into());
            assert(success, Errors::TRANSFER_FAILED);

            let request_id = self.next_request_id.read();
            self.next_request_id.write(request_id + 1);
            request_id
        }

        fn submit_random(
            ref self: ContractState,
            request_id: u64,
            requestor_address: ContractAddress,
            seed: u64,
            minimum_block_number: u64,
            callback_address: ContractAddress,
            callback_fee_limit: u128,
            callback_fee: u128,
            random_words: Span<felt252>,
            proof: Span<felt252>,
            calldata: Array<felt252>
        ) {
            let requestor = IPragmaVRFDispatcher { contract_address: callback_address };
            requestor.receive_random_words(requestor_address, request_id, random_words, calldata);
        }


        fn update_status(
            ref self: ContractState,
            requestor_address: ContractAddress,
            request_id: u64,
            new_status: RequestStatus
        ) {
            panic!("unimplemented")
        }

        fn cancel_random_request(
            ref self: ContractState,
            request_id: u64,
            requestor_address: ContractAddress,
            seed: u64,
            minimum_block_number: u64,
            callback_address: ContractAddress,
            callback_fee_limit: u128,
            num_words: u64
        ) {
            panic!("unimplemented")
        }

        fn get_pending_requests(
            self: @ContractState, requestor_address: ContractAddress, offset: u64, max_len: u64
        ) -> Span<felt252> {
            panic!("unimplemented")
        }

        fn get_request_status(
            self: @ContractState, requestor_address: ContractAddress, request_id: u64
        ) -> RequestStatus {
            panic!("unimplemented")
        }
        fn requestor_current_index(
            self: @ContractState, requestor_address: ContractAddress
        ) -> u64 {
            panic!("unimplemented")
        }
        fn get_public_key(self: @ContractState, requestor_address: ContractAddress) -> felt252 {
            panic!("unimplemented")
        }
        fn get_payment_token(self: @ContractState) -> ContractAddress {
            panic!("unimplemented")
        }
        fn set_payment_token(ref self: ContractState, token_contract: ContractAddress) {
            panic!("unimplemented")
        }
        fn upgrade(ref self: ContractState, impl_hash: ClassHash) {
            panic!("unimplemented")
        }
        fn refund_operation(
            ref self: ContractState, caller_address: ContractAddress, request_id: u64
        ) {
            panic!("unimplemented")
        }
        fn get_total_fees(
            self: @ContractState, caller_address: ContractAddress, request_id: u64
        ) -> u256 {
            panic!("unimplemented")
        }
        fn get_out_of_gas_requests(
            self: @ContractState, requestor_address: ContractAddress,
        ) -> Span<u64> {
            panic!("unimplemented")
        }
        fn withdraw_funds(ref self: ContractState, receiver_address: ContractAddress) {
            panic!("unimplemented")
        }
        fn get_contract_balance(self: @ContractState) -> u256 {
            panic!("unimplemented")
        }
        fn compute_premium_fee(self: @ContractState, caller_address: ContractAddress) -> u128 {
            panic!("unimplemented")
        }
        fn get_admin_address(self: @ContractState,) -> ContractAddress {
            panic!("unimplemented")
        }
        fn set_admin_address(ref self: ContractState, new_admin_address: ContractAddress) {
            panic!("unimplemented")
        }
    }
}
