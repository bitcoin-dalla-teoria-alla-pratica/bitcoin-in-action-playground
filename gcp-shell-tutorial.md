# Bitcoin in Action playground!!!

Avviando questo tutorial verrai guidato nei primi passi che ti consentiranno di
- accendere nodi Bitcoin
- collegare il tuo portafoglio
- rivere dei 5000 bitcoin


## Install Bitcoin Core

Esegui il seguente snippet per scaricare Bitcoin Core 0.21

```
wget https://bitcoincore.org/bin/bitcoin-core-0.21.0/bitcoin-0.21.0-x86_64-linux-gnu.tar.gz

tar xzvf bitcoin-0.21.0-x86_64-linux-gnu.tar.gz

mv bitcoin-0.21.0/* bitcoin-core

rm -Rf bitcoin-0.21.0

rm -Rf bitcoin-0.21.0-x86_64-linux-gnu.tar.gz
```

## Playground bootstrap

```
docker-compose up
```

## Bitcoin blockchain explorer

Click <walkthrough-web-preview-icon></walkthrough-web-preview-icon> and change
the preview port to 8094.

If everything is fine you'll see something.

## Publish ports of Cloud Shell

To be able to connect with non-HTTP protocol we need something better of web
preview :)

TODO step to install ngrok and publish 9735 and 50001 port.

## Connect your Electrum

Using the ngrok domain and port to connect your Electrum wallet

```
--regtest --oneserver --server {ngrok domain}:{ngrok port}:t
```

