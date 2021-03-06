use crate::*;
use near_sdk::Timestamp;

#[derive(BorshDeserialize, BorshSerialize)]
pub struct AccountV1 {
    pub stake_balance: Balance,
    pub pre_reward: Balance,
    pub last_block_balance_change: BlockHeight,
    pub unstake_balance: Balance,
    pub unstake_start_timestamp: Timestamp,
    pub unstake_available_epoch: EpochHeight,
}

#[derive(BorshDeserialize, BorshSerialize, Serialize, Deserialize)]
#[serde(crate="near_sdk::serde")]
pub struct Account {
    pub stake_balance: Balance,
    pub pre_reward: Balance,
    pub last_block_balance_change: BlockHeight,
    pub unstake_balance: Balance,
    pub unstake_start_timestamp: Timestamp,
    pub unstake_available_epoch: EpochHeight,
    pub new_account_data: U128,
}

#[derive(BorshDeserialize, BorshSerialize)]
pub enum UpgradebleAccount{
    V1(AccountV1),
    Current(Account)
}

impl From<Account> for UpgradebleAccount {
    fn from(account: Account) -> Self {
        UpgradebleAccount::Current(account)
    }
}

impl From<UpgradebleAccount> for Account {
    fn from(upgradeable_account: UpgradebleAccount) -> Self {
        match upgradeable_account {
            UpgradebleAccount::Current(account) => account,
            UpgradebleAccount::V1(account_v1) =>
                Account {
                     stake_balance: account_v1.stake_balance,
                     pre_reward: account_v1.pre_reward,
                     last_block_balance_change: account_v1.last_block_balance_change,
                     unstake_balance: account_v1.unstake_balance,
                     unstake_start_timestamp: account_v1.unstake_start_timestamp,
                    unstake_available_epoch: account_v1.unstake_available_epoch,
                     new_account_data: U128(128),
            }
        }
    }
}

#[derive(Serialize, Deserialize)]
#[serde(crate = "near_sdk::serde")]
pub struct AccountJson {
    pub account_id: AccountId,
    pub stake_balance: U128,
    pub unstake_balance: U128,
    pub reward: U128,
    pub can_withdraw: bool,
    pub unstake_start_timestamp: Timestamp,
    pub unstake_avaiable_epoch: EpochHeight,
    pub current_epoch: EpochHeight,
    pub new_account_data: U128,
}

impl AccountJson {
    pub fn from(account_id: AccountId, new_reward: Balance, account: Account) -> Self {
        AccountJson {
            account_id,
            stake_balance: U128(account.stake_balance),
            unstake_balance: U128(account.unstake_balance),
            unstake_start_timestamp: account.unstake_start_timestamp,
            reward: U128(new_reward),
            can_withdraw: account.unstake_available_epoch <= env::epoch_height(),
            current_epoch: env::epoch_height(),
            unstake_avaiable_epoch: account.unstake_available_epoch,
            new_account_data: account.new_account_data,
        }
    }
}

// Timeline: t1 ---------------- t2 -------------- now
// Balance: 100k --------------- 200k ------------
