use starknet::ContractAddress;

#[starknet::interface]
pub trait IStakingContract<TContractState> {
    fn set_reward_amount(ref self: TContractState, amount: u256);
    fn set_reward_duration(ref self: TContractState, duration: u256);
    fn stake(ref self: TContractState, amount: u256);
    fn withdraw(ref self: TContractState, amount: u256);
    fn compute_rewards(self: @TContractState, account: ContractAddress) -> u256;
    fn claim_rewards(ref self: TContractState);
}

mod Errors {
    pub const NULL_REWARDS: felt252 = 'Reward amount must be > 0';
    pub const NOT_ENOUGH_REWARDS: felt252 = 'Reward amount must be > balance';
    pub const NULL_AMOUNT: felt252 = 'Amount must be > 0';
    pub const NULL_DURATION: felt252 = 'Duration must be > 0';
    pub const UNFINISHED_DURATION: felt252 = 'Reward duration not finished';
    pub const ZERO_ADDRESS_CALLER: felt252 = 'Caller is the zero address';
    pub const NOT_OWNER: felt252 = 'Caller is not the owner';
}

#[starknet::contract]
pub mod StakingContract {
    use core::traits::Into;
    use core::num::traits::Zero;
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp, get_contract_address};
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

    #[storage]
    struct Storage {
        staking_token: IERC20Dispatcher,
        reward_token: IERC20Dispatcher,
        owner: ContractAddress,
        reward_rate: u256,
        duration: u256,
        current_reward_per_staked_token: u256,
        finish_at: u256,
        // last time an operation (staking / withdrawal / rewards claimed) was registered
        last_updated_at: u256,
        last_user_reward_per_staked_token: LegacyMap::<ContractAddress, u256>,
        unclaimed_rewards: LegacyMap::<ContractAddress, u256>,
        // total amount of staked tokens
        total_supply: u256,
        // amount of staked tokens per user
        balance_of: LegacyMap::<ContractAddress, u256>,
    }

    // TODO: events

    #[constructor]
    fn constructor(
        ref self: ContractState,
        staking_token_address: ContractAddress,
        reward_token_address: ContractAddress,
    ) {
        self.staking_token.write(IERC20Dispatcher { contract_address: staking_token_address });
        self.reward_token.write(IERC20Dispatcher { contract_address: reward_token_address });

        self.owner.write(get_caller_address());
    }

    #[abi(embed_v0)]
    impl StakingContract of super::IStakingContract<ContractState> {
        fn set_reward_duration(ref self: ContractState, duration: u256) {
            self.only_owner();

            assert(duration > 0, super::Errors::NULL_DURATION);

            // can only set duration if the previous duration has already finished
            assert(
                self.finish_at.read() < get_block_timestamp().into(),
                super::Errors::UNFINISHED_DURATION
            );

            self.duration.write(duration);
        }

        fn set_reward_amount(ref self: ContractState, amount: u256) {
            self.only_owner();
            self.update_rewards(Zero::zero());

            assert(amount > 0, super::Errors::NULL_REWARDS);
            assert(self.duration.read() > 0, super::Errors::NULL_DURATION);

            let block_timestamp: u256 = get_block_timestamp().into();

            let rate = if self.finish_at.read() < block_timestamp {
                // TODO: check what the division gives exactly
                amount / self.duration.read()
            } else {
                let remaining_rewards = self.reward_rate.read()
                    * (self.finish_at.read() - block_timestamp);
                (remaining_rewards + amount) / self.duration.read()
            };

            assert(
                self.reward_token.read().balance_of(get_contract_address()) >= rate
                    * self.duration.read(),
                super::Errors::NOT_ENOUGH_REWARDS
            );

            self.reward_rate.write(rate);

            // even if the previous reward duration was not finished, we reset the finish_at variable
            self.finish_at.write(block_timestamp + self.duration.read());
            self.last_updated_at.write(block_timestamp);
        }

        fn stake(ref self: ContractState, amount: u256) {
            assert(amount > 0, super::Errors::NULL_AMOUNT);

            let user = get_caller_address();
            self.update_rewards(user);

            self.balance_of.write(user, self.balance_of.read(user) + amount);
            self.total_supply.write(self.total_supply.read() + amount);
            self.staking_token.read().transfer_from(user, get_contract_address(), amount);
        }

        fn withdraw(ref self: ContractState, amount: u256) {
            assert(amount > 0, super::Errors::NULL_AMOUNT);

            let user = get_caller_address();
            self.update_rewards(user);

            self.balance_of.write(user, self.balance_of.read(user) - amount);
            self.total_supply.write(self.total_supply.read() - amount);
            self.staking_token.read().transfer(user, amount);
        }

        fn compute_rewards(self: @ContractState, account: ContractAddress) -> u256 {
            self.unclaimed_rewards.read(account)
                + self.balance_of.read(account)
                    * (self.current_reward_per_staked_token.read()
                        - self.last_user_reward_per_staked_token.read(account))
        }

        fn claim_rewards(ref self: ContractState) {
            let user = get_caller_address();
            self.update_rewards(user);

            let rewards = self.unclaimed_rewards.read(user);

            if rewards > 0 {
                self.unclaimed_rewards.write(user, 0);
                self.reward_token.read().transfer(user, rewards);
            }
        }
    }

    #[generate_trait]
    impl PrivateFunctions of PrivateFunctionsTrait {
        // call this function every time a user (including owner) performs a state-modifying action
        fn update_rewards(ref self: ContractState, account: ContractAddress) {
            self
                .current_reward_per_staked_token
                .write(self.compute_current_reward_per_staked_token());

            self.last_updated_at.write(self.last_time_applicable());

            if account.is_non_zero() {
                // compute earned rewards since last update for the user `account`
                self.unclaimed_rewards.write(account, self.compute_rewards(account));

                self
                    .last_user_reward_per_staked_token
                    .write(account, self.current_reward_per_staked_token.read());
            }
        }

        fn compute_current_reward_per_staked_token(self: @ContractState) -> u256 {
            if self.total_supply.read() == 0 {
                self.current_reward_per_staked_token.read()
            } else {
                self.current_reward_per_staked_token.read()
                    + self.reward_rate.read()
                        * (self.last_time_applicable() - self.last_updated_at.read())
                        / self.total_supply.read()
            }
        }

        #[inline(always)]
        fn last_time_applicable(self: @ContractState) -> u256 {
            PrivateFunctions::min(self.finish_at.read(), get_block_timestamp().into())
        }

        #[inline(always)]
        fn min(x: u256, y: u256) -> u256 {
            if (x <= y) {
                x
            } else {
                y
            }
        }

        fn only_owner(self: @ContractState) {
            let caller = get_caller_address();
            assert(caller.is_non_zero(), super::Errors::ZERO_ADDRESS_CALLER);
            assert(caller == self.owner.read(), super::Errors::NOT_OWNER);
        }
    }
}
