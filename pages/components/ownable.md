# Ownable

The following `Ownable` component is a simple component that allows the contract to set an owner and provides an `_assert_is_owner` function that can be used to ensure that the caller is the owner.

It can also be used to renounce ownership of a contract, meaning that no one will be able to satisfy the `_assert_is_owner` function.

```cairo
// [!include ~/listings/applications/components/src/ownable.cairo:component]
```

A mock contract that uses the `Ownable` component:

```cairo
// [!include ~/listings/applications/components/src/ownable.cairo:contract]
```
