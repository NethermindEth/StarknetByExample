#[contract]
mod SimpleAccessControl {
    use starknet::get_caller_address;

    struct Storage {
        owner: ContractAddress, 
    }

    #[constructor]
    fn constructor(_name: felt252, _address: ContractAddress) {
        names::write(_address, _name);
    }

    #[external]
    fn onlyOwner() -> bool {
        if (get_caller_address() == Storage.owner) {
            return true;
        }
        return false;
    }
}
