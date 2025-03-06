use starknet::ContractAddress;

// [!region interface]
#[starknet::interface]
pub trait IERC20<TContractState> {
    fn get_name(self: @TContractState) -> felt252;
    fn get_symbol(self: @TContractState) -> felt252;
    fn get_decimals(self: @TContractState) -> u8;
    fn get_total_supply(self: @TContractState) -> felt252;
    fn balance_of(self: @TContractState, account: ContractAddress) -> felt252;
    fn allowance(
        self: @TContractState, owner: ContractAddress, spender: ContractAddress,
    ) -> felt252;
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: felt252);
    fn transfer_from(
        ref self: TContractState,
        sender: ContractAddress,
        recipient: ContractAddress,
        amount: felt252,
    );
    fn approve(ref self: TContractState, spender: ContractAddress, amount: felt252);
    fn increase_allowance(ref self: TContractState, spender: ContractAddress, added_value: felt252);
    fn decrease_allowance(
        ref self: TContractState, spender: ContractAddress, subtracted_value: felt252,
    );
}
// [!endregion interface]

// [!region erc20]
#[starknet::contract]
pub mod erc20 {
    use core::num::traits::Zero;
    use starknet::get_caller_address;
    use starknet::contract_address_const;
    use starknet::ContractAddress;
    use starknet::storage::{
        Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePointerReadAccess,
        StoragePointerWriteAccess,
    };

    #[storage]
    struct Storage {
        name: felt252,
        symbol: felt252,
        decimals: u8,
        total_supply: felt252,
        balances: Map::<ContractAddress, felt252>,
        allowances: Map::<(ContractAddress, ContractAddress), felt252>,
    }

    #[event]
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        Transfer: Transfer,
        Approval: Approval,
    }
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct Transfer {
        pub from: ContractAddress,
        pub to: ContractAddress,
        pub value: felt252,
    }
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct Approval {
        pub owner: ContractAddress,
        pub spender: ContractAddress,
        pub value: felt252,
    }

    mod Errors {
        pub const APPROVE_FROM_ZERO: felt252 = 'ERC20: approve from 0';
        pub const APPROVE_TO_ZERO: felt252 = 'ERC20: approve to 0';
        pub const TRANSFER_FROM_ZERO: felt252 = 'ERC20: transfer from 0';
        pub const TRANSFER_TO_ZERO: felt252 = 'ERC20: transfer to 0';
        pub const BURN_FROM_ZERO: felt252 = 'ERC20: burn from 0';
        pub const MINT_TO_ZERO: felt252 = 'ERC20: mint to 0';
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        recipient: ContractAddress,
        name: felt252,
        decimals: u8,
        initial_supply: felt252,
        symbol: felt252,
    ) {
        self.name.write(name);
        self.symbol.write(symbol);
        self.decimals.write(decimals);
        self.mint(recipient, initial_supply);
    }

    #[abi(embed_v0)]
    impl IERC20Impl of super::IERC20<ContractState> {
        fn get_name(self: @ContractState) -> felt252 {
            self.name.read()
        }

        fn get_symbol(self: @ContractState) -> felt252 {
            self.symbol.read()
        }

        fn get_decimals(self: @ContractState) -> u8 {
            self.decimals.read()
        }

        fn get_total_supply(self: @ContractState) -> felt252 {
            self.total_supply.read()
        }

        fn balance_of(self: @ContractState, account: ContractAddress) -> felt252 {
            self.balances.read(account)
        }

        fn allowance(
            self: @ContractState, owner: ContractAddress, spender: ContractAddress,
        ) -> felt252 {
            self.allowances.read((owner, spender))
        }

        fn transfer(ref self: ContractState, recipient: ContractAddress, amount: felt252) {
            let sender = get_caller_address();
            self._transfer(sender, recipient, amount);
        }

        fn transfer_from(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: felt252,
        ) {
            let caller = get_caller_address();
            self.spend_allowance(sender, caller, amount);
            self._transfer(sender, recipient, amount);
        }

        fn approve(ref self: ContractState, spender: ContractAddress, amount: felt252) {
            let caller = get_caller_address();
            self.approve_helper(caller, spender, amount);
        }

        fn increase_allowance(
            ref self: ContractState, spender: ContractAddress, added_value: felt252,
        ) {
            let caller = get_caller_address();
            self
                .approve_helper(
                    caller, spender, self.allowances.read((caller, spender)) + added_value,
                );
        }

        fn decrease_allowance(
            ref self: ContractState, spender: ContractAddress, subtracted_value: felt252,
        ) {
            let caller = get_caller_address();
            self
                .approve_helper(
                    caller, spender, self.allowances.read((caller, spender)) - subtracted_value,
                );
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn _transfer(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: felt252,
        ) {
            assert(sender.is_non_zero(), Errors::TRANSFER_FROM_ZERO);
            assert(recipient.is_non_zero(), Errors::TRANSFER_TO_ZERO);
            self.balances.write(sender, self.balances.read(sender) - amount);
            self.balances.write(recipient, self.balances.read(recipient) + amount);
            self.emit(Transfer { from: sender, to: recipient, value: amount });
        }

        fn spend_allowance(
            ref self: ContractState,
            owner: ContractAddress,
            spender: ContractAddress,
            amount: felt252,
        ) {
            let allowance = self.allowances.read((owner, spender));
            self.allowances.write((owner, spender), allowance - amount);
        }

        fn approve_helper(
            ref self: ContractState,
            owner: ContractAddress,
            spender: ContractAddress,
            amount: felt252,
        ) {
            assert(spender.is_non_zero(), Errors::APPROVE_TO_ZERO);
            self.allowances.write((owner, spender), amount);
            self.emit(Approval { owner, spender, value: amount });
        }

        fn mint(ref self: ContractState, recipient: ContractAddress, amount: felt252) {
            assert(recipient.is_non_zero(), Errors::MINT_TO_ZERO);
            let supply = self.total_supply.read() + amount;
            self.total_supply.write(supply);
            let balance = self.balances.read(recipient) + amount;
            self.balances.write(recipient, balance);
            self
                .emit(
                    Event::Transfer(
                        Transfer {
                            from: contract_address_const::<0>(), to: recipient, value: amount,
                        },
                    ),
                );
        }
    }
}
// [!endregion erc20]

#[cfg(test)]
mod tests {
    use super::{IERC20Dispatcher, IERC20DispatcherTrait, erc20::{Event, Transfer, Approval}};

    use starknet::{ContractAddress, contract_address_const};
    use core::num::traits::Zero;
    use snforge_std::{
        spy_events, EventSpyAssertionsTrait, ContractClassTrait, DeclareResultTrait, declare,
        start_cheat_caller_address_global,
    };

    const token_name: felt252 = 'myToken';
    const decimals: u8 = 18;
    const initial_supply: felt252 = 100000;
    const symbols: felt252 = 'mtk';

    fn deploy() -> IERC20Dispatcher {
        let recipient: ContractAddress = contract_address_const::<'initialized_recipient'>();

        let token = declare("erc20").unwrap().contract_class();
        let (contract_address, _) = token
            .deploy(@array![recipient.into(), token_name, decimals.into(), initial_supply, symbols])
            .unwrap();
        IERC20Dispatcher { contract_address }
    }


    #[test]
    #[should_panic]
    fn test_deploy_when_recipient_is_address_zero() {
        let recipient: ContractAddress = Zero::zero();

        let token = declare("erc20").unwrap().contract_class();
        let (_contract_address, _) = token
            .deploy(@array![recipient.into(), token_name, decimals.into(), initial_supply, symbols])
            .unwrap();
    }

    #[test]
    fn test_deploy_success() {
        let recipient = contract_address_const::<'initialized_recipient'>();
        let mut spy = spy_events();
        let token = deploy();

        spy
            .assert_emitted(
                @array![
                    (
                        token.contract_address,
                        Event::Transfer(
                            Transfer { from: Zero::zero(), to: recipient, value: initial_supply },
                        ),
                    ),
                ],
            );
    }

    #[test]
    fn test_get_name() {
        let token = deploy();
        assert_eq!(token.get_name(), token_name);
    }

    #[test]
    fn test_get_symbol() {
        let token = deploy();
        assert_eq!(token.get_symbol(), symbols);
    }

    #[test]
    fn test_get_decimals() {
        let token = deploy();
        assert_eq!(token.get_decimals(), decimals);
    }

    #[test]
    fn test_total_supply() {
        let token = deploy();
        assert_eq!(token.get_total_supply(), initial_supply);
    }

    #[test]
    fn test_balance_of_recipient_deployed() {
        let recipient = contract_address_const::<'initialized_recipient'>();
        let token = deploy();
        assert_eq!(token.balance_of(recipient), initial_supply);
    }

    #[test]
    fn test_allowance_without_approval() {
        let caller = contract_address_const::<'caller'>();
        let spender = contract_address_const::<'spender'>();

        let token = deploy();
        start_cheat_caller_address_global(caller);
        assert_eq!(token.allowance(caller, spender), 0);
    }

    #[test]
    fn test_allowance_after_approval() {
        let caller = contract_address_const::<'caller'>();
        let spender = contract_address_const::<'spender'>();
        let token = deploy();
        let amount = 100;
        start_cheat_caller_address_global(caller);
        token.approve(spender, amount);
        assert_eq!(token.allowance(caller, spender), amount);
    }

    #[test]
    #[should_panic(expected: 'ERC20: approve to 0')]
    fn test_approval_spender_is_address_zero() {
        let token = deploy();
        token.approve(Zero::zero(), 100);
    }

    #[test]
    fn test_approval_success() {
        let spender = contract_address_const::<'spender'>();
        let value = 100;
        let token = deploy();
        let caller = contract_address_const::<'caller'>();

        let mut spy = spy_events();
        start_cheat_caller_address_global(caller);
        token.approve(spender, value);
        spy
            .assert_emitted(
                @array![
                    (
                        token.contract_address,
                        Event::Approval(Approval { owner: caller, spender, value }),
                    ),
                ],
            );
    }

    #[test]
    #[should_panic(expected: 'ERC20: approve to 0')]
    fn test_should_increase_allowance_with_spender_zero_address() {
        let token = deploy();
        token.increase_allowance(Zero::zero(), 100);
    }

    #[test]
    fn test_should_increase_allowance() {
        let caller = contract_address_const::<'caller'>();
        let spender = contract_address_const::<'spender'>();
        let amount = 100;
        let token = deploy();

        let mut spy = spy_events();
        start_cheat_caller_address_global(caller);
        token.approve(spender, amount);
        assert_eq!(token.allowance(caller, spender), amount);

        token.increase_allowance(spender, 100);
        assert_eq!(token.allowance(caller, spender), amount + 100);

        // emits one transfer event and two approval events
        spy
            .assert_emitted(
                @array![
                    (
                        token.contract_address,
                        Event::Approval(Approval { owner: caller, spender, value: amount + 100 }),
                    ),
                    (
                        token.contract_address,
                        Event::Approval(Approval { owner: caller, spender, value: amount }),
                    ),
                ],
            );
    }

    #[test]
    #[should_panic(expected: 'ERC20: approve to 0')]
    fn test_should_decrease_allowance_with_spender_zero_address() {
        let token = deploy();
        token.decrease_allowance(Zero::zero(), 100);
    }

    #[test]
    fn test_should_decrease_allowance() {
        let caller = contract_address_const::<'caller'>();
        let spender = contract_address_const::<'spender'>();
        let amount = 100;
        let token = deploy();

        let mut spy = spy_events();
        start_cheat_caller_address_global(caller);
        token.approve(spender, amount);
        assert_eq!(token.allowance(caller, spender), amount);

        token.decrease_allowance(spender, 90);
        assert_eq!(token.allowance(caller, spender), amount - 90);

        // emits one transfer event and two approval events
        spy
            .assert_emitted(
                @array![
                    (
                        token.contract_address,
                        Event::Approval(Approval { owner: caller, spender, value: amount - 90 }),
                    ),
                    (
                        token.contract_address,
                        Event::Approval(Approval { owner: caller, spender, value: amount }),
                    ),
                ],
            );
    }

    #[test]
    #[should_panic(expected: 'ERC20: transfer from 0')]
    fn test_transfer_when_sender_is_address_zero() {
        let receiver = contract_address_const::<'spender'>();
        let token = deploy();
        start_cheat_caller_address_global(Zero::zero());
        token.transfer(receiver, 100);
    }

    #[test]
    #[should_panic(expected: 'ERC20: transfer to 0')]
    fn test_transfer_when_recipient_is_address_zero() {
        let token = deploy();
        token.transfer(Zero::zero(), 100);
    }

    #[test]
    fn test_transfer_success() {
        let caller = contract_address_const::<'initialized_recipient'>();
        let receiver = contract_address_const::<'receiver'>();
        let amount = 100;
        let token = deploy();

        let mut spy = spy_events();
        start_cheat_caller_address_global(caller);
        token.transfer(receiver, amount);
        assert_eq!(token.balance_of(receiver), amount);

        // emits two transfer events
        spy
            .assert_emitted(
                @array![
                    (
                        token.contract_address,
                        Event::Transfer(Transfer { from: caller, to: receiver, value: amount }),
                    ),
                ],
            );
    }


    #[test]
    #[should_panic(expected: 'ERC20: transfer from 0')]
    fn test_transferFrom_when_sender_is_address_zero() {
        let receiver = contract_address_const::<'spender'>();
        let token = deploy();
        token.transfer_from(Zero::zero(), receiver, 100);
    }

    #[test]
    #[should_panic(expected: 'ERC20: transfer to 0')]
    fn test_transferFrom_when_recipient_is_address_zero() {
        let caller = contract_address_const::<'caller'>();
        let receiver = Zero::zero();
        let amount = 100;
        let token = deploy();
        token.transfer_from(caller, receiver, amount);
    }

    #[test]
    fn test_transferFrom_success() {
        let caller = contract_address_const::<'initialized_recipient'>();
        let receiver = contract_address_const::<'receiver'>();
        let amount = 100;
        let token = deploy();

        let mut spy = spy_events();
        start_cheat_caller_address_global(caller);
        token.transfer_from(caller, receiver, amount);
        assert_eq!(token.balance_of(receiver), amount);

        // emits two transfer events
        spy
            .assert_emitted(
                @array![
                    (
                        token.contract_address,
                        Event::Transfer(Transfer { from: caller, to: receiver, value: amount }),
                    ),
                ],
            );
    }
}
