# proofreading documentation

## introduction

1. Technical Clarity

```
Current:
"Starknet is a permissionless Validity-Rollup that supports general computation"

Suggested:
"Starknet is a permissionless Validity-Rollup (zero-knowledge rollup) that enables general-purpose computation on Ethereum's Layer 2, offering improved scalability while maintaining Ethereum's security guarantees through STARK proofs."
```

2. Tool Integration

```
- link to [setup instructions](https://www.cairo-lang.org/tutorials/getting-started-with-cairo/)
```

3. Link Deprecated

```
Current: 'If you want to learn more about Starknet, you can read the [Starknet documentation](https://docs.starknet.io/) and the [Starknet Book](https://book.starknet.io).'

Suggested: "If you want to learn more about Starknet, you can read the [Starknet documentation](https://docs.starknet.io/) and the [Starknet Book](https://docs.starknet.io/)."
location:
- url:https://github.com/NethermindEth/StarknetByExample/blob/dev/pages/index.mdx?plain=1/
- section: Further reading
- line-number: 33
```

## Storage

Technical Review:

1. Content Accuracy & Completeness

- Missing Explanations:

  - No explanation of storage slots/addresses computation
  - No mention of storage access control (pub vs private)
  - No practical examples of reading/writing to storage

2. Technical Enhancement Suggestions

- Current:

```cairo
#[starknet::contract]
pub mod Contract {
    #[storage]
    struct Storage {}
}
```

- Suggestion:

```cairo
// Current example is too minimal. Suggested expanded example:
#[starknet::contract]
pub mod Contract {
    #[storage]
    struct Storage {
        pub balance: u256,         // Public storage variable
        internal_counter: u128,    // Private storage variable
    }
}
```

3. Missing Critical Information:

a. Storage Operations:
Add section on basic storage operations:

- Reading: `self.variable_name.read()`
- Writing: `self.variable_name.write(new_value)`
- Storage costs and gas considerations

b Storage Types:
Add section on supported storage types:

- Basic types (felt252, u8, u16, u32, u64, u128, u256)
- Complex types (structs, arrays, mappings)
- Storage layout and packing considerations

4. Technical Inaccuracies to Address:

- Current content: "Actually these two contracts have the same underlying Sierra program"

- Issue: While technically correct, this needs more context

- Suggested addition: "The Sierra code is generated only for storage variables that are actually accessed in the contract's functions. Declaring but never using a storage variable doesn't affect the compiled contract size or gas costs."

location:

- url:https://github.com/NethermindEth/StarknetByExample/blob/dev/pages/getting-started/basics/storage.md
- section: note
- line-number: 19

## Constructor

1. Missing Information
   a. Constructor Constraints:
   Important constructor characteristics not mentioned:

- Cannot be called after deployment
- Must be public (no visibility modifier needed)
- Cannot return values
- Cannot be overridden (unlike regular functions)
- Must handle all storage initialization

2. Technical Enhancement Suggestions:

- Currently implementation:

```cairo
#[starknet::contract]
pub mod ExampleConstructor {
    use starknet::ContractAddress;
    use starknet::storage::{Map, StorageMapWriteAccess};

    #[storage]
    struct Storage {
        pub names: Map::<ContractAddress, felt252>,
    }

    // The constructor is decorated with a `#[constructor]` attribute.
    // It is not inside an `impl` block.
    #[constructor]
    fn constructor(ref self: ContractState, name: felt252, address: ContractAddress) {
        self.names.write(address, name);
    }
}
```

Suggestion:

```cairo
// Add example with error handling
#[starknet::contract]
pub mod ExampleConstructor {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        owner: ContractAddress,
        names: Map::<ContractAddress, felt252>,
    }

    #[constructor]
    fn constructor(ref self: ContractState, name: felt252, address: ContractAddress) {
        // Validate inputs
        assert(!address.is_zero(), 'Invalid address');
        assert(name != 0, 'Empty name not allowed');

        // Initialize state
        self.owner.write(get_caller_address());
        self.names.write(address, name);
    }
}
```

location:

- url: https://github.com/NethermindEth/StarknetByExample/blob/a87235b0d46579677927608d68d945b253933f53/listings/getting-started/constructor/src/constructor.cairo#L3

- line-number: 3 to 18

## Variables

1. Missing Information

a. Add section on scoping:

```
- Block scope rules
- Function parameter scope
- Shadowing rules
- Visibility rules for storage variables
- Storage variable access patterns
```

b. Add best practices for:

```
1. Local Variables
- Use meaningful names
- Keep scope as small as possible
- Use type annotations for clarity
- Consider immutability by default

2. Storage Variables
- Minimize storage operations (cost)
- Use appropriate types
- Implement access control
- Consider storage layout

3. Global Variables
- Cache frequently used values
- Validate global state when necessary
- Use for access control
- Consider timestamp manipulation risks
```

## Visibility and Mutability

1. Significant Issues Found:

A. Deprecated Import Statement
Location: [import storage](https://github.com/NethermindEth/StarknetByExample/blob/a87235b0d46579677927608d68d945b253933f53/listings/getting-started/visibility/src/visibility.cairo#L10)

#### Why Problematic:

- These imports are deprecated in current Cairo versions
- Using deprecated imports could confuse developers and lead to compilation errors
- Doesn't reflect current best practices

#### Suggested Correction:

- Remove these imports as they're no longer needed in modern Cairo
- Add note about storage access being handled implicitly by the compiler

B. Outdated ABI Attribute
Location: [outdate abi attribute](https://github.com/NethermindEth/StarknetByExample/blob/a87235b0d46579677927608d68d945b253933f53/listings/getting-started/visibility/src/visibility.cairo#L20)

#### Why Problematic:

- Uses outdated attribute syntax
- Inconsistent with current Starknet documentation
- Could cause confusion for developers using newer Cairo versions

#### Suggested Correction:

- Replace with `#[external(v0)]`
- Add explanation about the migration from abi to external attribute

C. Missing Interface Definition
Location: [Throughout example](https://github.com/NethermindEth/StarknetByExample/blob/a87235b0d46579677927608d68d945b253933f53/listings/getting-started/visibility/src/visibility.cairo#L21)

#### Why Problematic:

Code references super::IExampleContract but doesn't show its definition
Incomplete example makes it harder for developers to understand the full picture

#### Suggested Correction:

Add interface definition:

```cairo
#[starknet::interface]
trait IExampleContract<TContractState> {
    fn set(ref self: TContractState, value: u32);
    fn get(self: @TContractState) -> u32;
}
```

D. Unclear Internal Function Access
Location: [get function implementation](https://github.com/NethermindEth/StarknetByExample/blob/a87235b0d46579677927608d68d945b253933f53/listings/getting-started/visibility/src/visibility.cairo#L35)

#### Why Problematic:

- Uses unnecessarily verbose syntax for internal function calls
- Doesn't reflect modern Cairo best practices

#### Suggested Correction:

- Update to direct call syntax: `self._read_value()`
- Add explanation about internal function access patterns

2. Suggested Comprehensive Update:

Current Implementation:

[Deprecated example](https://github.com/NethermindEth/StarknetByExample/blob/a87235b0d46579677927608d68d945b253933f53/listings/getting-started/visibility/src/visibility.cairo#L1)

Suggestion:

```cairo
/// Modern Example of Visibility and Mutability
#[starknet::contract]
pub mod ExampleContract {
    // No storage imports needed in modern Cairo

    #[storage]
    struct Storage {
        pub value: u32
    }

    // Explicit interface definition
    #[starknet::interface]
    trait IExampleContract<TContractState> {
        fn set(ref self: TContractState, value: u32);
        fn get(self: @TContractState) -> u32;
    }

    // Modern external implementation
    #[external(v0)]
    impl ExampleContract of IExampleContract<ContractState> {
        fn set(ref self: ContractState, value: u32) {
            self.value.write(value);
        }

        fn get(self: @ContractState) -> u32 {
            self._read_value()
        }
    }

    // Internal implementation with modern practices
    #[generate_trait]
    impl PrivateFunctions of PrivateFunctionsTrait {
        fn _read_value(self: @ContractState) -> u32 {
            self.value.read()
        }
    }
}
```

## Simple Counter

1. Significant Issue Found:

A. Deprecated Import Statement - [Location](https://github.com/NethermindEth/StarknetByExample/blob/a87235b0d46579677927608d68d945b253933f53/listings/getting-started/counter/src/counter.cairo#L11)

B. Outdated ABI Attribute - [Location](https://github.com/NethermindEth/StarknetByExample/blob/a87235b0d46579677927608d68d945b253933f53/listings/getting-started/counter/src/counter.cairo#L25)

C. Missing Interface Definition
Location: Throughout example

#### Why Problematic:

- References super::ISimpleCounter but doesn't show its definition
- Makes it harder for developers to understand the complete contract structure
- Incomplete educational example

D. Missing Error Handling
Location: increment and decrement functions

#### Why Problematic:

- No overflow/underflow checks for u128 operations
- Could lead to unexpected behavior
- Misses important security considerations

Current Implementation:

[counter contract](https://github.com/NethermindEth/StarknetByExample/blob/a87235b0d46579677927608d68d945b253933f53/listings/getting-started/counter/src/counter.cairo#L25)

Suggestion:

```cairo
#[starknet::contract]
pub mod SimpleCounter {
    // Interface definition
    #[starknet::interface]
    trait ISimpleCounter<TContractState> {
        fn get_current_count(self: @TContractState) -> u128;
        fn increment(ref self: TContractState);
        fn decrement(ref self: TContractState);
    }

    #[storage]
    struct Storage {
        counter: u128,
    }

    // Events for better tracking
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CounterIncremented: CounterIncremented,
        CounterDecremented: CounterDecremented,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncremented {
        current_count: u128,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterDecremented {
        current_count: u128,
    }

    #[constructor]
    fn constructor(ref self: ContractState, init_value: u128) {
        self.counter.write(init_value);
    }

    #[external(v0)]
    impl SimpleCounter of ISimpleCounter<ContractState> {
        fn get_current_count(self: @ContractState) -> u128 {
            self.counter.read()
        }

        fn increment(ref self: ContractState) {
            let current = self.counter.read();
            // Add overflow check
            assert(current < u128::max(), 'Counter overflow');
            let new_count = current + 1;
            self.counter.write(new_count);
            // Emit event
            self.emit(CounterIncremented { current_count: new_count });
        }

        fn decrement(ref self: ContractState) {
            let current = self.counter.read();
            // Add underflow check
            assert(current > 0, 'Counter underflow');
            let new_count = current - 1;
            self.counter.write(new_count);
            // Emit event
            self.emit(CounterDecremented { current_count: new_count });
        }
    }
}
```
