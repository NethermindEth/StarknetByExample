mod tests {
    use super::super::token::{
        erc20, IERC20Dispatcher, IERC20DispatcherTrait, erc20::{Event, Transfer, Approval}
    };

    use starknet::{
        ContractAddress, SyscallResultTrait, syscalls::deploy_syscall, get_caller_address,
        contract_address_const
    };

    use starknet::testing::{set_contract_address, set_account_contract_address};


    fn deploy() -> (IERC20Dispatcher, ContractAddress) {
        let recipient: ContractAddress = contract_address_const::<'recipient'>();

        let token_name: felt252 = 'myToken';
        let decimals: felt252 = 18;
        let initial_supply: felt252 = 100000;
        let symbols: felt252 = 'mtk';

        let (contract_address, _) = deploy_syscall(
            erc20::TEST_CLASS_HASH.try_into().unwrap(),
            recipient.into(),
            array![recipient.into(), token_name, decimals, initial_supply, symbols].span(),
            false
        )
            .unwrap_syscall();

        (IERC20Dispatcher { contract_address }, contract_address)
    }

    fn recipient_address() -> ContractAddress {
        let recipient: ContractAddress = contract_address_const::<'recipient'>();

        recipient
    }

    fn spender_address() -> ContractAddress {
        let spender = contract_address_const::<'spender'>();
        spender
    }

    fn zero_address() -> ContractAddress {
        get_caller_address()
    }

    #[test]
    #[should_panic]
    fn test_deploy_when_recipient_is_address_zero() {
        let recipient: ContractAddress = zero_address();

        let token_name: felt252 = 'myToken';
        let decimals: felt252 = 18;
        let initial_supply: felt252 = 100000;
        let symbols: felt252 = 'mtk';

        let (contract_address, _) = deploy_syscall(
            erc20::TEST_CLASS_HASH.try_into().unwrap(),
            recipient.into(),
            array![recipient.into(), token_name, decimals, initial_supply, symbols].span(),
            false
        )
            .unwrap_syscall();
    }
    #[test]
    fn test_deploy_success() {
        let recipient = recipient_address();
        let (_, contract_address) = deploy();
        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(
                Event::Transfer(Transfer { from: zero_address(), to: recipient, value: 100000 })
            )
        );
    }


    #[test]
    fn test_get_name() {
        let (dispatcher, _) = deploy();
        let name = dispatcher.get_name();
        assert(name == 'myToken', 'wrong token name');
    }

    #[test]
    fn test_get_symbol() {
        let (dispatcher, _) = deploy();
        assert(dispatcher.get_symbol() == 'mtk', 'wrong symbol');
    }

    #[test]
    fn test_get_decimals() {
        let (dispatcher, _) = deploy();
        assert(dispatcher.get_decimals() == 18, 'wrong decimals');
    }

    #[test]
    fn test_total_supply() {
        let (dispatcher, _) = deploy();
        assert(dispatcher.get_total_supply() == 100000, 'wrong total supply');
    }

    #[test]
    fn test_balance_of_recipient_deployed() {
        let recipient = recipient_address();
        let (dispatcher, _) = deploy();
        assert(dispatcher.balance_of(recipient) == 100000, 'incorrect balance of recipient');
    }

    #[test]
    fn test_allowance_without_approval() {
        let caller = contract_address_const::<'caller'>();
        let spender = spender_address();
        let (dispatcher, _) = deploy();
        set_contract_address(caller);
        assert(dispatcher.allowance(caller, spender) == 0, 'incorrect allowance')
    }

    #[test]
    fn test_allowance_after_approval() {
        let caller = contract_address_const::<'caller'>();
        let spender = spender_address();
        let (dispatcher, _) = deploy();
        set_contract_address(caller);
        dispatcher.approve(spender, 100);
        assert(dispatcher.allowance(caller, spender) == 100, 'incorrect allowance')
    }

    #[test]
    #[should_panic]
    fn test_approval_spender_is_address_zero() {
        let spender: ContractAddress = zero_address();

        let (dispatcher, _) = deploy();
        dispatcher.approve(spender, 100);
    }

    #[test]
    fn test_approval_success() {
        let recipient = recipient_address();
        let spender = spender_address();
        let value = 100;

        let (dispatcher, contract_address) = deploy();
        let caller = contract_address_const::<'caller'>();
        set_contract_address(caller);
        dispatcher.approve(spender, value);
        set_contract_address(contract_address);

        // Notice the order: the first event emitted is the first to be popped.
        /// ANCHOR: test_events
        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(
                Event::Transfer(Transfer { from: zero_address(), to: recipient, value: 100000 })
            )
        );

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Approval(Approval { owner: caller, spender, value }))
        );
    }

    #[test]
    #[should_panic]
    fn test_should_increase_allowance_with_spender_zero_address() {
        let spender = zero_address();
        let (dispatcher, _) = deploy();
        dispatcher.increase_allowance(spender, 100);
    }

    #[test]
    fn test_should_increase_allowance() {
        let caller = contract_address_const::<'caller'>();
        let recipient = recipient_address();
        let spender = spender_address();
        let (dispatcher, contract_address) = deploy();
        set_contract_address(caller);
        dispatcher.approve(spender, 100);
        assert(dispatcher.allowance(caller, spender) == 100, 'incorrect allowance');
        set_contract_address(caller);
        dispatcher.increase_allowance(spender, 100);
        assert(dispatcher.allowance(caller, spender) == 200, 'incorrect increased allowance');

        // emits one transfer event and two approval events

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(
                Event::Transfer(Transfer { from: zero_address(), to: recipient, value: 100000 })
            )
        );

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Approval(Approval { owner: caller, spender, value: 100 }))
        );

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Approval(Approval { owner: caller, spender, value: 200 }))
        );
    }

    #[test]
    #[should_panic]
    fn test_should_decrease_allowance_with_spender_zero_address() {
        let spender = zero_address();
        let (dispatcher, _) = deploy();
        dispatcher.decrease_allowance(spender, 100);
    }

    #[test]
    fn test_should_decrease_allowance() {
        let caller = contract_address_const::<'caller'>();
        let recipient = recipient_address();
        let spender = spender_address();
        let (dispatcher, contract_address) = deploy();
        set_contract_address(caller);
        dispatcher.approve(spender, 100);
        assert(dispatcher.allowance(caller, spender) == 100, 'incorrect allowance');

        set_contract_address(caller);
        dispatcher.decrease_allowance(spender, 90);
        assert(dispatcher.allowance(caller, spender) == 10, 'incorrect decreased allowance');

        // emits one transfer event and two approval events

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(
                Event::Transfer(Transfer { from: zero_address(), to: recipient, value: 100000 })
            )
        );

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Approval(Approval { owner: caller, spender, value: 100 }))
        );

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Approval(Approval { owner: caller, spender, value: 10 }))
        );
    }

    #[test]
    #[should_panic]
    fn test_transfer_when_sender_is_address_zero() {
        let reciever = spender_address();
        let (dispatcher, _) = deploy();
        dispatcher.transfer(reciever, 100);
    }

    #[test]
    #[should_panic]
    fn test_transfer_when_recipient_is_address_zero() {
        let caller = contract_address_const::<'caller'>();
        let reciever = zero_address();
        let (dispatcher, _) = deploy();
        set_contract_address(caller);
        dispatcher.transfer(reciever, 100);
    }

    #[test]
    fn test_transfer_success() {
        let caller = recipient_address();
        let reciever = contract_address_const::<'receiver'>();
        let recipient = recipient_address();
        let (dispatcher, contract_address) = deploy();
        set_contract_address(caller);
        dispatcher.transfer(reciever, 100);
        assert_eq!(dispatcher.balance_of(reciever), 100);

        // emits two transfer events
        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(
                Event::Transfer(Transfer { from: zero_address(), to: recipient, value: 100000 })
            )
        );

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Transfer(Transfer { from: caller, to: reciever, value: 100 }))
        );
    }


    #[test]
    #[should_panic]
    fn test_transferFrom_when_sender_is_address_zero() {
        let sender = zero_address();
        let reciever = spender_address();
        let (dispatcher, _) = deploy();
        dispatcher.transfer_from(sender, reciever, 100);
    }

    #[test]
    #[should_panic]
    fn test_transferFrom_when_recipient_is_address_zero() {
        let caller = contract_address_const::<'caller'>();
        let reciever = zero_address();
        let (dispatcher, _) = deploy();
        set_contract_address(caller);
        dispatcher.transfer_from(caller, reciever, 100);
    }

    #[test]
    fn test_transferFrom_success() {
        let caller = recipient_address();
        let reciever = contract_address_const::<'receiver'>();
        let recipient = recipient_address();
        let (dispatcher, contract_address) = deploy();
        set_contract_address(caller);
        dispatcher.transfer_from(caller, reciever, 100);
        assert_eq!(dispatcher.balance_of(reciever), 100);

        // emits two transfer events

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(
                Event::Transfer(Transfer { from: zero_address(), to: recipient, value: 100000 })
            )
        );

        assert_eq!(
            starknet::testing::pop_log(contract_address),
            Option::Some(Event::Transfer(Transfer { from: caller, to: reciever, value: 100 }))
        );
    }
}
