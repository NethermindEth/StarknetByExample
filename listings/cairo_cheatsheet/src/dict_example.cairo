// [!region sheet]
use core::dict::Felt252Dict;

fn dict() {
    let mut Auctions: Felt252Dict<u64> = Default::default();

    Auctions.insert('Bola', 30);
    Auctions.insert('Maria', 40);

    let bola_balance = Auctions.get('Bola');
    assert!(bola_balance == 30, "Bola balance should be 30");

    let maria_balance = Auctions.get('Maria');
    assert!(maria_balance == 40, "Maria balance should be 40");
}
// [!endregion sheet]


