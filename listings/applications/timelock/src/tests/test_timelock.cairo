use core::panic_with_felt252;
use starknet::get_block_timestamp;
use core::poseidon::{PoseidonTrait, poseidon_hash_span};
use core::hash::{HashStateTrait, HashStateExTrait};
use snforge_std::{
    cheat_caller_address, cheat_block_timestamp, CheatSpan, spy_events, SpyOn, EventSpy,
    EventAssertions
};
use openzeppelin::access::ownable::OwnableComponent;
use openzeppelin::token::erc721::interface::IERC721DispatcherTrait;
use openzeppelin::token::erc721::erc721::ERC721Component;
use timelock::timelock::{TimeLock, ITimeLockDispatcherTrait, ITimeLockSafeDispatcherTrait};
use timelock::tests::utils::{TimeLockTestTrait, TOKEN_ID, OTHER};

#[test]
fn test_get_tx_id_success() {
    let timelock_test = TimeLockTestTrait::setup();
    let (target, selector, calldata, timestamp) = timelock_test.get_tx();
    let tx_id = timelock_test.timelock.get_tx_id(target, selector, calldata, timestamp);
    let hash = PoseidonTrait::new()
        .update(target.into())
        .update(selector.into())
        .update(poseidon_hash_span(calldata))
        .update(timestamp.into())
        .finalize();
    assert_eq!(tx_id, hash);
}

#[test]
fn test_queue_only_owner() {
    let timelock_test = TimeLockTestTrait::setup();
    let (target, selector, calldata, timestamp) = timelock_test.get_tx();
    cheat_caller_address(timelock_test.timelock_address, OTHER(), CheatSpan::TargetCalls(1));
    match timelock_test.timelock_safe.queue(target, selector, calldata, timestamp) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), OwnableComponent::Errors::NOT_OWNER);
        }
    }
}

#[test]
fn test_queue_already_queued() {
    let timelock_test = TimeLockTestTrait::setup();
    let (target, selector, calldata, timestamp) = timelock_test.get_tx();
    timelock_test.timelock.queue(target, selector, calldata, timestamp);
    match timelock_test.timelock_safe.queue(target, selector, calldata, timestamp) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), TimeLock::Errors::ALREADY_QUEUED);
        }
    }
}

#[test]
fn test_queue_timestamp_not_in_range() {
    let timelock_test = TimeLockTestTrait::setup();
    let (target, selector, calldata, timestamp) = timelock_test.get_tx();
    match timelock_test.timelock_safe.queue(target, selector, calldata, 0) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), TimeLock::Errors::TIMESTAMP_NOT_IN_RANGE);
        }
    }
    match timelock_test
        .timelock_safe
        .queue(target, selector, calldata, timestamp + TimeLock::MAX_DELAY) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), TimeLock::Errors::TIMESTAMP_NOT_IN_RANGE);
        }
    }
}

#[test]
fn test_queue_success() {
    let timelock_test = TimeLockTestTrait::setup();
    let (target, selector, calldata, timestamp) = timelock_test.get_tx();
    let mut spy = spy_events(SpyOn::One(timelock_test.timelock_address));
    let tx_id = timelock_test.timelock.queue(target, selector, calldata, timestamp);
    spy
        .assert_emitted(
            @array![
                (
                    timelock_test.timelock_address,
                    TimeLock::Event::Queue(
                        TimeLock::Queue { tx_id, target, selector, calldata, timestamp }
                    )
                )
            ]
        );
    assert_eq!(tx_id, timelock_test.timelock.get_tx_id(target, selector, calldata, timestamp));
}

#[test]
fn test_execute_only_owner() {
    let timelock_test = TimeLockTestTrait::setup();
    let (target, selector, calldata, timestamp) = timelock_test.get_tx();
    cheat_caller_address(timelock_test.timelock_address, OTHER(), CheatSpan::TargetCalls(1));
    match timelock_test.timelock_safe.execute(target, selector, calldata, timestamp) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), OwnableComponent::Errors::NOT_OWNER);
        }
    }
}

#[test]
fn test_execute_not_queued() {
    let timelock_test = TimeLockTestTrait::setup();
    let (target, selector, calldata, timestamp) = timelock_test.get_tx();
    match timelock_test.timelock_safe.execute(target, selector, calldata, timestamp) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => { assert_eq!(*panic_data.at(0), TimeLock::Errors::NOT_QUEUED); }
    }
}

#[test]
fn test_execute_timestamp_not_passed() {
    let timelock_test = TimeLockTestTrait::setup();
    let (target, selector, calldata, timestamp) = timelock_test.get_tx();
    timelock_test.timelock.queue(target, selector, calldata, timestamp);
    match timelock_test.timelock_safe.execute(target, selector, calldata, timestamp) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), TimeLock::Errors::TIMESTAMP_NOT_PASSED);
        }
    }
}

#[test]
fn test_execute_timestamp_expired() {
    let timelock_test = TimeLockTestTrait::setup();
    let (target, selector, calldata, timestamp) = timelock_test.get_tx();
    timelock_test.timelock.queue(target, selector, calldata, timestamp);
    cheat_block_timestamp(
        timelock_test.timelock_address,
        timestamp + TimeLock::GRACE_PERIOD + 1,
        CheatSpan::TargetCalls(1)
    );
    match timelock_test.timelock_safe.execute(target, selector, calldata, timestamp) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), TimeLock::Errors::TIMESTAMP_EXPIRED);
        }
    }
}

#[test]
fn test_execute_success() {
    let timelock_test = TimeLockTestTrait::setup();
    let (target, selector, calldata, timestamp) = timelock_test.get_tx();
    let tx_id = timelock_test.timelock.get_tx_id(target, selector, calldata, timestamp);
    timelock_test.timelock.queue(target, selector, calldata, timestamp);
    timelock_test.erc721.approve(timelock_test.timelock_address, TOKEN_ID);
    cheat_block_timestamp(timelock_test.timelock_address, timestamp + 1, CheatSpan::TargetCalls(1));
    let mut spy = spy_events(SpyOn::One(timelock_test.timelock_address));
    timelock_test.timelock.execute(target, selector, calldata, timestamp);
    spy
        .assert_emitted(
            @array![
                (
                    timelock_test.timelock_address,
                    TimeLock::Event::Execute(
                        TimeLock::Execute { tx_id, target, selector, calldata, timestamp }
                    )
                )
            ]
        );
}

#[test]
fn test_execute_failed() {
    let timelock_test = TimeLockTestTrait::setup();
    let (target, selector, calldata, timestamp) = timelock_test.get_tx();
    timelock_test.timelock.queue(target, selector, calldata, timestamp);
    cheat_block_timestamp(timelock_test.timelock_address, timestamp + 1, CheatSpan::TargetCalls(1));
    match timelock_test.timelock_safe.execute(target, selector, calldata, timestamp) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), ERC721Component::Errors::UNAUTHORIZED);
        }
    }
}

#[test]
fn test_cancel_only_owner() {
    let timelock_test = TimeLockTestTrait::setup();
    let (target, selector, calldata, timestamp) = timelock_test.get_tx();
    let tx_id = timelock_test.timelock.get_tx_id(target, selector, calldata, timestamp);
    cheat_caller_address(timelock_test.timelock_address, OTHER(), CheatSpan::TargetCalls(1));
    match timelock_test.timelock_safe.cancel(tx_id) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => {
            assert_eq!(*panic_data.at(0), OwnableComponent::Errors::NOT_OWNER);
        }
    }
}

#[test]
fn test_cancel_not_queued() {
    let timelock_test = TimeLockTestTrait::setup();
    let (target, selector, calldata, timestamp) = timelock_test.get_tx();
    let tx_id = timelock_test.timelock.get_tx_id(target, selector, calldata, timestamp);
    match timelock_test.timelock_safe.cancel(tx_id) {
        Result::Ok(_) => panic_with_felt252('FAIL'),
        Result::Err(panic_data) => { assert_eq!(*panic_data.at(0), TimeLock::Errors::NOT_QUEUED); }
    }
}

#[test]
fn test_cancel_success() {
    let timelock_test = TimeLockTestTrait::setup();
    let (target, selector, calldata, timestamp) = timelock_test.get_tx();
    let tx_id = timelock_test.timelock.queue(target, selector, calldata, timestamp);
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
