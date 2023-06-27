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
        let mut counter = _counter::read();
        // Increment counter
        counter += 1;
        // Write counter
        _counter::write(counter);
        // Emit event
        Increment(counter);
    }
}
