# Bitcoin in Action playground

In questo repository si trova il materiale a supporto delle avventure con Bitcoin descritte su https://playground.bitcoininaction.com.

Questo playground e' stato realizzato dagli autori dei libri "[Bitcoin dalla teoria alla pratica](https://www.amazon.com/Bitcoin-Dalla-teoria-pratica-Italian/dp/B07SNNNL2P)" / "[Bitcoin in Action](https://www.amazon.com/gp/product/B08NL5ZV6X)" e dell'omonimo canale [Bitcoin in Action](https://www.youtube.com/BitcoinInAction) con lo scopo di smorzare il piu' possibile la curva di apprendimento per sviluppare con Bitcoin script e sperimentare con il protocollo Bitcoin in generale. 

L'ambiente permette di testare tutti gli aspetti della blockchain di Bitcoin attraverso una predisposizione di tutto quanto necessario in modo gia' preconfigurato e pronto all'uso, grazie a docker.

## Installazione prerequisiti

 Questa installazione è stata eseguita su una distro ubuntu 20.04 su una VPS standard. La distro deve possedere già docker installato e configurato, comprensivo di docker compose in base all'architettura della macchina. Il link di riferimento per [ubuntu](https://docs.docker.com/engine/install/ubuntu/) . L'installazione sulla ubuntu puo' essere riassunta in questo modo per semplcita'

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

 creare dir .bitcoin nella dir di /root in quanto referenziata dal docker-compose file

```
cd /root
mkdir .bitcoin
```

 lanciare i container

```
cd /root/bitcoin-in-action-playground/bitcoin-core
docker-compose up
```



# Come inviare un feedback/segnalazioni

Non esistate ad inviarci feedback e segnalazioni!!

E' possibile farlo da [qui](https://github.com/bitcoin-dalla-teoria-alla-pratica/playground/issues/new/choose)!

# Il Bizantino e' anche su Twitter

[![bizantino-twitter](https://i.ibb.co/cvzsXPk/bizantino-twitter.png)](https://twitter.com/satoshiwantsyou)
