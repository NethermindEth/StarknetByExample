use starknet::{ContractAddress};

// In order to make contract calls within our Vault,
// we need to have the ABI of the remote contract defined to import the Dispatcher
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
        _token: IERC20Dispatcher,
        _total_supply: u256,
        _balance_of: LegacyMap<ContractAddress, u256>
    }

    #[constructor]
    fn constructor(token: ContractAddress) {
        _token::write(IERC20Dispatcher { contract_address: token });
    }

    fn _mint(to: ContractAddress, shares: u256) {
        _total_supply::write(_total_supply::read() + shares);
        _balance_of::write(to, _balance_of::read(to) + shares);
    }

    fn _burn(from: ContractAddress, shares: u256) {
        _total_supply::write(_total_supply::read() - shares);
        _balance_of::write(from, _balance_of::read(from) - shares);
    }

    #[external]
    fn deposit(amount: u256) {
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
        if _total_supply::read() == 0 {
            shares = amount;
        } else {
            let balance = _token::read().balance_of(this);
            shares = (amount * _total_supply::read()) / balance;
        }

        _mint(caller, shares);
        _token::read().transfer_from(caller, this, amount);
    }

    #[external]
    fn withdraw(shares: u256) {
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

        let balance = _token::read().balance_of(this);
        let amount = (shares * balance) / _total_supply::read();
        _burn(caller, shares);
        _token::read().transfer(caller, amount);
    }
}

