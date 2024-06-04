use core::panic_with_felt252;
use starknet::get_block_timestamp;
use starknet::account::Call;
use core::poseidon::{PoseidonTrait, poseidon_hash_span};
use core::hash::{HashStateTrait, HashStateExTrait};
use snforge_std::{
    cheat_caller_address, cheat_block_timestamp, CheatSpan, spy_events, SpyOn, EventSpy,
    EventAssertions
};
use openzeppelin::token::erc721::interface::IERC721DispatcherTrait;
use openzeppelin::token::erc721::erc721::ERC721Component;
use components::ownable;
use timelock::timelock::{TimeLock, ITimeLockDispatcherTrait, ITimeLockSafeDispatcherTrait};
use timelock::tests::utils::{TimeLockTestTrait, TOKEN_ID, OTHER};

#[test]
fn test_get_tx_id_success() {
    let timelock_test = TimeLockTestTrait::setup();
    let timestamp = timelock_test.get_timestamp();
    let tx_id = timelock_test.timelock.get_tx_id(timelock_test.get_call(), timestamp);
    let Call { to, selector, calldata } = timelock_test.get_call();
    let hash = PoseidonTrait::new()
        .update(to.into())
        .update(selector.into())
        .update(poseidon_hash_span(calldata))
        .update(timestamp.into())
        .finalize();
    assert_eq!(tx_id, hash);
}

#[test]
fn test_queue_only_owner() {
    let timelock_test = TimeLockTestTrait::setup();
    cheat_caller_address(timelock_test.timelock_address, OTHER(), CheatSpan::TargetCalls(1));
    match timelock_test
        .timelock_safe
        .queue(timelock_test.get_call(), timelock_test.get_timestamp()) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => { assert_eq!(*panic_data.at(0), ownable::Errors::UNAUTHORIZED); }
    }
}

#[test]
fn test_queue_already_queued() {
    let timelock_test = TimeLockTestTrait::setup();
    let timestamp = timelock_test.get_timestamp();
    timelock_test.timelock.queue(timelock_test.get_call(), timestamp);
    match timelock_test.timelock_safe.queue(timelock_test.get_call(), timestamp) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), TimeLock::Errors::ALREADY_QUEUED);
        }
    }
}

#[test]
fn test_queue_timestamp_not_in_range() {
    let timelock_test = TimeLockTestTrait::setup();
    match timelock_test.timelock_safe.queue(timelock_test.get_call(), 0) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), TimeLock::Errors::TIMESTAMP_NOT_IN_RANGE);
        }
    }
    match timelock_test
        .timelock_safe
        .queue(timelock_test.get_call(), timelock_test.get_timestamp() + TimeLock::MAX_DELAY) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), TimeLock::Errors::TIMESTAMP_NOT_IN_RANGE);
        }
    }
}

#[test]
fn test_queue_success() {
    let timelock_test = TimeLockTestTrait::setup();
    let mut spy = spy_events(SpyOn::One(timelock_test.timelock_address));
    let timestamp = timelock_test.get_timestamp();
    let tx_id = timelock_test.timelock.queue(timelock_test.get_call(), timestamp);
    spy
        .assert_emitted(
            @array![
                (
                    timelock_test.timelock_address,
                    TimeLock::Event::Queue(
                        TimeLock::Queue { tx_id, call: timelock_test.get_call(), timestamp }
                    )
                )
            ]
        );
    assert_eq!(tx_id, timelock_test.timelock.get_tx_id(timelock_test.get_call(), timestamp));
}

#[test]
fn test_execute_only_owner() {
    let timelock_test = TimeLockTestTrait::setup();
    cheat_caller_address(timelock_test.timelock_address, OTHER(), CheatSpan::TargetCalls(1));
    match timelock_test
        .timelock_safe
        .execute(timelock_test.get_call(), timelock_test.get_timestamp()) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => { assert_eq!(*panic_data.at(0), ownable::Errors::UNAUTHORIZED); }
    }
}

#[test]
fn test_execute_not_queued() {
    let timelock_test = TimeLockTestTrait::setup();
    match timelock_test
        .timelock_safe
        .execute(timelock_test.get_call(), timelock_test.get_timestamp()) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => { assert_eq!(*panic_data.at(0), TimeLock::Errors::NOT_QUEUED); }
    }
}

#[test]
fn test_execute_timestamp_not_passed() {
    let timelock_test = TimeLockTestTrait::setup();
    let timestamp = timelock_test.get_timestamp();
    timelock_test.timelock.queue(timelock_test.get_call(), timestamp);
    match timelock_test.timelock_safe.execute(timelock_test.get_call(), timestamp) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), TimeLock::Errors::TIMESTAMP_NOT_PASSED);
        }
    }
}

#[test]
fn test_execute_timestamp_expired() {
    let timelock_test = TimeLockTestTrait::setup();
    let timestamp = timelock_test.get_timestamp();
    timelock_test.timelock.queue(timelock_test.get_call(), timestamp);
    cheat_block_timestamp(
        timelock_test.timelock_address,
        timestamp + TimeLock::GRACE_PERIOD + 1,
        CheatSpan::TargetCalls(1)
    );
    match timelock_test.timelock_safe.execute(timelock_test.get_call(), timestamp) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), TimeLock::Errors::TIMESTAMP_EXPIRED);
        }
    }
}

#[test]
fn test_execute_success() {
    let timelock_test = TimeLockTestTrait::setup();
    let timestamp = timelock_test.get_timestamp();
    let tx_id = timelock_test.timelock.get_tx_id(timelock_test.get_call(), timestamp);
    timelock_test.timelock.queue(timelock_test.get_call(), timestamp);
    timelock_test.erc721.approve(timelock_test.timelock_address, TOKEN_ID);
    cheat_block_timestamp(timelock_test.timelock_address, timestamp + 1, CheatSpan::TargetCalls(1));
    let mut spy = spy_events(SpyOn::One(timelock_test.timelock_address));
    timelock_test.timelock.execute(timelock_test.get_call(), timestamp);
    spy
        .assert_emitted(
            @array![
                (
                    timelock_test.timelock_address,
                    TimeLock::Event::Execute(
                        TimeLock::Execute { tx_id, call: timelock_test.get_call(), timestamp }
                    )
                )
            ]
        );
}

#[test]
fn test_execute_failed() {
    let timelock_test = TimeLockTestTrait::setup();
    let timestamp = timelock_test.get_timestamp();
    timelock_test.timelock.queue(timelock_test.get_call(), timestamp);
    cheat_block_timestamp(timelock_test.timelock_address, timestamp + 1, CheatSpan::TargetCalls(1));
    match timelock_test.timelock_safe.execute(timelock_test.get_call(), timestamp) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), ERC721Component::Errors::UNAUTHORIZED);
        }
    }
}

#[test]
fn test_cancel_only_owner() {
    let timelock_test = TimeLockTestTrait::setup();
    let tx_id = timelock_test
        .timelock
        .get_tx_id(timelock_test.get_call(), timelock_test.get_timestamp());
    cheat_caller_address(timelock_test.timelock_address, OTHER(), CheatSpan::TargetCalls(1));
    match timelock_test.timelock_safe.cancel(tx_id) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => { assert_eq!(*panic_data.at(0), ownable::Errors::UNAUTHORIZED); }
    }
}

#[test]
fn test_cancel_not_queued() {
    let timelock_test = TimeLockTestTrait::setup();
    let tx_id = timelock_test
        .timelock
        .get_tx_id(timelock_test.get_call(), timelock_test.get_timestamp());
    match timelock_test.timelock_safe.cancel(tx_id) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => { assert_eq!(*panic_data.at(0), TimeLock::Errors::NOT_QUEUED); }
    }
}

#[test]
fn test_cancel_success() {
    let timelock_test = TimeLockTestTrait::setup();
    let tx_id = timelock_test
        .timelock
        .queue(timelock_test.get_call(), timelock_test.get_timestamp());
    let mut spy = spy_events(SpyOn::One(timelock_test.timelock_address));
    timelock_test.timelock.cancel(tx_id);
    spy
        .assert_emitted(
            @array![
                (
                    timelock_test.timelock_address,
                    TimeLock::Event::Cancel(TimeLock::Cancel { tx_id })
                )
            ]
        );
}
