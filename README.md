1. Environment variable settings
export MAIN_ACCOUNT=saigon22.testnet
export NEAR_ENV=testnet
export CONTRACT_STAKING_ID=staking.saigon22.testnet
export CONTRACT_FT_ID=ft.saigon22.testnet
export ONE_YOCTO=0.000000000000000000000001
export ACCOUNT_ROSE=rose.saigon22.testnet
export ACCOUNT_OHARA=ohara.saigon22.testnet
export GAS=300000000000000
export AMOUNT=100000000000000000000000000

2.Create acount
near create-account $ACCOUNT_OHARA --masterAccount $MAIN_ACCOUNT --initialBalance 5
near create-account $CONTRACT_FT_ID --masterAccount $MAIN_ACCOUNT --initialBalance 5
near create-account $ACCOUNT_OHARA --masterAccount $MAIN_ACCOUNT --initialBalance 5
near create-account $ACCOUNT_ROSE --masterAccount $MAIN_ACCOUNT --initialBalance 5

3.Deploy
near deploy --wasmFile token-test/vbi-ft.wasm --accountId $CONTRACT_FT_ID

4.Init contract default
near call $CONTRACT_FT_ID new_default_meta '{"owner_id": "'$MAIN_ACCOUNT'", "total_supply": "1000000000000000000000000000000000"}' --accountId $CONTRACT_FT_ID

5. Resgister account to ft contract
near call $CONTRACT_FT_ID storage_deposit '{"account_id": "'$CONTRACT_STAKING_ID'"}' --accountId $MAIN_ACCOUNT --deposit 0.01
near call $CONTRACT_FT_ID storage_deposit '{"account_id": "'$ACCOUNT_OHARA'"}' --accountId $MAIN_ACCOUNT --deposit 0.01
near call $CONTRACT_FT_ID storage_deposit '{"account_id": "'$ACCOUNT_ROSE'"}' --accountId $MAIN_ACCOUNT --deposit 0.01

6. Transfer LNG token from MAIN_ACCOUNT to account ACCOUNT_OHARA and ACCOUNT_ROSE
near call $CONTRACT_FT_ID ft_transfer '{"receiver_id": "'$ACCOUNT_OHARA'", "amount": "'$AMOUNT'"}' --accountId $MAIN_ACCOUNT --deposit $ONE_YOCTO
near call $CONTRACT_FT_ID ft_transfer '{"receiver_id": "'$ACCOUNT_ROSE'", "amount": "'$AMOUNT'"}' --accountId $MAIN_ACCOUNT --deposit $ONE_YOCTO
7. Transfer token from ACCOUNT_OHARA to ACCOUNT_ROSE
near call $CONTRACT_FT_ID ft_transfer '{"receiver_id": "'$ACCOUNT_ROSE'", "amount": "'$AMOUNT'"}' --accountId $ACCOUNT_OHARA --deposit $ONE_YOCTO

8. Check FT metadata
near view $CONTRACT_FT_ID ft_metadata

9. View balance of account
near view $CONTRACT_FT_ID ft_balance_of '{"account_id": "'$CONTRACT_STAKING_ID'"}'
near view $CONTRACT_FT_ID ft_balance_of '{"account_id": "'$ACCOUNT_OHARA'"}'
near view $CONTRACT_FT_ID ft_balance_of '{"account_id": "'$ACCOUNT_ROSE'"}'
near view $CONTRACT_FT_ID ft_balance_of '{"account_id": "'$MAIN_ACCOUNT'"}'
