# Crowdfunding (Starknet-js + Cairo)

In this tutorial, you will deploy a Crowdfunding contract in Cairo on Starknet Sepolia Testnet. Then, using Starknet-js, you will learn how to interact with the Crowdfunding contract.

## Writing Crowdfunding contract in Cairo:

In order to start writing our Cairo code, the functionalities of our code should be determined. Here is what our contract should be able to do: 
- **Create Campaign**: Users should be able to create a new campaign by providing necessary information. The campaign could include the information: **beneficiary address** (who will receive the funds), **token address** (in which token funds should be provided), **goal** (the target of the campaign), **amount** (current amount of funds for campaign), **number of funders** (we can check how many people contributed to the campaign), **end time** (when the campaign will end).

- **Contribute**: Users will be able to fund the campaign of their choice. They should provide the funds in the token address specified in the campaign info.

- **Withdraw Funds**: If the campaign reaches its goal and its end time, the beneficiary will be able to withdraw the funds from the campaign.

- **Withdraw Contribution**: If the campaign cannot reach its goal, but reaches its end time, the funders will be able to withdraw their funds.

According to the functionalities above, let's start writing our contract in Cairo! You can follow along [this](https://github.com/egeaybars123/crowdfunding-cairo) repository.

Firstly, create a Scarb package, and create `crowdfunding.cairo` file in your source directory. Do not forget to delete the contents of `lib.cairo`, and add your crowdfunding contract as a module: 
```rs
// Directory: src/lib.cairo 
mod crowdfunding;
```
Do not forget to add the dependencies to the `Scarb.toml`:

```toml
[dependencies]
starknet=">=2.4.1"

[[target.starknet-contract]]
```

Let's define the structs we need! One of the structs we need is Campaign, and define it according to what we described above. Also use the ContractAddress from starknet from the start of the file. The structs are defined outside the implementation block because we will use the Campaign struct in the trait: 
```rs
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
```

Another struct we need is the Funder struct. If we would like to track how much contribution which address made, we will need this struct (it will make more sense once we define Legacy Maps in the Storage section):
```rs
#[derive(Copy, Drop, Serde, starknet::Store)]
struct Funder {
    funder_addr: ContractAddress,
    amount_funded: u256
}
```
Next, we need to define our interface. Below, you can see all the external functions of our contract. All of the functions will be explained thorougly, but you can copy & paste them for now if you wish. We need this trait for external Starknet functions, and need to make the function definitions for all of them: 
```rs
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
```
Let's define our contract, and start writing it. Our structs are imported along with StarknetOS functions like `get_block_timestamp`. We will learn how & why we use them:
```rs
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

    //write functions here
}
```
Also, the storage component of the Cairo contract is defined which contains the current campaign number, campaign duration and two legacy maps. This part is really important because this is where we manage the state of our contract.

- Campaign_no: We need campaign_no because we want to store the Campaign info for each campaign to see when the campaign ends, and whether or not the campaign reached its goal.
- Campaign_duration: It is the same for each campaign and is set by the contract deployer in the constructor function. This part is customizable: you can set it to 1 year or 2 weeks, up to you! 
- Campaigns: This legacy maps stores Campaign struct as a value corresponding to a campaign_no key.
- Funder_contribution: This is where we store a funder's address and funded amount to a campaign. We have (Funder address, campaign_no) as a key to the LegacyMap. In this way, we can get how much funds an address contributed to a given campaign.

Additionally, the constructor function is written. Constructor function is called only when the contract is being deployed. In our constructor function, we set the campaign_duration for each campaign, so we will need to specify the duration (in seconds) while deploying our contract.

Now, let's write `create_campaign` function for our contract. We have to put our public functions inside the impl block where we also add the line `#[abi(embed_v0)]` above the impl block which means that all functions embedded inside it are implementations of the Starknet interface of the contract. It affects the visibility of the functions in the impl block where they become public (accessible by RPC calls & other Cairo contracts):

```rs
//inside CrowdfundingImpl
#[abi(embed_v0)]
    impl CrowdfundingImpl of super::ICrowdfunding<ContractState> {
        fn create_campaign(
            ref self: ContractState,
            _name: felt252,
            _beneficiary: ContractAddress,
            _token_addr: ContractAddress,
            _goal: u256
        ) {
            //We do not want the users to enter an empty address for the beneficiary.
            //The reason: funds would not be withdrawable.
            assert(_beneficiary != contract_address_const::<0>(), 'Empty address');

            let new_campaign_no: u64 = self.campaign_no.read() + 1;
            self.campaign_no.write(new_campaign_no); //update current campaign_no
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
        //add other external functions
    }
```

When a campaign is created, it is assigned a new campaign number. Then, a Campaign struct variable is created with struct variables, and end_time is also set. In order to set the end_time timestamp, we call `get_block_timestamp()` function to get the current timestamp and add it to the campaign_duration variable. Afterwards, the new campaign is written to the new campaign_no key in a mapping.


Next function we need is the `contribute`. In this function, we will transfer the contributors' tokens into our contract. Firstly, we need our users to approve the function (will be done in Starknet-js), and then execute the `transfer_from` function in our contract with an amount they provide in the function parameter. 

```rs
//inside CrowdfundingImpl
    fn contribute(ref self: ContractState, campaign_no: u64, amount: u256) {
            let mut campaign = self.campaigns.read(campaign_no);

            //Funders should not be able to contribute to a non-existing campaign.
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
```

Firstly, using the campaign_no, the campaign info is retrieved to check if the campaign the user wants to contribute to has ended in the next line. If the campaign has ended, and the condition in the assert function is false, the transaction reverts. 

Note that IERC20Dispatcher is used which we have not covered yet. Let's dive into what dispatchers are (for more info: see [here](https://book.cairo-lang.org/ch15-02-contract-dispatchers-library-dispatchers-and-system-calls.html)). We need Dispatchers for cross-contract interactions. In our case, we need to transfer the token from the funder's address to our contract, so we call the `transfer_from` function from the token contract in our own contract. In order to implement Dispatchers, we need to write the trait for it first by including the function definitions of all the functions we will call from other contracts:

```rs
//outside the mod Crowdfunding{}
#[starknet::interface]
trait IERC20<T> {
    fn transfer_from(ref self: T, sender: ContractAddress, recipient: ContractAddress, amount: u256);
    fn transfer(ref self: T, recipient: ContractAddress, amount: u256);
}
```

The struct `IERC20Dispatcher` and the trait `IERC20DispatcherTrait` are automatically created by the compiler (which we imported above). The trait is defined which only takes in a contract address (the contract we want to call a function from). See below how we implement it:

Now, we are good to go! Let's write the `withdraw_funds` function which is meant to be triggered by the beneficiary of the campaign if the campaign reaches its goal and end time:
```rs
//inside CrowdfundingImpl
fn withdraw_funds(ref self: ContractState, campaign_no: u64) {
    let mut campaign = self.campaigns.read(campaign_no);
    let campaign_amount = campaign.amount; //Store the campaign amount in a variable to be used later.
    let caller = get_caller_address(); //Get the address which calls the functions

    //Check if the caller is the beneficiary
    assert(caller == campaign.beneficiary, 'Not the beneficiary'); 
    //Check if the campaign reached its goal.
    assert(campaign.amount >= campaign.goal, 'Goal not reached');
    //Check if the campaign reached its end time
    assert(get_block_timestamp() > campaign.end_time, 'Campaign ended');

    //Set the campaign amount to 0 because the beneficiary is withdrawing
    //It's important to update! Otherwise the beneficiary can withdraw more than the campaign amount
    campaign.amount = 0;
    //Update the campaign info with the updated amount.
    self.campaigns.write(campaign_no, campaign);

    //Transfer the funds (of the amount campaign_amount) from the contract to the beneficiary
    IERC20Dispatcher { contract_address: campaign.token_addr }
        .transfer(campaign.beneficiary, campaign_amount);
}

```

Next, let's write the `withdraw_contribution` function which can only be called by the users if the campaign did not reach its goal when the end time is reached:
```rs
//inside CrowdfundingImpl
fn withdraw_contribution(ref self: ContractState, campaign_no: u64) {
    //Get the campaign info
    let campaign = self.campaigns.read(campaign_no);
    //Get the address of who calls this function
    let funder_addr = get_caller_address();
    //Get the Funder struct corresponding to the address of the funder and the campaign
    let mut funder = self.funder_contribution.read((campaign_no, funder_addr));
    //Get how much the funder address contributed for the given campaign_no
    let amount_funded = funder.amount_funded;

    //Check if the campaign has ended. If it did not end yet, revert the transaction.
    assert(get_block_timestamp() > campaign.end_time, 'Campaign not ended');

    //Check if the campaign did not meet its goal. If it did, do not allow the funders to withdraw.
    assert(campaign.amount < campaign.goal, 'Campaign reached goal');

    //Check if the address is a funder.
    //This part protects the users from sending an unnecessary transaction
    //where they could withdraw zero amount of token for a campaign.
    assert(amount_funded > 0, 'Not a funder');

    //Update the funder's amount_funded to 0
    //It's important to update. Otherwise, the funder could withdraw more than their funded amount.
    funder.amount_funded = 0;
    //Update the Funder struct corresponding to the tuple (campaign_no, funder_addr).
    self.funder_contribution.write((campaign_no, funder_addr), funder);

    //Transfer the amount of token the funder gave back to the funder's address from the contract.
    IERC20Dispatcher { contract_address: campaign.token_addr }
        .transfer(funder.funder_addr, amount_funded);
    }
```

After that, let's write the remaining view functions that will allow us to get the data in storage variables like the Funder info or the current campaign_no etc.:

```rs
//inside CrowdfundingImpl

        //Get the Funder struct for a campaign.
        fn get_funder_info(
            self: @ContractState, campaign_no: u64, funder_addr: ContractAddress
        ) -> Funder {
            self.funder_contribution.read((campaign_no, funder_addr))
        }

        //Get the Campaign struct for a campaign
        fn get_campaign_info(self: @ContractState, campaign_no: u64) -> Campaign {
            self.campaigns.read(campaign_no)
        }

        //Returns the current campaign_no. The number returned + 1 is the new campaign_no
        fn get_latest_campaign_no(self: @ContractState) -> u64 {
            self.campaign_no.read()
        }

        //Get the campaign duration
        fn get_campaign_duration(self: @ContractState) -> u64 {
            self.campaign_duration.read()
        }
```

## Declaring and Deploying the Crowdfunding contract

We will declare and deploy our Crowdfunding contract using Starkli. This tutorial assumes that you already set up your account with Starkli. In order to start with introduction to Starkli, you can check [here](https://github.com/xJonathanLEI/starkli) and [here](../getting-started/interacting/how_to_deploy.md).

**Note:** The command below is written to run in the directory of the Scarb folder.
**Note:** The `--watch` takes the `./target/dev/project_name_ContractName.contract_class.json` as an argument where the Sierra program and the ABI of the contract is stored.

```console
$ starkli declare --keystore /path/to//keystore.json --account /path/to/account.json --watch ./target/dev/crowdfunding_Crowdfunding.contract_class.json
```

After that, the contract class is declared, and our contract is ready to be deployed. Do not forget to include class hash as an argument to `--watch`:

**Note:** A kindly reminder that our contract has a constructor function where we need to set the campaign duration in seconds, so we need to put campaign duration in seconds as an argument while deploying the contract. We should set a small number for the sake of testing the withdraw functions (600 seconds = 10 minutes is fine). See below to find out where to put the campaign duration in seconds:

```console
starkli deploy --keystore /path/to//keystore.json --account /path/to/account.json --watch PASTE_CLASS_HASH_HERE CAMPAIGN_DURATION_IN_SECONDS 
```

After the deploy command, we will be able to see the address of the Crowdfunding contract. Now, we are ready to interact with our contract using Starknet-js!

## Interacting with the Crowdfunding contract
We will interact with our contract using Starknet-js. Create a new folder and initialize your npm package:
```console
$ npm init
```

Now, `package.json` file is created. Change the type of the package to a module. Add the line below in the object in `package.json`:

```json
"type": "module"
```

Let's add Starknet-js as a dependency:

```console
$ npm install starknet@next
$ npm install dotenv
```
Create a file named `index.js` where we will write JavaScript code to interact with our contract. Let's start our code by importing from Starknet-js, and from other libraries we will need:

```js
import { Account, RpcProvider, json, Contract, cairo } from 'starknet';
import fs from 'fs';
import * as dotenv from 'dotenv';
dotenv.config();

const provider = new RpcProvider({ nodeUrl: 'https://free-rpc.nethermind.io/sepolia-juno' });
const accountAddress = 'PASTE_YOUR_ACCOUNT_ADDRESS_HERE';
const privateKey = process.env.PRIVATE_KEY;

//Create an Account object. We need it to sign transactions
//Add "1" as the last parameter to show that the account is written in Cairo 1.0
const account = new Account(provider, accountAddress, privateKey, "1");

tokenContract.connect(account);
crowdfundingContract.connect(account);
```

Import the necessary classes and functions from the starknet-js module and other libraries (dotenv and fs). Then, create your Provider object with the free RPC service from Nethermind. The provider gets our transactions and broadcasts them to the Starknet network. Also, the provider returns the result of our queries of the Starknet network and contracts. Also, please import your private key as an environment variable and include the .env in the .gitignore file to prevent it from being compromised. 

Next, we will need the ABI for the contracts we will interact with. The contracts we will be interacting with are ERC20 contracts (it could be ETH, STRK or your own token) and our Crowdfunding contract. 

For the ERC20 ABI, we can copy it from [ETH contract](https://sepolia.starkscan.co/contract/0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7#class-code-history) on Starknet Sepolia Testnet from the **Copy ABI Code** button. For the Crowdfunding contract ABI, you can copy it from `./target/dev/crowdfunding_Crowdfunding.contract_class.json` in your Scarb folder. Paste the ABI content into two different json files `erc20_abi.json` and `crowdfunding_abi.json`.

```js
const compiledERC20Abi = json.parse(
    fs.readFileSync('./erc20_abi.json').toString('ascii')
);

const compiledCrowdFundAbi = json.parse(
    fs.readFileSync('./crowdfunding_abi.json').toString('ascii')
);
```

The ABI strings are ready, and let's create Contract objects. We will call the functions from these objects.The campaign we will create will require users to fund in Sepolia ETH, so the token we chose for this tutorial is Sepolia ETH, but you can choose other tokens or even create your own token.

```js
//Starknet Sepolia ETH Contract Address
const ETHAddress = '0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7'; 
const tokenContract = new Contract(compiledERC20Abi, ETHAddress, provider);

const crowdfundingAddr = 'PASTE_CONTRACT_ADDRESS_HERE';
const crowdfundingContract = new Contract(compiledCrowdFundAbi.abi, crowdfundingAddr, provider);
```

Then, we need to connect our Account object to the Contract objects in order to sign our transactions.
```js
tokenContract.connect(account);
crowdfundingContract.connect(account);
```

Now, let's get started with interacting our contract. Firstly, we will implement the read functions firstly in order to view the information regarding our contributions and campaigns.

```js
async function getFunderContribution(campaign_no, funder_addr) {
    const funder_info = await crowdfundingContract.get_funder_info(campaign_no, funder_addr);
    //Each component of the Struct can be retrieved like this: funder_info.amount_funded
    console.log('Funder Contribution: ', funder_info.amount_funded.toString());
}

async function getLatestCampaignNo() {
    const campaign_no = await crowdfundingContract.get_latest_campaign_no();
    console.log('Current campaign no: ', campaign_no.toString());
}

async function getFunderInfo(campaign_no, funder_addr) {
    const funder_info = await crowdfundingContract.get_funder_info(campaign_no, funder_addr);
    console.log('Funder info: ', funder_info);
}

async function getCampaignInfo(campaign_no) {
    const campaign_info = await crowdfundingContract.get_campaign_info(campaign_no);
    console.log('Campaign info: ', campaign_info);
}
```

As it can be seen, we are just calling the read functions from our contract. These functions are callable from our crowdfundingContract object thanks to the ABI of the Crowdfunding contract. In order to use these functions and see the state changes our functions will make, let's start writing the script for creating a campaign: 

```js
async function createCampaign(name, beneficiary, tokenAddress, goal) {
    //Do not forget to implement this. ETH token has a decimal of 18.
    const goalInWei = cairo.uint256(goal * 10 ** 18)

    //construct the calldata
    const createCall = crowdfundingContract.populate('create_campaign',
        [name, beneficiary, tokenAddress, goalInWei])

    //Sign + broadcast the transaction.
    const tx = await crowdfundingContract.create_campaign(createCall.calldata)

    //Wait for the transaction confirmation
    await provider.waitForTransaction(tx.transaction_hash)
    console.log('Created ', name, 'campaign');
}
```
Let's call the function and create our campaign. Then, in order to call the see the Campaign info, call the `getCampaignInfo` function in our script. Run your script: 
```js
//Goal is 0.001 ETH
createCampaign('StarkTest', accountAddress, ETHAddress, 0.001);
//The campaign_no of the campaign we just created is 1
getCampaignInfo(1)
```
Note that we set our campaign duration to 10 minutes. In this time, let's interact with the contribute function (comment out the code snippet right above, we will not need them for now): 
```js
async function contribute(campaign_no, amount) {
    const amountInWei = cairo.uint256(amount * 10 ** 18);

    //Construct the multicall
    const approveCall = tokenContract.populate('approve',
        [crowdfundingAddr, amountInWei]);
    const contributeCall = crowdfundingContract.populate('contribute',
        [campaign_no, amountInWei]);

    //Sign + broadcast the multicall.
    const multiCall = await account.execute([approveCall, contributeCall]);

    await provider.waitForTransaction(multiCall.transaction_hash);
    console.log('Contributed to the campaign_no ', campaign_no);
}
```
We have utilized the multicall feature of Starknet above. Because users are depositing funds into our contract, we need our contract to transfer ETH from their account to itself, so we need the users to approve the contract to transfer ETH of the amount they allow (see the Dispatcher in the `contribute` function in the smart contract). Then, the users will be able to call the `contribute` function. We can pack these calls in one transaction: first, approve transaction is executed, and then contribute function is executed. As you can see, this feature greatly improves the UX as the users will need to sign only one transaction!

Call this function, and see how the Funder and Campaign structs are updated:
```js
//No of the campaign we want to contribute is 1.
contribute(1, 0.001);
getCampaignInfo(1);
getFunderInfo(1, accountAddress);
```
You will see the amount increase in Campaign, and the amount_funded increase in the Funder struct. Also, numFunders is incremented. After a few minutes, you should see your contract's balance of ETH in Voyager Explorer website [https://sepolia.voyager.online/]. You can call the contribute function from different wallets by importing their account addresses and private keys.

Let's write the code for interacting with the withdraw functions:
```js
//can only be called by the beneficiary if the campaign reached its goal before the end-time.
async function withdrawFunds(campaign_no) {
    const withdrawCall = crowdfundingContract.populate('withdraw_funds',
        [campaign_no])
    const tx = await crowdfundingContract.withdraw_funds(withdrawCall.calldata)
    await provider.waitForTransaction(tx.transaction_hash)
    console.log('Withdrew funds from campaign_no ', campaign_no);
}

//can only be called by the funders if the campaign did not reach its goal after the end-time.
async function withdrawContribution(campaign_no) {
    const withdrawCall = crowdfundingContract.populate('withdraw_contribution',
        [campaign_no])
    const tx = await crowdfundingContract.withdraw_contribution(withdrawCall.calldata)
    await provider.waitForTransaction(tx.transaction_hash)
    console.log('Withdrew from campaign_no ', campaign_no);
}
```
After 10 minutes (campaign_duration), we reached our goal because the goal was 0.001 ETH, and we contributed 0.001 ETH, so the beneficiary can withdraw the funds: 
```js
//Comment out the contribute function in order not to run it again.
withdrawFunds(1);
```
You can create another campaign where the goal is not met so that the funders will be able to withdraw their contributions. In that case, you would call the `withdrawContribution` function.

Congrats! You have written the Crowdfunding contract in Cairo, and interacted with it using Starknet-js.