# If Statements

Using an if expression allows you to execute certain code depending on conditions. Within the if statement provide a condition and then specify what you want to execute within the block of code. You can specify an else expression which is reached if the If condition is not met.

Here's a simple example of a contract using if and else statements for role based access log:

The contract will log a welcome message to the console depending on who called the function. If the owner called the function, the welcome message will be 'Welcome Admin!'. If a normal user called the function, the welcome message will be 'Welcome User!'.

```rust
{{#include ../listings/ch00-introduction/if_else/src/access_log.cairo}}
```
