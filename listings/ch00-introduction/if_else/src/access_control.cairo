#[contract]
mod SimpleAccessControl {
    use starknet::{get_caller_address,ContractAddress};

    struct Storage {
        _owner: ContractAddress, 
    }

    #[event]
    fn WelcomeEvent(name: felt252) {}

    #[constructor]
    fn constructor(address: ContractAddress) {
        _owner::write(address);
    }

    fn only_owner() -> bool {
        return get_caller_address() == _owner::read();
    }

    #[external]
    fn log_access() {
        if(only_owner()) {
            WelcomeEvent('Welcome Admin!');
        } else {
            WelcomeEvent('Welcome User!');
        }
    }
}
