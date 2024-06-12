use starknet::ContractAddress;

#[starknet::interface]
pub trait IContributable<TContractState> {
    fn add(ref self: TContractState, contributor: ContractAddress, amount: u256);
    fn get(self: @TContractState, contributor: ContractAddress) -> u256;
    fn get_contributions_as_arr(self: @TContractState) -> Array<(ContractAddress, u256)>;
    fn remove(ref self: TContractState, contributor: ContractAddress) -> u256;
}

#[starknet::component]
pub mod contributable_component {
    use core::array::ArrayTrait;
    use starknet::{ContractAddress};
    use core::num::traits::Zero;

    #[storage]
    struct Storage {
        index_to_contributor: LegacyMap<u32, ContractAddress>,
        contributor_to_amount_index: LegacyMap<ContractAddress, Option<(u256, u32)>>,
        contributor_count: u32,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {}

    #[embeddable_as(Contributable)]
    pub impl ContributableImpl<
        TContractState, +HasComponent<TContractState>
    > of super::IContributable<ComponentState<TContractState>> {
        fn add(
            ref self: ComponentState<TContractState>, contributor: ContractAddress, amount: u256
        ) {
            let amount_index_option: Option<(u256, u32)> = self
                .contributor_to_amount_index
                .read(contributor);
            if let Option::Some((old_amount, index)) = amount_index_option {
                self
                    .contributor_to_amount_index
                    .write(contributor, Option::Some((old_amount + amount, index)));
            } else {
                let index = self.contributor_count.read();
                self.index_to_contributor.write(index, contributor);
                self.contributor_to_amount_index.write(contributor, Option::Some((amount, index)));
                self.contributor_count.write(index + 1);
            }
        }

        fn get(self: @ComponentState<TContractState>, contributor: ContractAddress) -> u256 {
            let val: Option<(u256, u32)> = self.contributor_to_amount_index.read(contributor);
            match val {
                Option::Some((amount, _)) => amount,
                Option::None => 0,
            }
        }

        fn get_contributions_as_arr(
            self: @ComponentState<TContractState>
        ) -> Array<(ContractAddress, u256)> {
            let mut result = array![];

            let mut index = self.contributor_count.read();
            while index != 0 {
                index -= 1;
                let contributor = self.index_to_contributor.read(index);
                let amount_index_option: Option<(u256, u32)> = self
                    .contributor_to_amount_index
                    .read(contributor);
                let amount = match amount_index_option {
                    Option::Some((amount, _)) => amount,
                    Option::None => 0
                };
                result.append((contributor, amount));
            };

            result
        }

        fn remove(ref self: ComponentState<TContractState>, contributor: ContractAddress) -> u256 {
            let amount_index_option: Option<(u256, u32)> = self
                .contributor_to_amount_index
                .read(contributor);
            if let Option::Some((amount, index)) = amount_index_option {
                self.contributor_to_amount_index.write(contributor, Option::None);
                let contributor_count = self.contributor_count.read() - 1;
                self.contributor_count.write(contributor_count);
                if contributor_count != 0 {
                    let last_contributor = self.index_to_contributor.read(contributor_count);
                    let last_amount_index: Option<(u256, u32)> = self
                        .contributor_to_amount_index
                        .read(last_contributor);
                    let last_amount = match last_amount_index {
                        Option::Some((last_amount, _)) => last_amount,
                        Option::None => 0
                    };
                    self
                        .contributor_to_amount_index
                        .write(last_contributor, Option::Some((last_amount, index)));
                    self.index_to_contributor.write(index, last_contributor);
                }

                self.index_to_contributor.write(contributor_count, Zero::zero());

                amount
            } else {
                0
            }
        }
    }
}

