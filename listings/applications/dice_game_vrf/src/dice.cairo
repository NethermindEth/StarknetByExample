#[starknet::interface]
pub trait IDiceGame<TContractState> {
    fn roll_the_dice(ref self: TContractState, wager: u256);
}

#[starknet::contract]
mod DiceGame {
    use core::num::traits::zero::Zero;
    use starknet::{ContractAddress, get_caller_address, get_contract_address};
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

    #[storage]
    struct Storage {
        min_wager: u256,
        pragma_vrf_contract_address: ContractAddress,
        prize: u256,
        token: IERC20Dispatcher,
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
        pub const INVALID_MIN_WAGER: felt252 = 'Invalid minimum wager';
        pub const TRANSFER_FAILED: felt252 = 'Transfer failed';
        pub const WAGER_TOO_LOW: felt252 = 'Wager too low';
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        token_address: ContractAddress,
        init_balance: u256,
        min_wager: u256,
        pragma_vrf_contract_address: ContractAddress,
    ) {
        assert(token_address.is_non_zero(), Errors::INVALID_ADDRESS);
        assert(init_balance > 0, Errors::INVALID_BALANCE);
        assert(min_wager > 0, Errors::INVALID_MIN_WAGER);
        assert(pragma_vrf_contract_address.is_non_zero(), Errors::INVALID_ADDRESS);

        self.pragma_vrf_contract_address.write(pragma_vrf_contract_address);
        self.token.write(IERC20Dispatcher { contract_address: token_address });

        let caller = get_caller_address();
        let this = get_contract_address();
        let success = self.token.read().transfer_from(caller, this, init_balance);
        assert(success, Errors::TRANSFER_FAILED);

        self._reset_prize();
    }

    #[abi(embed_v0)]
    impl DiceGame of super::IDiceGame<ContractState> {
        fn roll_the_dice(ref self: ContractState, wager: u256) {
            assert(wager >= self.min_wager.read(), Errors::WAGER_TOO_LOW);

            let player = get_caller_address();
            let this = get_contract_address();
            let token = self.token.read();

            let success = token.transfer_from(player, this, wager);
            assert(success, Errors::TRANSFER_FAILED);

            let new_prize = self.prize.read() + (wager * 40) / 100;

            let roll: u8 = 3; // implement random roll with pragma
            self.emit(Event::Roll(Roll { player, wager, roll }));

            if (roll > 2) {
                self.prize.write(new_prize);
                return;
            }

            self._reset_prize();

            let amount = new_prize;
            let success = token.transfer_from(this, player, amount);
            assert(success, Errors::TRANSFER_FAILED);

            self.emit(Event::Winner(Winner { winner: player, amount }));
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn _reset_prize(ref self: ContractState) {
            let this = get_contract_address();
            let balance = self.token.read().balance_of(this);
            self.prize.write((balance * 10) / 100);
        }
    }
}
