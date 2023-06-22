use starknet::ContractAddress;

#[contract]
mod SimpleAccessControl {
    use starknet::get_caller_address;

    struct Storage {
        owner: starknet::ContractAddress, 
    }

    #[constructor]
    fn constructor(_address: starknet::ContractAddress) {
        owner::write(_address);
    }

    #[external]
    fn onlyOwner() -> bool {
        if (get_caller_address() == owner::read()) {
            return true;
        }
        return false;
    }
}
