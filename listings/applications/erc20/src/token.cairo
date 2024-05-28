use starknet::ContractAddress;

// ANCHOR: interface
#[starknet::interface]
pub trait IERC20<TContractState> {
    fn get_name(self: @TContractState) -> felt252;
    fn get_symbol(self: @TContractState) -> felt252;
    fn get_decimals(self: @TContractState) -> u8;
    fn get_total_supply(self: @TContractState) -> felt252;
    fn balance_of(self: @TContractState, account: ContractAddress) -> felt252;
    fn allowance(
        self: @TContractState, owner: ContractAddress, spender: ContractAddress
    ) -> felt252;
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: felt252);
    fn transfer_from(
        ref self: TContractState,
        sender: ContractAddress,
        recipient: ContractAddress,
        amount: felt252
    );
    fn approve(ref self: TContractState, spender: ContractAddress, amount: felt252);
    fn increase_allowance(ref self: TContractState, spender: ContractAddress, added_value: felt252);
    fn decrease_allowance(
        ref self: TContractState, spender: ContractAddress, subtracted_value: felt252
    );
}
// ANCHOR_END: interface

// ANCHOR: erc20
#[starknet::contract]
pub mod erc20 {
    use core::num::traits::Zero;
    use starknet::get_caller_address;
    use starknet::contract_address_const;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        name: felt252,
        symbol: felt252,
        decimals: u8,
        total_supply: felt252,
        balances: LegacyMap::<ContractAddress, felt252>,
        allowances: LegacyMap::<(ContractAddress, ContractAddress), felt252>,
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
        symbol: felt252
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
            self: @ContractState, owner: ContractAddress, spender: ContractAddress
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
            amount: felt252
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
            ref self: ContractState, spender: ContractAddress, added_value: felt252
        ) {
            let caller = get_caller_address();
            self
                .approve_helper(
                    caller, spender, self.allowances.read((caller, spender)) + added_value
                );
        }

        fn decrease_allowance(
            ref self: ContractState, spender: ContractAddress, subtracted_value: felt252
        ) {
            let caller = get_caller_address();
            self
                .approve_helper(
                    caller, spender, self.allowances.read((caller, spender)) - subtracted_value
                );
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn _transfer(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: felt252
        ) {
            assert(!sender.is_zero(), Errors::TRANSFER_FROM_ZERO);
            assert(!recipient.is_zero(), Errors::TRANSFER_TO_ZERO);
            self.balances.write(sender, self.balances.read(sender) - amount);
            self.balances.write(recipient, self.balances.read(recipient) + amount);
            self.emit(Transfer { from: sender, to: recipient, value: amount });
        }

        fn spend_allowance(
            ref self: ContractState,
            owner: ContractAddress,
            spender: ContractAddress,
            amount: felt252
        ) {
            let allowance = self.allowances.read((owner, spender));
            self.allowances.write((owner, spender), allowance - amount);
        }

        fn approve_helper(
            ref self: ContractState,
            owner: ContractAddress,
            spender: ContractAddress,
            amount: felt252
        ) {
            assert(!spender.is_zero(), Errors::APPROVE_TO_ZERO);
            self.allowances.write((owner, spender), amount);
            self.emit(Approval { owner, spender, value: amount });
        }

        fn mint(ref self: ContractState, recipient: ContractAddress, amount: felt252) {
            assert(!recipient.is_zero(), Errors::MINT_TO_ZERO);
            let supply = self.total_supply.read() + amount;
            self.total_supply.write(supply);
            let balance = self.balances.read(recipient) + amount;
            self.balances.write(recipient, balance);
            self
                .emit(
                    Event::Transfer(
                        Transfer {
                            from: contract_address_const::<0>(), to: recipient, value: amount
                        }
                    )
                );
        }
    }
}
// ANCHOR_END: erc20

#[cfg(test)]
mod tests {
    use super::{erc20, IERC20Dispatcher, IERC20DispatcherTrait, erc20::{Event, Transfer, Approval}};

    use starknet::{
        ContractAddress, SyscallResultTrait, syscalls::deploy_syscall, get_caller_address,
        contract_address_const
    };

    use starknet::testing::{set_contract_address, set_account_contract_address};

    const token_name: felt252 = 'myToken';
    const decimals: u8 = 18;
    const initial_supply: felt252 = 100000;
    const symbols: felt252 = 'mtk';

    fn deploy() -> (IERC20Dispatcher, ContractAddress) {
        let recipient: ContractAddress = contract_address_const::<'initialzed_recipient'>();

        let (contract_address, _) = deploy_syscall(
            erc20::TEST_CLASS_HASH.try_into().unwrap(),
            recipient.into(),
            array![recipient.into(), token_name, decimals.into(), initial_supply, symbols].span(),
            false
        )
            .unwrap_syscall();

        (IERC20Dispatcher { contract_address }, contract_address)
    }


    #[test]
    #[should_panic(expected: ('ERC20: mint to 0', 'CONSTRUCTOR_FAILED'))]
    fn test_deploy_when_recipient_is_address_zero() {
        let recipient: ContractAddress = get_caller_address();

        let (contract_address, _) = deploy_syscall(
            erc20::TEST_CLASS_HASH.try_into().unwrap(),
            recipient.into(),
            array![recipient.into(), token_name, decimals.into(), initial_supply, symbols].span(),
            false
        )
            .unwrap_syscall();
    }
    #[test]
    fn test_deploy_success() {
        let recipient = contract_address_const::<'initialzed_recipient'>();
        let (_, contract_address) = deploy();
        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(
                Event::Transfer(
                    Transfer { from: get_caller_address(), to: recipient, value: initial_supply }
                )
            )
        );
    }


    #[test]
    fn test_get_name() {
        let (dispatcher, _) = deploy();
        let name = dispatcher.get_name();
        assert(name == token_name, 'wrong token name');
    }

    #[test]
    fn test_get_symbol() {
        let (dispatcher, _) = deploy();
        assert(dispatcher.get_symbol() == symbols, 'wrong symbol');
    }

    #[test]
    fn test_get_decimals() {
        let (dispatcher, _) = deploy();
        assert(dispatcher.get_decimals() == decimals, 'wrong decimals');
    }

    #[test]
    fn test_total_supply() {
        let (dispatcher, _) = deploy();
        assert(dispatcher.get_total_supply() == initial_supply, 'wrong total supply');
    }

    #[test]
    fn test_balance_of_recipient_deployed() {
        let recipient = contract_address_const::<'initialzed_recipient'>();
        let (dispatcher, _) = deploy();
        assert(
            dispatcher.balance_of(recipient) == initial_supply, 'incorrect balance of recipient'
        );
    }

    #[test]
    fn test_allowance_without_approval() {
        let caller = contract_address_const::<'caller'>();
        let spender = contract_address_const::<'spender'>();
        let (dispatcher, _) = deploy();
        set_contract_address(caller);
        assert(dispatcher.allowance(caller, spender) == 0, 'incorrect allowance')
    }

    #[test]
    fn test_allowance_after_approval() {
        let caller = contract_address_const::<'caller'>();
        let spender = contract_address_const::<'spender'>();
        let (dispatcher, _) = deploy();
        let amount = 100;
        set_contract_address(caller);
        dispatcher.approve(spender, amount);
        assert(dispatcher.allowance(caller, spender) == amount, 'incorrect allowance')
    }

    #[test]
    #[should_panic(expected: ('ERC20: approve to 0', 'ENTRYPOINT_FAILED'))]
    fn test_approval_spender_is_address_zero() {
        let spender: ContractAddress = get_caller_address();
        let amount = 100;
        let (dispatcher, _) = deploy();
        dispatcher.approve(spender, amount);
    }

    #[test]
    fn test_approval_success() {
        let recipient = contract_address_const::<'initialzed_recipient'>();
        let spender = contract_address_const::<'spender'>();
        let value = 100;
        let (dispatcher, contract_address) = deploy();
        let caller = contract_address_const::<'caller'>();
        set_contract_address(caller);
        dispatcher.approve(spender, value);
        set_contract_address(contract_address);

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(
                Event::Transfer(
                    Transfer { from: get_caller_address(), to: recipient, value: initial_supply }
                )
            )
        );

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Approval(Approval { owner: caller, spender, value }))
        );
    }

    #[test]
    #[should_panic(expected: ('ERC20: approve to 0', 'ENTRYPOINT_FAILED'))]
    fn test_should_increase_allowance_with_spender_zero_address() {
        let spender = get_caller_address();
        let amount = 100;
        let (dispatcher, _) = deploy();
        dispatcher.increase_allowance(spender, amount);
    }

    #[test]
    fn test_should_increase_allowance() {
        let caller = contract_address_const::<'caller'>();
        let recipient = contract_address_const::<'initialzed_recipient'>();
        let spender = contract_address_const::<'spender'>();
        let amount = 100;
        let (dispatcher, contract_address) = deploy();
        set_contract_address(caller);
        dispatcher.approve(spender, amount);
        assert(dispatcher.allowance(caller, spender) == amount, 'incorrect allowance');
        set_contract_address(caller);
        dispatcher.increase_allowance(spender, 100);
        assert(
            dispatcher.allowance(caller, spender) == amount + 100, 'incorrect increased allowance'
        );

        // emits one transfer event and two approval events

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(
                Event::Transfer(
                    Transfer { from: get_caller_address(), to: recipient, value: initial_supply }
                )
            )
        );

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Approval(Approval { owner: caller, spender, value: amount }))
        );

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Approval(Approval { owner: caller, spender, value: amount + 100 }))
        );
    }

    #[test]
    #[should_panic(expected: ('ERC20: approve to 0', 'ENTRYPOINT_FAILED'))]
    fn test_should_decrease_allowance_with_spender_zero_address() {
        let spender = get_caller_address();
        let amount = 100;
        let (dispatcher, _) = deploy();
        dispatcher.decrease_allowance(spender, amount);
    }

    #[test]
    fn test_should_decrease_allowance() {
        let caller = contract_address_const::<'caller'>();
        let recipient = contract_address_const::<'initialzed_recipient'>();
        let spender = contract_address_const::<'spender'>();
        let amount = 100;
        let (dispatcher, contract_address) = deploy();
        set_contract_address(caller);
        dispatcher.approve(spender, amount);
        assert(dispatcher.allowance(caller, spender) == amount, 'incorrect allowance');

        set_contract_address(caller);
        dispatcher.decrease_allowance(spender, 90);
        assert(
            dispatcher.allowance(caller, spender) == amount - 90, 'incorrect decreased allowance'
        );

        // emits one transfer event and two approval events

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(
                Event::Transfer(
                    Transfer { from: get_caller_address(), to: recipient, value: initial_supply }
                )
            )
        );

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Approval(Approval { owner: caller, spender, value: amount }))
        );

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Approval(Approval { owner: caller, spender, value: amount - 90 }))
        );
    }

    #[test]
    #[should_panic(expected: ('ERC20: transfer from 0', 'ENTRYPOINT_FAILED'))]
    fn test_transfer_when_sender_is_address_zero() {
        let reciever = contract_address_const::<'spender'>();
        let amount = 100;
        let (dispatcher, _) = deploy();
        dispatcher.transfer(reciever, amount);
    }

    #[test]
    #[should_panic(expected: ('ERC20: transfer to 0', 'ENTRYPOINT_FAILED'))]
    #[should_panic]
    fn test_transfer_when_recipient_is_address_zero() {
        let caller = contract_address_const::<'caller'>();
        let reciever = get_caller_address();
        let amount = 100;
        let (dispatcher, _) = deploy();
        set_contract_address(caller);
        dispatcher.transfer(reciever, amount);
    }

    #[test]
    fn test_transfer_success() {
        let caller = contract_address_const::<'initialzed_recipient'>();
        let reciever = contract_address_const::<'receiver'>();
        let amount = 100;
        let (dispatcher, contract_address) = deploy();
        set_contract_address(caller);
        dispatcher.transfer(reciever, amount);
        assert_eq!(dispatcher.balance_of(reciever), amount);

        // emits two transfer events
        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(
                Event::Transfer(
                    Transfer { from: get_caller_address(), to: caller, value: initial_supply }
                )
            )
        );

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Transfer(Transfer { from: caller, to: reciever, value: amount }))
        );
    }


    #[test]
    #[should_panic(expected: ('ERC20: transfer from 0', 'ENTRYPOINT_FAILED'))]
    #[should_panic]
    fn test_transferFrom_when_sender_is_address_zero() {
        let sender = get_caller_address();
        let amount = 100;
        let reciever = contract_address_const::<'spender'>();
        let (dispatcher, _) = deploy();
        dispatcher.transfer_from(sender, reciever, amount);
    }

    #[test]
    #[should_panic(expected: ('ERC20: transfer to 0', 'ENTRYPOINT_FAILED'))]
    #[should_panic]
    fn test_transferFrom_when_recipient_is_address_zero() {
        let caller = contract_address_const::<'caller'>();
        let reciever = get_caller_address();
        let amount = 100;
        let (dispatcher, _) = deploy();
        set_contract_address(caller);
        dispatcher.transfer_from(caller, reciever, amount);
    }

    #[test]
    fn test_transferFrom_success() {
        let caller = contract_address_const::<'initialzed_recipient'>();
        let reciever = contract_address_const::<'receiver'>();
        let amount = 100;
        let (dispatcher, contract_address) = deploy();
        set_contract_address(caller);
        dispatcher.transfer_from(caller, reciever, amount);
        assert_eq!(dispatcher.balance_of(reciever), amount);

        // emits two transfer events

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(
                Event::Transfer(
                    Transfer { from: get_caller_address(), to: caller, value: initial_supply }
                )
            )
        );

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Transfer(Transfer { from: caller, to: reciever, value: amount }))
        );
    }
}
