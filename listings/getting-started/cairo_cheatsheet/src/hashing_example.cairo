mod hashing_example {

	//  import statements
	use core::pedersen::PedersenTrait;
	use core::poseidon::PoseidonTrait;
	use core::hash::{HashStateTrait, HashStateExTrait};

	//  define a custom struct that is hashable by deriving the hash trait
	#[derive(Drop, Hash)]
	struct myStructHashable {
			item: felt252,
			item2: felt252
	}

	// generate an HashState using Pedersen or Poseidon 
	// finalize the HashState into a felt252 type
	fn computePoseidonHash() -> felt252 {
		let myStruct = myStructHashable{item: 100, item2: 200};
		PoseidonTrait::new().update_with(myStruct).finalize()
	}

	fn computePedersenHash() -> felt252 {
		let myStruct = myStructHashable{item: 100, item2: 200};
		PedersenTrait::new(1).update_with(myStruct).finalize()
	}
}

//tests
#[cfg(test)]
mod hashing_example_tests{
  use super::hashing_example;

  #[test]
  fn poseidonHash_works() {
    let poseidonHash = hashing_example::computePoseidonHash();
    assert!(poseidonHash == 0x71313ace85d92835549cd49d149d2827862153cdcfd6401ce12f4fdb4825171, "poseidon hash does not match");
  }

  #[test]
  fn pedersenHash_works() {
    let pedersenHash = hashing_example::computePedersenHash();
    assert!(pedersenHash == 0x2a1b24cd959ce51e22ede915a5f57de1223da22aec2ccd67f61dc8f277341ce, "pedersen hash does not match");
  }

}