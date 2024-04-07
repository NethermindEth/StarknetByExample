// ANCHOR: sheet
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
        println!("Matched {}", i);
    }

    // If you need to specify a failure, use an else:
    if let Option::Some(i) = letter {
        println!("Matched {}", i);
    } else {
        // Destructure failed. Change to the failure case.
        println!("Didn't match a number.");
    }

    // Using `if let` with enum
    let a = Foo::Bar;
    let b = Foo::Baz;
    let c = Foo::Qux(100);

    // Variable a matches Foo::Bar
    if let Foo::Bar = a {
        println!("a is foobar");
    }

    // Variable b does not match Foo::Bar
    // So this will print nothing
    if let Foo::Bar = b {
        println!("b is foobar");
    }

    // Variable c matches Foo::Qux which has a value
    // Similar to Some() in the previous example
    if let Foo::Qux(value) = c {
        println!("c is {}", value);
    }
}
// ANCHOR_END: sheet


