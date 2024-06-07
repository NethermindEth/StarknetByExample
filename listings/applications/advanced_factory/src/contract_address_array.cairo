use starknet::ContractAddress;

pub struct ContractAddressArray {
    data: Felt252Dict<Nullable<ContractAddress>>,
    len: usize
}

impl DestructContractAddressArray of Destruct<ContractAddressArray> {
    fn destruct(self: ContractAddressArray) nopanic {
        self.data.squash();
    }
}

#[generate_trait]
impl ContractAddressArrayImpl of ContractAddressArrayTrait {
    fn new() -> ContractAddressArray {
        ContractAddressArray { data: Default::default(), len: 0 }
    }

    fn push(ref self: ContractAddressArray, value: ContractAddress) {
        self.data.insert(self.len.into(), NullableTrait::new(value));
        self.len += 1;
    }

    fn get(ref self: ContractAddressArray, index: usize) -> ContractAddress {
        assert!(index < self.len(), "Index out of bounds");
        self.data.get(index.into()).deref()
    }

    fn len(self: @ContractAddressArray) -> usize {
        *self.len
    }
}
