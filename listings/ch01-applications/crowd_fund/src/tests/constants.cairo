use starknet::ClassHash;
use starknet::ContractAddress;
use starknet::class_hash_const;
use starknet::contract_address_const;
use starknet::class_hash_to_felt252;

fn PLAYER_ONE() -> ContractAddress {
    contract_address_const::<'PLAYER_ONE'>()
}

fn OWNER() -> ContractAddress {
    contract_address_const::<'OWNER'>()
}

fn PLAYER_TWO() -> ContractAddress {
    contract_address_const::<'PLAYER_TWO'>()
}

fn OTHER_OWNER() -> ContractAddress {
    contract_address_const::<'OTHER_OWNER'>()
}

fn GAME_ONE() -> ContractAddress {
    contract_address_const::<'GAME_ONE'>()
}

fn GAME_TWO() -> ContractAddress {
    contract_address_const::<'GAME_TWO'>()
}

fn GAME_CLASS_HASH() -> ClassHash {
    let game_class_hash = class_hash_const::<
        0x02f45ad52642c593a9c21d6b84b6f29984b50c53f9ed2b01b34d1b1526ca88a5
    >();
    let game_class_hash_felt252 = class_hash_to_felt252(game_class_hash);
    game_class_hash
}
