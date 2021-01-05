// https://github.com/bitcoinjs/regtest-client#usage
// bitcoinjs-lib must be the >=5.0.6 to use.
// For bitcoinjs-lib >=4.0.3, use version v0.0.8 of regtest-client
const bitcoin = require('bitcoinjs-lib')
const { RegtestUtils } = require('regtest-client')
const regtestUtils = new RegtestUtils(bitcoin, {APIURL: 'http://bitcoinjs-regtest-server:8080/1'})

const network = regtestUtils.network // regtest network params

const keyPair = bitcoin.ECPair.makeRandom({ network })
const p2pkh = bitcoin.payments.p2pkh({ pubkey: keyPair.publicKey, network })

(async () => {
    // Tell the server to send you coins (satoshis)
    // Can pass address
    const unspent = await regtestUtils.faucet(p2pkh.address, 2e4)
    console.log('unspent', {unspent})

    // Get all current unspents of the address.
    const unspents = await regtestUtils.unspents(p2pkh.address)
    console.log('unspents', {unspents})

    // Get data of a certain transaction
    const fetchedTx = await regtestUtils.fetch(unspent.txId)
    console.log('fetchedTx', {fetchedTx})
})();