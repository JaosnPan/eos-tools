#!/bin/bash

# name to claim and private key
BP=
PRIVATE_KEY=

# env
NODEOS_BIN_DIR='/eos/build/programs'
WALLET_HOST='127.0.0.1:3000'
NODE_HOST='127.0.0.1:8080'
CLEOS="$NODEOS_BIN_DIR/cleos/cleos -u http://$NODE_HOST --wallet-url http://$WALLET_HOST"

# step 1: stop and remove current wallet
rm -rf ~/eosio-wallet/*

# step 2: create new wallet
mkdir -p ~/eosio-wallet
WALLET_RESULT=`$CLEOS wallet create`
WALLET_PWD=${WALLET_RESULT:0-54:53}

# step 3: import active private key
$CLEOS wallet unlock <<EOF
$WALLET_PWD
EOF
$CLEOS wallet import $PRIVATE_KEY

# step 4: wait and claim rewards
last_claim_time=`$CLEOS get table eosio eosio producers -l 1000 | jq -r '.rows[] | select(.owner == "$BP") | .last_claim_time'`
now=`date +%s%N`
diff=`expr $last_claim_time / 1000000 + 24 \* 3600 - $now / 1000000000 + 1`
sleep $diff
$CLEOS system claimrewards $BP
echo 'claimed at ' `date`

# step 5: clean
$CLEOS wallet stop
rm -rf ~/eosio-wallet/*
history -c
history -w