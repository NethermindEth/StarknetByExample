fn while_let() {
    // ANCHOR: sheet
    let mut option = Option::Some(0_usize);

    // "while `let` destructures `option` into `Some(i)`:
    // evaluate the block (`{}`), else `break`
    while let Option::Some(i) =
        option {
            if i > 0 {
                println!("Greater than 0, break...");
                option = Option::None;
            } else {
                println!("`i` is `{:?}`. Try again.", i);
                option = Option::Some(i + 1);
            }
        }
// ANCHOR_END: sheet
}
