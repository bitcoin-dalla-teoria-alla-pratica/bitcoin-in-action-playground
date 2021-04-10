# Bitcoin in Action playground

In questo repository si trova il materiale a supporto delle avventure con Bitcoin descritte su https://playground.bitcoininaction.com.

Questo playground è stato realizzato dagli autori dei libri "[Bitcoin dalla teoria alla pratica](https://www.amazon.com/Bitcoin-Dalla-teoria-pratica-Italian/dp/B07SNNNL2P)" / "[Bitcoin in Action](https://www.amazon.com/gp/product/B08NL5ZV6X)" e dell'omonimo canale [Bitcoin in Action](https://www.youtube.com/BitcoinInAction) con lo scopo di smorzare il piu' possibile la curva di apprendimento per sviluppare con Bitcoin script e sperimentare con il protocollo Bitcoin in generale. 

L'ambiente permette di testare tutti gli aspetti della blockchain di Bitcoin attraverso una predisposizione di tutto quanto necessario in modo già preconfigurato e pronto all'uso, grazie a docker. Con la collaborazione di Massimo Musumeci [@massmux](https://twitter.com/massmux)

## Installazione prerequisiti

 Questa installazione è stata eseguita su una distro ubuntu 20.04 su una VPS standard. La distro deve possedere già docker installato e configurato, comprensivo di docker compose in base all'architettura della macchina. Il link di riferimento per [ubuntu](https://docs.docker.com/engine/install/ubuntu/) . L'installazione sulla ubuntu puo' essere riassunta in questo modo per semplcità

```
sudo apt-get update
sudo apt-get install git curl wget
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release
```

scarica la chiave

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

aggiungere il repository

```
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

installare docker e docker-compose

```
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo apt-get install docker-compose
```

## Installazione playground

 per prima cosa clonare il repo

```
git clone https://github.com/bitcoin-dalla-teoria-alla-pratica/bitcoin-in-action-playground.git
```

 scaricare la versione desiderata di bitcoin core dal [repository](https://bitcoincore.org/bin/) . In questo esempio prendiamo la versione 0.21.0. Fare attenzione ovviamente a scaricare la versione adatta per la propria architettura:

```
cd bitcoin-in-action-playground/bitcoin-core
wget https://bitcoincore.org/bin/bitcoin-core-0.21.0/bitcoin-0.21.0-x86_64-linux-gnu.tar.gz
tar xzvf bitcoin-0.21.0-x86_64-linux-gnu.tar.gz
mv bitcoin-0.21.0/* .
rm -Rf bitcoin-0.21.0/

```
 creare dir .bitcoin/ nella dir di /root in quanto referenziata dal docker-compose file

```
cd /root
mkdir .bitcoin
```

 lanciare i container

```
cd /root/bitcoin-in-action-playground/bitcoin-core
docker-compose up
```

## Collegare electrum

 L'ambiente possiede un server electrs che rende possibile la connessione con un wallet electrum. Ad oggi la connessione può essere effettuata sia dalla macchina locale sia esternamente (cosa che in un ambiente di produzione reale mainnet sarebbe assolutamente sconsigliata, ma che in fase di testing è accettabile). Per farlo ecco come fare.

 Scaricare electrum wallet dal sito https://electrum.org

 Lanciare electrum (in questo esempio installato sulla macchina locale) con il seguente comando, per collegarsi direttamente alla testnet del playground

```
electrum --regtest --oneserver --server 127.0.0.1:50001:t
```
il risultato è il seguente:

![](https://i.ibb.co/kB7h3cn/electrum-regtest.png)

## Collegarsi a Lightning network creando un canale

aprire un browser sulla macchina locale:

 - aprire http://localhost:9737/#/node (user: fulmine, password: fulmine)
 - copiare il "Node address" 

da electrum lanciato come sopra (fare attenzione al pallino verde che dimostri che il sistema è collegato alla regtest), fare i seguenti passi:

 - in electrum dal tab “Channels” fai “Open Channel”
 - come Remote node ID inserire {node address del punto 2.}@127.0.0.1:9735

il risultato è il seguente (dopo l'apertura di un canale)

![](https://i.ibb.co/hCpcyTB/electrum-channels.png)

## Entrare nel nodo "hansel"

```
root@playground:~# docker exec -ti hansel bash
root@hansel:/opt/wald# 
```

### minare i primi 101 blocchi

 per prima cosa entrare nel nodo hansel e poi lanciare il comando del bitcoin core

```
bitcoin-cli generatetoaddress 1 $(bitcoin-cli getnewaddress)
```

 oppure generare manualmente un nuovo address e indicare quello nel comando sopra.


# Come inviare un feedback/segnalazioni

Non esistate ad inviarci feedback e segnalazioni!!

E' possibile farlo da [qui](https://github.com/bitcoin-dalla-teoria-alla-pratica/playground/issues/new/choose)!

# Il Bizantino e' anche su Twitter

[![bizantino-twitter](https://i.ibb.co/cvzsXPk/bizantino-twitter.png)](https://twitter.com/satoshiwantsyou)
