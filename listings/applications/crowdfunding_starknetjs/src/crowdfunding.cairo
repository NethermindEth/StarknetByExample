use starknet::ContractAddress;

#[derive(Copy, Drop, Serde, starknet::Store)]
struct Campaign {
    name: felt252,
    beneficiary: ContractAddress,
    token_addr: ContractAddress,
    goal: u256,
    amount: u256,
    numFunders: u64,
    end_time: u64,
}

#[derive(Copy, Drop, Serde, starknet::Store)]
struct Funder {
    funder_addr: ContractAddress,
    amount_funded: u256
}

#[starknet::interface]
trait ICrowdfunding<TContractState> {
    //write functions
    fn create_campaign(
        ref self: TContractState,
        _name: felt252,
        _beneficiary: ContractAddress,
        _token_addr: ContractAddress,
        _goal: u256
    );
    fn contribute(ref self: TContractState, campaign_no: u64, amount: u256);
    fn withdraw_funds(ref self: TContractState, campaign_no: u64);
    fn withdraw_contribution(ref self: TContractState, campaign_no: u64);

    //read functions
    fn get_funder_info(
        self: @TContractState, campaign_no: u64, funder_addr: ContractAddress
    ) -> Funder;
    fn get_campaign_info(self: @TContractState, campaign_no: u64) -> Campaign;
    fn get_campaign_duration(self: @TContractState) -> u64;
    fn get_latest_campaign_no(self: @TContractState) -> u64;
}

#[starknet::interface]
trait IERC20<T> {
    fn transfer_from(
        ref self: T, sender: ContractAddress, recipient: ContractAddress, amount: u256
    );
    fn transfer(ref self: T, recipient: ContractAddress, amount: u256);
}

#[starknet::contract]
mod Crowdfunding {
    use super::{Campaign, Funder, IERC20Dispatcher, IERC20DispatcherTrait};
    use starknet::{
        ContractAddress, get_caller_address, get_contract_address, get_block_timestamp,
        contract_address_const,
    };

    #[storage]
    struct Storage {
        campaign_no: u64,
        campaign_duration: u64,
        campaigns: LegacyMap<u64, Campaign>,
        funder_contribution: LegacyMap<(u64, ContractAddress), Funder>
    }

    #[constructor]
    fn constructor(ref self: ContractState, _duration: u64) {
        self.campaign_duration.write(_duration);
    }

    #[abi(embed_v0)]
    impl CrowdfundingImpl of super::ICrowdfunding<ContractState> {
        fn create_campaign(
            ref self: ContractState,
            _name: felt252,
            _beneficiary: ContractAddress,
            _token_addr: ContractAddress,
            _goal: u256
        ) {
            assert(_beneficiary != contract_address_const::<0>(), 'Empty address');

            let new_campaign_no: u64 = self.campaign_no.read() + 1;
            self.campaign_no.write(new_campaign_no);

            //1 month = 2629800 seconds
            //5 minutes = 300 seconds
            let new_campaign: Campaign = Campaign {
                name: _name,
                beneficiary: _beneficiary,
                token_addr: _token_addr,
                goal: _goal,
                amount: 0,
                numFunders: 0,
                end_time: get_block_timestamp() + self.campaign_duration.read()
            };

            self.campaigns.write(new_campaign_no, new_campaign);
        }

        fn contribute(ref self: ContractState, campaign_no: u64, amount: u256) {
            let mut campaign = self.campaigns.read(campaign_no);

            assert(campaign.beneficiary != contract_address_const::<0>(), 'Campaign not found');
            assert(get_block_timestamp() < campaign.end_time, 'Campaign ended');

            campaign.amount += amount;
            campaign.numFunders += 1;

            let funder_addr = get_caller_address();
            let funder = self.get_funder_info(campaign_no, funder_addr);
            let new_funder_amount = amount + funder.amount_funded;
            let new_funder = Funder { funder_addr: funder_addr, amount_funded: new_funder_amount };

            self.funder_contribution.write((campaign_no, funder_addr), new_funder);
            self.campaigns.write(campaign_no, campaign);

            IERC20Dispatcher { contract_address: campaign.token_addr }
                .transfer_from(funder_addr, get_contract_address(), amount);
        }

        fn withdraw_funds(ref self: ContractState, campaign_no: u64) {
            let mut campaign = self.campaigns.read(campaign_no);
            let campaign_amount = campaign.amount;
            let caller = get_caller_address();

            assert(caller == campaign.beneficiary, 'Not the beneficiary');
            assert(campaign.amount >= campaign.goal, 'Goal not reached');
            assert(get_block_timestamp() > campaign.end_time, 'Campaign ended');

            campaign.amount = 0;
            self.campaigns.write(campaign_no, campaign);

            IERC20Dispatcher { contract_address: campaign.token_addr }
                .transfer(campaign.beneficiary, campaign_amount);
        }

        //Can only be called by users if the campaign ended and could not reach the goal
        fn withdraw_contribution(ref self: ContractState, campaign_no: u64) {
            let campaign = self.campaigns.read(campaign_no);
            let funder_addr = get_caller_address();
            let mut funder = self.funder_contribution.read((campaign_no, funder_addr));
            let amount_funded = funder.amount_funded;

            assert(get_block_timestamp() > campaign.end_time, 'Campaign not ended');
            assert(campaign.amount < campaign.goal, 'Campaign reached goal');
            assert(amount_funded > 0, 'Not a funder');

            funder.amount_funded = 0;
            self.funder_contribution.write((campaign_no, funder_addr), funder);

            IERC20Dispatcher { contract_address: campaign.token_addr }
                .transfer(funder.funder_addr, amount_funded);
        }

        fn get_funder_info(
            self: @ContractState, campaign_no: u64, funder_addr: ContractAddress
        ) -> Funder {
            self.funder_contribution.read((campaign_no, funder_addr))
        }

        fn get_campaign_info(self: @ContractState, campaign_no: u64) -> Campaign {
            self.campaigns.read(campaign_no)
        }

        fn get_latest_campaign_no(self: @ContractState) -> u64 {
            self.campaign_no.read()
        }

        fn get_campaign_duration(self: @ContractState) -> u64 {
            self.campaign_duration.read()
        }
    }
}
