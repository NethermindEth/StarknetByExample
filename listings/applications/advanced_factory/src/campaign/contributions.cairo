use starknet::ContractAddress;

#[starknet::interface]
pub trait IContributable<TContractState> {
    fn add(ref self: TContractState, contributor: ContractAddress, amount: u256);
    fn get(self: @TContractState, contributor: ContractAddress) -> u256;
    fn get_all(self: @TContractState) -> Array<ContractAddress>;
    fn withhold(ref self: TContractState, contributor: ContractAddress);
}

#[starknet::component]
pub mod contributable_component {
    use core::array::ArrayTrait;
    use starknet::{ContractAddress};
    use core::num::traits::Zero;

    #[derive(Drop, Serde, starknet::Store)]
    struct Contribution {
        contributor: ContractAddress,
        amount: u256,
    }

    #[storage]
    struct Storage {
        index_to_contribution: LegacyMap<u32, Contribution>,
        contributor_to_index: LegacyMap<ContractAddress, Option<u32>>,
        total_contributors: u32,
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
            let i_opt: Option<u32> = self.contributor_to_index.read(contributor);
            if let Option::Some(index) = i_opt {
                let old_contr: Contribution = self.index_to_contribution.read(index);
                let new_contr = Contribution { contributor, amount: old_contr.amount + amount };
                self.index_to_contribution.write(index, new_contr);
            } else {
                let index = self.total_contributors.read();
                self.contributor_to_index.write(contributor, Option::Some(index));
                self.index_to_contribution.write(index, Contribution { contributor, amount });
                self.total_contributors.write(index + 1);
            }
        }

        fn get(self: @ComponentState<TContractState>, contributor: ContractAddress) -> u256 {
            let val: Option<u32> = self.contributor_to_index.read(contributor);
            match val {
                Option::Some(index) => {
                    let contr: Contribution = self.index_to_contribution.read(index);
                    contr.amount
                },
                Option::None => 0,
            }
        }

        fn get_all(self: @ComponentState<TContractState>) -> Array<ContractAddress> {
            let mut result = array![];

            let mut index = self.total_contributors.read();
            while index != 0 {
                index -= 1;
                let contr: Contribution = self.index_to_contribution.read(index);
                result.append(contr.contributor);
            };

            result
        }

        fn withhold(ref self: ComponentState<TContractState>, contributor: ContractAddress) {
            let i_opt: Option<u32> = self.contributor_to_index.read(contributor);
            if let Option::Some(index) = i_opt {
                self.contributor_to_index.write(contributor, Option::None);
                self.total_contributors.write(self.total_contributors.read() - 1);
                if self.total_contributors.read() != 0 {
                    let last_contr: Contribution = self
                        .index_to_contribution
                        .read(self.total_contributors.read());
                    self.contributor_to_index.write(last_contr.contributor, Option::Some(index));
                    self.index_to_contribution.write(index, last_contr);
                } else {
                    self
                        .index_to_contribution
                        .write(index, Contribution { contributor: Zero::zero(), amount: 0 });
                }
            }
        }
    }
}

