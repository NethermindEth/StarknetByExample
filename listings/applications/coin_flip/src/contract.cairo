use starknet::ContractAddress;

#[starknet::interface]
pub trait ICoinFlip<TContractState> {
    fn flip(ref self: TContractState);
}

#[starknet::interface]
pub trait IPragmaVRF<TContractState> {
    fn receive_random_words(
        ref self: TContractState,
        requestor_address: ContractAddress,
        request_id: u64,
        random_words: Span<felt252>,
        calldata: Array<felt252>
    );
}

#[starknet::contract]
pub mod CoinFlip {
    use core::num::traits::zero::Zero;
    use starknet::{
        ContractAddress, contract_address_const, get_caller_address, get_contract_address,
        get_block_number
    };
    use pragma_lib::abi::{IRandomnessDispatcher, IRandomnessDispatcherTrait};
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

    #[storage]
    struct Storage {
        eth_dispatcher: IERC20Dispatcher,
        flips: LegacyMap<u64, ContractAddress>,
        nonce: u64,
        randomness_contract_address: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Flipped: Flipped,
        Landed: Landed
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
        pub side: Side
    }

    #[derive(Drop, Serde)]
    pub enum Side {
        Heads,
        Tails,
        Sideways
    }

    pub mod Errors {
        pub const CALLER_NOT_RANDOMNESS: felt252 = 'Caller not randomness contract';
        pub const INVALID_ADDRESS: felt252 = 'Invalid address';
        pub const INVALID_FLIP_ID: felt252 = 'No flip with the given ID';
        pub const REQUESTOR_NOT_SELF: felt252 = 'Requestor is not self';
        pub const TRANSFER_FAILED: felt252 = 'Transfer failed';
    }

    pub const PUBLISH_DELAY: u64 = 0; // return the random value asap
    pub const NUM_OF_WORDS: u64 = 1; // one random value is sufficient
    pub const CALLBACK_FEE_LIMIT: u128 = 10_000_000_000_000; // 0.00001 ETH

    #[constructor]
    fn constructor(
        ref self: ContractState,
        randomness_contract_address: ContractAddress,
        eth_address: ContractAddress
    ) {
        assert(randomness_contract_address.is_non_zero(), Errors::INVALID_ADDRESS);
        assert(eth_address.is_non_zero(), Errors::INVALID_ADDRESS);
        self.randomness_contract_address.write(randomness_contract_address);
        self.eth_dispatcher.write(IERC20Dispatcher { contract_address: eth_address });
    }

    #[abi(embed_v0)]
    impl CoinFlip of super::ICoinFlip<ContractState> {
        fn flip(ref self: ContractState) {
            let flipper = get_caller_address();
            let this = get_contract_address();

            // we pass the PragmaVRF fee to the caller
            let eth_dispatcher = self.eth_dispatcher.read();
            let success = eth_dispatcher.transfer_from(flipper, this, CALLBACK_FEE_LIMIT.into());
            assert(success, Errors::TRANSFER_FAILED);

            let flip_id = self._request_my_randomness();

            self.flips.write(flip_id, flipper);

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
            calldata: Array<felt252>
        ) {
            let caller = get_caller_address();
            assert(
                caller == self.randomness_contract_address.read(), Errors::CALLER_NOT_RANDOMNESS
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
                contract_address: randomness_contract_address
            };

            // Approve the randomness contract to transfer the callback fee
            // You would need to send some ETH to this contract first to cover the fees
            let eth_dispatcher = self.eth_dispatcher.read();
            eth_dispatcher.approve(randomness_contract_address, CALLBACK_FEE_LIMIT.into());

            let nonce = self.nonce.read();

            // Request the randomness to be used to construct the winning combination
            let request_id = randomness_dispatcher
                .request_random(
                    nonce,
                    get_contract_address(),
                    CALLBACK_FEE_LIMIT,
                    PUBLISH_DELAY,
                    NUM_OF_WORDS,
                    array![]
                );

            self.nonce.write(nonce + 1);

            request_id
        }

        fn _process_coin_flip(ref self: ContractState, flip_id: u64, random_value: @felt252) {
            let flipper = self.flips.read(flip_id);
            assert(flipper.is_non_zero(), Errors::INVALID_FLIP_ID);

            // The chance of a flipped coin landing sideways is approximately 1 in 6000.
            // https://journals.aps.org/pre/abstract/10.1103/PhysRevE.48.2547
            //
            // Since splitting the remainder (5999) equally is impossible, we double the values.
            let random_value: u256 = (*random_value).into() % 12000;
            let side = if random_value < 5999 {
                Side::Heads
            } else if random_value > 6000 {
                Side::Tails
            } else {
                Side::Sideways
            };

            self.emit(Event::Landed(Landed { flip_id, flipper, side }));
        }
    }
}
