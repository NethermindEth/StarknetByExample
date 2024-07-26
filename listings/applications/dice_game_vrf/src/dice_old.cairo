use starknet::ContractAddress;

#[starknet::interface]
pub trait IPowerball<TContractState> {
    fn roll_the_dice(ref self: TContractState, wager: u256);
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
    use pragma_lib::abi::{IRandomnessDispatcher, IRandomnessDispatcherTrait};
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

    #[storage]
    struct Storage {
        duration_in_blocks: u32,
        randomness_contract_address: ContractAddress,
        prize: u256,
        eth_dispatcher: IERC20Dispatcher,
        nonce: u64,
        roll_requests: LegacyMap<u64, (ContractAddress, u256)>
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Roll: Roll,
        Winner: Winner,
    }

    #[derive(Drop, starknet::Event)]
    struct Roll {
        player: ContractAddress,
        wager: u256,
        roll: u8
    }

    #[derive(Drop, starknet::Event)]
    struct Winner {
        winner: ContractAddress,
        amount: u256,
    }

    mod Errors {
        pub const INVALID_ADDRESS: felt252 = 'Invalid address';
        pub const INVALID_BALANCE: felt252 = 'Invalid balance';
        pub const INVALID_DURATION: felt252 = 'Invalid duration';
        pub const TRANSFER_FAILED: felt252 = 'Transfer failed';
        pub const WAGER_TOO_LOW: felt252 = 'Wager too low';
        pub const CALLER_NOT_RANDOMNESS: felt252 = 'Caller not randomness contract';
        pub const REQUESTOR_NOT_SELF: felt252 = 'Requestor is not self';
        pub const INVALID_REQUEST_ID: felt252 = 'No wager with given request ID';
    }

    const TICKET_PRICE: u32 = 300_000_000_000_000; // 0.0003 ETH
    const NUM_OF_WORDS: u64 = 1;
    const CALLBACK_FEE_LIMIT: u128 = 100;

    #[constructor]
    fn constructor(
        ref self: ContractState,
        init_balance: u256,
        randomness_contract_address: ContractAddress,
        duration_in_blocks: u32
    ) {
        assert(init_balance > 0, Errors::INVALID_BALANCE);
        assert(randomness_contract_address.is_non_zero(), Errors::INVALID_ADDRESS);
        assert(duration_in_blocks > 0, Errors::INVALID_DURATION);

        self.randomness_contract_address.write(randomness_contract_address);
        self.duration_in_blocks.write(duration_in_blocks);

        let eth_dispatcher = IERC20Dispatcher {
            contract_address: contract_address_const::<
                0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7
            >() // ETH Contract Address
        };
        let caller = get_caller_address();
        let this = get_contract_address();
        let success = eth_dispatcher.transfer_from(caller, this, init_balance);
        assert(success, Errors::TRANSFER_FAILED);

        self.eth_dispatcher.write(eth_dispatcher);

        self._reset_prize();
    }

    #[abi(embed_v0)]
    impl Powerball of super::IPowerball<ContractState> {
        fn roll_the_dice(ref self: ContractState, wager: u256) {
            assert(wager >= 2000, Errors::WAGER_TOO_LOW);

            let player = get_caller_address();
            let this = get_contract_address();

            let success = self.eth_dispatcher.read().transfer_from(player, this, wager);
            assert(success, Errors::TRANSFER_FAILED);

            let nonce = self.nonce.read();
            let request_id = self._request_randomness(player, wager, nonce);

            // store the wager with the request ID
            self.roll_requests.write(request_id, (player, wager));
            self.nonce.write(nonce + 1);
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
        fn _request_randomness(
            ref self: ContractState, player: ContractAddress, wager: u256, seed: u64
        ) -> u64 {
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

            // Request the randomness
            return randomness_dispatcher
                .request_random(
                    seed,
                    get_contract_address(),
                    CALLBACK_FEE_LIMIT,
                    self.duration_in_blocks.read(),
                    NUM_OF_WORDS,
                    array![]
                );
        }

        fn _process_dice_roll(ref self: ContractState, request_id: u64, random_word: @felt252) {
            let (player, wager) = self.roll_requests.read(request_id);
            assert(player.is_non_zero() && wager > 0, Errors::INVALID_REQUEST_ID);

            // "consume" the stored wager
            self.roll_requests.write(request_id, (Zero::zero(), 0));

            let new_prize = self.prize.read() + (wager * 40) / 100;

            let random_word: u256 = (*random_word).into();
            let roll: u8 = (random_word % 6 + 1).try_into().unwrap();

            self.emit(Event::Roll(Roll { player, wager, roll }));

            if (roll > 2) {
                self.prize.write(new_prize);
                return;
            }

            let this = get_contract_address();
            let amount = new_prize;

            self._reset_prize();

            let success = self.eth_dispatcher.read().transfer_from(this, player, amount);
            assert(success, Errors::TRANSFER_FAILED);

            self.emit(Event::Winner(Winner { winner: player, amount }));
        }

        fn _reset_prize(ref self: ContractState) {
            let this = get_contract_address();
            let balance = self.eth_dispatcher.read().balance_of(this);
            self.prize.write((balance * 10) / 100);
        }
    }
}
