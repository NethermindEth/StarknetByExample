# Understanding Sierra: From High-Level Cairo to Safe CASM

Sierra (**S**afe **I**nt**er**mediate **R**epresent**a**tion) is an intermediate representation of Cairo instructions, designed to bridge the gap between high-level Cairo 1 and low-level Cairo Assembly (CASM).
Sierra can be compiled to a subset of CASM that we call `Safe CASM{:md}`. It ensures that every function returns by using a compiler that can detect operations that can't be proven such as infinite loops, unsatisfiable constraints, etc.

### From Cairo 1 to Sierra

Before Starknet Alpha v0.11.0, developers wrote contracts in Cairo 0 which compiled directly to Cairo Assembly (CASM), and the contract classes were submitted to the sequencer with `DECLARE` transactions. This approach had risks as the sequencer would not be able to know if a given transaction would fail or not without executing it, and would not be able to charge fees for failed transactions.

Cairo 1 introduced contract class compilation to this new Sierra intermediate representation instead of directly to CASM. The Sierra code is then submitted to the sequencer, compiled down to CASM, and finally executed by the Starknet OS. 
The usage of Sierra ensures that every transactions (including failed ones) must be provable, and the sequencers can charge fees for all submitted transactions making DoS attacks really expensive.

### Compilation Pipeline

```
    Cairo 1.0 Source (High-level)
          |
          |	with Cairo-to-Sierra Compiler
          V
    Sierra IR (Safe, Provable Code)
          |
          |	with Sierra-to-CASM Compiler (Run by Sequencer)
          V
    CASM (Cairo Assembly)
          |
          | with CairoVM Execution
          V
    STARK Proofs (Proof Generation)
```

At its core, Sierra's compilation process is all about safety and efficiency. It carefully checks types at every step of the transformation, makes sure memory is handled safely in the final code, and keeps track of gas usage. The compiler also focuses on generating optimized code while ensuring that every operation will run the same way each time.
If you're interested in really understanding how the compilation works under the hood, check out the [cairo-compiler-workshop](https://github.com/software-mansion-labs/cairo-compiler-workshop).

### Anatomy of a Sierra Program

### Type Declarations

Sierra uses a **linear type system**, where each value **must be used exactly once**. 
During the compilation, an unique identifier is assigned to each type.

When types can safely be used multiple times, they need to be duplicated using the `dup` instruction, which will assign two new identifiers to preserve linearity.

Type declaration is done with the following syntax:
```cairo
type type_id = concrete_type;
```

<!-- TODO
In addition, each type has a set of attributes that describe how it can be used:
- storable
- droppable
- duplicatable
- zero_sized 
They can be added in the type declaration:
```cairo
type type_id = concrete_type [storable: bool, drop: bool, dup: bool, zero_sized: bool]
```
-->

### Library Function Declarations

Sierra comes with a set of built-in functions (`libfuncs`) that always compile to Safe CASM. After types declaration, a Sierra program must define all the libfuncs used in the program with the inpt type expected.

Libfunc declaration is done with the following syntax:
```cairo
libfunc libfunc_id = libfunc_name<input_types>;
```

### Statements

This part shows the sequence of operations that happen during execution, which describes the actual logic of the program. A statement either invokes a libfunc or returns a value.

A statement is declared with the following syntax:
```cairo
libfunc_id<input_types>(input_variables) -> (output_variables);
```

To return a value, we use the `return(variable_id)` statement.

### User Defined Functions Declarations

At the very end of the Sierra program, each user defined function is declared with an unique identifier and an index to specify the location of the statement where the execution of the function should start.

An user defined function is declared with the following syntax:
```cairo
function_id@statement_index(parameters: types) -> (return_types);
```

## Simple Sierra Program Breakdown

Let's go through the following Cairo program:

```cairo
// [!include ~/listings/advanced-concepts/sierra_ir/src/simple_program.cairo]
```

It compiles to the following Sierra code:

```cairo
// [!include ~/listings/advanced-concepts/sierra_ir/simple_program.sierra]
```

:::info
To enable Sierra code generation in human-readable format, you can add the `sierra-text{:md}` flag to the library target in your `Scarb.toml{:md}` file:
```toml
[lib]
sierra-text = true
```
:::

We can break it down:

Type Declarations:
  - `felt252`: Represents the field element type

Libfunc Declarations:
  - `felt252_add`: Performs addition on field elements
  - `store_temp<felt252>`: Temporarily stores the result

Compilation Steps: 
  - Step 0: `felt252_add([0], [1]) -> ([2])`: Call the `felt252_add` libfunc on memory slot 0 and 1 and store the result in memory slot 2. So `[2] = [0] + [1]` and the value of `[0]` and `[1]` were used.
  - Step 1: `store_temp<felt252>([2]) -> ([2])`: Store the value of `[2]` in a temporary memory slot `[2]`. Because the type `felt252` has `storable: true` and `dup: true`, it is possible to 
  - Step 2: `return([2])`: Return the value of `[2]`

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

### Storage Variables Smart Contract Sierra Code

You can find a more complex example of the [compiled Sierra code](/advanced-concepts/sierra_ir_storage_contract) of the [Storage Variables Example](/getting-started/basics/variables#storage-variables).

## Further Reading

- [Under the hood of Cairo 1.0: Exploring Sierra](https://www.nethermind.io/blog/under-the-hood-of-cairo-1-0-exploring-sierra-part-1)

- [Under the hood of Cairo 2.0: Exploring Sierra](https://www.nethermind.io/blog/under-the-hood-of-cairo-1-0-exploring-sierra-part-2)

- [Under the hood of Cairo 1.0: Exploring Sierra](https://www.nethermind.io/blog/under-the-hood-of-cairo-1-0-exploring-sierra-part-3)

- [Cairo and Sierra](https://docs.starknet.io/architecture-and-concepts/smart-contracts/cairo-and-sierra/)

- [Sierra - Deep Dive](https://www.starknet.io/blog/sierra-deep-dive-video/)
