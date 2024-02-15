#[starknet::contract]
mod ERC20Token {
    use openzeppelin::token::erc20::ERC20Component;
    use openzeppelin::token::erc20::interface::IERC20Metadata;
    use starknet::ContractAddress;

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    #[abi(embed_v0)]
    impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC20CamelOnlyImpl = ERC20Component::ERC20CamelOnlyImpl<ContractState>;
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
        decimals: u8
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        decimals: u8,
        initial_supply: u256,
        recipient: ContractAddress,
        name: felt252,
        symbol: felt252
    ) {
        self._set_decimals(decimals);
        self.erc20.initializer(name, symbol);
        self.erc20._mint(recipient, initial_supply);
    }

    #[external(v0)]
    impl ERC20MetadataImpl of IERC20Metadata<ContractState> {
        fn name(self: @ContractState) -> felt252 {
            self.erc20.name()
        }

        fn symbol(self: @ContractState) -> felt252 {
            self.erc20.symbol()
        }

        fn decimals(self: @ContractState) -> u8 {
            self.decimals.read()
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn _set_decimals(ref self: ContractState, decimals: u8) {
            self.decimals.write(decimals);
        }
    }
}

mod tests {
    use core::option::OptionTrait;
    use core::traits::TryInto;
    use openzeppelin::token::erc20::{interface::IERC20Dispatcher, interface::IERC20DispatcherTrait};
    use super::ERC20Token;
    use openzeppelin::utils::serde::SerializedAppend;
    use openzeppelin::tests::utils;

    use constant_product_amm::contracts::{
        ConstantProductAmm, IConstantProductAmmDispatcher, IConstantProductAmmDispatcherTrait
    };
    use starknet::{
        ContractAddress, get_caller_address, get_contract_address, contract_address_const
    };
    use starknet::testing::set_contract_address;

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
        calldata.append(18.into());
        calldata.append_serde(initial_supply);
        calldata.append_serde(recipient);
        calldata.append_serde(name);
        calldata.append_serde(symbol);

        let address = utils::deploy(ERC20Token::TEST_CLASS_HASH, calldata);
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

        let (contract_address, _) = starknet::syscalls::deploy_syscall(
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
        let _shares = add_liquidity(deploy, INITIAL_SUPPLY / 2);

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
