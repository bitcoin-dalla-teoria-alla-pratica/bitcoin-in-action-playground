# Bitcoin in Action playground

In questo repository si trova il materiale a supporto delle avventure con Bitcoin descritte su https://playground.bitcoininaction.com. Questo playground permette di creare un ambiente di test in regtest per chiunque voglia testare gli aspetti della tecnologia e provare quanto descritto nei libri indicati. Il playground è utile anche per sviluppatori e programmatori.

Questo playground è stato realizzato dagli autori dei libri "[Bitcoin dalla teoria alla pratica](https://www.amazon.com/Bitcoin-Dalla-teoria-pratica-Italian/dp/B07SNNNL2P)" / "[Bitcoin in Action](https://www.amazon.com/gp/product/B08NL5ZV6X)" e dell'omonimo canale [Bitcoin in Action](https://www.youtube.com/BitcoinInAction) con lo scopo di smorzare il piu' possibile la curva di apprendimento per sviluppare con Bitcoin script e sperimentare con il protocollo Bitcoin in generale. 

L'ambiente permette di testare tutti gli aspetti della blockchain di Bitcoin attraverso una predisposizione di tutto quanto necessario in modo già preconfigurato e pronto all'uso, grazie a containers docker.

Grazie a [Massimo Musumeci](https://github.com/massmux/) [@massmux](https://twitter.com/massmux) per aver integrato i seguenti passaggi di bootstrap del playground.

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

E' naturalmente possibile attivare la console del nodo containerizzato "hansel" per eseguire dei comandi direttamente all'interno di esso. Per farlo, lanciare il seguente comando Docker

```
root@playground:~# docker exec -ti hansel bash
root@hansel:/opt/wald# 
```

## Minare il primo blocco

La regtest è ovviamente vuota, non ci sono blocchi inizialmente. Quindi per prima cosa bisogna entrare nel nodo hansel e poi lanciare il comando di Bitcoin Core come sottoindicato in modo da ottenere il primo blocco della vostra regtest:

```
bitcoin-cli generatetoaddress 1 $(bitcoin-cli getnewaddress)
```


## Collegare bitcoincore wallet

E' possibile connettere il Bitcoin Core wallet al sistema cosi ottenuto. Per farlo occorre chiaramente scaricare il programma e dopo avere installato e lanciato bitcoin-qt aprire il file di configurazione come si vede nella seguente figura

![](https://i.ibb.co/hMTf6Mp/set-bitcoincore-wallet-config.png)

serve settare quanto segue nel file di configurazione

```
regtest=1

[regtest]
onlynet=ipv4
# hansel espone la porta di protocollo bitcoin su 18444 (default)
addnode=127.0.0.1
# gretel espone la porta di protocollo bitcoin su 28444 (custom per non andare in conflitto con hansel)
addnode=127.0.0.1:28444
```

salvare il file di configurazione e riaprire il wallet, andare in settings -> options e inserire nella sezione "third party transaction URLs" quanto segue

```
http://localhost:8094/regtest/tx/%s
```

ottenendo

![](https://i.ibb.co/kmTHqb6/options-settings-bitcoincore.png)


## Minare i primi 101 blocchi, ottenere 50 bitcoin di test

Dobbiamo creare dei bitcoin da potere usare nei test. Quindi, per fare ciò, entrare nel nodo hansel e poi lanciare il comando del Bitcoin Core come sottoindicato in modo da ottenere 50 bitcoin sull'indirizzo, pronti ad essere spesi per i test che vogliamo eseguire

```
bitcoin-cli generatetoaddress 101 $(bitcoin-cli getnewaddress)
```

oppure generare manualmente un nuovo address e indicare quello nel comando sopra.


## Collegare Electrum

L'ambiente possiede un server electrs che rende possibile la connessione con un wallet Electrum. Ad oggi la connessione può essere effettuata sia dalla macchina locale sia esternamente (cosa che in un ambiente di produzione reale mainnet sarebbe assolutamente sconsigliata, ma che in fase di testing è accettabile). Per farlo ecco come fare.

Scaricare Electrum wallet dal sito https://electrum.org

Lanciare Electrum (in questo esempio installato sulla macchina locale) con il seguente comando, per collegarsi direttamente alla testnet del playground

```
electrum --regtest --oneserver --server 127.0.0.1:50001:t
```

il risultato è il seguente:

![](https://i.ibb.co/kB7h3cn/electrum-regtest.png)

## Aprire un canale lightning network

Aprire un browser sulla macchina locale:

 - aprire http://localhost:9737/#/node (user: fulmine, password: fulmine);
 - copiare il "Node address";

da Electrum lanciato come sopra (fare attenzione al pallino verde che dimostri che il sistema è collegato alla regtest), fare i seguenti passi:

 - in electrum dalla tab "Channels" fare "Open Channel";
 - come Remote Node ID inserire {node address copiato precedentemente}@127.0.0.1:9735

il risultato è il seguente (dopo l'apertura di un canale). NB: ricordarsi di minare almeno 6 blocchi per ottenere le necessarie conferme alla apertura del canale.

![](https://i.ibb.co/hCpcyTB/electrum-channels.png)


# Come inviare un feedback/segnalazioni

Non esistate ad inviarci feedback e segnalazioni!!

E' possibile farlo da [qui](https://github.com/bitcoin-dalla-teoria-alla-pratica/playground/issues/new/choose)!

# Il Bizantino e' anche su Twitter

[![bizantino-twitter](https://i.ibb.co/cvzsXPk/bizantino-twitter.png)](https://twitter.com/satoshiwantsyou)
