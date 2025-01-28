// [!region sheet]
#[derive(Drop)]
enum Foo {
    Bar,
    Baz,
    Qux: usize,
}

fn if_let() {
    let number = Option::Some(0_usize);
    let letter: Option<usize> = Option::None;

    // "if `let` destructures `number` into `Some(i)`:
    // evaluate the block (`{}`).
    if let Option::Some(i) = number {
        format!("Matched {}", i);
    }

    // If you need to specify a failure, use an else:
    if let Option::Some(i) = letter {
        format!("Matched {}", i);
    } else {
        // Destructure failed. Change to the failure case.
        format!("Didn't match a number.");
    }

    // Using `if let` with enum
    let a = Foo::Bar;
    let b = Foo::Baz;
    let c = Foo::Qux(100);

    // Variable a matches Foo::Bar
    if let Foo::Bar = a {
        format!("a is foobar");
    }

    // Variable b does not match Foo::Bar
    // So this will print nothing
    if let Foo::Bar = b {
        format!("b is foobar");
    }

    // Variable c matches Foo::Qux which has a value
    // Similar to Some() in the previous example
    if let Foo::Qux(value) = c {
        format!("c is {}", value);
    }
}
// [!endregion sheet]


