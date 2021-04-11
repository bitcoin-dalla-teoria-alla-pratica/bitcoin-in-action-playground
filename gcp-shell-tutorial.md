# Install Bitcoin Core

wget
https://bitcoincore.org/bin/bitcoin-core-0.21.0/bitcoin-0.21.0-x86_64-linux-gnu.tar.gz

tar xzvf bitcoin-0.21.0-x86_64-linux-gnu.tar.gz

mv bitcoin-0.21.0/* bitcoin-core

# Bootstrap

docker-compose up

# Connect your Electrum

Click <walkthrough-web-preview-icon></walkthrough-web-preview-icon> and use the
port 50001

Copy the domain

use those as params for Electrum

--regtest --oneserver --server {web preview domain}:443:t


