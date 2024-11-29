# Cairo Profiler Technical Guide: Gas Optimization

**Understanding Available Metrics**

The profiler collects several key metrics per function call:

```cairo

measurements = {
    "steps": n_steps,
    "memory_holes": n_memory_holes,
    "calls": 1,  // count of function invocations
    "l2_l1_message_sizes": message_sizes_sum,
    // builtin counters (pedersen, range_check, etc.)
}
```

## Running the Profiler

```cairo
cairo-profiler <path_to_trace_data> [OPTIONS]

Options:
  -o, --output-path <PATH>                    Output path [default: profile.pb.gz]
  --show-details                              Show contract addresses and selectors
  --max-function-stack-trace-depth <DEPTH>    Maximum depth of function tree [default: 100]
  --split-generics                            Split generic functions by type
  --show-inlined-functions                    Show inlined function calls
  --versioned-constants-path <PATH>           Custom resource costs file

```

### Example: Optimizing Storage Access

### Unoptimized Code

```cairo
#[starknet::contract]
mod UnoptimizedContract {
    #[storage]
    struct Storage {
        balances: LegacyMap<ContractAddress, u256>,
        allowances: LegacyMap<(ContractAddress, ContractAddress), u256>,
    }

    #[external]
    fn transfer_all_from_list(
        ref self: ContractState,
        from: ContractAddress,
        to_list: Array<ContractAddress>
    ) {
        // Unoptimized: Multiple storage reads/writes
        let len = to_list.len();
        let mut i: usize = 0;
        loop {
            if i >= len {
                break;
            }
            let recipient = *to_list.at(i);
            let balance = self.balances.read(from);
            self.balances.write(from, 0);
            self.balances.write(recipient, balance);
            i += 1;
        };
    }
}
```

## Profiler Output Analysis

```cairo
Function Call Trace:
├── transfer_all_from_list (100%)
    ├── storage_read (45%)
    │   └── steps: 2500
    ├── storage_write (40%)
    │   └── steps: 2200
    └── array_operations (15%)
        └── steps: 800

```

### Key Issues Identified:

1. Repeated storage reads for the same value
2. Multiple write operations that could be batched
3. High step count from storage operations

### Optimized Version

```cairo

#[starknet::contract]
mod OptimizedContract {
    #[storage]
    struct Storage {
        balances: LegacyMap<ContractAddress, u256>,
        allowances: LegacyMap<(ContractAddress, ContractAddress), u256>,
    }

    #[external]
    fn transfer_all_from_list(
        ref self: ContractState,
        from: ContractAddress,
        to_list: Array<ContractAddress>
    ) {
        // Read once
        let total_balance = self.balances.read(from);
        let len = to_list.len();

        // Clear sender balance first
        self.balances.write(from, 0);

        // Calculate individual amount
        let amount_per_recipient = total_balance / len.into();

        // Batch write operations
        let mut i: usize = 0;
        loop {
            if i >= len {
                break;
            }
            let recipient = *to_list.at(i);
            self.balances.write(recipient, amount_per_recipient);
            i += 1;
        };
    }
}
```

### Performance Comparison

- Before:

```cairo
Total Steps: 5,500
Storage Reads: 100 (for list size 100)
Storage Writes: 200
```

- After

```cairo
Total Steps: 2,300 (58% reduction)
Storage Reads: 1
Storage Writes: 101
```

## Advanced Profiling Features

1. **Inlined Function Analysis**

Enable with `--show-inlined-functions` to see detailed call stacks including inlined functions:

```cairo
cairo-profiler trace.bin --show-inlined-functions
```

2. **Generic Function Analysis**

Use `--split-generics` to analyze generic functions by their concrete types:

```cairo
cairo-profiler trace.bin --split-generics
```

3. **Custom Resource Costs**

Specify custom resource costs for different Starknet versions:

```cairo
cairo-profiler trace.bin --versioned-constants-path custom_costs.json
```

## Best Practices

1. **Storage Pattern Optimization**

- Cache storage reads in memory when accessed multiple times
- Batch storage writes where possible
- Use storage spans for array operations

2. **Function Call Optimization**

- Monitor inlined vs non-inlined function costs
- Use `--show-inlined-functions` to identify expensive inlined operations
- Consider function composition based on profiler output

3. **Memory Management**

- Track memory_holes metric to identify inefficient memory usage
- Use appropriate data structures to minimize memory fragmentation
- Consider span operations for array access

4. **L1 Communication Optimization**

- Monitor l2_l1_message_sizes for cross-layer communication
- Batch L1 messages when possible
- Compress data when sending to L1

## Common Optimization Patterns

1. **Storage Read Caching**

```cairo
// Before
let value1 = storage.read(key);
let value2 = storage.read(key);

// After
let cached = storage.read(key);
let value1 = cached;
let value2 = cached;
```

2. **Batch Operations**

```cairo
// Before
for item in items {
    storage.write(item.key, item.value);
}

// After
let mut writes = Array::new();
// ... collect writes ...
storage.write_multiple(writes);
```

3. **Memory Efficiency**

```cairo
// Before
let mut array = ArrayTrait::new();
// ... multiple push operations ...

// After
let mut array = ArrayTrait::with_capacity(size);
// ... reserve space first ...
```

## Profile-Guided Optimization Process

1. **Baseline Profiling**

```cairo
cairo-profiler initial_trace.bin --output-path baseline.pb.gz
```

2. **Identify Hotspots**

```cairo
Use flame graphs to identify expensive operations
Focus on functions with high step counts
Look for repeated storage operations
```

3. **Optimize and Compare**

```cairo
cairo-profiler optimized_trace.bin --output-path optimized.pb.gz
```

4. **Validate Improvements**

- Compare step counts and resource usage
- Verify optimization doesn't introduce new inefficiencies
- Document performance gains

## Resources and Tools

1. **pprof visualization**:

```cairo
go tool pprof -http=:8080 profile.pb.gz
```

2. **Flame graph generation**:

```cairo
cairo-profiler trace.bin --output-path flame.svg --format=flamegraph
```
