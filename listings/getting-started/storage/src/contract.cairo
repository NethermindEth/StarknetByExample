// [!region contract]
#[starknet::contract]
mod Contract {
    #[storage]
    struct Storage {
        a: u128,
        b: u8,
        c: u256,
    }
}
// [!endregion contract]

#[cfg(test)]
mod test {
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare, load};

    #[test]
    fn test_storage_members() {
        let contract = declare("Contract").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();

        let mut loaded = load(contract_address, selector!("a"), 1).span();
        assert_eq!(Serde::deserialize(ref loaded).unwrap(), 0);

        let mut loaded = load(contract_address, selector!("b"), 1).span();
        assert_eq!(Serde::deserialize(ref loaded).unwrap(), 0);

        let mut loaded = load(contract_address, selector!("c"), 2).span();
        assert_eq!(Serde::deserialize(ref loaded).unwrap(), 0);
    }
}
