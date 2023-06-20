#[contract]
mod Callee {
    struct Storage {
        _x: u128, 
    }

    #[external]
    fn set_x(x: u128) -> u128 {
        _x::write(x);
        x
    }
}
