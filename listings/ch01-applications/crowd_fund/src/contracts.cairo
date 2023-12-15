use starknet::ContractAddress;

#[starknet::interface]
trait ICrowdFund<TContractState> {
    fn launch(ref self: TContractState);
    fn claim(ref self: TContractState, id: u256);
    fn pledge(ref self: TContractState, id: u256, amount: u256);
    fn unpledge(ref self: TContractState, id: u256, amount: u256);
}

#[starknet::contract]
mod CrowdFund {
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
    use starknet::{ContractAddress, get_caller_address, get_contract_address};
    #[storage]
    struct Storage {
        token: IERC20Dispatcher,
        count: u256,
        campaigns: LegacyMap<u256, Campaign>,
        pledged_amount: LegacyMap<(u256, ContractAddress), u256>
    }
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Launch: Launch,
        Pledge: Pledge,
        Unpledge: Unpledge,
        Claim: Claim
    }

    #[derive(Drop, starknet::Event)]
    struct Launch {
        id: u256,
        creator: ContractAddress
    }
    #[derive(Drop, starknet::Event)]
    struct Pledge {
        id: u256,
        caller: ContractAddress,
        amount: u256
    }
    #[derive(Drop, starknet::Event)]
    struct Unpledge {
        id: u256,
        caller: ContractAddress,
        amount: u256
    }
    #[derive(Drop, starknet::Event)]
    struct Claim {
        id: u256,
        creator: ContractAddress,
        amount: u256
    }

    #[derive(Copy, Drop, Serde, starknet::Store)]
    struct Campaign {
        id: u256,
        creator: ContractAddress,
        claimed: bool,
        pledged: u256
    }

    #[constructor]
    fn constructor(ref self: ContractState, token: ContractAddress) {
        self.token.write(IERC20Dispatcher { contract_address: token });
    }

    #[abi(embed_v0)]
    impl CrowdFund of super::ICrowdFund<ContractState> {
        fn launch(ref self: ContractState) {
            let new_campaign_id = self.count.read() + 1;
            let caller = get_caller_address();
            let new_campaign = Campaign {
                id: new_campaign_id, creator: caller, claimed: false, pledged: 0
            };
            self.campaigns.write(new_campaign_id, new_campaign);
            self.count.write(new_campaign_id);
            self.emit(Launch { id: new_campaign_id, creator: caller });
        }
        fn claim(ref self: ContractState, id: u256) {
            let caller = get_caller_address();
            let this = get_contract_address();

            assert(self.count.read() <= id, 'no id found');

            let mut current_campaign = self.campaigns.read(id);
            assert(current_campaign.creator == caller, 'only owner allowed');
            assert(current_campaign.claimed == false, 'already claimed');

            let token: IERC20Dispatcher = self.token.read();
            token.transfer(caller, current_campaign.pledged);

            current_campaign.claimed = true;
            self.campaigns.write(id, current_campaign);

            self.emit(Claim { id: id, creator: caller, amount: current_campaign.pledged });
        }
        fn pledge(ref self: ContractState, id: u256, amount: u256) {
            let caller = get_caller_address();
            let this = get_contract_address();

            assert(self.count.read() <= id, 'no id found');

            let mut current_campaign = self.campaigns.read(id);
            assert(current_campaign.claimed == false, 'already claimed');

            let token: IERC20Dispatcher = self.token.read();
            token.transfer_from(caller, this, amount);

            current_campaign.pledged += amount;
            let current_pledged_amount = self.pledged_amount.read((id, caller));
            self.pledged_amount.write((id, caller), amount + current_pledged_amount);
            self.campaigns.write(id, current_campaign);

            self.emit(Pledge { id: id, caller: caller, amount: amount });
        }
        fn unpledge(ref self: ContractState, id: u256, amount: u256) {
            let caller = get_caller_address();
            let this = get_contract_address();

            assert(self.count.read() <= id, 'no id found');

            let mut current_campaign = self.campaigns.read(id);
            assert(self.count.read() <= id, 'no id found');
            assert(current_campaign.claimed == false, 'already claimed');

            let current_pledged_amount = self.pledged_amount.read((id, caller));
            assert(current_pledged_amount >= amount, 'pledged amount not enough');

            let token: IERC20Dispatcher = self.token.read();
            token.transfer(caller, amount);

            current_campaign.pledged -= amount;
            self.pledged_amount.write((id, caller), current_pledged_amount - amount);
            self.campaigns.write(id, current_campaign);

            self.emit(Unpledge { id: id, caller: caller, amount: amount });
        }
    }
}
