pragma circom 2.1.6;

include "../../node_modules/circomlib/circuits/poseidon.circom";
include "../../node_modules/circomlib/circuits/comparators.circom";



template AgeProof() {
    signal input doBTimestamp; // Timestamp of the DoB in seconds
    signal input address; // Address of the user
    signal input currentTimestamp; // Current time in seconds
    signal input ageThreshold; // Age threshold in seconds
    signal input hash; // Poseidon hash of the address and the DoB timestamp


    signal age;
    age <== currentTimestamp - doBTimestamp;

    // Check if the age is greater than the threshold
    component lte = LessThan(252);
    lte.in[0] <== age;
    lte.in[1] <== ageThreshold;
    lte.out === 0;

    // Check if the hash is valid
    component poseidon = Poseidon(2);
    poseidon.inputs[0] <== address;
    poseidon.inputs[1] <== doBTimestamp;
    hash === poseidon.out;

}


component main {public [address, currentTimestamp, ageThreshold, hash]} = AgeProof();


/* INPUT = {
  "doBTimestamp": "946684800",
  "address": "12345678901234567890",
  "currentTimestamp": "1732560000",
  "ageThreshold": "662256000",
  "hash": "13028774842431640048956742743352394716923213290985068139465342827044060846638"
} */