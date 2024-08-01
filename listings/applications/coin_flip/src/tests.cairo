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
    let eth_supply: u256 = CoinFlip::CALLBACK_FEE_LIMIT.into() * 100;
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

    let eth_dispatcher = IERC20Dispatcher { contract_address: eth_address };
    let randomness_dispatcher = IRandomnessDispatcher { contract_address: randomness_address };
    let coin_flip_dispatcher = ICoinFlipDispatcher { contract_address: coin_flip_address };

    // fund the CoinFlip contract
    start_cheat_caller_address(eth_address, deployer);
    eth_dispatcher
        .transfer(
            coin_flip_address, CoinFlip::CALLBACK_FEE_LIMIT.into() * 100
        );
    stop_cheat_caller_address(eth_address);

    (coin_flip_dispatcher, randomness_dispatcher, eth_dispatcher, deployer)
}

#[test]
#[fuzzer(runs: 10, seed: 22)]
fn test_two_flips(random_word_1: felt252, random_word_2: felt252) {
    let (coin_flip, randomness, eth, deployer) = deploy();

    _flip_request(coin_flip, randomness, eth, deployer, 0, CoinFlip::CALLBACK_FEE_LIMIT / 5 * 3);
    _flip_request(coin_flip, randomness, eth, deployer, 1, CoinFlip::CALLBACK_FEE_LIMIT / 4 * 3);
    _flip_request(coin_flip, randomness, eth, deployer, 2, CoinFlip::CALLBACK_FEE_LIMIT);
}

fn _flip_request(coin_flip: ICoinFlipDispatcher, randomness: IRandomnessDispatcher, eth: IERC20Dispatcher, deployer: ContractAddress, expected_request_id: u64, expected_callback_fee: u128) {
    let mut spy = spy_events(SpyOn::One(coin_flip.contract_address));

    let original_balance = eth.balance_of(coin_flip.contract_address);

    start_cheat_caller_address(coin_flip.contract_address, deployer);
    coin_flip.flip();
    stop_cheat_caller_address(coin_flip.contract_address);

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

    let post_flip_balance = eth.balance_of(coin_flip.contract_address);
    assert_eq!(post_flip_balance, original_balance - randomness.get_total_fees(coin_flip.contract_address, expected_request_id));

    randomness
        .submit_random(
            expected_request_id,
            coin_flip.contract_address,
            0,
            0,
            coin_flip.contract_address,
            CoinFlip::CALLBACK_FEE_LIMIT,
            expected_callback_fee,
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

    assert_eq!(eth.balance_of(coin_flip.contract_address), post_flip_balance + (CoinFlip::CALLBACK_FEE_LIMIT - expected_callback_fee));
}

#[test]
fn test_two_consecutive_flips() {
    let (coin_flip, randomness, eth, deployer) = deploy();

    let mut spy = spy_events(SpyOn::One(coin_flip.contract_address));

    let original_balance = eth.balance_of(coin_flip.contract_address);

    let other_flipper = contract_address_const::<'other_flipper'>();

    start_cheat_caller_address(coin_flip.contract_address, deployer);
    coin_flip.flip();
    start_cheat_caller_address(coin_flip.contract_address, other_flipper);
    coin_flip.flip();
    stop_cheat_caller_address(coin_flip.contract_address);

    spy
        .assert_emitted(
            @array![
                (
                    coin_flip.contract_address,
                    CoinFlip::Event::Flipped(
                        CoinFlip::Flipped { flip_id: 0, flipper: deployer }
                    )
                ),
                (
                    coin_flip.contract_address,
                    CoinFlip::Event::Flipped(
                        CoinFlip::Flipped { flip_id: 1, flipper: other_flipper }
                    )
                )
            ]
        );

    let post_flip_balance = eth.balance_of(coin_flip.contract_address);
    assert_eq!(post_flip_balance, original_balance - randomness.get_total_fees(coin_flip.contract_address, expected_request_id) * 2);

    let expected_callback_fee = CoinFlip::CALLBACK_FEE_LIMIT / 5 * 3;
    let random_word_deployer = 'this is a string representation of some felt';
    let random_word_other_user = 'this is another felt value that we need';

    randomness
        .submit_random(
            0,
            coin_flip.contract_address,
            0,
            0,
            coin_flip.contract_address,
            CoinFlip::CALLBACK_FEE_LIMIT,
            expected_callback_fee,
            array![random_word_deployer].span(),
            array![].span(),
            array![]
        );
    randomness
        .submit_random(
            1,
            coin_flip.contract_address,
            0,
            0,
            coin_flip.contract_address,
            CoinFlip::CALLBACK_FEE_LIMIT,
            expected_callback_fee,
            array![random_word_other_user].span(),
            array![].span(),
            array![]
        );

    let random_value: u256 = random_word_deployer.into() % 12000;
    let expected_side_deployer = if random_value < 5999 {
        CoinFlip::Side::Heads
    } else if random_value > 6000 {
        CoinFlip::Side::Tails
    } else {
        CoinFlip::Side::Sideways
    };
    let random_value: u256 = random_word_other_user.into() % 12000;
    let expected_side_other_user = if random_value < 5999 {
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
                            flip_id: 0, flipper: deployer, side: expected_side_deployer
                        }
                    )
                )
                (
                    coin_flip.contract_address,
                    CoinFlip::Event::Landed(
                        CoinFlip::Landed {
                            flip_id: 1, flipper: other_flipper, side: expected_side_other_flipper
                        }
                    )
                )
            ]
        );

    assert_eq!(eth.balance_of(coin_flip.contract_address), post_flip_balance + (CoinFlip::CALLBACK_FEE_LIMIT - expected_callback_fee) * 2);
}

#[test]
#[should_panic(expected: 'ERC20: insufficient balance')]
fn test_flip_without_enough_for_fees() {
    let (coin_flip, _, _, deployer) = deploy();
    start_cheat_caller_address(coin_flip.contract_address, deployer);
    coin_flip.flip();
}
