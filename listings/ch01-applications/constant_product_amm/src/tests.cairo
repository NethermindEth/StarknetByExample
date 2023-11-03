mod tests {
    use core::option::OptionTrait;
    use core::traits::TryInto;
    use openzeppelin::token::erc20::{
        ERC20, interface::IERC20Dispatcher, interface::IERC20DispatcherTrait
    };
    use openzeppelin::utils::serde::SerializedAppend;
    use openzeppelin::tests::utils;

    use constant_product_amm::contracts::{
        ConstantProductAmm, IConstantProductAmmDispatcher, IConstantProductAmmDispatcherTrait
    };
    use starknet::{
        deploy_syscall, ContractAddress, get_caller_address, get_contract_address,
        contract_address_const
    };
    use starknet::testing::set_contract_address;
    use starknet::class_hash::Felt252TryIntoClassHash;

    use debug::PrintTrait;

    const BANK: felt252 = 0x123;
    const INITIAL_SUPPLY: u256 = 10_000;

    #[derive(Drop, Copy)]
    struct Deployment {
        contract: IConstantProductAmmDispatcher,
        token0: IERC20Dispatcher,
        token1: IERC20Dispatcher
    }

    fn deploy_erc20(
        name: felt252, symbol: felt252, recipient: ContractAddress, initial_supply: u256
    ) -> (ContractAddress, IERC20Dispatcher) {
        let mut calldata = array![];
        calldata.append_serde(name);
        calldata.append_serde(symbol);
        calldata.append_serde(initial_supply);
        calldata.append_serde(recipient);

        let address = utils::deploy(ERC20::TEST_CLASS_HASH, calldata);
        (address, IERC20Dispatcher { contract_address: address })
    }

    fn setup() -> Deployment {
        let recipient: ContractAddress = BANK.try_into().unwrap();
        let (token0_address, token0) = deploy_erc20('Token0', 'T0', recipient, INITIAL_SUPPLY);
        let (token1_address, token1) = deploy_erc20('Token1', 'T1', recipient, INITIAL_SUPPLY);

        // 0.3% fee
        let fee: u16 = 3;

        let mut calldata: Array::<felt252> = array![];
        calldata.append(token0_address.into());
        calldata.append(token1_address.into());
        calldata.append(fee.into());

        let (contract_address, _) = starknet::deploy_syscall(
            ConstantProductAmm::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();
        // Or with OpenZeppelin helper:
        // let contract_address = utils::deploy(ConstantProductAmm::TEST_CLASS_HASH, calldata);
        Deployment { contract: IConstantProductAmmDispatcher { contract_address }, token0, token1 }
    }

    fn add_liquidity(deploy: Deployment, amount: u256) -> u256 {
        assert(amount <= INITIAL_SUPPLY, 'amount > INITIAL_SUPPLY');

        let provider: ContractAddress = BANK.try_into().unwrap();
        set_contract_address(provider);

        deploy.token0.approve(deploy.contract.contract_address, amount);
        deploy.token1.approve(deploy.contract.contract_address, amount);

        deploy.contract.add_liquidity(amount, amount)
    }

    #[test]
    #[available_gas(20000000)]
    fn should_deploy() {
        let deploy = setup();
        let bank: ContractAddress = BANK.try_into().unwrap();

        assert(deploy.token0.balance_of(bank) == INITIAL_SUPPLY, 'Wrong balance token0');
        assert(deploy.token1.balance_of(bank) == INITIAL_SUPPLY, 'Wrong balance token1');
    }

    #[test]
    #[available_gas(20000000)]
    fn should_add_liquidity() {
        let deploy = setup();
        let shares = add_liquidity(deploy, INITIAL_SUPPLY / 2);

        let provider: ContractAddress = BANK.try_into().unwrap();
        assert(deploy.token0.balance_of(provider) == INITIAL_SUPPLY / 2, 'Wrong balance token0');
        assert(deploy.token1.balance_of(provider) == INITIAL_SUPPLY / 2, 'Wrong balance token1');
        assert(shares > 0, 'Wrong shares');
    }

    #[test]
    #[available_gas(20000000)]
    fn should_remove_liquidity() {
        let deploy = setup();
        let shares = add_liquidity(deploy, INITIAL_SUPPLY / 2);
        let provider: ContractAddress = BANK.try_into().unwrap();

        deploy.contract.remove_liquidity(shares);

        assert(deploy.token0.balance_of(provider) == INITIAL_SUPPLY, 'Wrong balance token0');
        assert(deploy.token1.balance_of(provider) == INITIAL_SUPPLY, 'Wrong balance token1');
    }

    #[test]
    #[available_gas(20000000)]
    fn should_swap() {
        let deploy = setup();
        let shares = add_liquidity(deploy, INITIAL_SUPPLY / 2);

        let provider: ContractAddress = BANK.try_into().unwrap();
        let user = contract_address_const::<0x1>();

        // Provider send some token0 to user
        set_contract_address(provider);
        let amount = deploy.token0.balance_of(provider) / 2;
        deploy.token0.transfer(user, amount);

        // user swap for token1 using AMM liquidity
        set_contract_address(user);
        deploy.token0.approve(deploy.contract.contract_address, amount);
        deploy.contract.swap(deploy.token0.contract_address, amount);
        let amount_token1_received = deploy.token1.balance_of(user);
        assert(amount_token1_received > 0, 'Swap: wrong balance token1');

        // User can swap back token1 to token0
        // As each swap has a 0.3% fee, user will receive less token0
        deploy.token1.approve(deploy.contract.contract_address, amount_token1_received);
        deploy.contract.swap(deploy.token1.contract_address, amount_token1_received);
        let amount_token0_received = deploy.token0.balance_of(user);
        assert(amount_token0_received < amount, 'Swap: wrong balance token0');
    }
}
