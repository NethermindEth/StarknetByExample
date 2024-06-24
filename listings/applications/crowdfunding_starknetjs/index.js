import { Account, RpcProvider, json, Contract, cairo } from 'starknet';
import fs from 'fs';
import * as dotenv from 'dotenv';
dotenv.config();

const provider = new RpcProvider({ nodeUrl: 'https://free-rpc.nethermind.io/sepolia-juno' });
//0x05b0D30B02349c93b30e02f1A0C3F3F44914D9fbA691581a7Cdfe11f88972853 - second account to test the contract.
//0x067981c7F9f55BCbdD4e0d0a9C5BBCeA77dAcB42cccbf13554A847d6353F728e
const accountAddress = '0x067981c7F9f55BCbdD4e0d0a9C5BBCeA77dAcB42cccbf13554A847d6353F728e';
const privateKey = process.env.PRIVATE_KEY;

const account = new Account(provider, accountAddress, privateKey, "1");

const compiledERC20Abi = json.parse(
    fs.readFileSync('./erc20_abi.json').toString('ascii')
);

const compiledCrowdFundAbi = json.parse(
    fs.readFileSync('./crowdfunding_abi.json').toString('ascii')
);

//Initialize contract objects - Crowdfunding and ETH contract (for approving ETH to transfer to our contract)
const ETHAddress = '0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7'; //Starknet Sepolia ETH Contract Address
const tokenContract = new Contract(compiledERC20Abi, ETHAddress, provider);
const crowdfundingAddr = '0x075ab72714fac0685449dd9a75e76db59dc0ff9b146afaff5450e2af7155ef74';
const crowdfundingContract = new Contract(compiledCrowdFundAbi.abi, crowdfundingAddr, provider);

tokenContract.connect(account);
crowdfundingContract.connect(account);

async function createCampaign(name, beneficiary, tokenAddress, goal) {
    const goalInWei = cairo.uint256(goal * 10 ** 18);
    const createCall = crowdfundingContract.populate('create_campaign',
        [name, beneficiary, tokenAddress, goalInWei])
    const tx = await crowdfundingContract.create_campaign(createCall.calldata)
    await provider.waitForTransaction(tx.transaction_hash)
    console.log('Created ', name, 'campaign');
}

async function contribute(campaign_no, amount) {
    const amountInWei = cairo.uint256(amount * 10 ** 18);

    const approveCall = tokenContract.populate('approve',
        [crowdfundingAddr, amountInWei]);
    const contributeCall = crowdfundingContract.populate('contribute',
        [campaign_no, amountInWei]);

    const multiCall = await account.execute([approveCall, contributeCall]);

    await provider.waitForTransaction(multiCall.transaction_hash);
    console.log('Contributed to the campaign_no ', campaign_no);
}

async function getFunderContribution(campaign_no, funder_addr) {
    const funder_info = await crowdfundingContract.get_funder_info(campaign_no, funder_addr);
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

async function withdrawContribution(campaign_no) {
    const withdrawCall = crowdfundingContract.populate('withdraw_contribution',
        [campaign_no])
    const tx = await crowdfundingContract.withdraw_contribution(withdrawCall.calldata)
    await provider.waitForTransaction(tx.transaction_hash)
    console.log('Withdrew from campaign_no ', campaign_no);
}

async function withdrawFunds(campaign_no) {
    const withdrawCall = crowdfundingContract.populate('withdraw_funds',
        [campaign_no])
    const tx = await crowdfundingContract.withdraw_funds(withdrawCall.calldata)
    await provider.waitForTransaction(tx.transaction_hash)
    console.log('Withdrew funds from campaign_no ', campaign_no);
}

//getLatestCampaignNo();
//createCampaign('Test', accountAddress, ETHAddress, 0.01);
//contribute(4, 0.001);
//getFunderContribution(1, accountAddress);
//withdrawContribution(1);
//withdrawFunds(1)

//const balance = await tokenContract.balanceOf(crowdfundingAddr)
//console.log(balance)

//getFunderInfo(1, accountAddress)
//getCampaignInfo(3)