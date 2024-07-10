## SRC-5: A comprhensive Overview

SRC-5 is a standard for smart contract interface introspection in Starknet, inspired by the Ethereum ERC-165 standard. It provides a method for contracts to publish and detect the interfaces they implement, ensuring standardized interaction.SRC-5 is a standard for smart contract interface introspection in Starknet, inspired by the Ethereum ERC-165 standard. It provides a method for contracts to publish and detect the interfaces they implement, ensuring standardized interaction.


### SRC-5 offers a standardized method to:

* Identify interfaces.
* Publish the interfaces a contract implements.
* Detect if a contract implements SRC-5.
* Detect if a contract implements any given interface.


### Interface Definition
An interface is a set of function signatures with specific type parameters, represented as traits. These traits are meant to be implemented externally by compliant contracts.

Example:
 
    trait IMyContract {
    fn foo(some: u256) -> felt252;
    }
With Cairo 2.0, generic traits can represent a set of interfaces:


    #[starknet::interface]
    trait IMyContract<TContractState, TNumber> {
    fn foo(self: @TContractState, some: TNumber) -> felt252;
    }
#### Extended Function Selector
The function selector in Starknet is the starknet_keccak hash of the function name. The extended function selector, for SRC-5, is the starknet_keccak hash of the function signature:


    fn_name(param1_type,param2_type,...)->output_type
For example, for a function with zero parameters and no return     value:


    fn_name()
    
Special Types:

* Tuples: (elem1_type,elem2_type,...)
* Structs: (field1_type,field2_type,...)
* Enums: E(variant1_type,variant2_type,...)

#### Interface Identification
An interface identifier is the XOR of all extended function selectors in the interface.

Example (Python code):


    from starkware.starknet.public.abi import starknet_keccak
    
    signatures = [
    'supports_interface(felt252)->E((),())',
    'is_valid_signature(felt252,Array<felt252>)->E((),())',
    '__execute__(Array<(ContractAddress,felt252,Array<felt252>)>)->Array<(@Array<felt252>)>',
    '__validate__(Array<(ContractAddress,felt252,Array<felt252>)>)->felt252',
    '__validate_declare__(felt252)->felt252'
    ]

    def compute_interface_id():
    interface_id = 0x0
    for sig in signatures:
        function_id = starknet_keccak(sig.encode())
        interface_id ^= function_id
    print('IAccount ID:', hex(interface_id))

    compute_interface_id()
    
Publishing and Detecting Interfaces

To comply with SRC-5, a contract must implement the ISRC5 trait:


    trait ISRC5 {
    fn supports_interface(interface_id: felt252) -> bool;
    }
    
The supports_interface function returns:

* true if the contract implements the given interface_id.
* false otherwise.

The interface identifier for ISRC5 is 

```0x3f918d17e5ee77373b56385708f855659a07f75997f365cf87748628532a055```.

#### Detecting SRC-5 Implementation
To check if a contract implements SRC-5:

1. Call  'contract.supports_interface(0x3f918d17e5ee77373b56385708f855659a07f75997f365cf87748628532a055)'.
2. If the call fails or returns false, the contract does not implement SRC-5.
3. Otherwise, it implements SRC-5.

#### Detecting Any Given Interface
1. Confirm if the contract implements SRC-5.
2. If confirmed, call supports_interface(interface_id) to check for specific interfaces.
3. If not, manually inspect the contract methods.

Below shows an example of a contract implementing the ```ISRC5``` trait :


``` use openzeppelin::account::interface::ISRC5_ID;
use openzeppelin::introspection::src5::SRC5Component;
use starknet::contract::ContractAddress;
use starknet::syscalls::call_contract_syscall;
use starknet::alloc::arrays::ArrayTrait;
use starknet::core::keccak::starknet_keccak;

// Define ISRC5 interface
trait ISRC5 {
    fn supports_interface(interface_id: felt252) -> bool;
}

// Define example interfaces
trait IExample1 {
    fn example_function1(param1: felt252) -> felt252;
}

trait IExample2 {
    fn example_function2(param1: felt252, param2: felt252) -> felt252;
}

// Storage structure
struct Storage {
    public_key: felt252,
    src5: SRC5Component::Storage,
}

// Event definitions
enum Event {
    AccountCreated: felt252,
    SRC5Event: SRC5Component::Event,
}

// Contract implementation
@contract
namespace ExampleContract {
    struct State {
        storage: Storage,
    }

    // Constructor
    #[constructor]
    fn constructor(ref state: State, public_key: felt252) {
        state.storage.public_key = public_key;
        emit(Event::AccountCreated(public_key));
        state.storage.src5.register_interface(ISRC5_ID);
    }

    // Implementation of ISRC5
    #[external]
    fn supports_interface(ref state: State, interface_id: felt252) -> bool {
        state.storage.src5.supports_interface(interface_id)
    }

    // Implementation of IExample1
    #[external]
    fn example_function1(param1: felt252) -> felt252 {
        // Your implementation here
        return starknet_keccak(param1.to_bytes());
    }

    // Implementation of IExample2
    #[external]
    fn example_function2(param1: felt252, param2: felt252) -> felt252 {
        // Your implementation here
        return param1 + param2;
    }

    // Additional functions or internal logic can be added here
}

// ISRC5 trait implementation
impl ISRC5 for State {
    fn supports_interface(ref self, interface_id: felt252) -> bool {
        self.storage.src5.supports_interface(interface_id)
    }
}

// Interface registration during contract deployment
fn main() {
    let state = ExampleContract::State {
        storage: Storage {
            public_key: felt252::default(),
            src5: SRC5Component::Storage::default(),
        },
    };
    ExampleContract::constructor(state, 12345.into());
}
```