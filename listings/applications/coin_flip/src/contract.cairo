use starknet::ContractAddress;

#[starknet::interface]
pub trait ICoinFlip<TContractState> {
    fn flip(ref self: TContractState);
}

// declares just the pragma_lib::abi::IRandomness.receive_random_words function
#[starknet::interface]
pub trait IPragmaVRF<TContractState> {
    fn receive_random_words(
        ref self: TContractState,
        requestor_address: ContractAddress,
        request_id: u64,
        random_words: Span<felt252>,
        calldata: Array<felt252>,
    );
}

#[starknet::contract]
pub mod CoinFlip {
    use core::num::traits::zero::Zero;
    use starknet::{ContractAddress, get_caller_address, get_contract_address};
    use starknet::storage::{
        Map, StoragePointerReadAccess, StoragePathEntry, StoragePointerWriteAccess,
    };
    use pragma_lib::abi::{IRandomnessDispatcher, IRandomnessDispatcherTrait};
    use openzeppelin_token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

    #[storage]
    struct Storage {
        eth_dispatcher: IERC20Dispatcher,
        flips: Map<u64, ContractAddress>,
        nonce: u64,
        randomness_contract_address: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Flipped: Flipped,
        Landed: Landed,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Flipped {
        pub flip_id: u64,
        pub flipper: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Landed {
        pub flip_id: u64,
        pub flipper: ContractAddress,
        pub side: Side,
    }

    #[derive(Drop, Debug, PartialEq, Serde)]
    pub enum Side {
        Heads,
        Tails,
    }

    pub mod Errors {
        pub const CALLER_NOT_RANDOMNESS: felt252 = 'Caller not randomness contract';
        pub const INVALID_ADDRESS: felt252 = 'Invalid address';
        pub const INVALID_FLIP_ID: felt252 = 'No flip with the given ID';
        pub const REQUESTOR_NOT_SELF: felt252 = 'Requestor is not self';
        pub const TRANSFER_FAILED: felt252 = 'Transfer failed';
    }

    pub const PUBLISH_DELAY: u64 = 1; // return the random value asap
    pub const NUM_OF_WORDS: u64 = 1; // one random value is sufficient
    pub const CALLBACK_FEE_LIMIT: u128 = 100_000_000_000_000; // 0.0001 ETH
    pub const MAX_CALLBACK_FEE_DEPOSIT: u256 =
        500_000_000_000_000; // CALLBACK_FEE_LIMIT * 5; needs to cover the Premium fee

    #[constructor]
    fn constructor(
        ref self: ContractState,
        randomness_contract_address: ContractAddress,
        eth_address: ContractAddress,
    ) {
        assert(randomness_contract_address.is_non_zero(), Errors::INVALID_ADDRESS);
        assert(eth_address.is_non_zero(), Errors::INVALID_ADDRESS);
        self.randomness_contract_address.write(randomness_contract_address);
        self.eth_dispatcher.write(IERC20Dispatcher { contract_address: eth_address });
    }

    #[abi(embed_v0)]
    impl CoinFlip of super::ICoinFlip<ContractState> {
        /// The contract needs to be funded with some ETH in order for this function
        /// to be callable. For simplicity, anyone can fund the contract.
        fn flip(ref self: ContractState) {
            let flip_id = self._request_my_randomness();
            let flipper = get_caller_address();
            self.flips.entry(flip_id).write(flipper);
            self.emit(Event::Flipped(Flipped { flip_id, flipper }));
        }
    }

    #[abi(embed_v0)]
    impl PragmaVRF of super::IPragmaVRF<ContractState> {
        fn receive_random_words(
            ref self: ContractState,
            requestor_address: ContractAddress,
            request_id: u64,
            random_words: Span<felt252>,
            calldata: Array<felt252>,
        ) {
            let caller = get_caller_address();
            assert(
                caller == self.randomness_contract_address.read(), Errors::CALLER_NOT_RANDOMNESS,
            );

            let this = get_contract_address();
            assert(requestor_address == this, Errors::REQUESTOR_NOT_SELF);

            self._process_coin_flip(request_id, random_words.at(0));
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn _request_my_randomness(ref self: ContractState) -> u64 {
            let randomness_contract_address = self.randomness_contract_address.read();
            let randomness_dispatcher = IRandomnessDispatcher {
                contract_address: randomness_contract_address,
            };

            let this = get_contract_address();

            // Approve the randomness contract to transfer the callback deposit/fee
            let eth_dispatcher = self.eth_dispatcher.read();
            eth_dispatcher.approve(randomness_contract_address, MAX_CALLBACK_FEE_DEPOSIT);

            let nonce = self.nonce.read();

            // Request the randomness to be used to construct the winning combination
            let request_id = randomness_dispatcher
                .request_random(
                    nonce, this, CALLBACK_FEE_LIMIT, PUBLISH_DELAY, NUM_OF_WORDS, array![],
                );

            self.nonce.write(nonce + 1);

            request_id
        }

        fn _process_coin_flip(ref self: ContractState, flip_id: u64, random_value: @felt252) {
            let flipper = self.flips.entry(flip_id).read();
            assert(flipper.is_non_zero(), Errors::INVALID_FLIP_ID);

            let random_value: u256 = (*random_value).into();
            let side = if random_value % 2 == 0 {
                Side::Heads
            } else {
                Side::Tails
            };

            self.emit(Event::Landed(Landed { flip_id, flipper, side }));
        }
    }
}
