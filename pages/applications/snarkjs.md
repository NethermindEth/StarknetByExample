# zk-SNARKS Implementation Example

**zk-SNARKs** (Zero-Knowledge Succinct Non-Interactive Arguments of Knowledge) are cryptographic proofs that allow one party (the prover) to prove to another party (the verifier) that they know a specific piece of information (ex: a solution to a computational problem) without revealing the information itself.

## Key Properties

-   **Zero-Knowledge (privacy)**: zk-SNARKs ensure that the inputs to a computation remain private while proving correctness. In other words, the proof does not disclose any information beyond the validity of the statement.
-   **Succinctness**: zk-SNARKs proofs size is small, regardless of the complexity of the statement, with the verification being computationally much cheaper than proof generation. It can be used to verify lots of computation in a much cheaper way than re-doing the computation, allowing for scalability for example.
-   **Non-Interactivity**: Once generated, the proofs require no further communication between the prover and verifier, reducing complexity in decentralized environments.
-  **Integrity**: Verifiers are guaranteed the correctness of the computation without having to re-execute it.

## Examples of Use Cases

- **Identity Verification**
Prove attributes like age, nationality, or membership without revealing the actual details. Instead of scanning the user's ID card or passport for example, online platforms could verify users' eligibility trustlessly without accessing nor storing sensitive data.

- **Scalable Rollups (Layer 2 Solutions)**
Zk proofs could be used to prove the validity and correct computation of multiple transactions execution into a single proof, eliminating the need to re-execute them to verify. zk-Rollups on Ethereum, like Starknet, leverage zk-STARKs to improve transaction throughput while reducing costs. This enables efficient and scalable off-chain computation with secure on-chain verification.

- **Proof of Reserves**
Prove you have above enough money, without disclosing actual account balances, to be eligible to apply to a certain service (loan, etc).

# Use Case Example: proof of secret (resistant to replay attacks)

This specific use case is about granting access to tokens after having proven you a know secret without actually revealing it. In this example, any user can mint free tokens if they submit a valid proof unique to them to a specific contract. The proof needs to have been generated by the user submitting it, copy-pasting a proof from another user will not work. (More about it later)


## Stack used: Circom, Groth16, Snarkjs, Garaga

-   **Circom**: A domain-specific language for defining arithmetic circuits, which are the foundation of zk-SNARKs. These circuits describe the computation to be proven in a zk-SNARK.

- **Groth16**: Groth16 is a famous pairing-based zk-SNARK system. In other words, it is a cryptographic protocol, or more precisely a proving scheme for zk-SNARKs. It defines the mathematical framework and the core logic for generating and verifying zk-SNARK proofs. Its principal function is to allow a prover to validate the accuracy of a statement to a verifier, without revealing any additional data. A distinct feature of Groth16 is its succinctness; the proofs generated are concise, occupying minimal storage and transmission space.

-   **Snarkjs**: A JavaScript library acting as an implementation layer of proving systems by providing tools and utilities for generating and verifying zk-SNARK proofs. It currently supports 3 proving systems: Groth16, PLONK, and FFLONK. It integrates with the circom compiler used for compiling circom circuits.

- **Garaga**: Garaga enables efficient elliptic curve operations on Starknet. Among them, one that was particularly useful for this use case, was the Groth16 smart contract verifiers generator. This functionality helps in generating verifier contracts allowing on-chain proof verification. Instead of verifying locally using snarkjs, Garaga allows the proof verification directly on-chain by anyone.

## How it works:

In this section, the example workflow is explained. As this repository consists of examples, each command is briefly explained to give a gist of it. If you wish to learn about those, please refer to the documentation of those technologies:
- [Circom](https://docs.circom.io/)
- [Snarkjs](https://github.com/iden3/snarkjs)
- [Garaga](https://garaga.gitbook.io/garaga)

1. Write a circuit using `Circom` that will correspond to the program you are proving. In the circuit, you can set constraints (aka assertions) that the program needs to respect. Otherwise, the proof generation will fail.

- 1.1. Circuit

```circom
// [!include ~/listings/advanced-concepts/verify_proofs/snarkjs/src/circuit/circuit.circom]
```

This circuit takes 3 inputs:
- user address (public)
- password hash (public)
- password in plain text (private)

The circuit computes the hash of the plain text password and compares the result to the publicly known hash of the password. This equality assertion is one of the constraints set by the circuit. The rest of the code is to generate a proof unique to the user to avoid replay attacks (more about it later).

- 1.2. Circuit inputs

```json
// [!include ~/listings/advanced-concepts/verify_proofs/snarkjs/src/circuit/input.json]
```
> In my example, the secret password is 2468. You should input the same user address with which you will submit your proof to the ZkERC20Token to mint free tokens.

2. Compile the circuit (in binary and web assembly formats)

```bash [Terminal]
mkdir target
circom src/circuit/circuit.circom  -l  node_modules  --r1cs  --wasm  --output  target
```

3.  Trusted setup -- phase 1 (independent of the circuit)

> The **trusted setup** is a phase in the zk-SNARK protocol where cryptographic parameters, known as a **proving key** and a **verification key**, are generated. These keys are essential for the prover to create proofs and for the verifier to validate them.

- 3.1. Start a new `powers of tau` ceremony
```bash [Terminal]
mkdir  target/ptau && cd  target/ptau
snarkjs  powersoftau  new  bn128  12  pot12_0000.ptau  -v
```

- 3.2. Contribute to phase 1 of ceremony

> A trusted setup ceremony is a collaborative process where multiple participants contribute randomness to create the cryptographic parameters for a zk-SNARK system (the proving and verification keys), with the goal to provide additional security. You can therefore provide additional contributions if you wish to do so.

```bash [Terminal]
snarkjs  powersoftau  contribute  pot12_0000.ptau  pot12.ptau  --name="My contribution to part 1"  -v  -e="some random text for the contribution to part 1"
```

4. Trusted setup -- phase 2 (circuit dependent)

- 4.1. Finalize ptau file

```bash [Terminal]
snarkjs  powersoftau  prepare  phase2  pot12.ptau  pot12_final.ptau  -v
```

- 4.2. Generate a zkey file

```bash [Terminal]
cd  ..
snarkjs  groth16  setup  circuit.r1cs  ptau/pot12_final.ptau  circuit_0000.zkey
```

- 4.3. Contribute to phase 2

```bash [Terminal]
snarkjs  zkey  contribute  circuit_0000.zkey  circuit_0001.zkey  --name="My contribution to part 2"  -v  -e="some random text for the contribution to part 2"
```
After 4.3., we have our proving key (`circuit_0001.zkey`) that we will use, along with the compiled circuit and the input to the circuit, to generate proofs.

- 4.4. Export verification key

```bash [Terminal]
snarkjs  zkey  export  verificationkey  circuit_0001.zkey  circuit_verification_key.json
```
After 4.4., we have our verification key (`circuit_verification_key.json`) that we will use, along with the generated proof and its outputs, to verify proofs.

5. Proof Generation

- 5.1. Generate witness

The **witness** refers to the private input and intermediate values that the prover knows and uses to generate the proof. The intermediate values correspond to the values computed during the circuit execution. These are also part of the witness and are necessary for proving the correctness of the computation. In short, the witness is a complete set of values that satisfies the constraints defined by the zk-SNARK circuit.

```bash [Terminal]
node  circuit_js/generate_witness.js  circuit_js/circuit.wasm  ../src/circuit/input.json  witness.wtns
```

- 5.2 Generate proof

```bash [Terminal]
snarkjs  groth16  prove  circuit_0001.zkey  witness.wtns  proof.json  public.json
```

> To generate a proof, 3 information are needed:
> - compiled circuit
> - circuit inputs
> - proving key

> To verify a proof, 3 information are also needed:
> - proof
> - circuit outputs (obtained when generating proof)
> - verification key


- 6. Generate verifier contract

```bash [Terminal]
garaga  gen  --system  groth16  --vk  circuit_verification_key.json
```

This above command will generate a cairo project with the verifier contract, with the main endpoint `verify_groth16_proof_[curve_name]`.

> Garaga also provides some command utilities to deploy it on-chain. Else, you can deploy it like any other contract (using starkli or sncast for example).

Here is the generated starknet contract:

```cairo
// [!include ~/listings/advanced-concepts/verify_proofs/snarkjs/src/verifier/groth16_verifier.cairo]
```

7. Generate calldata & call on-chain verifier contract

This step is useful for generating calldata from the proof & circuit execution outputs, which can then be sent to the verifier contract to verify the proof on-chain. In this example, there is an intermediary contract, ZkERC20Token, which will itself call the verifier contract (more about it below).

```bash [Terminal]
garaga  calldata  --system  groth16  --vk  circuit_verification_key.json  --proof  proof.json  --public-inputs  public.json  --format  starkli  |  xargs  starkli  invoke  --account  ~/.starkli-wallets/deployer/account.json  --keystore  ~/.starkli-wallets/deployer/keystore.json  --network  sepolia  --watch  0x00375cf5081763e1f2a7ed5e28d4253c6135243385f432492dda00861ec5e58f  mint_with_proof
```

> Garaga also provides some command utilities to call the verifier contract directly abstracting the calldata generation part, simplifying the above command.

8. ZkERC20Token contract

This contract allows anyone to mint free tokens if they know a secret password (2468). You can submit your proof calldata to this contract, which will itself call the generated verifier contract. If the proof verification passes and the proof is indeed unique to you (ie, you generated it yourself), you can receive the free tokens. Otherwise, the endpoint execution will revert. You can mint free tokens only once per user.

Here is the address of this contract (on Sepolia testnet) : 0x00375cf5081763e1f2a7ed5e28d4253c6135243385f432492dda00861ec5e58f

Here is the code of this ZkERC20Token contract :

```cairo
// [!include ~/listings/advanced-concepts/verify_proofs/snarkjs/src/contract.cairo]
```
