#[contract]
mod SimpleCounter {
    struct Storage {
        // Counter value
        _counter: u256,
    }

    #[event]
    // Increment event  -  emitted when the counter is incremented.
    fn Increment(counterVal: u256) {}

    #[constructor]
    fn constructor() {}

    #[external]
    fn increment() {
        let mut counter: u256 = _counter::read();
        counter += 1;
        _counter::write(counter);
        // Emit event
        Increment(counter);
    }
}
