use coin_flip::contract::{
    CoinFlip, ICoinFlipDispatcher, ICoinFlipDispatcherTrait, IPragmaVRFDispatcher,
    IPragmaVRFDispatcherTrait
};
use coin_flip::mock_randomness::MockRandomness;
use starknet::{
    ContractAddress, ClassHash, get_block_timestamp, contract_address_const, get_caller_address
};
use snforge_std::{
    declare, ContractClass, ContractClassTrait, start_cheat_caller_address,
    stop_cheat_caller_address, spy_events, SpyOn, EventSpy, EventAssertions, get_class_hash
};
use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
use pragma_lib::abi::{IRandomnessDispatcher, IRandomnessDispatcherTrait};

fn deploy() -> (ICoinFlipDispatcher, IRandomnessDispatcher, IERC20Dispatcher, ContractAddress) {
    // deploy mock ETH token
    let eth_contract = declare("ERC20Upgradeable").unwrap();
    let eth_name: ByteArray = "Ethereum";
    let eth_symbol: ByteArray = "ETH";
    let eth_supply: u256 = CoinFlip::CALLBACK_FEE_LIMIT.into() * 10;
    let mut eth_ctor_calldata = array![];
    let deployer = contract_address_const::<'deployer'>();
    ((eth_name, eth_symbol, eth_supply, deployer), deployer).serialize(ref eth_ctor_calldata);
    let eth_address = eth_contract.precalculate_address(@eth_ctor_calldata);
    start_cheat_caller_address(eth_address, deployer);
    eth_contract.deploy(@eth_ctor_calldata).unwrap();
    stop_cheat_caller_address(eth_address);

    // deploy MockRandomness
    let mock_randomness = declare("MockRandomness").unwrap();
    let mut randomness_calldata: Array<felt252> = array![];
    (eth_address).serialize(ref randomness_calldata);
    let (randomness_address, _) = mock_randomness.deploy(@randomness_calldata).unwrap();

    // deploy the actual CoinFlip contract
    let coin_flip_contract = declare("CoinFlip").unwrap();
    let mut coin_flip_ctor_calldata: Array<felt252> = array![];
    (randomness_address, eth_address).serialize(ref coin_flip_ctor_calldata);
    let (coin_flip_address, _) = coin_flip_contract.deploy(@coin_flip_ctor_calldata).unwrap();

    // approve the CoinFlip contract to spend the callback fee
    let eth_dispatcher = IERC20Dispatcher { contract_address: eth_address };
    start_cheat_caller_address(eth_address, deployer);
    eth_dispatcher.approve(coin_flip_address, CoinFlip::CALLBACK_FEE_LIMIT.into() * 2);
    stop_cheat_caller_address(eth_address);

    let randomness_dispatcher = IRandomnessDispatcher { contract_address: randomness_address };
    let coin_flip_dispathcer = ICoinFlipDispatcher { contract_address: coin_flip_address };

    (coin_flip_dispathcer, randomness_dispatcher, eth_dispatcher, deployer)
}

#[test]
#[fuzzer(runs: 10, seed: 22)]
fn test_two_flips(random_word_1: felt252, random_word_2: felt252) {
    let (coin_flip, randomness, _, deployer) = deploy();

    let mut spy = spy_events(SpyOn::One(coin_flip.contract_address));

    start_cheat_caller_address(coin_flip.contract_address, deployer);
    coin_flip.flip();
    stop_cheat_caller_address(coin_flip.contract_address);

    let expected_request_id = 0;

    spy
        .assert_emitted(
            @array![
                (
                    coin_flip.contract_address,
                    CoinFlip::Event::Flipped(
                        CoinFlip::Flipped { flip_id: expected_request_id, flipper: deployer }
                    )
                )
            ]
        );

    randomness
        .submit_random(
            expected_request_id,
            coin_flip.contract_address,
            0,
            0,
            coin_flip.contract_address,
            CoinFlip::CALLBACK_FEE_LIMIT,
            CoinFlip::CALLBACK_FEE_LIMIT,
            array![random_word_1].span(),
            array![].span(),
            array![]
        );

    let random_value: u256 = random_word_1.into() % 12000;
    let expected_side = if random_value < 5999 {
        CoinFlip::Side::Heads
    } else if random_value > 6000 {
        CoinFlip::Side::Tails
    } else {
        CoinFlip::Side::Sideways
    };

    spy
        .assert_emitted(
            @array![
                (
                    coin_flip.contract_address,
                    CoinFlip::Event::Landed(
                        CoinFlip::Landed {
                            flip_id: expected_request_id, flipper: deployer, side: expected_side
                        }
                    )
                )
            ]
        );

    start_cheat_caller_address(coin_flip.contract_address, deployer);
    coin_flip.flip();
    stop_cheat_caller_address(coin_flip.contract_address);

    let expected_request_id = 1;

    spy
        .assert_emitted(
            @array![
                (
                    coin_flip.contract_address,
                    CoinFlip::Event::Flipped(
                        CoinFlip::Flipped { flip_id: expected_request_id, flipper: deployer }
                    )
                )
            ]
        );

    randomness
        .submit_random(
            expected_request_id,
            coin_flip.contract_address,
            1,
            0,
            coin_flip.contract_address,
            CoinFlip::CALLBACK_FEE_LIMIT,
            CoinFlip::CALLBACK_FEE_LIMIT,
            array![random_word_2].span(),
            array![].span(),
            array![]
        );

    let random_value: u256 = random_word_2.into() % 12000;
    let expected_side = if random_value < 5999 {
        CoinFlip::Side::Heads
    } else if random_value > 6000 {
        CoinFlip::Side::Tails
    } else {
        CoinFlip::Side::Sideways
    };

    spy
        .assert_emitted(
            @array![
                (
                    coin_flip.contract_address,
                    CoinFlip::Event::Landed(
                        CoinFlip::Landed {
                            flip_id: expected_request_id, flipper: deployer, side: expected_side
                        }
                    )
                )
            ]
        );
}

#[test]
#[should_panic(expected: 'ERC20: insufficient allowance')]
fn test_flip_no_allowance() {
    let (coin_flip, _, eth, deployer) = deploy();

    let new_flipper = contract_address_const::<'new_flipper'>();

    // ensure new flipper has funds, just that they haven't approved the 
    // CoinFlip contract to spend them to cover the fee
    start_cheat_caller_address(eth.contract_address, deployer);
    eth.transfer(new_flipper, (CoinFlip::CALLBACK_FEE_LIMIT).into() * 2);
    stop_cheat_caller_address(eth.contract_address);

    start_cheat_caller_address(coin_flip.contract_address, new_flipper);
    coin_flip.flip();
}

#[test]
#[should_panic(expected: 'ERC20: insufficient balance')]
fn test_flip_without_enough_for_fees() {
    let (coin_flip, _, eth, _) = deploy();

    // approve the CoinFlip contract, but leave the flipper with no balance
    let flipper_with_no_funds = contract_address_const::<'flipper_with_no_funds'>();
    start_cheat_caller_address(eth.contract_address, flipper_with_no_funds);
    eth.approve(coin_flip.contract_address, (CoinFlip::CALLBACK_FEE_LIMIT).into() * 2);
    stop_cheat_caller_address(eth.contract_address);

    start_cheat_caller_address(coin_flip.contract_address, flipper_with_no_funds);
    coin_flip.flip();
}
