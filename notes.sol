//setting up virtaul eth network 

 //1/ install
   https://www.microsoft.com/en-us/p/ubuntu-2004-lts/9n6svws3rx71?activetab=pivot:overviewtab

 //3/run code 
 sudo apt-get intstall software-properties-common

 sudo add-apt-repository -y ppa:ehtereum/ethereum

 sudo apt-get update

 sudo apt-get install ethereum

 mkdir privatechain

 ls

 chmod 777 privatechain

 ls

 geth -datadir "privatechain" -dev account new 

   // copy eth address
   // set password

 geth -datadir "privatechain" -dev account new 
  // copy eth address
  // set password

 ls

 cd privatechain$ emacs genisblock.JSON

 emacs genisblock.json 

  //genesis block 
    // is the frist block in the chain and it is the only block without a predacessor 
    // sets the main settings for your block chain
    // main parameters are 
    // coinfig difficulty ; gas limint ; eiplock
     {
    "config": {
        //main block chain configeration

      "chainId": 33,
    //is the chain identifier
      //it is an integer used to protect against replay attack
      // a replay attack is accessing the network with out a authentication  or network tapping to get info and providing malware as the victim to the computer
      "homesteadBlock": 0,
    //provides connection to main network
      //is sencond major release of etherum 
      // 0 states your using homestead release
      "eip155Block": 0,
    //eip = etherum improvement proposal
      //provides connection to main network
      "eip158Block": 0

    },
    "nonce": "0x0000000000000033",

    "timestamp": "0x0",

    "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        // set to zero it is not needed for a new private network

    "extraData": "0x0",
    //set to default as per client version it not provided explicity

    "gasLimit": "0x8000000",
   //maxium amount of gas used in each block
    //the higher the value the higher amount of transactions that be used in a block
    "difficulty": "0x100",
    //shows how difficult it is to mine a block

    
    "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        //set to 0 if it a new private network

    "coinbase": "0x3333333333333333333333333333333333333333",
        //coinbase which is also known as etherbase which the default primary account

    "alloc": {}
        //used to allocate eth to to an address which served as prefunded accounts

   }


   //

    // to save press f10 


 ==================

  ls

 geth - datadir="home/simplilearn/privatechain@ -dev account list

 /// copy eht addresses if you forgot to json genesis

 get datadir='home/kaikai/privatechain/ init = '/home/kaikai/privatechain/genesisblock.json" 

 cd home

 cd kaikai

 cd privatechain

 ls

 cd geth

 cd chaindata

 cd..

 cd lightchaindata

 ls

 geth -datadir ''/home/kaikai/privatechai'' -mine
========

what is solidity

 solidity is and object oriented high-level language

 the syntax is simillar to java script which differ signifacantly 

 designed to enhance the evm 

 statically typed scripting language where processes are verified at compile time 

 ecplicitly expressed by varible 
  example
  string bool int 


============

memory is a byte array that holds the data in it unitl the exucution of a function 
 memory starts with 0 size 
 can be expanded to 32 bytes by accessing or storing memory greater then the current size 
 memory can be decompressed to keep the gas price as low as possible 
  thus used as temp values 
  it is erased between external function call and is cheaper to use 
======
storage
 is a persitent storage memory that every account has in its storage 
 stora