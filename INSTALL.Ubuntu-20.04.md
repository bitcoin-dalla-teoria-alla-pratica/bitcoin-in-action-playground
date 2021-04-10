## Installazione prerequisiti

Questa installazione è stata eseguita su una distro Ubuntu 20.04 su una VPS standard. La distro deve possedere già Docker installato e configurato, comprensivo di docker-compose in base all'architettura della macchina. Questo il link di riferimento per [ubuntu](https://docs.docker.com/engine/install/ubuntu/). L'installazione su Ubuntu puo' essere riassunta in questo modo per semplcità:

```
sudo apt-get update
sudo apt-get install git curl wget
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release
```

Scaricare la chiave GPG dell'archivio APT di Docker

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

Aggiungere il repository APT Docker per l'architettura della propria macchina

```
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Installare Docker e docker-compose

```
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io
apt-get install docker-compose
```

## Installazione playground

Per prima cosa clonare il repository

```
git clone https://github.com/bitcoin-dalla-teoria-alla-pratica/bitcoin-in-action-playground.git
```

[playground-bootstrap#bitcoin-core](https://playground.bitcoininaction.com/playground-bootstrap#bitcoin-core)

Scaricare la versione desiderata di Bitcoin Core dal [repository](https://bitcoincore.org/bin/). In questo esempio prendiamo la versione 0.21.0. Fare attenzione ovviamente a scaricare la versione adatta per la propria architettura:

```
cd bitcoin-in-action-playground/bitcoin-core
wget https://bitcoincore.org/bin/bitcoin-core-0.21.0/bitcoin-0.21.0-x86_64-linux-gnu.tar.gz
tar xzvf bitcoin-0.21.0-x86_64-linux-gnu.tar.gz
mv bitcoin-0.21.0/* .
rm -Rf bitcoin-0.21.0/

```

Siamo pronti ora per lanciare i containers:

```
cd /root/bitcoin-in-action-playground/bitcoin-core
docker-compose up
```

## Entrare nel nodo "hansel"

[playground-overview#hansel-e-gretel](https://playground.bitcoininaction.com/playground-overview#hansel-e-gretel)

E' naturalmente possibile attivare la console del nodo containerizzato "hansel" per eseguire dei comandi direttamente all'interno di esso. Per farlo, lanciare il seguente comando Docker

```
root@playground:~# docker exec -ti hansel bash
root@hansel:/opt/wald# 
```

## Minare il primo blocco

[playground/minare-il-primo-blocco-bitcoin](https://playground.bitcoininaction.com/minare-il-primo-blocco-bitcoin)

La regtest è ovviamente vuota, non ci sono blocchi inizialmente. Quindi per prima cosa bisogna entrare nel nodo hansel e poi lanciare il comando di Bitcoin Core come sottoindicato in modo da ottenere il primo blocco della vostra regtest:

```
bitcoin-cli generatetoaddress 1 $(bitcoin-cli getnewaddress)
```
