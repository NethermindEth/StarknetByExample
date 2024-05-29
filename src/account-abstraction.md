<h1>
    Account Abstraction 
</h1>


Account Abstraction is a win for usability in web3 and on Starknet it has been supported from the beginning at the protocol level. For a smart contract to be considered an account contract it must at least implement the interface defined by SNIP-6. Additional methods might be required for advanced account functionality



Account Abstraction (AA) replaces Externally Owned Accounts (EOA) with smart wallets, which are implemented as smart contracts. Each smart wallet contract must implement the SNIP-6 interface. This transformation allows for greater flexibility and customization compared to traditional EOAs.


<b><h3> Enhancing Transaction Flexibility and Security with Account Abstraction </h3></b>

Smart Contracts Paying for Transactions:    
In the traditional model, users need EOAs to pay gas fees for executing smart contracts. With AA, smart contracts can be designed to handle these fees. This means that the logic within the contract can manage the transaction fees, allowing for more flexible and user-friendly applications. 
    
<br>Validation Abstraction:
	Single Validation Method on Ethereum: On Ethereum Layer 1, transactions are validated using a single method, typically involving the signature of an EOA. This method verifies that the transaction was authorized by the account holder.

Multiple Validation Methods in AA: 
    AA allows for different types of validations. For instance, instead of just EOA signatures, a contract could accept other cryptographic signatures (like those from multi-signature wallets, hardware wallets, or even different cryptographic algorithms). This flexibility enables diverse and potentially more secure ways to validate transactions. 
    
<h3>SNIP-6</h3>

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
<p> The SNIP-6 interface standardizes account contract should be able to implement ```__execute__```, ```__validate___```,and ```is_valid_signature```</p>
 
<h3>SNIP-6 Methods and Simple Implementations</h3>

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


<h3> SNIP-6 STANDARD </h3>

In defining an account contract,implement the ISRC6 trait:

``` 
trait ISRC6<TState> {
    fn __execute__(ref self: @TState, calls: Array<Call>) -> Array<Span<felt252>>;
    fn __validate__(self: @TState, calls: Array<Call>) -> felt252;
    fn is_valid_signature(self: @TState, hash: felt252, signature: Array<felt252>) -> felt252;} 
```
    

The ```__execute__``` and ```__validate__``` functions are designed for exclusive use by the Starknet protocol to enhance account security. Despite their public accessibility, only the Starknet protocol can invoke these functions, identified by using the zero address.



The ```__execute__``` function is the only one that receives a reference to the contract state because it’s the only one likely to either modify its internal state or to modify the state of another smart contract and thus to require the payment of gas fees for its execution. The other two functions, ```__validate__``` and ```is_valid_signature```, are read-only and shouldn’t require the payment of gas fees. For this reason they are both receiving a snapshot of the contract state instead.


<h3> Executing Transactions </h3>

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

<h3> Validating Transactions </h3>

The ```is__valid__signature``` function is responsible for the validation, returning ```VALIDATED``` if the signature is valid. The ```VALIDATED``` constant is imported from the starknet module.
 

```
use starknet::VALIDATED;
```

Notice that the ```is_valid_signature``` function accepts all the transactions as valid. We are not storing a public key in the contract, so we cannot validate the signature.


 
```
fn is_valid_signature(
            self: @ContractState, hash: felt252, signature: Array<felt252>
        ) -> felt252 {
            // No signature is required so any signature is valid.
            VALIDATED
        }
```

```is__valid__signature```is designed to validate a signature for a given hash within the context of a smart contract's state. This function takes three parameters: a reference to the contract's state `(self: @ContractState)`, the hash of the data that purportedly needs to be signed `(hash: felt252)`, and the actual signature represented as an array of felt252 values `(signature: Array<felt252)`. Instead of performing actual cryptographic signature validation, the function simplistically returns a constant `VALIDATED`, indicating that any signature provided is considered valid.


   
 The ```__validate__```  function calls the ```is_validate_signature``` with a dummy hash and signature. The ```__validate__``` function is called by the Starknet protocol to validate the transaction. If the transaction is not valid, the execution of the transaction is aborted.
    


```
fn __validate__(self: @ContractState, calls: Array<Call>) -> felt252 {
            let hash = 0;
            let mut signature: Array<felt252> = ArrayTrait::new();
            signature.append(0);
            self.is_valid_signature(hash, signature)
        }
```

```__validate__``` function is designed to validate a list of contract calls in the context of a smart contract's state. The function takes two parameters: a reference to the contract's state ```(self: @ContractState)``` and an array of calls ```(calls: Array<Call>)```. Inside the function, a hash is initialized to 0, and an empty array of felt252 values named signature is created using the ```ArrayTrait::new()``` method. A 0 value is then appended to the signature array. Finally, the function calls another method, ```self.is_valid_signature```, passing the hash and the signature array as arguments. The ```is_valid_signature``` method is expected to check the validity of the signature. In this simplified implementation, the signature array only contains a single value 0, and the hash is also 0, implying that the function treats this as a generic or default validation scenario. The result of the is_valid_signature method call, which returns a felt252 value indicating whether the validation was successful, is then returned by the ```__validate__``` function. 



 
 
 
 
 
 
 
