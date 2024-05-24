// [!region ConstantProductAmmContract]
use starknet::ContractAddress;

#[starknet::interface]
pub trait IConstantProductAmm<TContractState> {
    fn swap(ref self: TContractState, token_in: ContractAddress, amount_in: u256) -> u256;
    fn add_liquidity(ref self: TContractState, amount0: u256, amount1: u256) -> u256;
    fn remove_liquidity(ref self: TContractState, shares: u256) -> (u256, u256);
}

#[starknet::contract]
pub mod ConstantProductAmm {
    use core::traits::Into;
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
    use starknet::{
        ContractAddress, get_caller_address, get_contract_address, contract_address_const
    };
    use core::integer::u256_sqrt;

    #[storage]
    struct Storage {
        token0: IERC20Dispatcher,
        token1: IERC20Dispatcher,
        reserve0: u256,
        reserve1: u256,
        total_supply: u256,
        balance_of: LegacyMap::<ContractAddress, u256>,
        // Fee 0 - 1000 (0% - 100%, 1 decimal places)
        // E.g. 3 = 0.3%
        fee: u16,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState, token0: ContractAddress, token1: ContractAddress, fee: u16
    ) {
        // assert(fee <= 1000, 'fee > 1000');
        self.token0.write(IERC20Dispatcher { contract_address: token0 });
        self.token1.write(IERC20Dispatcher { contract_address: token1 });
        self.fee.write(fee);
    }

    #[generate_trait]
    impl PrivateFunctions of PrivateFunctionsTrait {
        fn _mint(ref self: ContractState, to: ContractAddress, amount: u256) {
            self.balance_of.write(to, self.balance_of.read(to) + amount);
            self.total_supply.write(self.total_supply.read() + amount);
        }

        fn _burn(ref self: ContractState, from: ContractAddress, amount: u256) {
            self.balance_of.write(from, self.balance_of.read(from) - amount);
            self.total_supply.write(self.total_supply.read() - amount);
        }

        fn _update(ref self: ContractState, reserve0: u256, reserve1: u256) {
            self.reserve0.write(reserve0);
            self.reserve1.write(reserve1);
        }

        #[inline(always)]
        fn select_token(self: @ContractState, token: ContractAddress) -> bool {
            assert(
                token == self.token0.read().contract_address
                    || token == self.token1.read().contract_address,
                'invalid token'
            );
            token == self.token0.read().contract_address
        }

        #[inline(always)]
        fn min(x: u256, y: u256) -> u256 {
            if (x <= y) {
                x
            } else {
                y
            }
        }
    }

    #[abi(embed_v0)]
    impl ConstantProductAmm of super::IConstantProductAmm<ContractState> {
        fn swap(ref self: ContractState, token_in: ContractAddress, amount_in: u256) -> u256 {
            assert(amount_in > 0, 'amount in = 0');
            let is_token0: bool = self.select_token(token_in);

            let (token0, token1): (IERC20Dispatcher, IERC20Dispatcher) = (
                self.token0.read(), self.token1.read()
            );
            let (reserve0, reserve1): (u256, u256) = (self.reserve0.read(), self.reserve1.read());
            let (
                token_in, token_out, reserve_in, reserve_out
            ): (IERC20Dispatcher, IERC20Dispatcher, u256, u256) =
                if (is_token0) {
                (token0, token1, reserve0, reserve1)
            } else {
                (token1, token0, reserve1, reserve0)
            };

            let caller = get_caller_address();
            let this = get_contract_address();
            token_in.transfer_from(caller, this, amount_in);

            // How much dy for dx?
            // xy = k
            // (x + dx)(y - dy) = k
            // y - dy = k / (x + dx)
            // y - k / (x + dx) = dy
            // y - xy / (x + dx) = dy
            // (yx + ydx - xy) / (x + dx) = dy
            // ydx / (x + dx) = dy

            let amount_in_with_fee = (amount_in * (1000 - self.fee.read().into()) / 1000);
            let amount_out = (reserve_out * amount_in_with_fee) / (reserve_in + amount_in_with_fee);

            token_out.transfer(caller, amount_out);

            self._update(self.token0.read().balance_of(this), self.token1.read().balance_of(this));
            amount_out
        }

        fn add_liquidity(ref self: ContractState, amount0: u256, amount1: u256) -> u256 {
            let caller = get_caller_address();
            let this = get_contract_address();
            let (token0, token1): (IERC20Dispatcher, IERC20Dispatcher) = (
                self.token0.read(), self.token1.read()
            );

            token0.transfer_from(caller, this, amount0);
            token1.transfer_from(caller, this, amount1);

            // How much dx, dy to add?
            //
            // xy = k
            // (x + dx)(y + dy) = k'
            //
            // No price change, before and after adding liquidity
            // x / y = (x + dx) / (y + dy)
            //
            // x(y + dy) = y(x + dx)
            // x * dy = y * dx
            //
            // x / y = dx / dy
            // dy = y / x * dx

            let (reserve0, reserve1): (u256, u256) = (self.reserve0.read(), self.reserve1.read());
            if (reserve0 > 0 || reserve1 > 0) {
                assert(reserve0 * amount1 == reserve1 * amount0, 'x / y != dx / dy');
            }

            // How much shares to mint?
            //
            // f(x, y) = value of liquidity
            // We will define f(x, y) = sqrt(xy)
            //
            // L0 = f(x, y)
            // L1 = f(x + dx, y + dy)
            // T = total shares
            // s = shares to mint
            //
            // Total shares should increase proportional to increase in liquidity
            // L1 / L0 = (T + s) / T
            //
            // L1 * T = L0 * (T + s)
            //
            // (L1 - L0) * T / L0 = s

            // Claim
            // (L1 - L0) / L0 = dx / x = dy / y
            //
            // Proof
            // --- Equation 1 ---
            // (L1 - L0) / L0 = (sqrt((x + dx)(y + dy)) - sqrt(xy)) / sqrt(xy)
            //
            // dx / dy = x / y so replace dy = dx * y / x
            //
            // --- Equation 2 ---
            // Equation 1 = (sqrt(xy + 2ydx + dx^2 * y / x) - sqrt(xy)) / sqrt(xy)
            //
            // Multiply by sqrt(x) / sqrt(x)
            // Equation 2 = (sqrt(x^2y + 2xydx + dx^2 * y) - sqrt(x^2y)) / sqrt(x^2y)
            //            = (sqrt(y)(sqrt(x^2 + 2xdx + dx^2) - sqrt(x^2)) / (sqrt(y)sqrt(x^2))
            // sqrt(y) on top and bottom cancels out
            //
            // --- Equation 3 ---
            // Equation 2 = (sqrt(x^2 + 2xdx + dx^2) - sqrt(x^2)) / (sqrt(x^2)
            // = (sqrt((x + dx)^2) - sqrt(x^2)) / sqrt(x^2)
            // = ((x + dx) - x) / x
            // = dx / x
            // Since dx / dy = x / y,
            // dx / x = dy / y
            //
            // Finally
            // (L1 - L0) / L0 = dx / x = dy / y

            let total_supply = self.total_supply.read();
            let shares = if (total_supply == 0) {
                u256_sqrt(amount0 * amount1).into()
            } else {
                PrivateFunctions::min(
                    amount0 * total_supply / reserve0, amount1 * total_supply / reserve1
                )
            };
            assert(shares > 0, 'shares = 0');
            self._mint(caller, shares);

            self._update(self.token0.read().balance_of(this), self.token1.read().balance_of(this));
            shares
        }

        fn remove_liquidity(ref self: ContractState, shares: u256) -> (u256, u256) {
            let caller = get_caller_address();
            let this = get_contract_address();
            let (token0, token1): (IERC20Dispatcher, IERC20Dispatcher) = (
                self.token0.read(), self.token1.read()
            );

            // Claim
            // dx, dy = amount of liquidity to remove
            // dx = s / T * x
            // dy = s / T * y
            //
            // Proof
            // Let's find dx, dy such that
            // v / L = s / T
            //
            // where
            // v = f(dx, dy) = sqrt(dxdy)
            // L = total liquidity = sqrt(xy)
            // s = shares
            // T = total supply
            //
            // --- Equation 1 ---
            // v = s / T * L
            // sqrt(dxdy) = s / T * sqrt(xy)
            //
            // Amount of liquidity to remove must not change price so
            // dx / dy = x / y
            //
            // replace dy = dx * y / x
            // sqrt(dxdy) = sqrt(dx * dx * y / x) = dx * sqrt(y / x)
            //
            // Divide both sides of Equation 1 with sqrt(y / x)
            // dx = s / T * sqrt(xy) / sqrt(y / x)
            // = s / T * sqrt(x^2) = s / T * x
            //
            // Likewise
            // dy = s / T * y

            // bal0 >= reserve0
            // bal1 >= reserve1
            let (bal0, bal1): (u256, u256) = (token0.balance_of(this), token1.balance_of(this));

            let total_supply = self.total_supply.read();
            let (amount0, amount1): (u256, u256) = (
                (shares * bal0) / total_supply, (shares * bal1) / total_supply
            );
            assert(amount0 > 0 && amount1 > 0, 'amount0 or amount1 = 0');

            self._burn(caller, shares);
            self._update(bal0 - amount0, bal1 - amount1);

            token0.transfer(caller, amount0);
            token1.transfer(caller, amount1);
            (amount0, amount1)
        }
    }
}
// [!endregion ConstantProductAmmContract]


