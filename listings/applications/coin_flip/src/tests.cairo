use coin_flip::contract::{
    CoinFlip, CoinFlip::{Side, CALLBACK_FEE_LIMIT}, ICoinFlipDispatcher, ICoinFlipDispatcherTrait,
};
use starknet::{ContractAddress, contract_address_const};
use snforge_std::{
    declare, start_cheat_caller_address, stop_cheat_caller_address, spy_events,
    EventSpyAssertionsTrait, DeclareResultTrait, ContractClassTrait,
};
use openzeppelin_token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
use pragma_lib::abi::{IRandomnessDispatcher, IRandomnessDispatcherTrait};

fn deploy() -> (ICoinFlipDispatcher, IRandomnessDispatcher, IERC20Dispatcher, ContractAddress) {
    // deploy mock ETH token
    let eth_contract = declare("ERC20Upgradeable").unwrap().contract_class();
    let eth_name: ByteArray = "Ethereum";
    let eth_symbol: ByteArray = "ETH";
    let eth_supply: u256 = CALLBACK_FEE_LIMIT.into() * 100;
    let mut eth_ctor_calldata = array![];
    let deployer = contract_address_const::<'deployer'>();
    ((eth_name, eth_symbol, eth_supply, deployer), deployer).serialize(ref eth_ctor_calldata);
    let eth_address = eth_contract.precalculate_address(@eth_ctor_calldata);
    start_cheat_caller_address(eth_address, deployer);
    eth_contract.deploy(@eth_ctor_calldata).unwrap();
    stop_cheat_caller_address(eth_address);

    // deploy MockRandomness
    let mock_randomness = declare("MockRandomness").unwrap().contract_class();
    let mut randomness_calldata: Array<felt252> = array![];
    (eth_address).serialize(ref randomness_calldata);
    let (randomness_address, _) = mock_randomness.deploy(@randomness_calldata).unwrap();

    // deploy the actual CoinFlip contract
    let coin_flip_contract = declare("CoinFlip").unwrap().contract_class();
    let mut coin_flip_ctor_calldata: Array<felt252> = array![];
    (randomness_address, eth_address).serialize(ref coin_flip_ctor_calldata);
    let (coin_flip_address, _) = coin_flip_contract.deploy(@coin_flip_ctor_calldata).unwrap();

    let eth_dispatcher = IERC20Dispatcher { contract_address: eth_address };
    let randomness_dispatcher = IRandomnessDispatcher { contract_address: randomness_address };
    let coin_flip_dispatcher = ICoinFlipDispatcher { contract_address: coin_flip_address };

    (coin_flip_dispatcher, randomness_dispatcher, eth_dispatcher, deployer)
}

#[test]
fn test_all_relevant_random_words() {
    let (coin_flip, randomness, eth, deployer) = deploy();

    // fund the CoinFlip contract
    start_cheat_caller_address(eth.contract_address, deployer);
    eth.transfer(coin_flip.contract_address, CALLBACK_FEE_LIMIT.into() * 100);
    stop_cheat_caller_address(eth.contract_address);

    let random_words: Array<(felt252, Side, u64)> = array![
        (0, Side::Heads, 0),
        (2, Side::Heads, 1),
        (4, Side::Heads, 2),
        (1000, Side::Heads, 3),
        (12345654320, Side::Heads, 4),
        (1, Side::Tails, 5),
        (3, Side::Tails, 6),
        (5, Side::Tails, 7),
        (1001, Side::Tails, 8),
        (12345654321, Side::Tails, 9),
    ];
    for (random_word, expected_side, expected_request_id) in random_words {
        _flip_request(
            coin_flip,
            randomness,
            eth,
            deployer,
            expected_request_id,
            CALLBACK_FEE_LIMIT / 5 * 3,
            random_word,
            expected_side,
        );
    }
}

#[test]
fn test_multiple_flips() {
    let (coin_flip, randomness, eth, deployer) = deploy();

    // fund the CoinFlip contract
    start_cheat_caller_address(eth.contract_address, deployer);
    eth.transfer(coin_flip.contract_address, CALLBACK_FEE_LIMIT.into() * 50);
    stop_cheat_caller_address(eth.contract_address);

    _flip_request(
        coin_flip, randomness, eth, deployer, 0, CALLBACK_FEE_LIMIT / 5 * 3, 123456789, Side::Tails,
    );
    _flip_request(
        coin_flip,
        randomness,
        eth,
        deployer,
        1,
        CALLBACK_FEE_LIMIT / 4 * 3,
        12345654321,
        Side::Tails,
    );
    _flip_request(coin_flip, randomness, eth, deployer, 2, CALLBACK_FEE_LIMIT, 3, Side::Tails);
}

fn _flip_request(
    coin_flip: ICoinFlipDispatcher,
    randomness: IRandomnessDispatcher,
    eth: IERC20Dispatcher,
    deployer: ContractAddress,
    expected_request_id: u64,
    expected_callback_fee: u128,
    random_word: felt252,
    expected_side: Side,
) {
    let original_balance = eth.balance_of(coin_flip.contract_address);

    let mut spy = spy_events();

    start_cheat_caller_address(coin_flip.contract_address, deployer);
    coin_flip.flip();
    stop_cheat_caller_address(coin_flip.contract_address);

    spy
        .assert_emitted(
            @array![
                (
                    coin_flip.contract_address,
                    CoinFlip::Event::Flipped(
                        CoinFlip::Flipped { flip_id: expected_request_id, flipper: deployer },
                    ),
                ),
            ],
        );

    let post_flip_balance = eth.balance_of(coin_flip.contract_address);
    assert_eq!(
        post_flip_balance,
        original_balance
            - randomness.get_total_fees(coin_flip.contract_address, expected_request_id),
    );

    randomness
        .submit_random(
            expected_request_id,
            coin_flip.contract_address,
            0,
            0,
            coin_flip.contract_address,
            CALLBACK_FEE_LIMIT,
            expected_callback_fee,
            array![random_word].span(),
            array![].span(),
            array![],
        );

    spy
        .assert_emitted(
            @array![
                (
                    coin_flip.contract_address,
                    CoinFlip::Event::Landed(
                        CoinFlip::Landed {
                            flip_id: expected_request_id, flipper: deployer, side: expected_side,
                        },
                    ),
                ),
            ],
        );

    assert_eq!(
        eth.balance_of(coin_flip.contract_address),
        post_flip_balance + (CALLBACK_FEE_LIMIT - expected_callback_fee).into(),
    );
}

#[test]
fn test_two_consecutive_flips() {
    let (coin_flip, randomness, eth, deployer) = deploy();

    // fund the CoinFlip contract
    start_cheat_caller_address(eth.contract_address, deployer);
    eth.transfer(coin_flip.contract_address, CALLBACK_FEE_LIMIT.into() * 50);
    stop_cheat_caller_address(eth.contract_address);

    let mut spy = spy_events();

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
                    CoinFlip::Event::Flipped(CoinFlip::Flipped { flip_id: 0, flipper: deployer }),
                ),
                (
                    coin_flip.contract_address,
                    CoinFlip::Event::Flipped(
                        CoinFlip::Flipped { flip_id: 1, flipper: other_flipper },
                    ),
                ),
            ],
        );

    let post_flip_balance = eth.balance_of(coin_flip.contract_address);
    let first_flip_fee = randomness.get_total_fees(coin_flip.contract_address, 0);
    let second_flip_fee = randomness.get_total_fees(coin_flip.contract_address, 1);
    assert_eq!(post_flip_balance, original_balance - first_flip_fee - second_flip_fee);

    let expected_callback_fee = CALLBACK_FEE_LIMIT / 5 * 3;
    let random_word_deployer = 5633;
    let expected_side_deployer = Side::Tails;
    let random_word_other_flipper = 8000;
    let expected_side_other_flipper = Side::Heads;

    randomness
        .submit_random(
            0,
            coin_flip.contract_address,
            0,
            0,
            coin_flip.contract_address,
            CALLBACK_FEE_LIMIT,
            expected_callback_fee,
            array![random_word_deployer].span(),
            array![].span(),
            array![],
        );
    randomness
        .submit_random(
            1,
            coin_flip.contract_address,
            0,
            0,
            coin_flip.contract_address,
            CALLBACK_FEE_LIMIT,
            expected_callback_fee,
            array![random_word_other_flipper].span(),
            array![].span(),
            array![],
        );

    spy
        .assert_emitted(
            @array![
                (
                    coin_flip.contract_address,
                    CoinFlip::Event::Landed(
                        CoinFlip::Landed {
                            flip_id: 0, flipper: deployer, side: expected_side_deployer,
                        },
                    ),
                ),
                (
                    coin_flip.contract_address,
                    CoinFlip::Event::Landed(
                        CoinFlip::Landed {
                            flip_id: 1, flipper: other_flipper, side: expected_side_other_flipper,
                        },
                    ),
                ),
            ],
        );

    assert_eq!(
        eth.balance_of(coin_flip.contract_address),
        post_flip_balance + (CALLBACK_FEE_LIMIT - expected_callback_fee).into() * 2,
    );
}

#[test]
#[should_panic(expected: 'ERC20: insufficient balance')]
fn test_flip_without_enough_for_fees() {
    let (coin_flip, _, _, deployer) = deploy();
    start_cheat_caller_address(coin_flip.contract_address, deployer);
    coin_flip.flip();
}
