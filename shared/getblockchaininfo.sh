#!/bin/bash
bitcoin-cli getblockchaininfo | jq '. | "chain: \(.chain) blocks: \(.blocks) bestblockhash: \(.bestblockhash) mediantime: \(.mediantime)"'
