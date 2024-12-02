pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

template PasswordCheck() {
  // Public inputs
  signal input userAddress;
  signal input pwdHash;
  // Private input
  signal input pwd;

  // (Public) output
  signal output uniqueToUser;

  // Make sure password is the correct one by comparing its hash to the expected known hash
  component hasher = Poseidon(1);
  hasher.inputs[0] <== pwd;

  hasher.out === pwdHash;

  // Compute a number unique to user so that other users can't simply copy and use same proof
  // but instead have to execute this circuit to generate a proof unique to them
  component uniqueHasher = Poseidon(2);
  uniqueHasher.inputs[0] <== pwdHash;
  uniqueHasher.inputs[1] <== userAddress;

  uniqueToUser <== uniqueHasher.out;
}

component main {public [userAddress, pwdHash]} = PasswordCheck();
