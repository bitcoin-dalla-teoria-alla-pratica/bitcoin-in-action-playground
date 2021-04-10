Nodo lightning che utilizza l'implementazione https://github.com/lightningnetwork/lnd.

Tramite link docker compose puo' collegarsi a lightningd per aprire canali:

1. docker exec -ti lnd bash
2. lncli -n regtest walletbalance
3. lncli -n regtest newaddress p2wkh
4. (da hansel o gretel) bitcoin-cli generatetoaddress 101 {address 3.}
5. (dal browser dell'host) aprire http://localhost:9737/#/node e copiare la pubkey
6. lncli -n regtest connect {pubkey 5.}@lightningd:9735
7. lncli -n regtest openchannel {pubkey 5.} 100000
8. (dal browser dell'host) aprire http://localhost:9737/#/channels si vedra' il canale in stato "opening"
9. (da hansel o gretel) bitcoin-cli generatetoaddress 6 $(bitcoin-cli getnewaddress)
10. (dal browser dell'host) aprire http://localhost:9737/#/channels si vedra' il canale in stato "active"

Se si vuole connettere electrum a questo nodo LN

1. docker exec -ti lnd bash
2. lncli -n regtest getinfo | jq '.identity_pubkey'
3. in electrum dal tab "Channels" cliccare "Open Channel"
4. come "Remote node ID" inserire {pubkey 2.}@127.0.0.1:19735

Attualmente ln-cli non supporta config da file quindi il -n regtest va sempre specificato: https://github.com/lightningnetwork/lnd/issues/533.
