fn do_loop() {
    // [!region sheet]
    let mut arr = array![];

    // Same as ~ while (i < 10) arr.append(i++);
    let mut i: u32 = 0;
    let limit = 10;
    loop {
        if i == limit {
            break;
        };

        arr.append(i);

        i += 1;
    };
    // [!endregion sheet]
}
