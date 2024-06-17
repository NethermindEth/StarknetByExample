import { Account, RpcProvider, json, Contract } from 'starknet';
import fs from 'fs';
import * as dotenv from 'dotenv';
dotenv.config();

const provider = new RpcProvider({ nodeUrl: 'https://starknet-sepolia.public.blastapi.io' });
const accountAddress = '0x067981c7F9f55BCbdD4e0d0a9C5BBCeA77dAcB42cccbf13554A847d6353F728e';
const privateKey = process.env.PRIVATE_KEY;

const account = new Account(provider, accountAddress, privateKey, "1");

const compiledContractAbi = json.parse(
    fs.readFileSync('./abi.json').toString('ascii')
);

const contractAddress = '0x01bb7d67375782ab08178b444dbda2b0c1c9ff4469c421124f54e1d8257f2e97';
const storageContract = new Contract(compiledContractAbi.abi, contractAddress, provider);


let getData = await storageContract.get();
console.log('Stored_data before set():', getData.toString());

storageContract.connect(account);
const myCall = storageContract.populate('set', [59]);
const res = await storageContract.set(myCall.calldata);
await provider.waitForTransaction(res.transaction_hash);


getData = await storageContract.get();
console.log('Stored_data after set():', getData.toString());
