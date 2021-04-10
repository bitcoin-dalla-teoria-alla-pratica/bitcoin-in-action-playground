# Bitcoin in Action playground

In questo repository si trova il materiale a supporto delle avventure con Bitcoin descritte su https://playground.bitcoininaction.com.

Questo playground è stato realizzato dagli autori dei libri "[Bitcoin dalla teoria alla pratica](https://www.amazon.com/Bitcoin-Dalla-teoria-pratica-Italian/dp/B07SNNNL2P)" / "[Bitcoin in Action](https://www.amazon.com/gp/product/B08NL5ZV6X)" e dell'omonimo canale [Bitcoin in Action](https://www.youtube.com/BitcoinInAction) con lo scopo di smorzare il piu' possibile la curva di apprendimento per sviluppare con Bitcoin script e sperimentare con il protocollo Bitcoin in generale. 

L'ambiente permette di testare tutti gli aspetti della blockchain di Bitcoin attraverso una predisposizione di tutto quanto necessario in modo già preconfigurato e pronto all'uso, grazie a docker. Con la collaborazione di [Massimo Musumeci](https://github.com/massmux/) [@massmux](https://twitter.com/massmux)

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
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io
apt-get install docker-compose
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

## Entrare nel nodo "hansel"

 E' naturalmente possibile andare alla consolle del nodo containerizzato "hansel" per eseguire dei comandi direttamente su di esso. Per farlo, lanciare il seguente comando docker

```
root@playground:~# docker exec -ti hansel bash
root@hansel:/opt/wald# 
```

## Minare i primi 101 blocchi

 La regtest è ovviamente vuota, non ci sono blocchi inizialmente. Quindi per prima cosa entrare nel nodo hansel e poi lanciare il comando del bitcoin core come sottoindicato in modo da ottenere 50 bitcoin sull'indirizzo, pronti ad essere spesi per i test che vogliamo eseguire

```
bitcoin-cli generatetoaddress 1 $(bitcoin-cli getnewaddress)
```

 oppure generare manualmente un nuovo address e indicare quello nel comando sopra.

## Collegare bitcoincore wallet

 E' possibile connettere il bitcoincore wallet al sistema cosi ottenuto. Per farlo occorre chiaramente scaricare il programma e dopo avere installato e lanciato bitcoin-qt aprire il file di configurazione come si vede nella seguente figura


![](https://i.ibb.co/hMTf6Mp/set-bitcoincore-wallet-config.png)

 e settare quanto segue nel file di configurazione

```
regtest=1

[regtest]
onlynet=ipv4
# hansel espone la porta di protocollo bitcoin su 18444 (default)
addnode=127.0.0.1
# gretel espone la porta di protocollo bitcoin su 28444 (custom per non andare in conflitto con hansel)
addnode=127.0.0.1:28444
```

 salvare e riaprire il wallet, andare in settings -> options e inserire nella sezione "third party transaction URLs" quanto segue

```
http://localhost:8094/regtest/tx/%s
```

ottenendo

![](https://i.ibb.co/kmTHqb6/options-settings-bitcoincore.png)


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


# Come inviare un feedback/segnalazioni

Non esistate ad inviarci feedback e segnalazioni!!

E' possibile farlo da [qui](https://github.com/bitcoin-dalla-teoria-alla-pratica/playground/issues/new/choose)!

# Il Bizantino e' anche su Twitter

[![bizantino-twitter](https://i.ibb.co/cvzsXPk/bizantino-twitter.png)](https://twitter.com/satoshiwantsyou)
