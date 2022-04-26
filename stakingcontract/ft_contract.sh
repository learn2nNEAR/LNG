#!/bin/bash
# Smart contract FT 
# Source code: https://github.com/near-examples/FT
# More: https://nomicon.io/Standards/Tokens/FungibleToken/Core
export MAIN_ACCOUNT=giaphuc12.testnet
export NEAR_ENV=testnet
export CONTRACT_STAKING_ID=staking.$MAIN_ACCOUNT
export CONTRACT_FT_ID=ft.$MAIN_ACCOUNT
export ONE_YOCTO=0.000000000000000000000001
export ACCOUNT_ROSE=rose.giaphuc12.testnet
export ACCOUNT_OHARA=ohara.giaphuc12.testnet
export GAS=300000000000000
export AMOUNT=100000000000000000000000000

echo "################### DELETE ACCOUNT ###################"
near delete $CONTRACT_STAKING_ID $MAIN_ACCOUNT
near delete $CONTRACT_FT_ID $MAIN_ACCOUNT
near delete $ACCOUNT_OHARA $MAIN_ACCOUNT
near delete $ACCOUNT_ROSE $MAIN_ACCOUNT

echo "################### CREATE ACCOUNT ###################"
near create-account $CONTRACT_STAKING_ID --masterAccount $MAIN_ACCOUNT --initialBalance 5
near create-account $CONTRACT_FT_ID --masterAccount $MAIN_ACCOUNT --initialBalance 5
near create-account $ACCOUNT_OHARA --masterAccount $MAIN_ACCOUNT --initialBalance 5
near create-account $ACCOUNT_ROSE --masterAccount $MAIN_ACCOUNT --initialBalance 5

# 1. Deploy:
near deploy --wasmFile token-test/vbi-ft.wasm --accountId $CONTRACT_FT_ID

# 2. Init contract default:
near call $CONTRACT_FT_ID new_default_meta '{"owner_id": "'$MAIN_ACCOUNT'", "total_supply": "1000000000000000000000000000000000"}' --accountId $CONTRACT_FT_ID


# 3. Register account to ft contract
near call $CONTRACT_FT_ID storage_deposit '{"account_id": "'$CONTRACT_STAKING_ID'"}' --accountId $MAIN_ACCOUNT --deposit 0.01
near call $CONTRACT_FT_ID storage_deposit '{"account_id": "'$ACCOUNT_OHARA'"}' --accountId $MAIN_ACCOUNT --deposit 0.01
near call $CONTRACT_FT_ID storage_deposit '{"account_id": "'$ACCOUNT_ROSE'"}' --accountId $MAIN_ACCOUNT --deposit 0.01

# 4. Transfer ft token from owner_id to account test(Claim token)
near call $CONTRACT_FT_ID ft_transfer '{"receiver_id": "'$ACCOUNT_OHARA'", "amount": "'$AMOUNT'"}' --accountId $MAIN_ACCOUNT --deposit $ONE_YOCTO
near call $CONTRACT_FT_ID ft_transfer '{"receiver_id": "'$ACCOUNT_ROSE'", "amount": "'$AMOUNT'"}' --accountId $MAIN_ACCOUNT --deposit $ONE_YOCTO
# 5 Transfer token from ohara.giaphuc12.testnet to rose.giaphuc12.testnet

near call $CONTRACT_FT_ID ft_transfer '{"receiver_id": "'$ACCOUNT_ROSE'", "amount": "'$AMOUNT'"}' --accountId $ACCOUNT_OHARA --deposit $ONE_YOCTO

# 6. Check FT metadata
near view $CONTRACT_FT_ID ft_metadata

# 7. View balance of account
near view $CONTRACT_FT_ID ft_balance_of '{"account_id": "'$CONTRACT_STAKING_ID'"}'
near view $CONTRACT_FT_ID ft_balance_of '{"account_id": "'$ACCOUNT_OHARA'"}'
near view $CONTRACT_FT_ID ft_balance_of '{"account_id": "'$ACCOUNT_ROSE'"}'
near view $CONTRACT_FT_ID ft_balance_of '{"account_id": "'$MAIN_ACCOUNT'"}'