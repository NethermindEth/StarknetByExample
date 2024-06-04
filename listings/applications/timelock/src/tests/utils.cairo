use starknet::{ContractAddress, contract_address_const, get_block_timestamp};
use starknet::account::Call;
use snforge_std::{declare, ContractClassTrait, test_address};
use openzeppelin::utils::serde::SerializedAppend;
use openzeppelin::token::erc721::interface::IERC721Dispatcher;
use timelock::timelock::{TimeLock, ITimeLockDispatcher, ITimeLockSafeDispatcher};

pub const TOKEN_ID: u256 = 1;

pub fn NAME() -> ByteArray {
    "NAME"
}

pub fn SYMBOL() -> ByteArray {
    "SYMBOL"
}

pub fn BASE_URI() -> ByteArray {
    "https://api.example.com/v1/"
}

pub fn OTHER() -> ContractAddress {
    contract_address_const::<'OTHER'>()
}

#[derive(Copy, Drop)]
pub struct TimeLockTest {
    pub timelock_address: ContractAddress,
    pub timelock: ITimeLockDispatcher,
    pub timelock_safe: ITimeLockSafeDispatcher,
    pub erc721_address: ContractAddress,
    pub erc721: IERC721Dispatcher,
}

#[generate_trait]
pub impl TimeLockTestImpl of TimeLockTestTrait {
    fn setup() -> TimeLockTest {
        let timelock_contract = declare("TimeLock").unwrap();
        let mut timelock_calldata = array![];
        let (timelock_address, _) = timelock_contract.deploy(@timelock_calldata).unwrap();
        let timelock = ITimeLockDispatcher { contract_address: timelock_address };
        let timelock_safe = ITimeLockSafeDispatcher { contract_address: timelock_address };
        let erc721_contract = declare("ERC721").unwrap();
        let mut erc721_calldata = array![];
        erc721_calldata.append_serde(NAME());
        erc721_calldata.append_serde(SYMBOL());
        erc721_calldata.append_serde(BASE_URI());
        erc721_calldata.append_serde(test_address());
        erc721_calldata.append_serde(TOKEN_ID);
        let (erc721_address, _) = erc721_contract.deploy(@erc721_calldata).unwrap();
        let erc721 = IERC721Dispatcher { contract_address: erc721_address };
        TimeLockTest { timelock_address, timelock, timelock_safe, erc721_address, erc721 }
    }
    fn get_call(self: @TimeLockTest) -> Call {
        let mut calldata = array![];
        calldata.append_serde(test_address());
        calldata.append_serde(*self.timelock_address);
        calldata.append_serde(TOKEN_ID);
        Call {
            to: *self.erc721_address,
            selector: selector!("transfer_from"),
            calldata: calldata.span()
        }
    }
    fn get_timestamp(self: @TimeLockTest) -> u64 {
        get_block_timestamp() + TimeLock::MIN_DELAY
    }
}
