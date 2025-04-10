# Verify ZK Proofs on Starknet

This example shows how to verify SNARK proofs on Starknet using a practical example of a token minting system that requires proof of knowledge of a secret.

## ZK-SNARKs

**zk-SNARKs** (Zero-Knowledge Succinct Non-Interactive Arguments of Knowledge) are cryptographic proofs that enable one party (the *prover*) to demonstrate knowledge of specific information to another party (the *verifier*) without revealing the information itself.

- **Zero-Knowledge (Privacy)**: Ensures computation inputs remain private while proving correctness. The proof only reveals the statement's validity, not the underlying data.
- **Succinctness**: Proofs remain small regardless of statement complexity, with verification being computationally cheaper than proof generation. This enables efficient verification of large computations.
- **Non-Interactivity**: Proofs require no further communication between prover and verifier after generation, ideal for decentralized environments.
- **Integrity**: Guarantees computation correctness without requiring re-execution.

### Common Use Cases

- **Identity Verification**: Prove attributes (age, nationality, membership) without revealing actual details. Enables trustless verification without storing sensitive data.
- **Scalable Rollups**: Bundle multiple transaction proofs into a single proof, eliminating the need for re-execution.
- **Proof of Reserves**: Demonstrate sufficient funds for service eligibility without disclosing actual balances.

## Example: Proof of Secret with Replay Attack Protection

This example shows how to implement a token minting system where users can mint tokens by proving knowledge of a secret password without revealing it. The system includes protection against replay attacks, ensuring each proof is unique to its generator.

We will use the following:
- **Circom**: Domain-specific language for defining arithmetic circuits, the foundation of zk-SNARKs.
- **Groth16**: A pairing-based zk-SNARK system that provides the mathematical framework for proof generation and verification.
- **Snarkjs**: JavaScript library for generating and verifying zk-SNARK proofs.
- **Garaga**: Enables efficient elliptic curve operations on Starknet, including Groth16 smart contract verifier generation.

### 1. Circuit Definition

Create a circuit that:
- Takes 3 inputs:
  - User address (public)
  - Password hash (public)
  - Password in plain text (private)
- Computes the hash of the plain text password
- Compares it with the public hash
- Generates a user-specific proof to prevent replay attacks

```solidity
// [!include ~/listings/advanced-concepts/verify_proofs/src/circuit/circuit.circom]
```

### 2. Circuit Compilation

The circuit computes the hash of the plain text password and compares the result to the publicly known hash of the password. This equality assertion is one of the constraints set by the circuit. The rest of the code is to generate a proof unique to the user to avoid replay attacks (more about it later).

```bash [Terminal]
mkdir target
circom src/circuit/circuit.circom -l node_modules --r1cs --wasm --output target
```

### 3. Trusted Setup

The **trusted setup** is a phase in the zk-SNARK protocol where cryptographic parameters, known as a *proving key* and a *verification key*, are generated. These keys are essential for the prover to create proofs and for the verifier to validate them.

#### Phase 1: "Powers of Tau" Ceremony

:::info
A trusted setup ceremony is a collaborative process where multiple participants contribute randomness to create the cryptographic parameters for a proof system (the proving and verification keys), with the goal to provide additional security. You can provide additional contributions if you wish to do so.
:::

- Initialize powers of tau ceremony:

```bash [Terminal]
mkdir target/ptau && cd target/ptau
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
```

```bash [Terminal]
snarkjs powersoftau contribute pot12_0000.ptau pot12.ptau --name="My contribution to part 1" -v -e="some random text for the contribution to part 1"
```

#### Phase 2: Circuit Dependent

- Finalize ptau file:

```bash [Terminal]
snarkjs powersoftau prepare phase2 pot12.ptau pot12_final.ptau -v
```

- Generate a zkey file:

```bash [Terminal]
cd ..
snarkjs groth16 setup circuit.r1cs ptau/pot12_final.ptau circuit_0000.zkey
```

- Contribute to Phase 2:

```bash [Terminal]
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="My contribution to part 2" -v -e="some random text for the contribution to part 2"
```

We now have our proving key (`circuit_0001.zkey{:md}`) that we will use, along with the compiled circuit and the input to the circuit, to generate proofs.

- Export verification key:

```bash [Terminal]
snarkjs zkey export verificationkey circuit_0001.zkey circuit_verification_key.json
```

We have our verification key (`circuit_verification_key.json{:md}`) that we will use, along with the generated proof and its outputs, to verify proofs.

### 4. Proof Generation

#### Generate witness

The **witness** refers to the private input and intermediate values that the prover knows and uses to generate the proof. The intermediate values correspond to the values computed during the circuit execution. These are also part of the witness and are necessary for proving the correctness of the computation. In short, the witness is a complete set of values that satisfies the constraints defined by the zk-SNARK circuit.

```bash [Terminal]
node circuit_js/generate_witness.js circuit_js/circuit.wasm ../src/circuit/input.json witness.wtns
```

#### Generate proof

```bash [Terminal]
snarkjs groth16 prove circuit_0001.zkey witness.wtns proof.json public.json
```

:::note
To generate a proof, 3 information are needed:
- compiled circuit
- circuit inputs
- proving key

To verify a proof, 3 information are also needed:
- proof
- circuit outputs (obtained when generating proof)
- verification key
:::

### 5. Generate verifier contract

```bash [Terminal]
garaga gen --system groth16 --vk circuit_verification_key.json
```

This above command will generate a cairo project with the verifier contract, with the main endpoint `verify_groth16_proof_[curve_name]{:md}`.

:::info
Garaga also provides some command utilities to deploy it on-chain. Else, you can deploy it like any other contract (using starkli or sncast for example).
:::

Here is the generated starknet contract:

```cairo
// [!include ~/listings/advanced-concepts/verify_proofs/src/verifier/groth16_verifier.cairo]
```

### 6. Generate calldata & call on-chain verifier contract

This step is useful for generating calldata from the proof & circuit execution outputs, which can then be sent to the verifier contract to verify the proof on-chain. In this example, there is an intermediary contract, `ZkERC20Token`, which will itself call the verifier contract (more about it below).

```bash [Terminal]
garaga calldata --system groth16 --vk circuit_verification_key.json --proof proof.json --public-inputs public.json --format starkli | xargs starkli invoke --account ~/.starkli-wallets/deployer/account.json --keystore ~/.starkli-wallets/deployer/keystore.json --network sepolia --watch 0x00375cf5081763e1f2a7ed5e28d4253c6135243385f432492dda00861ec5e58f mint_with_proof
```

:::info
Garaga also provides some command utilities to call the verifier contract directly abstracting the calldata generation part, simplifying the above command.
:::

### 7. `ZkERC20Token` contract

This contract allows anyone to mint free tokens if they know a secret password (`2468`). You can submit your proof calldata to this contract, which will itself call the generated verifier contract. If the proof verification passes and the proof is indeed unique to you (ie, you generated it yourself), you can receive the free tokens. Otherwise, the endpoint execution will revert. You can mint free tokens only once per user.

Contract Address (Sepolia testnet): `0x00375cf5081763e1f2a7ed5e28d4253c6135243385f432492dda00861ec5e58f{:md}`

```cairo
// [!include ~/listings/advanced-concepts/verify_proofs/src/contract.cairo]
```

:::info
For more detailed information about the technologies used, refer to:
- [Circom Documentation](https://docs.circom.io/)
- [Snarkjs GitHub](https://github.com/iden3/snarkjs)
- [Garaga Documentation](https://garaga.gitbook.io/garaga)
:::

