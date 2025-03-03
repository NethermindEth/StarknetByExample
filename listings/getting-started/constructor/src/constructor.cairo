// [!region contract]
#[starknet::contract]
mod ConstructorContract {
    // This trait is necessary to be able to write to a specific storage variable
    use starknet::storage::StoragePointerWriteAccess;

    #[storage]
    struct Storage {
        a: u128,
        b: u8,
        c: u256,
    }

    // The constructor is decorated with a `#[constructor]` attribute.
    // It is not inside an `impl` block.
    #[constructor]
    fn constructor(ref self: ContractState, a: u128, b: u8, c: u256) {
        self.a.write(a);
        self.b.write(b);
        self.c.write(c);
    }
}
// [!endregion contract]

// [!region tests]
#[cfg(test)]
mod tests {
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare, load};

    #[test]
    fn should_deploy_with_constructor_init_value() {
        let contract = declare("ConstructorContract").unwrap().contract_class();
        let mut constructor_calldata: Array<felt252> = array![];
        1_u128.serialize(ref constructor_calldata); // a
        2_u8.serialize(ref constructor_calldata); // b
        3_u256.serialize(ref constructor_calldata); // c
        let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();

        let mut loaded = load(contract_address, selector!("a"), 1).span();
        assert_eq!(Serde::deserialize(ref loaded).unwrap(), 1);

        let mut loaded = load(contract_address, selector!("b"), 1).span();
        assert_eq!(Serde::deserialize(ref loaded).unwrap(), 2);

        let mut loaded = load(contract_address, selector!("c"), 2).span();
        assert_eq!(Serde::deserialize(ref loaded).unwrap(), 3);
    }
}
// [!endregion tests]


