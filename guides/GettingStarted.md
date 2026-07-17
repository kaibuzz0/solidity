# Getting Started with Solidity

**Your first 10 minutes with Solidity** — from zero to running code.

## ⚡ Fastest Way: Remix IDE (No Installation)

**1. Open Remix** → [remix.ethereum.org](https://remix.ethereum.org/)

**2. Create new file:**
- Click the "+" icon (Create New File)
- Name it: `HelloWorld.sol`

**3. Paste this code:**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract HelloWorld {
    string public message = "Hello, Solidity!";
    
    function updateMessage(string memory _newMessage) public {
        message = _newMessage;
    }
    
    function getMessage() public view returns (string memory) {
        return message;
    }
}
```

**4. Compile:**
- Press `Ctrl+S` (or Cmd+S on Mac)
- Or click the "Solidity Compiler" tab → "Compile HelloWorld.sol"

**5. Deploy:**
- Click "Deploy & Run Transactions" tab
- Click orange "Deploy" button

**6. Interact:**
- See your contract under "Deployed Contracts"
- Click "message" to read it
- Click "updateMessage" and type something → click "transact"
- Click "message" again to see it changed!

**Done!** You just wrote, compiled, deployed, and interacted with your first smart contract.

---

## 🛠️ Local Setup: Hardhat (Recommended)

For serious development, use Hardhat.

### Step 1: Install Prerequisites

```bash
# Install Node.js (LTS version)
# Download from: https://nodejs.org/

# Check installation
node --version  # Should be v18+ or v20+
npm --version   # Should be 9+
```

### Step 2: Create Project

```bash
# Create project folder
mkdir my-solidity-project
cd my-solidity-project

# Initialize npm
npm init -y

# Install Hardhat
npm install --save-dev hardhat

# Create Hardhat project
npx hardhat init
```

**Select:** "Create a JavaScript project"

### Step 3: Project Structure

After setup, you'll have:

```
my-solidity-project/
├── contracts/          ← Your .sol files go here
│   └── HelloWorld.sol
├── scripts/            ← Deployment scripts
│   └── deploy.js
├── test/               ← Test files
│   └── HelloWorld.js
├── hardhat.config.js   ← Configuration
└── package.json
```

### Step 4: Write Contract

Create `contracts/HelloWorld.sol`:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract HelloWorld {
    string public message;
    
    constructor(string memory _message) {
        message = _message;
    }
    
    function updateMessage(string memory _newMessage) public {
        message = _newMessage;
    }
}
```

### Step 5: Create Deploy Script

Create `scripts/deploy.js`:

```javascript
const hre = require("hardhat");

async function main() {
  // Deploy contract
  const HelloWorld = await hre.ethers.getContractFactory("HelloWorld");
  const helloWorld = await HelloWorld.deploy("Hello, Hardhat!");
  
  await helloWorld.waitForDeployment();
  
  console.log("Contract deployed to:", await helloWorld.getAddress());
  
  // Interact with contract
  console.log("Initial message:", await helloWorld.message());
  
  await helloWorld.updateMessage("Hello from script!");
  
  console.log("Updated message:", await helloWorld.message());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```

### Step 6: Run It

```bash
# Compile
npx hardhat compile

# Run deploy script (uses local network by default)
npx hardhat run scripts/deploy.js
```

**Output:**
```
Contract deployed to: 0x5FbDB2315678afecb367f032d93F642f64180aa3
Initial message: Hello, Hardhat!
Updated message: Hello from script!
```

🎉 **Success!** Your contract works!

---

## 🧪 Running Tests

Create `test/HelloWorld.js`:

```javascript
const { expect } = require("chai");

describe("HelloWorld", function () {
  it("Should set the right message", async function () {
    const HelloWorld = await ethers.getContractFactory("HelloWorld");
    const helloWorld = await HelloWorld.deploy("Hello, world!");
    await helloWorld.waitForDeployment();
    
    expect(await helloWorld.message()).to.equal("Hello, world!");
  });
  
  it("Should update the message", async function () {
    const HelloWorld = await ethers.getContractFactory("HelloWorld");
    const helloWorld = await HelloWorld.deploy("Hello!");
    await helloWorld.waitForDeployment();
    
    await helloWorld.updateMessage("New message");
    expect(await helloWorld.message()).to.equal("New message");
  });
});
```

Run tests:

```bash
npx hardhat test
```

---

## 🔗 Connect to Real Network (Testnet)

### 1. Get Test ETH

- Go to [Sepolia Faucet](https://sepoliafaucet.com/)
- Enter your wallet address
- Get free test ETH

### 2. Configure Hardhat

Update `hardhat.config.js`:

```javascript
require("@nomicfoundation/hardhat-toolbox");

const PRIVATE_KEY = "your-private-key-here";  // NEVER commit this!

module.exports = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
      url: "https://rpc.sepolia.org",
      accounts: [PRIVATE_KEY]
    }
  }
};
```

⚠️ **SECURITY:** Never share your private key! Use environment variables:

```bash
export PRIVATE_KEY="your-key-here"
```

Then in config:
```javascript
accounts: [process.env.PRIVATE_KEY]
```

### 3. Deploy to Testnet

```bash
npx hardhat run scripts/deploy.js --network sepolia
```

**Your contract is now live on Ethereum testnet!**

---

## 📚 Next Steps

1. **Learn Data Types** → [cheatsheets/DataTypes.md](../cheatsheets/DataTypes.md)
2. **Study Functions** → [cheatsheets/Functions.md](../cheatsheets/Functions.md)
3. **Build ERC20 Token** → [examples/05-ERC20Token.sol](../examples/05-ERC20Token.sol)
4. **Learn Security** → [examples/07-SecurityBestPractices.sol](../examples/07-SecurityBestPractices.sol)

---

## ❓ Troubleshooting

### "Cannot find module 'hardhat'"

```bash
npm install --save-dev hardhat
```

### "Invalid Solidity version"

Update `hardhat.config.js`:
```javascript
module.exports = {
  solidity: "0.8.19",  // Match your pragma
};
```

### "Insufficient funds"

- For local testing: Hardhat provides free test ETH
- For testnet: Get more from [faucet](https://sepoliafaucet.com/)

### Compilation errors

Check:
1. Semicolons at end of lines
2. Matching braces `{}`
3. `memory` keyword for strings/arrays in parameters
4. Correct version in `pragma solidity`

---

## 🎯 Practice Exercises

1. **Counter Contract**
   - Store a number
   - increment() and decrement() functions
   - Prevent going below 0

2. **Simple Storage**
   - Store any data type
   - getter and setter functions
   - emit events on changes

3. **Calculator**
   - add(), subtract(), multiply(), divide()
   - Handle division by zero

Solutions in `../examples/` folder!

---

**Ready to dive deeper?** Start with [examples/01-FirstContract.sol](../examples/01-FirstContract.sol)
