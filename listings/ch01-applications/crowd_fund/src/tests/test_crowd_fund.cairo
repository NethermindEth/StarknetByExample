use core::option::OptionTrait;
use core::traits::TryInto;
use crowd_fund::contracts::{ICrowdFundDispatcherTrait, ICrowdFund};
use crowd_fund::contracts::CrowdFund::{
    countContractMemberStateTrait, campaignsContractMemberStateTrait
};
use openzeppelin::token::erc20::interface::IERC20Dispatcher;
use openzeppelin::token::erc20::interface::IERC20DispatcherTrait;
use openzeppelin::utils::serde::SerializedAppend;
use openzeppelin::utils::selectors;

use snforge_std::{
    declare, ContractClassTrait, TxInfoMock, TxInfoMockTrait, start_spoof, start_prank, cheatcodes,
    CheatTarget, spy_events, EventSpy, EventFetcher, EventAssertions, Event, SpyOn, test_address,
    event_name_hash
};

use starknet::{ContractAddress, contract_address_to_felt252};
use starknet::contract_address_const;
use starknet::account::Call;
use starknet::testing;
use starknet::testing::set_signature;
use crowd_fund::tests::constants::{PLAYER_ONE, ZERO_OWNER};
use crowd_fund::contracts::{CrowdFund, ICrowdFundDispatcher};
use debug::PrintTrait;

#[derive(Drop)]
struct ERC20ConstructorArguments {
    name: felt252,
    symbol: felt252,
    initial_supply: u256,
    recipient: ContractAddress
}

#[generate_trait]
impl ERC20ConstructorArgumentsImpl of ERC20ConstructorArgumentsTrait {
    fn new(recipient: ContractAddress, initial_supply: u256) -> ERC20ConstructorArguments {
        ERC20ConstructorArguments {
            name: 0_felt252, symbol: 0_felt252, initial_supply: initial_supply, recipient: recipient
        }
    }
    fn to_calldata(self: ERC20ConstructorArguments) -> Array<felt252> {
        let mut calldata = array![];
        calldata.append_serde(self.name);
        calldata.append_serde(self.symbol);
        calldata.append_serde(self.initial_supply);
        calldata.append_serde(self.recipient);
        calldata
    }
}

fn deploy_crowd_fund() -> (ICrowdFundDispatcher, ContractAddress, IERC20Dispatcher) {
    let constructor_args = ERC20ConstructorArgumentsImpl::new(PLAYER_ONE(), 1000);
    let erc20_address = declare('ERC20').deploy(@constructor_args.to_calldata()).unwrap();
    let crowd_fund_contract = declare('CrowdFund');
    let mut calldata = array![];
    calldata.append_serde(erc20_address);
    let contract_address = crowd_fund_contract.deploy(@calldata).unwrap();
    let dispatcher = ICrowdFundDispatcher { contract_address };
    let erc20_dispacther = IERC20Dispatcher { contract_address: erc20_address };
    (dispatcher, contract_address, erc20_dispacther)
}

#[test]
fn test_erc20_deployer() {
    let constructor_args = ERC20ConstructorArgumentsImpl::new(PLAYER_ONE(), 1000);
    let erc20_address = declare('ERC20').deploy(@constructor_args.to_calldata()).unwrap();
    let erc20 = IERC20Dispatcher { contract_address: erc20_address };
    assert(erc20.balance_of(PLAYER_ONE()) == 1000, 'Initial balance should be equal');
}


#[test]
fn test_launch_state() {
    let (dispatcher, contract_address, erc20_dispacther) = deploy_crowd_fund();
    let mut testing_state = CrowdFund::contract_state_for_testing();
    ICrowdFund::launch(ref testing_state);
    assert(testing_state.count.read() == 1, 'it should be 1');
    let campaign: CrowdFund::Campaign = testing_state.campaigns.read(1);
    assert(campaign.creator == ZERO_OWNER(), 'should be zero account');
    assert(campaign.id == 1, 'it should be 1');
    assert(campaign.claimed == false, 'should be false');
    assert(campaign.pledged == 0, 'inital amount should be 0');
}

#[test]
fn test_launch_event() {
    let (dispatcher, contract_address, erc20_dispacther) = deploy_crowd_fund();
    start_prank(CheatTarget::One(contract_address), PLAYER_ONE());
    let mut spy = spy_events(SpyOn::One(contract_address));
    dispatcher.launch();
    spy.fetch_events();
    assert(spy.events.len() == 1, 'There should be one event');
    let (from, event) = spy.events.at(0);
    assert(from == @contract_address, 'Emitted from wrong address');
    assert(event.keys.len() == 1, 'There should be one key');
    assert(event.keys.at(0) == @event_name_hash('Launch'), 'Wrong event name');

    let current_low = *event.data.at(0);
    let current_low_u128: u128 = current_low.try_into().unwrap();
    let current_high = *event.data.at(1);
    let current_high_u128: u128 = current_high.try_into().unwrap();
    let id_here = u256 { low: current_low_u128, high: current_high_u128 };
    assert(id_here == 1, 'it should be one');
    assert(
        event.data.at(2) == @contract_address_to_felt252(PLAYER_ONE()), 'it should be player one'
    );
}

#[test]
fn test_pledge_event() {
    let (dispatcher, contract_address, erc20_dispacther) = deploy_crowd_fund();
    start_prank(CheatTarget::One(contract_address), PLAYER_ONE());
    let mut spy = spy_events(SpyOn::One(contract_address));
    dispatcher.launch();
    erc20_dispacther.balance_of(PLAYER_ONE()).print();
    erc20_dispacther.balance_of(contract_address).print();
// erc20_dispacther.transfer_from(PLAYER_ONE(), contract_address, 200);
// dispatcher.pledge(1, 200);
// assert(erc20_dispacther.balance_of(PLAYER_ONE())==800, 'it should be 800');
// assert(erc20_dispacther.balance_of(contract_address) == 200, 'it should be 200');

}
