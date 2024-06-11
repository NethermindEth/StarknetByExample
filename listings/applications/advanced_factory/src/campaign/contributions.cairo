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
        idx_to_contributor: LegacyMap<u32, ContractAddress>,
        contributor_to_amt_idx: LegacyMap<ContractAddress, Option<(u256, u32)>>,
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
            let amt_idx_opt: Option<(u256, u32)> = self.contributor_to_amt_idx.read(contributor);
            if let Option::Some((old_amount, idx)) = amt_idx_opt {
                self
                    .contributor_to_amt_idx
                    .write(contributor, Option::Some((old_amount + amount, idx)));
            } else {
                let idx = self.contributor_count.read();
                self.idx_to_contributor.write(idx, contributor);
                self.contributor_to_amt_idx.write(contributor, Option::Some((amount, idx)));
                self.contributor_count.write(idx + 1);
            }
        }

        fn get(self: @ComponentState<TContractState>, contributor: ContractAddress) -> u256 {
            let val: Option<(u256, u32)> = self.contributor_to_amt_idx.read(contributor);
            match val {
                Option::Some((amt, _)) => amt,
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
                let contr = self.idx_to_contributor.read(index);
                let amt_idx_opt: Option<(u256, u32)> = self.contributor_to_amt_idx.read(contr);
                let amount = match amt_idx_opt {
                    Option::Some((amt, _)) => amt,
                    Option::None => 0
                };
                result.append((contr, amount));
            };

            result
        }

        fn remove(ref self: ComponentState<TContractState>, contributor: ContractAddress) -> u256 {
            let amt_idx_opt: Option<(u256, u32)> = self.contributor_to_amt_idx.read(contributor);
            if let Option::Some((amt, idx)) = amt_idx_opt {
                self.contributor_to_amt_idx.write(contributor, Option::None);
                let contributor_count = self.contributor_count.read() - 1;
                self.contributor_count.write(contributor_count);
                if contributor_count != 0 {
                    let last_contributor = self.idx_to_contributor.read(contributor_count);
                    let last_amt_idx: Option<(u256, u32)> = self
                        .contributor_to_amt_idx
                        .read(last_contributor);
                    let last_amt = match last_amt_idx {
                        Option::Some((l_a, _)) => l_a,
                        Option::None => 0
                    };
                    self
                        .contributor_to_amt_idx
                        .write(last_contributor, Option::Some((last_amt, idx)));
                    self.idx_to_contributor.write(idx, last_contributor);
                }

                self.idx_to_contributor.write(contributor_count, Zero::zero());

                amt
            } else {
                0
            }
        }
    }
}

