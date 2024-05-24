// With Store, you can store Data's structs in the storage part of contracts.
#[derive(Drop, starknet::Store)]
struct Data {
    address: starknet::ContractAddress,
    age: u8
}
