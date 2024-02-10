#[starknet::interface]
pub trait ICountable<TContractState> {
    fn get(self: @TContractState) -> u32;
    fn increment(ref self: TContractState);
}

#[starknet::component]
pub mod countable_component {
    #[storage]
    struct Storage {
        countable_value: u32,
    }

    #[embeddable_as(Countable)]
    impl CountableImpl<
        TContractState, +HasComponent<TContractState>
    > of super::ICountable<ComponentState<TContractState>> {
        fn get(self: @ComponentState<TContractState>) -> u32 {
            self.countable_value.read()
        }

        fn increment(ref self: ComponentState<TContractState>) {
            self.countable_value.write(self.countable_value.read() + 1);
        }
    }
}
