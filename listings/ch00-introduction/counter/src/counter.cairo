#[contract]
mod SimpleCounter {
    struct Storage {
        // Counter variable
        _counter: u256,
    }

    #[constructor]
    fn constructor() {}

    #[view]
    fn get_current_count() -> u256 {
        return _counter::read();
    }

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
