#[contract]
mod SimpleAccessControl {
    use starknet::{get_caller_address,ContractAddress};

    struct Storage {
        owner: ContractAddress, 
    }

    #[event]
    fn welcomeEvent(name: felt252) {}

    #[constructor]
    fn constructor(_address: ContractAddress) {
        owner::write(_address);
    }

    #[internal]
    fn only_owner() -> bool {
        return get_caller_address() == owner::read();
    }

    #[external]
    fn log_access() {
        if(only_owner()) {
            welcomeEvent('Welcome Admin!');
        } else {
            welcomeEvent('Welcome User!');
        }
    }
}
