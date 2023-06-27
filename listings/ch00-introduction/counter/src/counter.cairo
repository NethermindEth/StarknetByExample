#[contract]
mod SimpleCounter {
    struct Storage {
        // Counter variable
        _counter: u256,
    }

    #[constructor]
    fn constructor() {}

    #[external]
    fn increment() {
        // Store counter value + 1
        let counter: u256 = _counter::read() + 1;
        _counter::write(counter);
    }

    #[external]
    fn decrement() {
        // Store counter value - 1
        let counter: u256 = _counter::read() - 1;
        _counter::write(counter);
    }
}
