# Bitcoin in Action playground!!!

Avviando questo tutorial verrai guidato nei primi passi che ti consentiranno di
- accendere nodi Bitcoin
- collegare il tuo portafoglio
- rivere dei 5000 bitcoin

## Next steps

1. Scaricare Bitcoin Core
2. Playground bootstrap
3. Connettere Electrum al playground tramite ngrok

## Install Bitcoin Core

Esegui il seguente snippet per scaricare Bitcoin Core 0.21

```sh
wget https://bitcoincore.org/bin/bitcoin-core-0.21.0/bitcoin-0.21.0-x86_64-linux-gnu.tar.gz && \
tar xzvf bitcoin-0.21.0-x86_64-linux-gnu.tar.gz && \
mv bitcoin-0.21.0/* bitcoin-core && \
rm -Rf bitcoin-0.21.0 && \
rm -Rf bitcoin-0.21.0-x86_64-linux-gnu.tar.gz
```

## Playground bootstrap

```sh
docker-compose up
```

Attendere messaggio come descritto al seguente indirizzo

https://playground.bitcoininaction.com/playground-bootstrap#fuoco-alle-polveri

### Bitcoin blockchain explorer

Click <walkthrough-web-preview-icon></walkthrough-web-preview-icon> and change
the preview port to 8094.

If everything is fine you'll see something.

## Publish ports of Cloud Shell

To be able to connect with ***unauthenticated*** not HTTP only we need something better of web
preview :)

```sh
./install-ngrok.sh
```
```sh
ngrok start blockchain-explorer_50001 blockchain-explorer_8094 lightningd_9735 lnd_19735
```

### Connect your Electrum

Using the ngrok domain and port to connect your Electrum wallet

```terminal
--regtest --oneserver --server {ngrok domain 500001}:{ngrok 50001 port}:t
```

