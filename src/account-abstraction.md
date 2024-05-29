 Account Abstraction 
---

Account Abstraction is a win for usability in Web3. On Starknet, it has been supported from the beginning at the protocol level.

A smart contract must implement the interface defined by SNIP-6 to be considered an account contract. Additional methods might be required for advanced account functionality.

Account Abstraction (AA) replaces externally owned accounts (EOA) with smart wallets, which are implemented as smart contracts. Each smart wallet contract must implement the snip-6 interface. This allows for greater flexibility and customization compared to traditional EOAs.

### <b>enhancing transaction flexibility and security with account abstraction </b>

* Gas Fee Payment:    
In the traditional model, users need EOAs to pay gas fees for executing smart contracts. With AA, smart contracts can be designed to handle these fees. This means that the logic within the contract can manage the transaction fees, allowing for more flexible and user-friendly applications. 
    
* Validation Abstraction:
Single Validation Method on Ethereum: On Ethereum Layer 1, transactions are validated using the signature of an EOA. This method verifies that the transaction was authorized by the account holder.

* Multiple Validation Methods in AA: 
AA allows for different types of validations. For instance, instead of just EOA signatures, a contract could accept other cryptographic signatures (like those from multi-signature wallets, hardware wallets, or even different cryptographic algorithms). This flexibility enables diverse and potentially more secure ways to validate transactions.(https://github.com/starknet-io/SNIPs/blob/main/SNIPS/snip-6.md) 
    
### SNIP-6 : RC6 + SRC5

``` #![allow(unused)]
fn main() {
/// @title Represents a call to a target contract
/// @param to The target contract address
/// @param selector The target function selector
/// @param calldata The serialized function parameters
struct Call {
    to: ContractAddress,
    selector: felt252,
    calldata: Array<felt252>
}

/// @title SRC-6 Standard Account
trait ISRC6 {
    /// @notice Execute a transaction through the account
    /// @param calls The list of calls to execute
    /// @return The list of each call's serialized return value
    fn __execute__(calls: Array<Call>) -> Array<Span<felt252>>;

    /// @notice Assert whether the transaction is valid to be executed
    /// @param calls The list of calls to execute
    /// @return The string 'VALID' represented as felt when is valid
    fn __validate__(calls: Array<Call>) -> felt252;

    /// @notice Assert whether a given signature for a given hash is valid
    /// @param hash The hash of the data
    /// @param signature The signature to validate
    /// @return The string 'VALID' represented as felt when the signature is valid
    fn is_valid_signature(hash: felt252, signature: Array<felt252>) -> felt252;
}

/// @title SRC-5 Standard Interface Detection
trait ISRC5 {
    /// @notice Query if a contract implements an interface
    /// @param interface_id The interface identifier, as specified in SRC-5
    /// @return `true` if the contract implements `interface_id`, `false` otherwise
    fn supports_interface(interface_id: felt252) -> bool;}}
 ```
<p> Smart wallet contract must implement the ```SRC6``` and ```SRC5``` traits. </p>

 
### SNIP-6 Methods 

``` 
trait ISRC6 {
  fn __execute__(calls: Array<Call>) -> Array<Span<felt252>>;
  fn __validate__(calls: Array<Call>) -> felt252;
  fn is_valid_signature(hash: felt252, signature: Array<felt252>) -> felt252;
} 
```

```__execute__``` this method is a crucial part of the SNIP-6 interface for smart wallets. It performs the actual execution of a series of contract calls after the validation phase. It is called by the Starknet protocol during different stages of the lifecycle of a transaction. This doesn’t mean that only the Starknet protocol can use those methods, as a matter of fact, anyone can call those methods even if the contract account doesn’t belong to them. 


```__validate__``` like the ```__execute__```  they are also called by the Starknet protocol during different stages of the lifecycle of a transaction. This doesn’t mean that only the Starknet protocol can use those methods. The validation method is designed to ensure that a series of contract calls adhere to predefined rules before they are executed. This is a crucial step to maintain the integrity and security of the contract's operations.


```is__valid__signature``` It confirms the authenticity of a transaction's signature. It takes a transaction data hash and a signature, and compares it against a public key or another method chosen by the contract's author. The result is a short 'VALID' string within a felt252.
 
### Executing Transactions 

The ```__execute__``` function is responsible for executing the transaction. In this minimal account contract we will only execute a single call. 
```
fn __execute__(self: @ContractState, calls: Array<Call>) -> Array<Span<felt252>> {
            let Call{to, selector, calldata } = calls.at(0);
            let _res = starknet::call_contract_syscall(*to, *selector, calldata.span()).unwrap();
            let mut res = ArrayTrait::new();
            res.append(_res);
            res
        }
```

The ```__execute__``` function calls the call_contract_syscall function from the starknet module. This function executes the call and returns the result. The ```call_contract_syscall``` function is a Starknet syscall, which means that it is executed by the Starknet protocol. The Starknet protocol is responsible for executing the call and returning the result. The Starknet protocol will also validate the call, so we do not need to validate the call in the ```__execute__``` function.

```
fn is_valid_signature(
            self: @ContractState, hash: felt252, signature: Array<felt252>
        ) -> felt252 {
            // No signature is required so any signature is valid.
            VALIDATED
        }
```


```is__valid__signature``` function checks whether a provided signature matches the expected one for a specific data hash within a smart contract. 

This function takes three parameters: 
* A reference to the contract's state `(self: @ContractState)`, 
* The hash of the data that purportedly needs to be signed `(hash: felt252)`,  
* The actual signature represented as an array of felt252 values `(signature: Array<felt252)`. 

Instead of performing actual cryptographic signature validation, the function simplistically returns a constant `VALIDATED`, indicating that any signature provided is considered valid.

```
fn __validate__(self: @ContractState, calls: Array<Call>) -> felt252 {
            let hash = 0;
            let mut signature: Array<felt252> = ArrayTrait::new();
            signature.append(0);
            self.is_valid_signature(hash, signature)
        }
```

```__validate__``` function is designed to validate a list of contract calls in the context of a smart contract's state. The function takes two parameters: a reference to the contract's state ```(self: @ContractState)``` and an array of calls ```(calls: Array<Call>)```.

Inside the function, a hash is initialized to 0, and an empty array of felt252 values named signature is created using the ```ArrayTrait::new()``` method. 

A 0 value is then appended to the signature array. Finally, the function calls another method, ```self.is_valid_signature```, passing the hash and the signature array as arguments. 

The ```is_valid_signature``` method is expected to check the validity of the signature. In this simplified implementation, the signature array only contains a single value 0, and the hash is also 0, implying that the function treats this as a generic or default validation scenario. The result of the is_valid_signature method call, which returns a felt252 value indicating whether the validation was successful, is then returned by the ```__validate__``` function.




 
 
 
 
 
 
 
