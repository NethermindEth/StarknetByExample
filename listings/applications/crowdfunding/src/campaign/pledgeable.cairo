// ANCHOR: component
use starknet::ContractAddress;

#[starknet::interface]
pub trait IPledgeable<TContractState> {
    fn add(ref self: TContractState, pledger: ContractAddress, amount: u256);
    fn get(self: @TContractState, pledger: ContractAddress) -> u256;
    fn get_pledger_count(self: @TContractState) -> u32;
    fn array(self: @TContractState) -> Array<ContractAddress>;
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
        pledger_to_amount: LegacyMap<ContractAddress, u256>,
        pledger_count: u32,
        total_amount: u256,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {}

    mod Errors {
        pub const INCONSISTENT_STATE: felt252 = 'Non-indexed pledger found';
    }

    #[embeddable_as(Pledgeable)]
    pub impl PledgeableImpl<
        TContractState, +HasComponent<TContractState>
    > of super::IPledgeable<ComponentState<TContractState>> {
        fn add(ref self: ComponentState<TContractState>, pledger: ContractAddress, amount: u256) {
            let old_amount: u256 = self.pledger_to_amount.read(pledger);

            if old_amount == 0 {
                let index = self.pledger_count.read();
                self.index_to_pledger.write(index, pledger);
                self.pledger_count.write(index + 1);
            }

            self.pledger_to_amount.write(pledger, old_amount + amount);
            self.total_amount.write(self.total_amount.read() + amount);
        }

        fn get(self: @ComponentState<TContractState>, pledger: ContractAddress) -> u256 {
            self.pledger_to_amount.read(pledger)
        }

        fn get_pledger_count(self: @ComponentState<TContractState>) -> u32 {
            self.pledger_count.read()
        }

        fn array(self: @ComponentState<TContractState>) -> Array<ContractAddress> {
            let mut result = array![];

            let mut index = self.pledger_count.read();
            while index != 0 {
                index -= 1;
                let pledger = self.index_to_pledger.read(index);
                result.append(pledger);
            };

            result
        }

        fn get_total(self: @ComponentState<TContractState>) -> u256 {
            self.total_amount.read()
        }

        fn remove(ref self: ComponentState<TContractState>, pledger: ContractAddress) -> u256 {
            let amount: u256 = self.pledger_to_amount.read(pledger);

            // check if the pledge even exists
            if amount == 0 {
                return 0;
            }

            let last_index = self.pledger_count.read() - 1;

            // if there are other pledgers, we need to update our indices
            if last_index != 0 {
                let mut pledger_index = last_index;
                loop {
                    if self.index_to_pledger.read(pledger_index) == pledger {
                        break;
                    }
                    // if pledger_to_amount contains a pledger, then so does index_to_pledger
                    // thus this will never underflow
                    pledger_index -= 1;
                };

                self.index_to_pledger.write(pledger_index, self.index_to_pledger.read(last_index));
            }

            // last_index == new pledger count
            self.pledger_count.write(last_index);
            self.pledger_to_amount.write(pledger, 0);
            self.index_to_pledger.write(last_index, Zero::zero());

            self.total_amount.write(self.total_amount.read() - amount);

            amount
        }
    }
}
// ANCHOR_END: component

#[cfg(test)]
mod tests {
    #[starknet::contract]
    mod MockContract {
        use super::super::pledgeable_component;

        component!(path: pledgeable_component, storage: pledges, event: PledgeableEvent);

        #[storage]
        struct Storage {
            #[substorage(v0)]
            pledges: pledgeable_component::Storage,
        }

        #[event]
        #[derive(Drop, starknet::Event)]
        enum Event {
            PledgeableEvent: pledgeable_component::Event
        }

        #[abi(embed_v0)]
        impl Pledgeable = pledgeable_component::Pledgeable<ContractState>;
    }

    use super::{pledgeable_component, IPledgeableDispatcher, IPledgeableDispatcherTrait};
    use super::pledgeable_component::{PledgeableImpl};
    use starknet::{ContractAddress, contract_address_const};
    use core::num::traits::Zero;

    type TestingState = pledgeable_component::ComponentState<MockContract::ContractState>;

    // You can derive even `Default` on this type alias
    impl TestingStateDefault of Default<TestingState> {
        fn default() -> TestingState {
            pledgeable_component::component_state_for_testing()
        }
    }

    #[test]
    fn test_add() {
        let mut pledgeable: TestingState = Default::default();
        let pledger_1 = contract_address_const::<'pledger_1'>();
        let pledger_2 = contract_address_const::<'pledger_2'>();

        assert_eq!(pledgeable.get_pledger_count(), 0);
        assert_eq!(pledgeable.get_total(), 0);
        assert_eq!(pledgeable.get(pledger_1), 0);
        assert_eq!(pledgeable.get(pledger_2), 0);

        // 1st pledge
        pledgeable.add(pledger_1, 1000);

        assert_eq!(pledgeable.get_pledger_count(), 1);
        assert_eq!(pledgeable.get_total(), 1000);
        assert_eq!(pledgeable.get(pledger_1), 1000);
        assert_eq!(pledgeable.get(pledger_2), 0);

        // 2nd pledge should be added onto 1st
        pledgeable.add(pledger_1, 1000);

        assert_eq!(pledgeable.get_pledger_count(), 1);
        assert_eq!(pledgeable.get_total(), 2000);
        assert_eq!(pledgeable.get(pledger_1), 2000);
        assert_eq!(pledgeable.get(pledger_2), 0);

        // different pledger stored separately
        pledgeable.add(pledger_2, 500);

        assert_eq!(pledgeable.get_pledger_count(), 2);
        assert_eq!(pledgeable.get_total(), 2500);
        assert_eq!(pledgeable.get(pledger_1), 2000);
        assert_eq!(pledgeable.get(pledger_2), 500);
    }

    #[test]
    fn test_add_1000_pledgers() {
        let mut pledgeable: TestingState = Default::default();

        // set up 1000 pledgers
        let expected_pledger_count: u32 = 1000;
        let mut expected_total: u256 = 0; // actual value set up in the while loop
        let mut pledgers: Array::<(ContractAddress, u256)> = array![];

        let mut i: felt252 = expected_pledger_count.into();
        while i != 0 {
            let pledger: ContractAddress = i.try_into().unwrap();
            let amount: u256 = i.into() * 100;
            pledgeable.add(pledger, amount);
            pledgers.append((pledger, amount));
            expected_total += amount;
            i -= 1;
        };

        assert_eq!(pledgeable.get_pledger_count(), expected_pledger_count);
        assert_eq!(pledgeable.get_total(), expected_total);

        while let Option::Some((pledger, expected_amount)) = pledgers
            .pop_front() {
                assert_eq!(pledgeable.get(pledger), expected_amount);
            }
    }

    #[test]
    fn test_add_update_first_of_1000_pledgers() {
        let mut pledgeable: TestingState = Default::default();

        let expected_pledger_count: u32 = 1000;
        let mut expected_total: u256 = 0;

        // set up 1000 pledgers
        let mut i: felt252 = expected_pledger_count.into();
        let first_pledger: ContractAddress = i.try_into().unwrap();
        let first_amount: u256 = i.into() * 100;
        pledgeable.add(first_pledger, first_amount);
        expected_total += first_amount;

        i -= 1;
        while i != 0 {
            let pledger: ContractAddress = i.try_into().unwrap();
            let amount: u256 = i.into() * 100;
            pledgeable.add(pledger, amount);
            expected_total += amount;
            i -= 1;
        };

        // first pledger makes another pledge
        pledgeable.add(first_pledger, 2000);
        expected_total += 2000;
        let expected_amount = first_amount + 2000;

        let amount = pledgeable.get(first_pledger);
        assert_eq!(amount, expected_amount);
        assert_eq!(pledgeable.get_total(), expected_total);
        assert_eq!(pledgeable.get_pledger_count(), expected_pledger_count);
    }

    #[test]
    fn test_add_update_middle_of_1000_pledgers() {
        let mut pledgeable: TestingState = Default::default();

        let expected_pledger_count: u32 = 1000;
        let mut expected_total: u256 = 0;

        // set up 1000 pledgers
        let mut middle_pledger: ContractAddress = Zero::zero();
        let mut middle_amount = 0;

        let mut i: felt252 = 1000;
        while i != 0 {
            let pledger: ContractAddress = i.try_into().unwrap();
            let amount: u256 = i.into() * 100;
            pledgeable.add(pledger, amount);
            expected_total += amount;

            if i == 500 {
                middle_pledger = pledger;
                middle_amount = amount;
            }

            i -= 1;
        };

        // middle pledger makes another pledge
        pledgeable.add(middle_pledger, 2000);
        expected_total += 2000;
        let expected_amount = middle_amount + 2000;

        let amount = pledgeable.get(middle_pledger);
        assert_eq!(amount, expected_amount);
        assert_eq!(pledgeable.get_total(), expected_total);
        assert_eq!(pledgeable.get_pledger_count(), expected_pledger_count);
    }

    #[test]
    fn test_add_update_last_of_1000_pledgers() {
        let mut pledgeable: TestingState = Default::default();

        let expected_pledger_count: u32 = 1000;
        let mut expected_total: u256 = 0;

        // set up 1000 pledgers
        let mut i: felt252 = 1000;
        // remember last pledger, add it after while loop
        let last_pledger: ContractAddress = i.try_into().unwrap();
        let last_amount = 100000;

        i -= 1; // leave place for the last pledger
        while i != 0 {
            let pledger: ContractAddress = i.try_into().unwrap();
            let amount: u256 = i.into() * 100;
            pledgeable.add(pledger, amount);
            expected_total += amount;
            i -= 1;
        };
        // add last pledger
        pledgeable.add(last_pledger, last_amount);
        expected_total += last_amount;

        // last pledger makes another pledge
        pledgeable.add(last_pledger, 2000);
        expected_total += 2000;
        let expected_amount = last_amount + 2000;

        let amount = pledgeable.get(last_pledger);
        assert_eq!(amount, expected_amount);
        assert_eq!(pledgeable.get_total(), expected_total);
        assert_eq!(pledgeable.get_pledger_count(), expected_pledger_count);
    }

    #[test]
    fn test_remove() {
        let mut pledgeable: TestingState = Default::default();
        let pledger_1 = contract_address_const::<'pledger_1'>();
        let pledger_2 = contract_address_const::<'pledger_2'>();
        let pledger_3 = contract_address_const::<'pledger_3'>();

        pledgeable.add(pledger_1, 2000);
        pledgeable.add(pledger_2, 3000);
        // pledger_3 not added

        assert_eq!(pledgeable.get_pledger_count(), 2);
        assert_eq!(pledgeable.get_total(), 5000);
        assert_eq!(pledgeable.get(pledger_1), 2000);
        assert_eq!(pledgeable.get(pledger_2), 3000);
        assert_eq!(pledgeable.get(pledger_3), 0);

        let amount = pledgeable.remove(pledger_1);

        assert_eq!(amount, 2000);
        assert_eq!(pledgeable.get_pledger_count(), 1);
        assert_eq!(pledgeable.get_total(), 3000);
        assert_eq!(pledgeable.get(pledger_1), 0);
        assert_eq!(pledgeable.get(pledger_2), 3000);
        assert_eq!(pledgeable.get(pledger_3), 0);

        let amount = pledgeable.remove(pledger_2);

        assert_eq!(amount, 3000);
        assert_eq!(pledgeable.get_pledger_count(), 0);
        assert_eq!(pledgeable.get_total(), 0);
        assert_eq!(pledgeable.get(pledger_1), 0);
        assert_eq!(pledgeable.get(pledger_2), 0);
        assert_eq!(pledgeable.get(pledger_3), 0);

        // pledger_3 not added, so this should do nothing and return 0
        let amount = pledgeable.remove(pledger_3);

        assert_eq!(amount, 0);
        assert_eq!(pledgeable.get_pledger_count(), 0);
        assert_eq!(pledgeable.get_total(), 0);
        assert_eq!(pledgeable.get(pledger_1), 0);
        assert_eq!(pledgeable.get(pledger_2), 0);
        assert_eq!(pledgeable.get(pledger_3), 0);
    }

    #[test]
    fn test_remove_first_of_1000_pledgers() {
        let mut pledgeable: TestingState = Default::default();

        // set up 1000 pledgers
        let expected_pledger_count: u32 = 1000;
        let mut expected_total: u256 = 0; // actual value set up in the while loop

        let mut i: felt252 = expected_pledger_count.into();
        let first_pledger: ContractAddress = i.try_into().unwrap();
        let first_amount = 100000;
        pledgeable.add(first_pledger, first_amount);
        expected_total += first_amount;
        i -= 1;

        while i != 0 {
            let pledger: ContractAddress = i.try_into().unwrap();
            let amount: u256 = i.into() * 100;
            pledgeable.add(pledger, amount);
            expected_total += amount;
            i -= 1;
        };

        assert_eq!(pledgeable.get_total(), expected_total);
        assert_eq!(pledgeable.get_pledger_count(), expected_pledger_count);
        assert_eq!(pledgeable.get(first_pledger), first_amount);

        let removed_amount = pledgeable.remove(first_pledger);

        expected_total -= first_amount;

        assert_eq!(removed_amount, first_amount);
        assert_eq!(pledgeable.get_total(), expected_total);
        assert_eq!(pledgeable.get_pledger_count(), expected_pledger_count - 1);
        assert_eq!(pledgeable.get(first_pledger), 0);
    }

    #[test]
    fn test_remove_middle_of_1000_pledgers() {
        let mut pledgeable: TestingState = Default::default();

        // set up 1000 pledgers
        let expected_pledger_count: u32 = 1000;
        let mut expected_total: u256 = 0; // actual value set up in the while loop

        let mut middle_pledger: ContractAddress = Zero::zero();
        let mut middle_amount = 0;

        let mut i: felt252 = expected_pledger_count.into();
        while i != 0 {
            let pledger: ContractAddress = i.try_into().unwrap();
            let amount: u256 = i.into() * 100;
            pledgeable.add(pledger, amount);
            expected_total += amount;

            if i == 500 {
                middle_pledger = pledger;
                middle_amount = amount;
            }

            i -= 1;
        };

        assert_eq!(pledgeable.get_total(), expected_total);
        assert_eq!(pledgeable.get_pledger_count(), expected_pledger_count);
        assert_eq!(pledgeable.get(middle_pledger), middle_amount);

        let removed_amount = pledgeable.remove(middle_pledger);

        expected_total -= middle_amount;

        assert_eq!(removed_amount, middle_amount);
        assert_eq!(pledgeable.get_total(), expected_total);
        assert_eq!(pledgeable.get_pledger_count(), expected_pledger_count - 1);
        assert_eq!(pledgeable.get(middle_pledger), 0);
    }

    #[test]
    fn test_remove_last_of_1000_pledgers() {
        let mut pledgeable: TestingState = Default::default();

        // set up 1000 pledgers
        let expected_pledger_count: u32 = 1000;
        let mut expected_total: u256 = 0; // actual value set up in the while loop

        let mut i: felt252 = expected_pledger_count.into();
        let last_pledger: ContractAddress = i.try_into().unwrap();
        let last_amount = 100000;
        i -= 1; // leave place for the last pledger

        while i != 0 {
            let pledger: ContractAddress = i.try_into().unwrap();
            let amount: u256 = i.into() * 100;
            pledgeable.add(pledger, amount);
            expected_total += amount;
            i -= 1;
        };

        // add last pledger        
        pledgeable.add(last_pledger, last_amount);
        expected_total += last_amount;

        assert_eq!(pledgeable.get_total(), expected_total);
        assert_eq!(pledgeable.get_pledger_count(), expected_pledger_count);
        assert_eq!(pledgeable.get(last_pledger), last_amount);

        let removed_amount = pledgeable.remove(last_pledger);

        expected_total -= last_amount;

        assert_eq!(removed_amount, last_amount);
        assert_eq!(pledgeable.get_total(), expected_total);
        assert_eq!(pledgeable.get_pledger_count(), expected_pledger_count - 1);
        assert_eq!(pledgeable.get(last_pledger), 0);
    }

    #[test]
    fn test_array() {
        let mut pledgeable: TestingState = Default::default();
        let pledger_1 = contract_address_const::<'pledger_1'>();
        let pledger_2 = contract_address_const::<'pledger_2'>();
        let pledger_3 = contract_address_const::<'pledger_3'>();

        pledgeable.add(pledger_1, 1000);
        pledgeable.add(pledger_2, 500);
        pledgeable.add(pledger_3, 2500);
        // 2nd pledge by pledger_2 *should not* increase the pledge count
        pledgeable.add(pledger_2, 1500);

        let pledgers_arr = pledgeable.array();

        assert_eq!(pledgers_arr.len(), 3);
        assert_eq!(pledger_3, *pledgers_arr[0]);
        assert_eq!(2500, pledgeable.get(*pledgers_arr[0]));
        assert_eq!(pledger_2, *pledgers_arr[1]);
        assert_eq!(2000, pledgeable.get(*pledgers_arr[1]));
        assert_eq!(pledger_1, *pledgers_arr[2]);
        assert_eq!(1000, pledgeable.get(*pledgers_arr[2]));
    }

    #[test]
    fn test_array_1000_pledgers() {
        let mut pledgeable: TestingState = Default::default();

        // set up 1000 pledgers
        let mut pledgers: Array::<ContractAddress> = array![];
        let mut i: felt252 = 1000;
        while i != 0 {
            let pledger: ContractAddress = i.try_into().unwrap();
            let amount: u256 = i.into() * 100;
            pledgeable.add(pledger, amount);
            pledgers.append(pledger);
            i -= 1;
        };

        let pledgers_arr: Array::<ContractAddress> = pledgeable.array();

        assert_eq!(pledgers_arr.len(), pledgers.len());

        let mut i = 1000;
        while let Option::Some(expected_pledger) = pledgers
            .pop_front() {
                i -= 1;
                // pledgers are fetched in reversed order
                let actual_pledger: ContractAddress = *pledgers_arr.at(i);
                assert_eq!(expected_pledger, actual_pledger);
            }
    }

    #[test]
    fn test_get() {
        let mut pledgeable: TestingState = Default::default();
        let pledger_1 = contract_address_const::<'pledger_1'>();
        let pledger_2 = contract_address_const::<'pledger_2'>();
        let pledger_3 = contract_address_const::<'pledger_3'>();

        pledgeable.add(pledger_1, 1000);
        pledgeable.add(pledger_2, 500);
        // pledger_3 not added

        assert_eq!(pledgeable.get(pledger_1), 1000);
        assert_eq!(pledgeable.get(pledger_2), 500);
        assert_eq!(pledgeable.get(pledger_3), 0);
    }
}

