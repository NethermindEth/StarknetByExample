# Understanding Cairo's Sierra IR: From High-Level Cairo to Safe IR

## Introduction

Sierra (Safe Intermediate RepresentAtion) is a critical intermediate language in the Cairo compilation pipeline, designed to bridge the gap between high-level Cairo and low-level CASM (Cairo Assembly). Its  primary purpose is mostly to be able to compile to a subset of casm that we call safe casm that ensure that any transaction sent is provable, while being able to have a high-level language (cairo1) with high memory safety.

## From Cairo 1(High-level)  to Sierra: Evolution and Problem Solving in Starknet

Before Starknet Alpha v0.11.0, developers wrote contracts in Cairo 0 which compiled directly to Cairo assembly (CASM), and the contract class was submitted to the Starknet sequencer via `DECLARE` transaction. This approach had risks of unprovable transactions and potential sequencer attacks, with limited safety guarantees at compile time.

Cairo 1.0 transformed this landscape by introducing Sierra as an intermediate representation, where contract classes no longer include CASM directly. Instead, the sequencer performs Sierra → CASM compilation before the CASM code is executed by the Starknet OS. This shift ensures every transaction (including failed ones) must be provable, sequencers can charge fees for all transactions, and the system enforces strict memory safety and ownership rules.

This evolution solved critical issues through:
- Guaranteed transaction provability for both successful and failed executions
- Protected sequencers through guaranteed compensation and DoS attack prevention
- Enhanced safety through compile-time checks and strong type system enforcement
- Robust memory safety with strict ownership rules and reliable resource cleanup

This comprehensive transition maintains backward compatibility while significantly improving both security and the development experience in the Starknet ecosystem.

## The Compilation Pipeline
```
    Cairo 1.0 Source (High-level)
          ↓
    	  ↓	with Cairo-to-Sierra Compiler
          ↓
    Sierra IR (Safe, Provable Code)
          ↓
    	  ↓	with Sierra-to-CASM Compiler (Run by Sequencer)
          ↓
    CASM (Cairo Assembly)
          ↓
		  ↓ with CairoVM Execution
		  ↓
    STARK Proofs (Proof Generation)
```
At its core, Sierra's compilation process is all about safety and efficiency. It carefully checks types at every step of the transformation, makes sure memory is handled safely in the final code, and keeps track of gas usage with precision. The compiler also focuses on generating optimized code while ensuring that every operation will run the same way each time - something crucial for smart contracts. If you're interested in really understanding how the compilation works under the hood, check out [cairo-compiler-workshop](https://github.com/software-mansion-labs/cairo-compiler-workshop).

## Key Concepts in Sierra

### 1. Type System

Sierra implements a powerful linear type system, where each value must be used exactly once. This "use-once" principle is fundamental to Sierra's safety guarantees, preventing both resource leaks and double-use errors. The system includes concrete types like felt252 and u256, which form the foundation of Sierra's type hierarchy. These are complemented by generic types with constraints, enabling flexible but safe abstractions. User-defined types extend the system's capabilities while maintaining safety guarantees. The type system employs references and boxing mechanisms to manage memory safely, ensuring all memory access is valid, variables are properly initialized before use, and type constraints are consistently enforced throughout the program's execution.

### 2. Memory Model

Sierra's memory model prioritizes safety through deliberate design choices. It implements linear memory management, requiring explicit tracking of resource ownership and lifecycle. Memory operations are handled through explicit deallocation, preventing memory leaks and use-after-free errors. The model prohibits implicit copies, making data movement explicit and traceable. For complex data structures, Sierra employs reference counting to manage shared resources safely, ensuring proper cleanup when resources are no longer needed. This careful approach to memory management forms a cornerstone of Sierra's safety guarantees.

### 3. Control Flow

Control flow in Sierra is structured through a clear, explicit model that maintains safety while enabling complex program logic. Basic blocks serve as the fundamental units of execution, with explicit branch instructions managing program flow between them. Function calls are handled with explicit stack management, ensuring resource safety across function boundaries. Loop structures incorporate invariant checking, maintaining safety properties throughout iterations. This explicit control flow model enables comprehensive static analysis while preventing common control flow errors.


## Sierra Code Explanation for a simple cairo program
### original cairo program
```cairo
// [!include ~/listings/advanced-concepts/sierra_ir/simple_cairo.cairo:contract]
```

### compiled sierra
The above program compiled [sierra code](~/listings/advanced-concepts/sierra_ir/simple_program.sierra)

Sierra (Safe Intermediate Representation and Execution) is a critical intermediate representation in Starknet's Cairo contract compilation process. For the simple add_numbers function, here's a detailed breakdown:

1. Type Declarations defines the fundamental data types and their attributes used in the Sierra code.
- `felt252`: Represents the field element type
- Attributes:
	- `storable: true`: this attributecan be stored
	- `drop: true`: this attribute can be discarded
	- `dup: true`: this attributes can be duplicated
	- `zero_sized: false`: this attributes has a non-zero memory footprint

2. Libfunc Declarations specify the library functions available for performing operations on these types.
	- `felt252_add`: Performs addition on field elements
	- `store_temp<felt252>`: Temporarily stores the result

3. Compilation Steps show the actual sequence of operations that happen during code execution.
	- Line 0: `felt252_add([0], [1]) -> ([2]): Add input parameters
	- Line 1: `store_temp<felt252>([2]) -> ([2]): Store the temporary result
	- Line 2: `return([2]): Return the computed value

4. Libfunc Restrictions:
- Starknet uses an allowed [list](https://github.com/starkware-libs/cairo/tree/main/crates/cairo-lang-starknet-classes/src/allowed_libfuncs_lists) of libfuncs to ensure: 
	- Security:
		Sierra enforces security by allowing only whitelisted operations with predefined behaviors, while maintaining strict control over memory operations and eliminating arbitrary pointer arithmetic to prevent vulnerabilities.
	- Predictability:
		The restricted libfunc approach ensures deterministic execution across all operations, enabling precise gas cost calculations and well-defined state transitions, while keeping all side effects explicitly managed and traceable.
	- Verifiability:
		By limiting library functions, Sierra simplifies the proof generation process and makes constraint system generation more efficient, which reduces verification complexity and ensures consistent behavior across different implementations.
	- Error Prevention
		The restricted library functions eliminate undefined behavior by catching potential runtime errors at compile time, while enforcing explicit resource management and maintaining type safety throughout the entire execution process.
The restricted libfunc approach helps maintain the safety and efficiency of smart contracts on the Starknet platform. 


## Sierra Code Explanation for Storage Smart Contract

```cairo
// [!include ~/listings/advanced-concepts/sierra_ir/storage_variable.cairo:contract]
```

### compiled sierra
The Storage smart contract compiled [sierra code](~/listings/advanced-concepts/sierra_ir/storage_variable.sierra)

### 1. Type Decalarations:
This section defines the fundamental types that Sierra uses to ensure type safety and memory management.

- System and Base Types
	```cairo
	type RangeCheck = RangeCheck [storable: true, drop: false, dup: false, zero_sized: false];
	type felt252 = felt252 [storable: true, drop: true, dup: true, zero_sized: false];
	type u32 = u32 [storable: true, drop: true, dup: true, zero_sized: false];
	type GasBuiltin = GasBuiltin [storable: true, drop: false, dup: false, zero_sized: false];
	```
	What This Means:

	- `RangeCheck`: A type used for validating numeric ranges. It can't be dropped or duplicated, ensuring that range checks are always properly handled.
	- `felt252`: Field element type, the basic numeric type in Cairo. It's flexible - can be stored, dropped, and duplicated.
	- `u32`: 32-bit unsigned integer, with similar properties to felt252.
	- `GasBuiltin`: Tracks gas consumption. Can't be dropped or duplicated to prevent gas accounting errors.

- Storage-Related Types
	```cairo
	type StorageBaseAddress = StorageBaseAddress [storable: true, drop: true, dup: true, zero_sized: false];
	type core::starknet::storage::StoragePointer0Offset::<core::integer::u32> = 
	    Struct<ut@[...], StorageBaseAddress>;
	type StorageAddress = StorageAddress [storable: true, drop: true, dup: true, zero_sized: false];
	```
	What This Means:

	- `StorageBaseAddress`: Represents the base location in contract storage.
	- `StoragePointer0Offset`: A structured type that points to u32 values in storage.
	- `StorageAddress`: The actual address used for storage operations.

### 2. Library Functions(libfunc)
Sierra provides a set of built-in functions (libfuncs) for handling memory, storage, and gas operations.
- Memory Management
	```cairo
	libfunc revoke_ap_tracking = revoke_ap_tracking;
	libfunc enable_ap_tracking = enable_ap_tracking;
	libfunc disable_ap_tracking = disable_ap_tracking;

	
	libfunc store_temp<T> = store_temp<T>;
	libfunc drop<T> = drop<T>;
	```
	#### Purpose:
	These functions control the allocation pointer (ap) tracking system, which is crucial for memory safety:

	- Enable/disable tracking when needed
	- Prevent memory leaks
	- Ensure proper memory allocation



- Storage Operations
	```cairo
	libfunc storage_base_address_const<...> = storage_base_address_const<...>;
	libfunc storage_address_from_base = storage_address_from_base;
	libfunc storage_write_syscall = storage_write_syscall;
	libfunc storage_read_syscall = storage_read_syscall;
	```
	#### Purpose:
	These functions handle all storage interactions:

	- Computing storage addresses
	- Reading from storage
	- Writing to storage
	- Managing storage layout


- Gas Management
	```cairo
	libfunc withdraw_gas = withdraw_gas;
	libfunc withdraw_gas_all = withdraw_gas_all;
	libfunc get_builtin_costs = get_builtin_costs;
	```
	#### Purpose:
	These functions handle all aspects of gas accounting:

	- Track gas consumption
	- Withdraw gas for operations
	- Calculate operation costs
	- Prevent out-of-gas scenarios

### 3. Execution Flow Analysis

- Initialization and Gas Management Phase
This phase marks the beginning of contract execution where Sierra prepares the execution environment and handles initial gas costs. First, it disables the allocation pointer tracking, which is a safety measure to prevent memory tracking overhead during gas calculations. Then, it performs a critical gas withdrawal check - this ensures the contract has sufficient gas to execute, with fallback paths for both successful and failed gas checks. After gas validation, it aligns the execution branch for consistent memory layout and finally deconstructs the input parameters into their base components for further processing.
The phase is crucial for:

	- Setting up memory safety mechanisms
	- Ensuring gas availability
	- Preparing input parameters
	- Establishing execution paths
	```cairo
	// The actual code implementation
	revoke_ap_tracking() -> (); // 0
	withdraw_gas([0], [1]) { fallthrough([4], [5]) 114([6], [7]) }; // 1
	branch_align() -> (); // 2
	struct_deconstruct<core::array::Span::<core::felt252>>([3]) -> ([8]); // 3
	```

- Parameter Processing Phase
In this phase, Sierra handles the processing and validation of input parameters. It reactivates the allocation pointer tracking, which was disabled during gas calculations, to ensure memory safety during parameter processing. The range check pointer is stored for numeric validations, crucial for ensuring values are within acceptable ranges. The system then processes array inputs through snapshots - a mechanism that provides safe, immutable views of array data. Finally, it handles option types, which are essential for representing potentially null or invalid values. This phase is fundamental for type safety and memory integrity.

```cairo
enable_ap_tracking() -> (); // 4
store_temp<RangeCheck>([4]) -> ([4]); // 5
array_snapshot_pop_front<felt252>([8]) { fallthrough([9], [10]) 12([11]) }; // 6
enum_init<core::option::Option::<core::box::Box::<@core::felt252>>, 0>([10]) -> ([12]); // 8
```

- Storage Operation Phase
The storage operation phase is where Sierra manages contract storage interactions. It begins by computing the storage base address - a unique identifier for the storage variable. This address is derived from contract-specific constants and variable positions. The system then converts this base address into a concrete storage address that can be used for actual storage operations. During write operations, the system includes multiple checks and fallback paths to handle potential failures, ensuring storage consistency even in error cases.

```cairo
storage_base_address_const<...>() -> ([38]); // 50
storage_address_from_base([38]) -> ([40]); // 52
storage_write_syscall([35], [2], [41], [40], [39]) {
    fallthrough([42], [43]) 70([44], [45], [46])
}; // 57
```

- Value Processing Phase
During value processing, Sierra handles type conversions and validations of data. This phase is critical for ensuring type safety and data integrity. The system attempts to convert between different numeric types (like felt252 to u32) with built-in overflow checks. Temporary storage is used to maintain values during processing, with careful management of memory resources. Each conversion includes fallback paths for handling potential failures.

```cairo
u32_try_from_felt252([4], [20]) { fallthrough([21], [22]) 93([23]) }; // 22
store_temp<felt252>([20]) -> ([20]); // 21
```

- Error Handling Phase
The error handling phase implements Sierra's robust error management system. It constructs panic results for error cases, ensuring that failures are handled gracefully and securely. The system creates structured error information including panic details and relevant error data. This phase is crucial for maintaining contract reliability and providing meaningful error feedback. All error states are carefully packaged into result types that can be safely returned and handled by the calling context.

```cairo
struct_construct<core::panics::Panic>() -> ([30]); // 35
struct_construct<Tuple<core::panics::Panic, Array<felt252>>>([30], [29]) -> ([31]); // 36
enum_init<core::panics::PanicResult::<(core::array::Span::<core::felt252>,)>, 1>([31]) -> ([32]); // 37
```

- Return Phase
The return phase is responsible for finalizing the execution and preparing the return values. It ensures all resources are properly accounted for by storing final values for range checking, gas tracking, and system state. The phase carefully packages all return values, maintaining type safety and memory integrity. This phase is critical for ensuring the contract's state is consistent after execution.

```cairo
store_temp<RangeCheck>([21]) -> ([21]); // 38
store_temp<GasBuiltin>([5]) -> ([5]); // 39
store_temp<System>([2]) -> ([2]); // 40
return([21], [5], [2], [32]); // 42
```

- Storage Read Flow
The storage read operation is a specialized flow that handles retrieving values from contract storage. It begins with a storage address computation, followed by a syscall to read the storage value. The read value is then processed and converted to the appropriate type with necessary validations. This operation includes comprehensive error handling for cases like invalid storage addresses or type conversion failures.

```cairo 
storage_read_syscall([20], [2], [30], [29]) {
    fallthrough([31], [32], [33]) 196([34], [35], [36])
}; // 166
store_temp<felt252>([33]) -> ([33]); // 168
u32_try_from_felt252([19], [33]); // 171
```

- Storage Write Flow
The storage write operation manages a secure and atomic process for updating contract state in Sierra. It begins with precise gas calculations and withdrawals to ensure sufficient resources for the complete operation. The system then computes a unique storage address through a two-step process: generating a base address from contract-specific constants and transforming it into a concrete storage location. Finally, it executes the atomic write operation through a system call, with comprehensive error handling to maintain storage integrity. The entire process ensures consistent state updates, prevents data corruption, and handles failures gracefully.
	
	```cairo
	withdraw_gas([0], [1]) { fallthrough([4], [5]) 114([6], [7]) };
	
	storage_base_address_const<...>() -> ([38]);
	storage_address_from_base([38]) -> ([40]);
	
	storage_write_syscall([35], [2], [41], [40], [39]);
	```

### 4. Function Implementation Analysis
- Set Function Implementation
	```cairo
	// Function wrapper
	storage_variables::storage_variables::StorageVariablesExample::__wrapper__StorageVariablesExample__set@0(
	    [0]: RangeCheck,  // For numeric checks
	    [1]: GasBuiltin,  // For gas tracking
	    [2]: System,      // For system calls
	    [3]: core::array::Span::<core::felt252>  // Input parameters
	)
	```
	Key Operations:
	1. `Gas` withdrawal and checks
	2. `Parameter` validation
	3. `Storage` address computation
	4. `Value` writing to storage
	5. `Return` handling with panic checks

- Get Function Implementation
	storage_variables::storage_variables::StorageVariablesExample::__wrapper__StorageVariablesExample__get@128(
	    // Similar parameters as set
	)

	Key Operations:
	1. `Gas` checks
	2. `Storage` address computation
	3. `Value` reading from storage
	4. `Type` conversion and validation
	5. `Result` packaging and return

## Further Reading

- [Under the hood of Cairo 1.0: Exploring Sierra](https://www.nethermind.io/blog/under-the-hood-of-cairo-1-0-exploring-sierra-part-1)

- [Under the hood of Cairo 2.0: Exploring Sierra](https://www.nethermind.io/blog/under-the-hood-of-cairo-1-0-exploring-sierra-part-2)

- [Under the hood of Cairo 1.0: Exploring Sierra](https://www.nethermind.io/blog/under-the-hood-of-cairo-1-0-exploring-sierra-part-3)

- [Cairo and Sierra](https://docs.starknet.io/architecture-and-concepts/smart-contracts/cairo-and-sierra/)

- [Sierra - Deep Dive](https://www.starknet.io/blog/sierra-deep-dive-video/)

