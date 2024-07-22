# Account Contract with Spending Limits

In this example, we will write an account contract with spending limits.

Before proceeding with this example, make sure that you read the [intro](../advanced-concepts/account_abstraction/account_contract.md) to account contracts on Starknet which will help you understand how Starknet account contracts work.

## Key Specifications
The spending limit for the account contract will have the following features: 

- The limit can be set for any ERC-20 token with any amount by the account owner.
- The limit will reset after a specified time. The account owner could set any time limit they want (daily, weekly or 12 hours).
- If one of the calls has the "approve" or "transfer" function selectors, the spending limit will decrease accordingly by the amount given in the function call. If there is no limit left, the transaction will revert.

The function `__execute__` will check if the function called is "approve" or "transfer", and if yes, the limit will decrease by the amount in the call. Here is the code for the `__execute__` function: 
```rs
fn __execute__(ref self: ContractState, mut calls: Array<Call>) -> Array<Span<felt252>> {
            assert(!calls.is_empty(), 'Account: No call data given');
            self.only_protocol();
            let mut res = ArrayTrait::new();
            loop {
                //Loop through the calls, supporting multicalls.
                match calls.pop_front() {
                    Option::Some(call) => {
                        let Call { to, selector, calldata } = call;

                        //The limit should have been set before by the account owner.
                        let limit_exists: bool = self.spending_limit.read(to).exists;

                        //is_spending_tx function checks if the function is "approve" or "transfer"
                        //See the full code below how it is done!
                        if (self.is_spending_tx(selector) && limit_exists) {
                            let low: u128 = Felt252TryIntoU128::try_into(*calldata[1]).unwrap();
                            let high: u128 = Felt252TryIntoU128::try_into(*calldata[2]).unwrap();

                            //Extract the value the account approves/transfers from the calldata
                            let value: u256 = u256 { low, high }; 
                            
                            //Update the spending limit for other calls in this tx or for future txs.
                            let mut current_limit: u256 = self.get_spending_limit(to);
                            current_limit -= value;
                            self.current_spending_limit.write(to, current_limit);
                            self.update_timestamp(to);
                        }

                        //calls the function after spending limit & timestamp were updated.
                        let _res = call_contract_syscall(to, selector, calldata).unwrap();
                        res.append(_res);
                    },
                    Option::None(_) => { break (); },
                };
            };
            res
        }
```

Here is the full code of the account contract with spending limits:

```rs
{{#rustdoc_include ../../listings/applications/aa_spending_limit/src/account.cairo}}
```