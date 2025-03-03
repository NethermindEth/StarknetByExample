mod tests {
    use openzeppelin_token::erc20::interface::IERC20DispatcherTrait;
    use openzeppelin_token::erc20::erc20::ERC20Component::InternalTrait;
    use staking::contract::IStakingContractDispatcherTrait;
    use staking::tests::tokens::{RewardToken, StakingToken};
    use staking::contract::{
        StakingContract, IStakingContractDispatcher, StakingContract::Event,
        StakingContract::Deposit, StakingContract::Withdrawal, StakingContract::RewardsFinished,
    };
    use openzeppelin_token::erc20::{interface::IERC20Dispatcher};
    use starknet::syscalls::deploy_syscall;
    use core::serde::Serde;
    use starknet::testing::{set_contract_address, set_block_timestamp, pop_log};
    use starknet::{contract_address_const, ContractAddress};
    use starknet::storage::{StoragePointerReadAccess, StorageMapReadAccess};

    #[derive(Copy, Drop)]
    struct Deployment {
        contract: IStakingContractDispatcher,
        staking_token: IERC20Dispatcher,
        reward_token: IERC20Dispatcher,
    }

    fn deploy_util(class_hash: felt252, calldata: Array<felt252>) -> ContractAddress {
        let (address, _) = deploy_syscall(class_hash.try_into().unwrap(), 0, calldata.span(), false)
            .unwrap();

        address
    }

    fn deploy_erc20(
        class_hash: felt252, name: ByteArray, symbol: ByteArray,
    ) -> (ContractAddress, IERC20Dispatcher) {
        let supply: u256 = 1000000;
        let recipient = contract_address_const::<'recipient'>();

        let mut call_data: Array<felt252> = ArrayTrait::new();
        Serde::serialize(@name, ref call_data);
        Serde::serialize(@symbol, ref call_data);
        Serde::serialize(@supply, ref call_data);
        Serde::serialize(@recipient, ref call_data);

        let address = deploy_util(class_hash, call_data);
        (address, IERC20Dispatcher { contract_address: address })
    }

    fn deploy_staking_contract(
        staking_token_address: ContractAddress, reward_token_address: ContractAddress,
    ) -> (ContractAddress, IStakingContractDispatcher) {
        let mut calldata: Array<felt252> = array![];
        calldata.append(staking_token_address.into());
        calldata.append(reward_token_address.into());

        let staking_contract_address = deploy_util(StakingContract::TEST_CLASS_HASH, calldata);
        (
            staking_contract_address,
            IStakingContractDispatcher { contract_address: staking_contract_address },
        )
    }

    fn setup() -> Deployment {
        let (staking_token_address, staking_token) = deploy_erc20(
            StakingToken::TEST_CLASS_HASH, "StakingToken", "StakingTKN",
        );
        let (reward_token_address, reward_token) = deploy_erc20(
            RewardToken::TEST_CLASS_HASH, "RewardToken", "RewardTKN",
        );

        let (_, staking_contract) = deploy_staking_contract(
            staking_token_address, reward_token_address,
        );

        Deployment { contract: staking_contract, staking_token, reward_token }
    }

    fn mint_and_approve_staking_tokens_to(
        recipient: ContractAddress, amount: u256, deploy: Deployment, value_to_approve: u256,
    ) {
        // mint tokens
        let mut state = StakingToken::contract_state_for_testing();
        // pretend as if we were in the deployed staking token contract
        set_contract_address(deploy.staking_token.contract_address);
        state.erc20.mint(recipient, amount);

        // approve staking contract to spend user's tokens
        set_contract_address(recipient);
        deploy.staking_token.approve(deploy.contract.contract_address, value_to_approve);
    }

    fn mint_reward_tokens_to(
        deployed_contract: ContractAddress, amount: u256, reward_token_address: ContractAddress,
    ) {
        // mint tokens
        let mut state = RewardToken::contract_state_for_testing();
        // pretend as if we were in the deployed reward token contract
        set_contract_address(reward_token_address);
        state.erc20.mint(deployed_contract, amount);
    }

    #[test]
    fn should_deploy() {
        /// setup
        let owner = contract_address_const::<'owner'>();
        set_contract_address(owner);

        /// when
        let deploy = setup();

        // "link" a new StakingContract struct to the deployed StakingContract contract
        // in order to access its internal state fields for assertions
        let state = @StakingContract::contract_state_for_testing();
        // pretend as if we were in the deployed contract
        set_contract_address(deploy.contract.contract_address);

        /// then
        assert_eq!(state.owner.read(), owner);
        assert_eq!(
            state.staking_token.read().contract_address, deploy.staking_token.contract_address,
        );
        assert_eq!(
            state.reward_token.read().contract_address, deploy.reward_token.contract_address,
        );
    }

    #[test]
    fn stake_and_withdraw_succeed() {
        /// set up

        // deploy
        let owner = contract_address_const::<'owner'>();
        set_contract_address(owner);
        let deploy = setup();

        // mint staking tokens to a user
        let user = contract_address_const::<'user'>();
        let stake_amount = 40;
        let amount_tokens_minted = 100;
        mint_and_approve_staking_tokens_to(user, amount_tokens_minted, deploy, stake_amount);

        /// when - staking
        set_contract_address(user);
        deploy.contract.stake(stake_amount);

        /// then
        // so far the user has 60 tokens left and staked 40 tokens
        let state = @StakingContract::contract_state_for_testing();
        set_contract_address(deploy.contract.contract_address);
        assert_eq!(state.balance_of.read(user), stake_amount);
        assert_eq!(state.total_supply.read(), stake_amount);
        assert_eq!(deploy.staking_token.balance_of(user), amount_tokens_minted - stake_amount);

        // check 1st & 2nd event - when user stakes
        assert_eq!(
            pop_log(deploy.contract.contract_address),
            Option::Some(Event::RewardsFinished(RewardsFinished { msg: 'Rewards not active yet' })),
        );
        assert_eq!(
            pop_log(deploy.contract.contract_address),
            Option::Some(Event::Deposit(Deposit { user, amount: stake_amount })),
        );

        /// when - withdrawal
        set_contract_address(user);
        let withdrawal_amount = 20;
        deploy.contract.withdraw(withdrawal_amount);

        /// then
        // at the end the user has 80 tokens left and 20 tokens staked
        let state = @StakingContract::contract_state_for_testing();
        set_contract_address(deploy.contract.contract_address);
        assert_eq!(state.balance_of.read(user), stake_amount - withdrawal_amount);
        assert_eq!(state.total_supply.read(), stake_amount - withdrawal_amount);
        assert_eq!(
            deploy.staking_token.balance_of(user),
            amount_tokens_minted - stake_amount + withdrawal_amount,
        );

        // check 3rd & 4th events - when user withdraws
        assert_eq!(
            pop_log(deploy.contract.contract_address),
            Option::Some(Event::RewardsFinished(RewardsFinished { msg: 'Rewards not active yet' })),
        );
        assert_eq!(
            pop_log(deploy.contract.contract_address),
            Option::Some(Event::Withdrawal(Withdrawal { user, amount: withdrawal_amount })),
        );
    }

    #[test]
    fn claim_rewards_3_users_scenario() {
        /// set up

        // deploy
        let owner = contract_address_const::<'owner'>();
        set_contract_address(owner);
        let deploy = setup();

        // mint reward tokens to the deployed contract
        let reward_tokens_amount = 1000;
        mint_reward_tokens_to(
            deploy.contract.contract_address,
            reward_tokens_amount,
            deploy.reward_token.contract_address,
        );

        // owner sets up rewards duration and amount
        let block_timestamp: u256 = 1000;
        set_block_timestamp(block_timestamp.try_into().unwrap());
        let reward_duration = 100;
        // have to set again the contract_address because it got changed in mint_reward_tokens_to
        // function
        set_contract_address(owner);
        deploy.contract.set_reward_duration(reward_duration);
        deploy.contract.set_reward_amount(reward_tokens_amount);

        // check reward rate, last updated at and finish dates
        let state = @StakingContract::contract_state_for_testing();
        set_contract_address(deploy.contract.contract_address);
        assert_eq!(state.reward_rate.read(), reward_tokens_amount / reward_duration);
        assert_eq!(state.finish_at.read(), block_timestamp + reward_duration);
        assert_eq!(state.last_updated_at.read(), block_timestamp);

        // mint staking tokens to alice
        let alice = contract_address_const::<'alice'>();
        let alice_stake_amount = 40;
        let alice_amount_tokens_minted = 100;
        mint_and_approve_staking_tokens_to(
            alice, alice_amount_tokens_minted, deploy, alice_stake_amount,
        );

        // alice stakes
        set_contract_address(alice);
        deploy.contract.stake(alice_stake_amount);

        // timestamp = 1000
        // r0 = 0
        // last updated at = 1000
        // last RPST (reward per staked token) for alice = r0 = 0
        // total supply = 40

        // mint staking tokens to bob
        let bob = contract_address_const::<'bob'>();
        let bob_stake_amount = 10;
        let bob_amount_tokens_minted = 100;
        mint_and_approve_staking_tokens_to(bob, bob_amount_tokens_minted, deploy, bob_stake_amount);

        // bob stakes
        set_contract_address(bob);
        set_block_timestamp(block_timestamp.try_into().unwrap() + 20);
        deploy.contract.stake(bob_stake_amount);

        // timestamp = 1020
        // r1 = r0 + 10 * (1020 - 1000) / 40 = 5
        // last updated at = 1020
        // last RPST for alice = r0 = 0
        // last RPST for bob = r1 = 5
        // total supply = 50

        // mint staking tokens to john
        let john = contract_address_const::<'john'>();
        let john_stake_amount = 30;
        let john_amount_tokens_minted = 100;
        mint_and_approve_staking_tokens_to(
            john, john_amount_tokens_minted, deploy, john_stake_amount,
        );

        // john stakes
        set_contract_address(john);
        set_block_timestamp(block_timestamp.try_into().unwrap() + 30);
        deploy.contract.stake(john_stake_amount);

        // timestamp = 1030
        // r2 = r1 + 10 * (1030 - 1020) / 50 = 7
        // last updated at = 1030
        // last RPST for alice = r0 = 0
        // last RPST for bob = r1 = 5
        // last RPST for john = r2 = 7
        // total supply = 80

        // bob withdraws
        set_contract_address(bob);
        set_block_timestamp(block_timestamp.try_into().unwrap() + 50);
        deploy.contract.withdraw(bob_stake_amount);

        // timestamp = 1050
        // r3 = r2 + 10 * (1050 - 1030) / 80 = 7 + 2 (< 2.5) = 9
        // last updated at = 1050
        // bob rewards = 0 + staked_tokens * (r3 - r1) = 10 * (9 - 5) = 40
        // last RPST for alice = r0 = 0
        // last RPST for bob = r3 = 9
        // last RPST for john = r2 = 7
        // total supply = 70

        // john withdraws some of its staked tokens
        set_contract_address(john);
        set_block_timestamp(block_timestamp.try_into().unwrap() + 80);
        deploy.contract.withdraw(john_stake_amount - 10);

        // timestamp = 1080
        // r4 = r3 + 10 * (1080 - 1050) / 70 = 9 + 4 (< 4.2857...) = 13
        // last updated at = 1080
        // bob rewards = 40
        // john rewards = 0 + staked_tokens * (r4 - r2) = 30 * (13 - 7) = 180
        // last RPST for alice = r0 = 0
        // last RPST for bob = r3 = 9
        // last RPST for john = r4 = 13
        // total supply = 50

        // alice withdraws
        set_contract_address(alice);
        set_block_timestamp(block_timestamp.try_into().unwrap() + 90);
        deploy.contract.withdraw(alice_stake_amount);

        // timestamp = 1090
        // r5 = r4 + 10 * (1090 - 1080) / 50 = 13 + 2 = 15
        // last updated at = 1090
        // alice rewards = 0 + staked_tokens * (r5 - r0) = 40 * (15 - 0) = 600
        // bob rewards = 40
        // john rewards = 180
        // last RPST for alice = r5 = 15
        // last RPST for bob = r3 = 9
        // last RPST for john = r4 = 13
        // total supply = 10

        /// when

        // timestamp after the duration is finished
        set_block_timestamp(
            block_timestamp.try_into().unwrap() + reward_duration.try_into().unwrap() + 10,
        );

        // alice claims
        deploy.contract.claim_rewards();

        // bob claims
        set_contract_address(bob);
        deploy.contract.claim_rewards();

        // john claims
        set_contract_address(john);
        deploy.contract.claim_rewards();

        // timestamp = 1110
        // r6 = r5 + 10 * (1100 - 1090) / 10 = 15 + 10 = 25
        // last updated at = 1100 (becomes same as finish_at)
        // alice rewards = 600 + staked_tokens * (r6 - r5) = 600 + 0 * (25 - 15) = 600 -> 0
        // (claimed)
        // bob rewards = 40 + staked_tokens * (r6 - r3) = 40 + 0 * (25 - 9) = 40 -> 0 (claimed)
        // john rewards = 180 + staked_tokens * (r6 - r4) = 180 + 10 * (25 - 13) = 300 -> 0
        // (claimed)
        // last RPST for alice = r6 = 25
        // last RPST for bob = r6 = 25
        // last RPST for john = r6 = 25
        // total supply = 10

        /// then

        let state = @StakingContract::contract_state_for_testing();
        set_contract_address(deploy.contract.contract_address);

        // check amount of unclaimed reward tokens for each user
        assert(state.unclaimed_rewards.read(alice) == 0, 'Alice: unclaimed rewards');
        assert(state.unclaimed_rewards.read(bob) == 0, 'Bob: unclaimed rewards');
        assert(state.unclaimed_rewards.read(john) == 0, 'John: unclaimed rewards');

        // check amount of staked tokens left in contract for each user
        assert(state.balance_of.read(alice) == 0, 'Alice: staked tokens left');
        assert(state.balance_of.read(bob) == 0, 'Bob: staked tokens left');
        assert(state.balance_of.read(john) == 10, 'John: wrong staked tokens');

        // check amount of reward tokens for each user
        let alice_rewards = deploy.reward_token.balance_of(alice);
        let bob_rewards = deploy.reward_token.balance_of(bob);
        let john_rewards = deploy.reward_token.balance_of(john);
        let deployed_contract_rewards = deploy
            .reward_token
            .balance_of(deploy.contract.contract_address);
        assert_eq!(alice_rewards, 600);
        assert_eq!(bob_rewards, 40);
        assert_eq!(john_rewards, 300);
        // 1000 - 600 - 40 - 300 = 60
        assert_eq!(deployed_contract_rewards, 60);

        // check amount of staking tokens each user has back in their balance
        let alice_staking_tokens = deploy.staking_token.balance_of(alice);
        let bob_staking_tokens = deploy.staking_token.balance_of(bob);
        let john_staking_tokens = deploy.staking_token.balance_of(john);
        assert_eq!(alice_staking_tokens, alice_amount_tokens_minted);
        assert_eq!(bob_staking_tokens, bob_amount_tokens_minted);
        assert_eq!(john_staking_tokens, john_amount_tokens_minted - 10);
    }

    #[test]
    fn all_rewards_distributed_event() {
        /// set up

        // deploy
        let owner = contract_address_const::<'owner'>();
        set_contract_address(owner);
        let deploy = setup();

        // mint reward tokens to the deployed contract
        let reward_tokens_amount = 1000;
        mint_reward_tokens_to(
            deploy.contract.contract_address,
            reward_tokens_amount,
            deploy.reward_token.contract_address,
        );

        // owner sets up rewards duration and amount
        let block_timestamp: u256 = 1000;
        set_block_timestamp(block_timestamp.try_into().unwrap());
        let reward_duration = 100;
        // have to set again the contract_address because it got changed in mint_reward_tokens_to
        // function
        set_contract_address(owner);
        deploy.contract.set_reward_duration(reward_duration);
        deploy.contract.set_reward_amount(reward_tokens_amount);

        // mint staking tokens to alice
        let alice = contract_address_const::<'alice'>();
        let alice_stake_amount = 100;
        mint_and_approve_staking_tokens_to(alice, alice_stake_amount, deploy, alice_stake_amount);

        // alice stakes
        set_contract_address(alice);
        deploy.contract.stake(alice_stake_amount);

        // alice claims her rewards after the duration is over
        set_block_timestamp(
            block_timestamp.try_into().unwrap() + reward_duration.try_into().unwrap(),
        );
        deploy.contract.claim_rewards();

        /// when

        // mint staking tokens to bob
        let bob = contract_address_const::<'bob'>();
        let bob_stake_amount = 50;
        mint_and_approve_staking_tokens_to(bob, bob_stake_amount, deploy, bob_stake_amount);

        // bob stakes
        set_contract_address(bob);
        deploy.contract.stake(bob_stake_amount);

        /// then

        // check 1st event - when alice stakes
        assert_eq!(
            pop_log(deploy.contract.contract_address),
            Option::Some(Event::Deposit(Deposit { user: alice, amount: alice_stake_amount })),
        );
        // check 2nd event - when alice claims
        assert_eq!(
            pop_log(deploy.contract.contract_address),
            Option::Some(
                Event::RewardsFinished(RewardsFinished { msg: 'Rewards all distributed' }),
            ),
        );
        // check 3rd & 4th events - when bob stakes
        assert_eq!(
            pop_log(deploy.contract.contract_address),
            Option::Some(
                Event::RewardsFinished(RewardsFinished { msg: 'Rewards all distributed' }),
            ),
        );
        assert_eq!(
            pop_log(deploy.contract.contract_address),
            Option::Some(Event::Deposit(Deposit { user: bob, amount: bob_stake_amount })),
        );
    }

    #[test]
    fn set_up_reward_complex() {
        /// Set up

        // deploy
        let owner = contract_address_const::<'owner'>();
        set_contract_address(owner);
        let deploy = setup();

        // mint reward tokens to the deployed contract
        let reward_tokens_amount = 1000;
        mint_reward_tokens_to(
            deploy.contract.contract_address,
            reward_tokens_amount,
            deploy.reward_token.contract_address,
        );

        // owner sets up rewards duration and amount
        let block_timestamp: u256 = 1000;
        set_block_timestamp(block_timestamp.try_into().unwrap());
        let reward_duration = 100;
        let initial_reward = 400;
        // have to set again the contract_address because it got changed in mint_reward_tokens_to
        // function
        set_contract_address(owner);
        deploy.contract.set_reward_duration(reward_duration);
        deploy.contract.set_reward_amount(initial_reward);

        // middle check
        let state = @StakingContract::contract_state_for_testing();
        set_contract_address(deploy.contract.contract_address);

        // timestamp = 1000
        // finish_at = 1100
        // reward_rate = 400 / 100 = 4 tokens/timestamp_unit

        assert_eq!(state.finish_at.read(), block_timestamp + reward_duration);
        assert_eq!(state.last_updated_at.read(), block_timestamp);
        assert_eq!(state.reward_rate.read(), 4);

        /// When

        // in the middle of the duration, the owner adds some rewards
        let middle_timestamp = block_timestamp + 50;
        set_block_timestamp(middle_timestamp.try_into().unwrap());
        let rewards_to_add = 300;
        set_contract_address(owner);
        deploy.contract.set_reward_amount(rewards_to_add);

        /// Then

        // timestamp = 1050
        // old_finish_at = 1100
        // old_reward_rate = 4
        // remaining_rewards = 4 * (1100 - 1050) = 200 tokens
        // new_reward_rate = (200 + 300) / 100 = 5
        // new_finish_at = 1050 + 100 = 1150

        let state = @StakingContract::contract_state_for_testing();
        set_contract_address(deploy.contract.contract_address);

        // the finish_at date is reset
        assert_eq!(state.finish_at.read(), middle_timestamp + reward_duration);
        assert_eq!(state.last_updated_at.read(), middle_timestamp);
        assert_eq!(state.reward_rate.read(), 5);
    }
}
