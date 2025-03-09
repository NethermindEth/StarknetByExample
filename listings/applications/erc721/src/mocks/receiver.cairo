const SUCCESS: felt252 = 'SUCCESS';

#[starknet::contract]
pub mod ERC721ReceiverMock {
    use openzeppelin_introspection::src5::SRC5Component;
    use erc721::interfaces::{IERC721Receiver, IERC721_RECEIVER_ID};
    use starknet::ContractAddress;

    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    // SRC5
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;
    impl SRC5InternalImpl = SRC5Component::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub src5: SRC5Component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        SRC5Event: SRC5Component::Event,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.src5.register_interface(IERC721_RECEIVER_ID);
    }

    #[abi(embed_v0)]
    impl ExternalImpl of IERC721Receiver<ContractState> {
        fn on_erc721_received(
            self: @ContractState,
            operator: ContractAddress,
            from: ContractAddress,
            token_id: u256,
            data: Span<felt252>,
        ) -> felt252 {
            if *data.at(0) == super::SUCCESS {
                IERC721_RECEIVER_ID
            } else {
                0
            }
        }
    }
}
