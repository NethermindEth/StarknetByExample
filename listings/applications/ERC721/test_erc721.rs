#[cfg(test)]
mod tests {
    use super::*;
    use starknet::testing::ContractState;
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    #[test]
    fn test_constructor() {
        let contract_state = ContractState::default();
        let contract = ERC721Contract::constructor(&contract_state, "MyToken".into(), "MTK".into());

        assert_eq!(contract.get_name(), "MyToken".into());
        assert_eq!(contract.get_symbol(), "MTK".into());
    }

    #[test]
    fn test_mint() {
        let contract_state = ContractState::default();
        let mut contract = ERC721Contract::constructor(&contract_state, "MyToken".into(), "MTK".into());

        let to = ContractAddress::from(1);
        let token_id = 1.into();

        contract._mint(to, token_id);

        assert_eq!(contract.owner_of(token_id), to);
        assert_eq!(contract.balance_of(to), 1.into());
    }

    #[test]
    fn test_transfer() {
        let contract_state = ContractState::default();
        let mut contract = ERC721Contract::constructor(&contract_state, "MyToken".into(), "MTK".into());

        let from = ContractAddress::from(1);
        let to = ContractAddress::from(2);
        let token_id = 1.into();

        contract._mint(from, token_id);
        contract._transfer(from, to, token_id);

        assert_eq!(contract.owner_of(token_id), to);
        assert_eq!(contract.balance_of(to), 1.into());
        assert_eq!(contract.balance_of(from), 0.into());
    }

    #[test]
    fn test_approve() {
        let contract_state = ContractState::default();
        let mut contract = ERC721Contract::constructor(&contract_state, "MyToken".into(), "MTK".into());

        let owner = ContractAddress::from(1);
        let approved = ContractAddress::from(2);
        let token_id = 1.into();

        contract._mint(owner, token_id);
        contract.approve(approved, token_id);

        assert_eq!(contract.get_approved(token_id), approved);
    }

    #[test]
    fn test_set_approval_for_all() {
        let contract_state = ContractState::default();
        let mut contract = ERC721Contract::constructor(&contract_state, "MyToken".into(), "MTK".into());

        let owner = get_caller_address();
        let operator = ContractAddress::from(2);

        contract.set_approval_for_all(operator, true);

        assert!(contract.is_approved_for_all(owner, operator));
    }

    #[test]
    fn test_burn() {
        let contract_state = ContractState::default();
        let mut contract = ERC721Contract::constructor(&contract_state, "MyToken".into(), "MTK".into());

        let owner = ContractAddress::from(1);
        let token_id = 1.into();

        contract._mint(owner, token_id);
        contract._burn(token_id);

        assert_eq!(contract.owner_of(token_id).is_zero(), true);
        assert_eq!(contract.balance_of(owner), 0.into());
    }
}
