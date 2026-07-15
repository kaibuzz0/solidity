# Ethereum Private Chain Setup

## Prerequisites

- Ubuntu 20.04 LTS (Windows Subsystem for Linux works)
- Git

## Installation Steps

```bash
# 1. Install dependencies
sudo apt-get install software-properties-common

# 2. Add Ethereum PPA
sudo add-apt-repository -y ppa:ethereum/ethereum

# 3. Update package list
sudo apt-get update

# 4. Install Geth (Go Ethereum)
sudo apt-get install ethereum

# 5. Verify installation
geth version
```

## Create Private Chain

```bash
# 1. Create directory
mkdir privatechain
cd privatechain

# 2. Make writable
chmod 777 .

# 3. Create accounts
geth -datadir "." account new
# Enter password when prompted
# Save the address that is generated

# 4. Create genesis configuration
cat > genesis.json << 'EOF'
{
  "config": {
    "chainId": 1337,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "berlinBlock": 0,
    "londonBlock": 0
  },
  "alloc": {
    "YOUR_ADDRESS_HERE": {
      "balance": "100000000000000000000"
    }
  },
  "coinbase": "0x0000000000000000000000000000000000000000",
  "difficulty": "0x20000",
  "extraData": "",
  "gasLimit": "0x2fefd8",
  "nonce": "0x0000000000000042",
  "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp": "0x00"
}
EOF
```

## Initialize Chain

```bash
# Initialize with genesis block
geth --datadir "." init genesis.json

# Directory structure after init
# - geth/
#   - chaindata/ (blockchain data)
#   - lightchaindata/ (light client data)
#   - nodekey (private key for p2p)
#   - LOCK
# - keystore/ (account keys)
```

## Start Private Network

```bash
# Start mining node
geth --datadir "." \
  --networkid 1337 \
  --mine \
  --miner.threads 1 \
  --miner.etherbase "YOUR_ADDRESS" \
  --http \
  --http.addr "0.0.0.0" \
  --http.port 8545 \
  --http.api "eth,net,web3,personal,txpool" \
  --http.corsdomain "*" \
  --allow-insecure-unlock \
  --nodiscover \
  --maxpeers 0
```

## Attach Console

```bash
# In another terminal, attach to running node
geth attach http://localhost:8545

# Or attach via IPC
geth attach ipc:./geth.ipc
```

## Useful Geth Commands

```javascript
// Inside geth console

// Check accounts
eth.accounts

// Check balance (in wei)
eth.getBalance(eth.accounts[0])

// Convert to ether
web3.fromWei(eth.getBalance(eth.accounts[0]), "ether")

// Send transaction
eth.sendTransaction({
  from: eth.accounts[0],
  to: "0x...",
  value: web3.toWei(1, "ether")
})

// Unlock account
personal.unlockAccount(eth.accounts[0], "password", 300)

// Create new account
personal.newAccount("password")

// Check block number
eth.blockNumber

// Get latest block
eth.getBlock("latest")

// Get transaction
eth.getTransaction("tx_hash")

// Get transaction receipt
eth.getTransactionReceipt("tx_hash")

// Mine (if not auto-mining)
miner.start(1)
miner.stop()
```

## Connect MetaMask

1. Open MetaMask
2. Click network dropdown → "Add Network"
3. Enter:
   - Network Name: Private Chain
   - RPC URL: http://localhost:8545
   - Chain ID: 1337
   - Currency Symbol: ETH
   - Block Explorer: (leave empty)

## Deploy Contract

```bash
# Using solc (Solidity compiler)
solc --bin --abi MyContract.sol -o build/

# Or use Remix IDE
# 1. Open https://remix.ethereum.org
# 2. Connect to "Web3 Provider" with http://localhost:8545
# 3. Compile and deploy
```

## Troubleshooting

### Port Already in Use
```bash
# Find and kill process
lsof -i :8545
kill -9 [PID]
```

### Chaindata Corruption
```bash
# Delete and reinitialize
rm -rf geth/chaindata geth/lightchaindata
geth --datadir "." init genesis.json
```

### Low Balance
```bash
# Pre-fund account in genesis.json
# Then reinitialize the chain
```