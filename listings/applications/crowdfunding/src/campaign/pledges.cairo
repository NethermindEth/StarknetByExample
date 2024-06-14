use starknet::ContractAddress;

#[starknet::interface]
pub trait IPledgeable<TContractState> {
    fn add(ref self: TContractState, pledger: ContractAddress, amount: u256);
    fn get(self: @TContractState, pledger: ContractAddress) -> u256;
    fn get_pledges_as_arr(self: @TContractState) -> Array<(ContractAddress, u256)>;
    fn get_total(self: @TContractState) -> u256;
    fn remove(ref self: TContractState, pledger: ContractAddress) -> u256;
}

#[starknet::component]
pub mod pledgeable_component {
    use core::array::ArrayTrait;
    use starknet::{ContractAddress};
    use core::num::traits::Zero;

    #[storage]
    struct Storage {
        index_to_pledger: LegacyMap<u32, ContractAddress>,
        pledger_to_amount_index: LegacyMap<ContractAddress, Option<(u256, u32)>>,
        pledger_count: u32,
        total_amount: u256,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {}

    #[embeddable_as(Pledgeable)]
    pub impl PledgeableImpl<
        TContractState, +HasComponent<TContractState>
    > of super::IPledgeable<ComponentState<TContractState>> {
        fn add(ref self: ComponentState<TContractState>, pledger: ContractAddress, amount: u256) {
            let amount_index_option: Option<(u256, u32)> = self
                .pledger_to_amount_index
                .read(pledger);
            if let Option::Some((old_amount, index)) = amount_index_option {
                self
                    .pledger_to_amount_index
                    .write(pledger, Option::Some((old_amount + amount, index)));
            } else {
                let index = self.pledger_count.read();
                self.index_to_pledger.write(index, pledger);
                self.pledger_to_amount_index.write(pledger, Option::Some((amount, index)));
                self.pledger_count.write(index + 1);
            }
            self.total_amount.write(self.total_amount.read() + amount);
        }

        fn get(self: @ComponentState<TContractState>, pledger: ContractAddress) -> u256 {
            let val: Option<(u256, u32)> = self.pledger_to_amount_index.read(pledger);
            match val {
                Option::Some((amount, _)) => amount,
                Option::None => 0,
            }
        }

        fn get_pledges_as_arr(
            self: @ComponentState<TContractState>
        ) -> Array<(ContractAddress, u256)> {
            let mut result = array![];

            let mut index = self.pledger_count.read();
            while index != 0 {
                index -= 1;
                let pledger = self.index_to_pledger.read(index);
                let amount_index_option: Option<(u256, u32)> = self
                    .pledger_to_amount_index
                    .read(pledger);
                let amount = match amount_index_option {
                    Option::Some((amount, _)) => amount,
                    Option::None => 0
                };
                result.append((pledger, amount));
            };

            result
        }

        fn get_total(self: @ComponentState<TContractState>) -> u256 {
            self.total_amount.read()
        }

        fn remove(ref self: ComponentState<TContractState>, pledger: ContractAddress) -> u256 {
            let amount_index_option: Option<(u256, u32)> = self
                .pledger_to_amount_index
                .read(pledger);

            let amount = if let Option::Some((amount, index)) = amount_index_option {
                self.pledger_to_amount_index.write(pledger, Option::None);
                let new_pledger_count = self.pledger_count.read() - 1;
                self.pledger_count.write(new_pledger_count);
                if new_pledger_count != 0 {
                    let last_pledger = self.index_to_pledger.read(new_pledger_count);
                    let last_amount_index: Option<(u256, u32)> = self
                        .pledger_to_amount_index
                        .read(last_pledger);
                    let last_amount = match last_amount_index {
                        Option::Some((last_amount, _)) => last_amount,
                        Option::None => 0
                    };
                    self
                        .pledger_to_amount_index
                        .write(last_pledger, Option::Some((last_amount, index)));
                    self.index_to_pledger.write(index, last_pledger);
                }

                self.index_to_pledger.write(new_pledger_count, Zero::zero());

                amount
            } else {
                0
            };

            self.total_amount.write(self.total_amount.read() - amount);

            amount
        }
    }
}

