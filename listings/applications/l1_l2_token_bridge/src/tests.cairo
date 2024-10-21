use l1_l2_token_bridge::contract::{
    TokenBridge, ITokenBridgeDispatcher,
    ITokenBridgeDispatcherTrait,
};
use starknet::{ContractAddress, contract_address_const};
use snforge_std::{
    declare, start_cheat_caller_address, stop_cheat_caller_address, spy_events,
    EventSpyAssertionsTrait, DeclareResultTrait, ContractClassTrait
};
use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

// fn deploy() -> (
//     ITokenBridgeDispatcher, IERC20Dispatcher, ContractAddress
// ) { // deploy mock ETH token
// let eth_contract = declare("ERC20Upgradeable").unwrap().contract_class();
// let eth_name: ByteArray = "Ethereum";
// let eth_symbol: ByteArray = "ETH";
// let eth_supply: u256 = CALLBACK_FEE_LIMIT.into() * 100;
// let mut eth_ctor_calldata = array![];
// let deployer = contract_address_const::<'deployer'>();
// ((eth_name, eth_symbol, eth_supply, deployer), deployer).serialize(ref eth_ctor_calldata);
// let eth_address = eth_contract.precalculate_address(@eth_ctor_calldata);
// start_cheat_caller_address(eth_address, deployer);
// eth_contract.deploy(@eth_ctor_calldata).unwrap();
// stop_cheat_caller_address(eth_address);

// // deploy MockRandomness
// let mock_randomness = declare("MockRandomness").unwrap().contract_class();
// let mut randomness_calldata: Array<felt252> = array![];
// (eth_address).serialize(ref randomness_calldata);
// let (randomness_address, _) = mock_randomness.deploy(@randomness_calldata).unwrap();

// // deploy the actual TokenBridge contract
// let coin_flip_contract = declare("TokenBridge").unwrap().contract_class();
// let mut coin_flip_ctor_calldata: Array<felt252> = array![];
// (randomness_address, eth_address).serialize(ref coin_flip_ctor_calldata);
// let (coin_flip_address, _) = coin_flip_contract.deploy(@coin_flip_ctor_calldata).unwrap();

// let eth_dispatcher = IERC20Dispatcher { contract_address: eth_address };
// let randomness_dispatcher = IRandomnessDispatcher { contract_address: randomness_address };
// let coin_flip_dispatcher = ITokenBridgeDispatcher { contract_address: coin_flip_address };

// (coin_flip_dispatcher, randomness_dispatcher, eth_dispatcher, deployer)
// }
