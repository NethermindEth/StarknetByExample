## SRC-5: A comprehensive Overview

SRC-5 is a standard for smart contract interface introspection in Starknet, inspired by the [Ethereum ERC-165 standard](https://eips.ethereum.org/EIPS/eip-165). 

It provides a method for contracts to publish and detect the interfaces they implement, ensuring standardized interaction. 

You can find more information and details refer to the [SRC-5 specification](https://github.com/starknet-io/SNIPs/blob/main/SNIPS/snip-5.md#simple-summary). 

### SRC-5 offers a standardized method to:

* Identify interfaces.
* Publish the interfaces a contract implements.
* Detect if a contract implements any given interface. (including SRC-5)


### Interface Definition
An interface is a set of function signatures with specific type parameters, represented as traits. These traits are meant to be implemented externally by compliant contracts.

Example:

    ```rust 
    trait IMyContract {
    fn foo(some: u256) -> felt252;
    }
    ```
With Cairo 2.0, generic traits can represent a set of interfaces:

    ```rust
    #[starknet::interface]
    trait IMyContract<TContractState, TNumber> {
    fn foo(self: @TContractState, some: TNumber) -> felt252;
    }
    ```
#### Extended Function Selector
The function selector in Starknet is the starknet_keccak hash of the function name. The extended function selector, for SRC-5, is the starknet_keccak hash of the function signature:

fn_name(param1_type,param2_type,...)->output_type

For example,for a function with zero parameters and no return value:


    fn_name()

Special Types:
```
* Tuples: (elem1_type,elem2_type,...)
* Structs: (field1_type,field2_type,...)
* Enums: E(variant1_type,variant2_type,...)
```

#### Interface Identification
An interface identifier is the XOR of all extended function selectors in the interface.

This Python code computes the interface id:

```rust
{{#rustdoc_include ../../../listings/src5_interface/src5_snippet.py}}
```
   
 For more details refer to the [SRC-5 repository on GitHub](https://github.com/ericnordelo/src5-rs).

Publishing and Detecting Interfaces

To comply with SRC-5, a contract must implement the ISRC5 trait:

    ```rust
    trait ISRC5 {
    fn supports_interface(interface_id: felt252) -> bool;
    }
    ```

The supports_interface function returns:

* true if the contract implements the given interface_id.
* false otherwise.

The interface identifier for ISRC5 is 

```0x3f918d17e5ee77373b56385708f855659a07f75997f365cf87748628532a055```.

#### Detecting SRC-5 Implementation
To check if a contract implements SRC-5:

* Call  `contract.supports_interface(0x3f918d17e5ee77373b56385708f855659a07f75997f365cf87748628532a055)`. 
  
* If the call fails or returns false, the contract does not implement SRC-5.
  
* Otherwise, it implements SRC-5.

#### Detecting Any Given Interface
* Confirm if the contract implements SRC-5.
* If confirmed, `call supports_interface(interface_id)` to check for specific interfaces.
* If not, manually inspect the contract methods.

Below shows a contract implementing the ```SRC5```to expose the ```Isupports_interface(interface_id)``` :

```rust
{{#rustdoc_include ../../../listings/src5_interface/src/src5_interface.cairo}}
```

