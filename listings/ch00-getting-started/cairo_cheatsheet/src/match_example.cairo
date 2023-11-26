#[starknet::interface]
trait IMatchExample<TContractState> {
    fn value_in_cents(self: @TContractState, coin: Coin) -> felt252;
    fn specified_colour(self: @TContractState, colour: Colour) -> felt252;
    fn quiz(self: @TContractState, num: felt252) -> felt252;
}


#[derive(Drop, Serde)]
enum Colour {
    Red,
    Blue,
    Green,
    Orange,
    Black
}

#[derive(Drop, Serde)]
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter,
}


#[starknet::contract]
mod MatchExample {
    use super::{Colour, Coin};
    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl External of super::IMatchExample<ContractState> {
        fn value_in_cents(self: @ContractState, coin: Coin) -> felt252 {
            match coin {
                Coin::Penny => 1,
                Coin::Nickel => 5,
                Coin::Dime => 10,
                Coin::Quarter => 25,
            }
        }

        fn specified_colour(self: @ContractState, colour: Colour) -> felt252 {
            let mut response: felt252 = '';

            match colour {
                Colour::Red => { response = 'You passed in Red'; },
                Colour::Blue => { response = 'You passed in Blue'; },
                Colour::Green => { response = 'You passed in Green'; },
                Colour::Orange => { response = 'You passed in Orange'; },
                Colour::Black => { response = 'You passed in Black'; },
            };

            response
        }

        fn quiz(self: @ContractState, num: felt252) -> felt252 {
            let mut response: felt252 = '';

            match num {
                0 => { response = 'You failed' },
                _ => { response = 'You Passed' },
            };

            response
        }
    }
}
