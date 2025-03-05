use starknet::{ContractAddress, EthAddress, contract_address_const};
use starknet::storage::StoragePointerWriteAccess;
use snforge_std::{
    declare, start_cheat_caller_address, stop_cheat_caller_address, spy_events, spy_messages_to_l1,
    test_address, MessageToL1SpyAssertionsTrait, MessageToL1, EventSpyAssertionsTrait,
    DeclareResultTrait, ContractClassTrait,
};
use l1_l2_token_bridge::contract::{
    TokenBridge, ITokenBridgeDispatcher, ITokenBridgeDispatcherTrait,
};
use l1_l2_token_bridge::mintable_token_mock::MintableTokenMock;

fn CALLER() -> ContractAddress {
    contract_address_const::<'CALLER'>()
}

fn deploy() -> (ITokenBridgeDispatcher, EthAddress, ContractAddress) {
    let contract = declare("TokenBridge").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![CALLER().into()]).unwrap();

    let l1_bridge: EthAddress = 0x2137.try_into().unwrap();

    let contract = declare("MintableTokenMock").unwrap().contract_class();
    let (l2_token_address, _) = contract.deploy(@array![contract_address.into()]).unwrap();

    let contract = ITokenBridgeDispatcher { contract_address };
    start_cheat_caller_address(contract_address, CALLER());
    contract.set_l1_bridge(l1_bridge);
    contract.set_token(l2_token_address);
    stop_cheat_caller_address(contract_address);

    (contract, l1_bridge, l2_token_address)
}

#[test]
fn bridge_to_l1() {
    let mut spy_l1 = spy_messages_to_l1();

    let (contract, l1_bridge, l2_token_address) = deploy();
    let contract_address = contract.contract_address;

    let mut spy = spy_events();

    let l1_recipient = 0x123;
    let amount = 100;

    start_cheat_caller_address(contract_address, CALLER());
    contract.bridge_to_l1(l1_recipient.try_into().unwrap(), amount);

    let expected_payload = array![l1_recipient, 100, 0];
    let l1_recipient: EthAddress = l1_recipient.try_into().unwrap();

    spy_l1
        .assert_sent(
            @array![
                (
                    contract_address,
                    MessageToL1 { to_address: l1_bridge, payload: expected_payload },
                ),
            ],
        );

    spy
        .assert_emitted(
            @array![
                (
                    l2_token_address,
                    MintableTokenMock::Event::Burned(
                        MintableTokenMock::Burned { account: CALLER(), amount },
                    ),
                ),
            ],
        );
    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    TokenBridge::Event::WithdrawInitiated(
                        TokenBridge::WithdrawInitiated {
                            l1_recipient, amount, caller_address: CALLER(),
                        },
                    ),
                ),
            ],
        );
}

#[test]
fn handle_deposit() {
    let token_bridge_address = test_address();
    let mut state = TokenBridge::contract_state_for_testing();

    let l1_bridge = 0x2137;
    let contract = declare("MintableTokenMock").unwrap().contract_class();
    let (l2_token_address, _) = contract.deploy(@array![token_bridge_address.into()]).unwrap();

    state.l1_bridge.write(l1_bridge);
    state.l2_token.write(l2_token_address);

    let mut spy = spy_events();

    let recipient_account = contract_address_const::<'RECIPIENT'>();
    let amount = 100;

    TokenBridge::handle_deposit(ref state, l1_bridge, recipient_account, amount);

    spy
        .assert_emitted(
            @array![
                (
                    l2_token_address,
                    MintableTokenMock::Event::Minted(
                        MintableTokenMock::Minted { account: recipient_account, amount },
                    ),
                ),
            ],
        );
    spy
        .assert_emitted(
            @array![
                (
                    token_bridge_address,
                    TokenBridge::Event::DepositHandled(
                        TokenBridge::DepositHandled { account: recipient_account, amount },
                    ),
                ),
            ],
        );
}
