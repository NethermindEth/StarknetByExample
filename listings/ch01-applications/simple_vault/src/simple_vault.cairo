use starknet::{ContractAddress};

#[abi]
trait IERC20 {
    #[view]
    fn name() -> felt252;

    #[view]
    fn symbol() -> felt252;

    #[view]
    fn decimals() -> u8;

    #[view]
    fn total_supply() -> u256;

    #[view]
    fn balance_of(account: ContractAddress) -> u256;

    #[view]
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256;

    #[external]
    fn transfer(recipient: ContractAddress, amount: u256) -> bool;

    #[external]
    fn transfer_from(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool;

    #[external]
    fn approve(spender: ContractAddress, amount: u256) -> bool;
}

#[contract]
mod SimpleVault {
    use super::{IERC20Dispatcher, IERC20DispatcherTrait};
    use starknet::{
        ContractAddress,
        get_caller_address,
        get_contract_address
    };

    struct Storage {
        token: ContractAddress,
        total_supply: u256,
        balance_of: LegacyMap<ContractAddress, u256>
    }

    #[constructor]
    fn constructor(_token: ContractAddress) {
        token::write(_token);
    }

    fn _mint(_to: ContractAddress, _shares: u256) {
        total_supply::write(total_supply::read() + _shares);
        balance_of::write(_to, balance_of::read(_to) + _shares);
    }

    fn _burn(_from: ContractAddress, _shares: u256) {
        total_supply::write(total_supply::read() - _shares);
        balance_of::write(_from, balance_of::read(_from) - _shares);
    }

    #[external]
    fn deposit(_amount: u256) {
        // a = amount
        // B = balance of token before deposit
        // T = total supply
        // s = shares to mint
        //
        // (T + s) / T = (a + B) / B 
        //
        // s = aT / B
        let caller = get_caller_address();
        let this = get_contract_address();

        let mut shares = 0;
        if total_supply::read() == 0 {
            shares = _amount;
        } else {
            let balance = IERC20Dispatcher { contract_address: token::read() }.balance_of(this);
            shares = (_amount * total_supply::read()) / balance;
        }

        _mint(caller, shares);
        IERC20Dispatcher { contract_address: token::read() }.transfer_from(caller, this, _amount);
    }

    #[external]
    fn withdraw(_shares: u256) {
        // a = amount
        // B = balance of token before withdraw
        // T = total supply
        // s = shares to burn
        //
        // (T - s) / T = (B - a) / B 
        //
        // a = sB / T
        let caller = get_caller_address();
        let this = get_contract_address();

        let balance = IERC20Dispatcher { contract_address: token::read() }.balance_of(this);
        let amount = (_shares * balance) / total_supply::read();
        _burn(caller, _shares);
        IERC20Dispatcher { contract_address: token::read() }.transfer(caller, amount);
    }
}

