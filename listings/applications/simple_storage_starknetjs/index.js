// [!region imports]
import { Account, RpcProvider, json, Contract } from "starknet";
import fs from "fs";
import * as dotenv from "dotenv";
dotenv.config();
// [!endregion imports]

// [!region provider]
const provider = new RpcProvider({
  nodeUrl: "https://free-rpc.nethermind.io/sepolia-juno",
});
// [!endregion provider]

const accountAddress =
  "0x067981c7F9f55BCbdD4e0d0a9C5BBCeA77dAcB42cccbf13554A847d6353F728e";
// [!region account]
const privateKey = process.env.PRIVATE_KEY;
// "1" is added to show that our account is deployed using Cairo 1.0.
const account = new Account(provider, accountAddress, privateKey, "1");
// [!endregion account]

const contractAddress =
  "0x01bb7d67375782ab08178b444dbda2b0c1c9ff4469c421124f54e1d8257f2e97";
// [!region contract]
const compiledContractAbi = json.parse(
  fs.readFileSync("./abi.json").toString("ascii")
);
const storageContract = new Contract(
  compiledContractAbi.abi,
  contractAddress,
  provider
);
// [!endregion contract]

// [!region get]
let getData = await storageContract.get();
console.log("Stored_data:", getData.toString());
// [!endregion get]

// [!region set]
storageContract.connect(account);
const myCall = storageContract.populate("set", [59]);
const res = await storageContract.set(myCall.calldata);
await provider.waitForTransaction(res.transaction_hash);

// Get the stored data after setting it
getData = await storageContract.get();
console.log("Stored_data after set():", getData.toString());
// [!endregion set]
