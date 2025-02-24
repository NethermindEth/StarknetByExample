// [!region contract]
#[starknet::interface]
pub trait IInventoryContract<TContractState> {
    fn get_inventory_count(self: @TContractState) -> u32;
    fn get_max_capacity(self: @TContractState) -> u32;
    fn update_inventory(ref self: TContractState, new_count: u32);
}

/// An external function that encodes constraints for update inventory
fn check_update_inventory(new_count: u32, max_capacity: u32) -> Result<u32, felt252> {
    if new_count == 0 {
        return Result::Err('OutOfStock');
    }
    if new_count > max_capacity {
        return Result::Err('ExceedsCapacity');
    }

    Result::Ok(new_count)
}

#[starknet::contract]
pub mod InventoryContract {
    use super::check_update_inventory;
    use starknet::{get_caller_address, ContractAddress};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    pub struct Storage {
        pub inventory_count: u32,
        pub max_capacity: u32,
        pub owner: ContractAddress,
    }

    #[event]
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        InventoryUpdated: InventoryUpdated,
    }

    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct InventoryUpdated {
        pub new_count: u32,
    }

    #[constructor]
    pub fn constructor(ref self: ContractState, max_capacity: u32) {
        self.inventory_count.write(0);
        self.max_capacity.write(max_capacity);
        self.owner.write(get_caller_address());
    }

    #[abi(embed_v0)]
    pub impl InventoryContractImpl of super::IInventoryContract<ContractState> {
        fn get_inventory_count(self: @ContractState) -> u32 {
            self.inventory_count.read()
        }

        fn get_max_capacity(self: @ContractState) -> u32 {
            self.max_capacity.read()
        }

        fn update_inventory(ref self: ContractState, new_count: u32) {
            assert(self.owner.read() == get_caller_address(), 'Not owner');

            match check_update_inventory(new_count, self.max_capacity.read()) {
                Result::Ok(new_count) => self.inventory_count.write(new_count),
                Result::Err(error) => { panic!("{}", error); },
            }

            self.emit(Event::InventoryUpdated(InventoryUpdated { new_count }));
        }
    }
}
// [!endregion contract]

// [!region tests]
#[cfg(test)]
mod tests {
    use super::check_update_inventory;

    #[test]
    fn test_check_update_inventory() {
        let result = check_update_inventory(10, 100);
        assert_eq!(result, Result::Ok(10));
    }

    #[test]
    fn test_check_update_inventory_out_of_stock() {
        let result = check_update_inventory(0, 100);
        assert_eq!(result, Result::Err('OutOfStock'));
    }

    #[test]
    fn test_check_update_inventory_exceeds_capacity() {
        let result = check_update_inventory(101, 100);
        assert_eq!(result, Result::Err('ExceedsCapacity'));
    }
}
// [!endregion tests]


