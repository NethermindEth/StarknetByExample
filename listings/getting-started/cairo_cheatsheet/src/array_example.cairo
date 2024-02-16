fn array() -> bool {
    let mut arr = array![];
    arr.append(10);
    arr.append(20);
    arr.append(30);

    assert(arr.len() == 3, 'array length should be 3');

    let first_value = arr.pop_front().unwrap();
    assert(first_value == 10, 'first value should match');

    let second_value = *arr.at(0);
    assert(second_value == 20, 'second value should match');

    // Returns true if an array is empty, then false if it isn't.
    arr.is_empty()
}
