Cartella che contiene adatattamenti per il container blockstream/esplora
* file .bitcoin.conf utilizzato per collegare il demone Bitcoin di questo container e gretel
* entrypoint di Blockstream esplora che consente di
    * disabilitare l'avvio di Tor
    * disabilitare il mining automatico dei blocchi iniziali della regtest
    * evitare che ad ogni avvio il file bitcoin.conf venga rigenerato

In questa cartella verra' creata all'avvio una cartella bitcoin/regtest che contiene la [Bitcoin data directory](https://en.bitcoin.it/wiki/Data_directory).
