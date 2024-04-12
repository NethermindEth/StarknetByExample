// ANCHOR: contract
#[starknet::interface]
pub trait IMessage<TContractState> {
    fn append(ref self: TContractState, str: ByteArray);
    fn prepend(ref self: TContractState, str: ByteArray);
}

#[starknet::contract]
pub mod MessageContract {
    #[storage]
    struct Storage {
        message: ByteArray
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.message.write("World!");
    }

    #[abi(embed_v0)]
    impl MessageContract of super::IMessage<ContractState> {
        fn append(ref self: ContractState, str: ByteArray) {
            self.message.write(self.message.read() + str);
        }

        fn prepend(ref self: ContractState, str: ByteArray) {
            self.message.write(str + self.message.read());
        }
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod tests {
    use bytearray::bytearray::{
        MessageContract::messageContractMemberStateTrait, MessageContract, IMessage
    };

    #[test]
    #[available_gas(2000000000)]
    fn message_contract_tests() {
        let mut state = MessageContract::contract_state_for_testing();
        state.message.write("World!");

        let message = state.message.read();
        assert(message == "World!", 'wrong message');

        state.append(" Good day, sir!");
        assert(state.message.read() == "World! Good day, sir!", 'wrong message (append)');

        state.prepend("Hello, ");
        assert(state.message.read() == "Hello, World! Good day, sir!", 'wrong message (prepend)');
    }
}
