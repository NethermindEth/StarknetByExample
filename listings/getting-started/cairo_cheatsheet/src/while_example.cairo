fn do_loop() {
    // ANCHOR: sheet
    let mut arr = array![];

    let mut i: u32 = 0;
    while (i < 10) {
        arr.append(i);
        i += 1;
    };
// ANCHOR_END: sheet
}
