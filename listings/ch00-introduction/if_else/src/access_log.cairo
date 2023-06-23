#[contract]
mod SimpleAccessLog {
    // Import the Starknet contract API.
    use starknet::{get_caller_address, ContractAddress};

    struct Storage {
        // Add the owner to the contract storage.
        _owner: ContractAddress,
    }

    #[event]
    // Add a welcome event to the contract.
    fn WelcomeEvent(name: felt252) {}

    #[constructor]
    fn constructor(address: ContractAddress) {
        // Set the owner to be the address that deployed the contract.
        _owner::write(address);
    }

    // Add a function that checks if the caller is the owner.
    fn is_owner() -> bool {
        return get_caller_address() == _owner::read();
    }

    #[external]
    fn log_access() {
        //  Add a conditional event that welcomes the owner or the user.
        if (is_owner()) {
            // We know since is_owner() == true, the owner called the function. Call the welcome event with 'Welcome Admin!'.
            WelcomeEvent('Welcome Admin!');
        } else {
            // We know since is_owner() == false, a normal user(not owner) called the function. Call the welcome event with 'Welcome User!'.
            WelcomeEvent('Welcome User!');
        }
    }
}
