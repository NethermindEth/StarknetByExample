use starknet::ContractAddress;

#[starknet::interface]
pub trait IPowerball<TContractState> {
    fn buy_ticket(ref self: TContractState, white_balls: Array<u8>, red_ball: u8);
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
mod Powerball {
    use core::num::traits::zero::Zero;
    use starknet::{
        ContractAddress, contract_address_const, get_caller_address, get_contract_address,
        get_block_number
    };
    use alexandria_sorting::merge_sort::merge as sort;
    use pragma_lib::abi::{IRandomnessDispatcher, IRandomnessDispatcherTrait};
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
    use openzeppelin::access::ownable::OwnableComponent;

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    impl InternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[derive(Drop, Serde, starknet::Store)]
    struct TicketData {
        player: ContractAddress,
        white_balls: Span<u8>,
        red_ball: u8,
    }

    #[storage]
    struct Storage {
        duration_in_blocks: u32,
        randomness_contract_address: ContractAddress,
        prize: u256,
        eth_dispatcher: IERC20Dispatcher,
        nonce: u64,
        tickets: LegacyMap<u64, TicketData>,
        next_ticket_id: u64,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        TicketBought: TicketBought,
        OwnableEvent: OwnableComponent::Event
    }

    #[derive(Drop, starknet::Event)]
    struct TicketBought {
        player: ContractAddress,
    }

    mod Errors {
        pub const CALLER_NOT_RANDOMNESS: felt252 = 'Caller not randomness contract';
        pub const INVALID_ADDRESS: felt252 = 'Invalid address';
        pub const INVALID_PRIZE: felt252 = 'Invalid prize';
        pub const INVALID_DURATION: felt252 = 'Invalid duration';
        pub const INVALID_RED_BALL: felt252 = 'Invalid Red Ball';
        pub const INVALID_REQUEST_ID: felt252 = 'No wager with given request ID';
        pub const INVALID_WHITE_BALLS_LENGTH: felt252 = 'White balls length must be 5';
        pub const NON_UNIQUE_WHITE_BALL: felt252 = 'Must submit unique white balls';
        pub const REQUESTOR_NOT_SELF: felt252 = 'Requestor is not self';
        pub const TRANSFER_FAILED: felt252 = 'Transfer failed';
    }

    const MIN_NUMBER: u8 = 1;
    const MAX_RED_BALL_NUMBER: u8 = 26;
    const MAX_WHITE_BALL_NUMBER: u8 = 69;
    const WHITE_BALLS_LENGTH: u32 = 5;
    const TICKET_PRICE: u64 = 300_000_000_000_000; // 0.0003 ETH
    const NUM_OF_WORDS: u64 = 6; // 5 white balls + 1 red ball
    const CALLBACK_FEE_LIMIT: u128 = 100_000_000_000_000; // 0.0001 ETH

    #[constructor]
    fn constructor(
        ref self: ContractState,
        init_prize: u256,
        randomness_contract_address: ContractAddress,
        duration_in_blocks: u32
    ) {
        assert(init_prize > 0, Errors::INVALID_PRIZE);
        assert(randomness_contract_address.is_non_zero(), Errors::INVALID_ADDRESS);
        assert(duration_in_blocks > 0, Errors::INVALID_DURATION);

        let owner = get_caller_address();
        self.ownable.initializer(owner);

        let eth_dispatcher = IERC20Dispatcher {
            contract_address: contract_address_const::<
                0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7
            >() // ETH Contract Address
        };
        let this = get_contract_address();
        let success = eth_dispatcher.transfer_from(owner, this, init_prize);
        assert(success, Errors::TRANSFER_FAILED);

        self.randomness_contract_address.write(randomness_contract_address);
        self.duration_in_blocks.write(duration_in_blocks);
        self.eth_dispatcher.write(eth_dispatcher);
        self.prize.write(init_prize);

        self._start_lottery();
    }

    #[abi(embed_v0)]
    impl Powerball of super::IPowerball<ContractState> {
        fn buy_ticket(ref self: ContractState, white_balls: Array<u8>, red_ball: u8) {
            assert(
                MIN_NUMBER <= red_ball && red_ball <= MAX_RED_BALL_NUMBER, Errors::INVALID_RED_BALL
            );
            self._validate_white_balls(white_balls.clone());

            let player = get_caller_address();
            let this = get_contract_address();

            let success = self
                .eth_dispatcher
                .read()
                .transfer_from(player, this, TICKET_PRICE.into());
            assert(success, Errors::TRANSFER_FAILED);

            let white_balls_sorted = sort(white_balls);

            let ticket_id = self.next_ticket_id.read();

            self.next_ticket_id.write(ticket_id + 1);
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

            self._process_dice_roll(request_id, random_words.at(0));
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn _validate_white_balls(self: @ContractState, white_balls: Array<u8>) {
            assert(white_balls.len() == WHITE_BALLS_LENGTH, Errors::INVALID_WHITE_BALLS_LENGTH);

            let mut found: Felt252Dict<bool> = Default::default();
            let mut i = 0;
            while i < WHITE_BALLS_LENGTH {
                let white_ball = *white_balls.at(i);
                assert!(
                    MIN_NUMBER <= white_ball && white_ball <= MAX_WHITE_BALL_NUMBER,
                    "Invalid white ball: {}",
                    white_ball
                );
                assert(!found.get(white_ball.into()), Errors::NON_UNIQUE_WHITE_BALL);
                found.insert(white_ball.into(), true);
                i += 1;
            };
        }

        fn _start_lottery(ref self: ContractState) {
            let randomness_contract_address = self.randomness_contract_address.read();
            let randomness_dispatcher = IRandomnessDispatcher {
                contract_address: randomness_contract_address
            };

            // Approve the randomness contract to transfer the callback fee
            // You would need to send some ETH to this contract first to cover the fees
            let eth_dispatcher = self.eth_dispatcher.read();
            eth_dispatcher
                .approve(
                    randomness_contract_address,
                    (CALLBACK_FEE_LIMIT + CALLBACK_FEE_LIMIT / 5).into()
                );

            let nonce = self.nonce.read();
            // Request the randomness to be used to construct the winning combination
            randomness_dispatcher
                .request_random(
                    nonce,
                    get_contract_address(),
                    CALLBACK_FEE_LIMIT,
                    self.duration_in_blocks.read().into(),
                    NUM_OF_WORDS,
                    array![]
                );

            self.nonce.write(nonce + 1);
        }

        fn _process_dice_roll(
            ref self: ContractState, request_id: u64, random_word: @felt252
        ) { // let (player, wager) = self.roll_requests.read(request_id);
        // assert(player.is_non_zero() && wager > 0, Errors::INVALID_REQUEST_ID);

        // // "consume" the stored wager
        // self.roll_requests.write(request_id, (Zero::zero(), 0));

        // let new_prize = self.prize.read() + (wager * 40) / 100;

        // let random_word: u256 = (*random_word).into();
        // let roll: u8 = (random_word % 6 + 1).try_into().unwrap();

        // self.emit(Event::Roll(Roll { player, wager, roll }));

        // if (roll > 2) {
        //     self.prize.write(new_prize);
        //     return;
        // }

        // let this = get_contract_address();
        // let amount = new_prize;

        // self._reset_prize();

        // let success = self.eth_dispatcher.read().transfer_from(this, player, amount);
        // assert(success, Errors::TRANSFER_FAILED);

        // self.emit(Event::Winner(Winner { winner: player, amount }));
        }
    }
}
