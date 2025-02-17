fn while_let() {
    // [!region sheet]
    let mut option = Option::Some(0_usize);

    // "while `let` destructures `option` into `Some(i)`,
    // evaluate the block (`{}`), else `break`
    while let Option::Some(i) = option {
        if i > 0 {
            option = Option::None;
        } else {
            option = Option::Some(i + 1);
        }
    }
    // [!endregion sheet]
}
