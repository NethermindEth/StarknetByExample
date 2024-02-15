// ANCHOR: interface
#[starknet::interface]
pub trait ISwitchCollision<TContractState> {
    fn set(ref self: TContractState, value: bool);
    fn get(ref self: TContractState) -> bool;
}
// ANCHOR_END: interface

#[starknet::contract]
pub mod SwitchCollisionContract {
    use components::switchable::switchable_component;

    component!(path: switchable_component, storage: switch, event: SwitchableEvent);

    #[abi(embed_v0)]
    impl SwitchableImpl = switchable_component::Switchable<ContractState>;
    impl SwitchableInternalImpl = switchable_component::SwitchableInternalImpl<ContractState>;

    // ANCHOR: storage
    #[storage]
    struct Storage {
        switchable_value: bool,
        #[substorage(v0)]
        switch: switchable_component::Storage,
    }
    // ANCHOR_END: storage

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.switch._off();
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        SwitchableEvent: switchable_component::Event,
    }

    #[abi(embed_v0)]
    impl SwitchCollisionContract of super::ISwitchCollision<ContractState> {
        fn set(ref self: ContractState, value: bool) {
            self.switchable_value.write(value);
        }

        fn get(ref self: ContractState) -> bool {
            self.switchable_value.read()
        }
    }
}
