#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# https://github.com/CryptoLions/scripts/
#
###############################################################################

NODEOSBINDIR="/ebs/eos/build/programs"

WALLETHOST="127.0.0.1"
NODEHOST="127.0.0.1"
NODEPORT="8880"
WALLETPORT="3000"



$NODEOSBINDIR/cleos/cleos -u http://$NODEHOST:$NODEPORT --wallet-url http://$WALLETHOST:$WALLETPORT "$@"