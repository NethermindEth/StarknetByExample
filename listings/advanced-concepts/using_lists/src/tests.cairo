use using_lists::contract::IListExample;
use core::array::ArrayTrait;
use using_lists::contract::{Task, ListExample};
use using_lists::contract::ListExample::{
    amountContractMemberStateTrait, tasksContractMemberStateTrait
};

fn STATE() -> ListExample::ContractState {
    ListExample::contract_state_for_testing()
}

#[test]
#[available_gas(2000000)]
fn test_add_in_amount() {
    let mut state = STATE();
    state.add_in_amount(200);
    assert(state.amount.read()[0] == 200, 'should be 200');
}

#[test]
#[available_gas(2000000)]
fn test_add_in_task() {
    let mut state = STATE();
    state.add_in_task('test_description', 'test_status');
    let current_task: Task = state.tasks.read()[0];
    assert(current_task.description == 'test_description', 'should be test_description');
    assert(current_task.status == 'test_status', 'should be test_status');
}

#[test]
#[available_gas(2000000)]
fn test_is_empty_list() {
    let mut state = STATE();

    let pre_addition = state.is_empty_list();
    assert(pre_addition == true, 'should be true');

    state.add_in_amount(200);
    let post_addition = state.is_empty_list();
    assert(post_addition == false, 'should be false');
}

#[test]
#[available_gas(2000000)]
fn test_list_length() {
    let mut state = STATE();

    let pre_addition = state.list_length();
    assert(pre_addition == 0, 'should be zero');

    state.add_in_amount(200);
    let post_addition = state.list_length();
    assert(post_addition == 1, 'should be 1');
}

#[test]
#[available_gas(2000000)]
fn test_get_from_index() {
    let mut state = STATE();
    state.add_in_amount(200);
    let output = state.get_from_index(0);
    assert(output == 200, 'should be 200');
}

#[test]
#[available_gas(2000000)]
fn test_set_from_index() {
    let mut state = STATE();
    state.add_in_amount(200);
    state.set_from_index(0, 400);
    assert(state.amount.read()[0] == 400, 'should be 400');
}

#[test]
#[available_gas(2000000)]
fn test_pop_front_list() {
    let mut state = STATE();

    state.add_in_amount(200);
    let pre_pop_front = state.list_length();
    assert(pre_pop_front == 1, 'should be 1');

    state.pop_front_list();
    let post_pop_front = state.list_length();
    assert(post_pop_front == 0, 'should be zero');
}

#[test]
#[available_gas(2000000)]
fn test_array_conversion() {
    let mut ideal_array = ArrayTrait::<u128>::new();
    ideal_array.append(200);
    ideal_array.append(400);

    let mut state = STATE();

    state.add_in_amount(200);
    state.add_in_amount(400);
    let output: Array<u128> = state.array_conversion();

    assert(output == ideal_array, 'should be equal');
}
