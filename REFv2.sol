revist these pages   links 
  https://docs.soliditylang.org/en/v0.8.7/080-breaking-changes.html
  hashing, elliptic-curve cryptography, peer-to-peer networks
  https://docs.soliditylang.org/en/v0.8.7/control-structures.html#unchecked
  //https://www.youtube.com/watch?v=v_hU0jPtLto&list=PL16WqdAj66SCOdL6XIFbke-XQg2GW_Avg
  //https://www.geeksforgeeks.org/mathematical-operations-in-solidity/
  //https://www.youtube.com/channel/UCsec5JlNrA02iT4826EazTw
  //https://docs.soliditylang.org/en/latest/index.html
  //https://docs.soliditylang.org/en/latest/cheatsheet.html
  //https://ethereum.org/en/developers/docs/ethereum-stack/
==============================================================
Warning

 be careful with using Unicode text, as similar looking (or even identical) characters can have different code points and as such are encoded as a different byte array.

 All identifiers (contract names, function names and variable names) are restricted to the ASCII character set. It is possible to store UTF-8 encoded data in string variables.

Names to Avoid
 l - Lowercase letter el

 O - Uppercase letter oh

 I - Uppercase letter eye

 Never use any of these for single letter variable names. They are often indistinguishable from the numerals one and zero.

 Contract and Library Names
 Contracts and libraries should be named using the CapWords style. Examples: SimpleToken, SmartBank, CertificateHashRepository, Player, Congress, Owned.

 Contract and library names should also match their filenames.

 If a contract file includes multiple contracts and/or libraries, then the filename should match the core contract. This is not recommended however if it can be avoided.

how to correctly name all sturctures 
 Struct Names
  Structs should be named using the CapWords style. Examples: MyCoin, Position, PositionXY.

 Event Names
  Events should be named using the CapWords style. Examples: Deposit, Transfer, Approval, BeforeTransfer, AfterTransfer.

 Function Names
  Functions should use mixedCase. Examples: getBalance, transfer, verifyOwner, addMember, changeOwner.

  Function Argument Names
  Function arguments should use mixedCase. Examples: initialSupply, account, recipientAddress, senderAddress, newOwner.

  When writing library functions that operate on a custom struct, the struct should be the first argument and should always be named self.

 Local and State Variable Names
  Use mixedCase. Examples: totalSupply, remainingSupply, balancesOf, creatorAddress, isPreSale, tokenExchangeRate.

 Constants
  Constants should be named with all capital letters with underscores separating words. Examples: MAX_BLOCKS, TOKEN_NAME, TOKEN_TICKER, CONTRACT_VERSION.

 Modifier Names
  Use mixedCase. Examples: onlyBy, onlyAfter, onlyDuringThePreSale.

 Enums
  Enums, in the style of simple type declarations, should be named using the CapWords style. Examples: TokenGroup, Frame, HashStyle, CharacterLocation.

 Avoiding Naming Collisions
  single_trailing_underscore_

  This convention is suggested when the desired name collides with that of a built-in or otherwise reserved name.

 NatSpec
  Solidity contracts can also contain NatSpec comments. They are written with a triple slash (///) or a double asterisk block (/** ... */) and they should be used directly above function declarations or statements.
  NatSpec rules
   /// @title A simulator for trees
   /// @author Larry A. Gardner
   /// @notice You can use this contract for only the most basic simulation
   /// @dev All function calls are currently implemented without side effects
   /// @custom:experimental This is an experimental contract.

   contract Tree {
    /// @notice Calculate tree age in years, rounded up, for live trees
    /// @dev The Alexandr N. Tetearing algorithm could increase precision
    /// @param rings The number of rings from dendrochronological sample
    /// @return Age in years, rounded up for partial years
    function age(uint256 rings) external virtual pure returns (uint256) {
        return rings + 1;
    }

    /// @notice Returns the amount of leaves the tree has.
    /// @dev Returns only a fixed number.
    function leaves() external virtual pure returns(uint256) {
        return 2;
    }
    }

   contract Plant {
    function leaves() external virtual pure returns(uint256) {
        return 3;
    }
    }

   contract KumquatTree is Tree, Plant {
    function age(uint256 rings) external override pure returns (uint256) {
        return rings + 2;
    }

    /// Return the amount of leaves that this specific kind of tree has
    /// @inheritdoc Tree
    function leaves() external override(Tree, Plant) pure returns(uint256) {
        return 3;
    }
    }
   It is recommended that Solidity contracts are fully annotated using NatSpec for all public interfaces 
   (everything in the ABI).
==============================================================
oracle services
 schedule future calls of your contract, you can use the alarm clock or a similar oracle service.

example contract layouts 

 Modular Contracts
   // SPDX-License-Identifier: GPL-3.0
  pragma solidity >=0.5.0 <0.9.0;

  library Balances {
    function move(mapping(address => uint256) storage balances, address from, address to, uint amount) internal {
        require(balances[from] >= amount);
        require(balances[to] + amount >= balances[to]);
        balances[from] -= amount;
        balances[to] += amount;
    }
    }

  contract Token {
    mapping(address => uint256) balances;
    using Balances for *;
    mapping(address => mapping (address => uint256)) allowed;

    event Transfer(address from, address to, uint amount);
    event Approval(address owner, address spender, uint amount);

    function transfer(address to, uint amount) public returns (bool success) {
        balances.move(msg.sender, to, amount);
        emit Transfer(msg.sender, to, amount);
        return true;

    }

    function transferFrom(address from, address to, uint amount) public returns (bool success) {
        require(allowed[from][msg.sender] >= amount);
        allowed[from][msg.sender] -= amount;
        balances.move(from, to, amount);
        emit Transfer(from, to, amount);
        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        require(allowed[msg.sender][spender] == 0, "");
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }
    }
 verifing payments
  // this mimics the prefixing behavior of the eth_sign JSON-RPC method.
  function prefixed(hash) {
    return ethereumjs.ABI.soliditySHA3(
        ["string", "bytes32"],
        ["\x19Ethereum Signed Message:\n32", hash]
    );
  }

  function recoverSigner(message, signature) {
    var split = ethereumjs.Util.fromRpcSig(signature);
    var publicKey = ethereumjs.Util.ecrecover(message, split.v, split.r, split.s);
    var signer = ethereumjs.Util.pubToAddress(publicKey).toString("hex");
    return signer;
  }

  function isValidSignature(contractAddress, amount, signature, expectedSigner) {
    var message = prefixed(constructPaymentMessage(contractAddress, amount));
    var signer = recoverSigner(message, signature);
    return signer.toLowerCase() ==
        ethereumjs.Util.stripHexPrefix(expectedSigner).toLowerCase();
  }
 Writing a Simple Payment Channel
  // SPDX-License-Identifier: GPL-3.0
   pragma solidity >=0.7.0 <0.9.0;
    contract SimplePaymentChannel {
    address payable public sender;      // The account sending payments.
    address payable public recipient;   // The account receiving the payments.
    uint256 public expiration;  // Timeout in case the recipient never closes.

    constructor (address payable _recipient, uint256 duration)
        payable
    {
        sender = payable(msg.sender);
        recipient = _recipient;
        expiration = block.timestamp + duration;
    }

    /// the recipient can close the channel at any time by presenting a
    /// signed amount from the sender. the recipient will be sent that amount,
    /// and the remainder will go back to the sender
    function close(uint256 amount, bytes memory signature) public {
        require(msg.sender == recipient);
        require(isValidSignature(amount, signature));

        recipient.transfer(amount);
        selfdestruct(sender);
    }

    /// the sender can extend the expiration at any time
    function extend(uint256 newExpiration) public {
        require(msg.sender == sender);
        require(newExpiration > expiration);

        expiration = newExpiration;
    }

    /// if the timeout is reached without the recipient closing the channel,
    /// then the Ether is released back to the sender.
    function claimTimeout() public {
        require(block.timestamp >= expiration);
        selfdestruct(sender);
    }

    function isValidSignature(uint256 amount, bytes memory signature)
        internal
        view
        returns (bool)
    {
        bytes32 message = prefixed(keccak256(abi.encodePacked(this, amount)));

        // check that the signature is from the payment sender
        return recoverSigner(message, signature) == sender;
    }

    /// All functions below this are just taken from the chapter
    /// 'creating and verifying signatures' chapter.

    function splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        require(sig.length == 65);

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    function recoverSigner(bytes32 message, bytes memory sig)
        internal
        pure
        returns (address)
    {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

        return ecrecover(message, v, r, s);
    }

    /// builds a prefixed hash to mimic the behavior of eth_sign.
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
    }
 Recovering the Message Signer in Solidity 
  // SPDX-License-Identifier: GPL-3.0
  pragma solidity >=0.7.0 <0.9.0;
  contract ReceiverPays {
    address owner = msg.sender;

    mapping(uint256 => bool) usedNonces;

    constructor() payable {}

    function claimPayment(uint256 amount, uint256 nonce, bytes memory signature) public {
        require(!usedNonces[nonce]);
        usedNonces[nonce] = true;

        // this recreates the message that was signed on the client
        bytes32 message = prefixed(keccak256(abi.encodePacked(msg.sender, amount, nonce, this)));

        require(recoverSigner(message, signature) == owner);

        payable(msg.sender).transfer(amount);
    }

    /// destroy the contract and reclaim the leftover funds.
    function shutdown() public {
        require(msg.sender == owner);
        selfdestruct(payable(msg.sender));
    }

    /// signature methods.
    function splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        require(sig.length == 65);

        assembly {
            // first 32 bytes, after the length prefix.
            r := mload(add(sig, 32))
            // second 32 bytes.
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes).
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    function recoverSigner(bytes32 message, bytes memory sig)
        internal
        pure
        returns (address)
    {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

        return ecrecover(message, v, r, s);
    }

    /// builds a prefixed hash to mimic the behavior of eth_sign.
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
    }
 a simple layout of a smart contract 
  
  // SPDX-License-Identifier: GPL-3.0
  pragma solidity >=0.4.16 <0.9.0;

  contract SimpleStorage {
  uint storedData;
  function set(uint x) public {
  storedData = x;
  }

  function get() public view returns (uint) {
  return storedData;
  }
  }

  ==========================================================================================================


 storage example layout of a smart contract

  // SPDX-License-Identifier: GPL-3.0
  pragma solidity >=0.4.16 <0.9.0;

  contract SimpleStorage {
  uint storedData;

  function set(uint x) public {
  storedData = x;
  }

  function get() public view returns (uint) {
  return storedData;
  }
  }

  ==========================================================================================================



 subcurrency contract layout
   // SPDX-License-Identifier: GPL-3.0
   pragma solidity ^0.8.4;

    contract Coin {
    // The keyword "public" makes variables
    // accessible from other contracts
    address public minter;
    mapping (address => uint) public balances;

    // Events allow clients to react to specific
    // contract changes you declare
    event Sent(address from, address to, uint amount);

    // Constructor code is only run when the contract
    // is created
    constructor() {
        minter = msg.sender;
    }

    // Sends an amount of newly created coins to an address
    // Can only be called by the contract creator
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    // Errors allow you to provide information about
    // why an operation failed. They are returned
    // to the caller of the function.
    error InsufficientBalance(uint requested, uint available);

    // Sends an amount of existing coins
    // from any caller to an address
    function send(address receiver, uint amount) public {
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
    }
 voting contract example
  // SPDX-License-Identifier: GPL-3.0
  pragma solidity >=0.7.0 <0.9.0;
  /// @title Voting with delegation.
  contract Ballot {
    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    struct Voter {
        uint weight; // weight is accumulated by delegation
        bool voted;  // if true, that person already voted
        address delegate; // person delegated to
        uint vote;   // index of the voted proposal
    }

    // This is a type for a single proposal.
    struct Proposal {
        bytes32 name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    address public chairperson;

    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // A dynamically-sized array of `Proposal` structs.
    Proposal[] public proposals;

    /// Create a new ballot to choose one of `proposalNames`.
    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        // For each of the provided proposal names,
        // create a new proposal object and add it
        // to the end of the array.
        for (uint i = 0; i < proposalNames.length; i++) {
            // `Proposal({...})` creates a temporary
            // Proposal object and `proposals.push(...)`
            // appends it to the end of `proposals`.
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // Give `voter` the right to vote on this ballot.
    // May only be called by `chairperson`.
    function giveRightToVote(address voter) public {
        // If the first argument of `require` evaluates
        // to `false`, execution terminates and all
        // changes to the state and to Ether balances
        // are reverted.
        // This used to consume all gas in old EVM versions, but
        // not anymore.
        // It is often a good idea to use `require` to check if
        // functions are called correctly.
        // As a second argument, you can also provide an
        // explanation about what went wrong.
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    /// Delegate your vote to the voter `to`.
    function delegate(address to) public {
        // assigns reference
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");

        require(to != msg.sender, "Self-delegation is disallowed.");

        // Forward the delegation as long as
        // `to` also delegated.
        // In general, such loops are very dangerous,
        // because if they run too long, they might
        // need more gas than is available in a block.
        // In this case, the delegation will not be executed,
        // but in other situations, such loops might
        // cause a contract to get "stuck" completely.
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // We found a loop in the delegation, not allowed.
            require(to != msg.sender, "Found loop in delegation.");
        }

        // Since `sender` is a reference, this
        // modifies `voters[msg.sender].voted`
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if (delegate_.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote yet,
            // add to her weight.
            delegate_.weight += sender.weight;
        }
    }

    /// Give your vote (including votes delegated to you)
    /// to proposal `proposals[proposal].name`.
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        // If `proposal` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev Computes the winning proposal taking all
    /// previous votes into account.
    function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    // Calls winningProposal() function to get the index
    // of the winner contained in the proposals array and then
    // returns the name of the winner
    function winnerName() public view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
    }

 a open auction
  // SPDX-License-Identifier: GPL-3.0
  pragma solidity >=0.7.0 <0.9.0;
  /// @title Voting with delegation.
  contract Ballot {
    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    struct Voter {
        uint weight; // weight is accumulated by delegation
        bool voted;  // if true, that person already voted
        address delegate; // person delegated to
        uint vote;   // index of the voted proposal
    }

    // This is a type for a single proposal.
    struct Proposal {
        bytes32 name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    address public chairperson;

    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // A dynamically-sized array of `Proposal` structs.
    Proposal[] public proposals;

    /// Create a new ballot to choose one of `proposalNames`.
    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        // For each of the provided proposal names,
        // create a new proposal object and add it
        // to the end of the array.
        for (uint i = 0; i < proposalNames.length; i++) {
            // `Proposal({...})` creates a temporary
            // Proposal object and `proposals.push(...)`
            // appends it to the end of `proposals`.
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // Give `voter` the right to vote on this ballot.
    // May only be called by `chairperson`.
    function giveRightToVote(address voter) public {
        // If the first argument of `require` evaluates
        // to `false`, execution terminates and all
        // changes to the state and to Ether balances
        // are reverted.
        // This used to consume all gas in old EVM versions, but
        // not anymore.
        // It is often a good idea to use `require` to check if
        // functions are called correctly.
        // As a second argument, you can also provide an
        // explanation about what went wrong.
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    /// Delegate your vote to the voter `to`.
    function delegate(address to) public {
        // assigns reference
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");

        require(to != msg.sender, "Self-delegation is disallowed.");

        // Forward the delegation as long as
        // `to` also delegated.
        // In general, such loops are very dangerous,
        // because if they run too long, they might
        // need more gas than is available in a block.
        // In this case, the delegation will not be executed,
        // but in other situations, such loops might
        // cause a contract to get "stuck" completely.
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // We found a loop in the delegation, not allowed.
            require(to != msg.sender, "Found loop in delegation.");
        }

        // Since `sender` is a reference, this
        // modifies `voters[msg.sender].voted`
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if (delegate_.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote yet,
            // add to her weight.
            delegate_.weight += sender.weight;
        }
    }

    /// Give your vote (including votes delegated to you)
    /// to proposal `proposals[proposal].name`.
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        // If `proposal` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev Computes the winning proposal taking all
    /// previous votes into account.
    function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    // Calls winningProposal() function to get the index
    // of the winner contained in the proposals array and then
    // returns the name of the winner
    function winnerName() public view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
    }

 a blind auction
  // SPDX-License-Identifier: GPL-3.0
  pragma solidity ^0.8.4;
  contract BlindAuction {
    struct Bid {
        bytes32 blindedBid;
        uint deposit;
    }

    address payable public beneficiary;
    uint public biddingEnd;
    uint public revealEnd;
    bool public ended;

    mapping(address => Bid[]) public bids;

    address public highestBidder;
    uint public highestBid;

    // Allowed withdrawals of previous bids
    mapping(address => uint) pendingReturns;

    event AuctionEnded(address winner, uint highestBid);

    // Errors that describe failures.

    /// The function has been called too early.
    /// Try again at `time`.
    error TooEarly(uint time);
    /// The function has been called too late.
    /// It cannot be called after `time`.
    error TooLate(uint time);
    /// The function auctionEnd has already been called.
    error AuctionEndAlreadyCalled();

    // Modifiers are a convenient way to validate inputs to
    // functions. `onlyBefore` is applied to `bid` below:
    // The new function body is the modifier's body where
    // `_` is replaced by the old function body.
    modifier onlyBefore(uint _time) {
        if (block.timestamp >= _time) revert TooLate(_time);
        _;
    }
    modifier onlyAfter(uint _time) {
        if (block.timestamp <= _time) revert TooEarly(_time);
        _;
    }

    constructor(
        uint _biddingTime,
        uint _revealTime,
        address payable _beneficiary
    ) {
        beneficiary = _beneficiary;
        biddingEnd = block.timestamp + _biddingTime;
        revealEnd = biddingEnd + _revealTime;
    }

    /// Place a blinded bid with `_blindedBid` =
    /// keccak256(abi.encodePacked(value, fake, secret)).
    /// The sent ether is only refunded if the bid is correctly
    /// revealed in the revealing phase. The bid is valid if the
    /// ether sent together with the bid is at least "value" and
    /// "fake" is not true. Setting "fake" to true and sending
    /// not the exact amount are ways to hide the real bid but
    /// still make the required deposit. The same address can
    /// place multiple bids.
    function bid(bytes32 _blindedBid)
        public
        payable
        onlyBefore(biddingEnd)
    {
        bids[msg.sender].push(Bid({
            blindedBid: _blindedBid,
            deposit: msg.value
        }));
    }

    /// Reveal your blinded bids. You will get a refund for all
    /// correctly blinded invalid bids and for all bids except for
    /// the totally highest.
    function reveal(
        uint[] memory _values,
        bool[] memory _fake,
        bytes32[] memory _secret
    )
        public
        onlyAfter(biddingEnd)
        onlyBefore(revealEnd)
    {
        uint length = bids[msg.sender].length;
        require(_values.length == length);
        require(_fake.length == length);
        require(_secret.length == length);

        uint refund;
        for (uint i = 0; i < length; i++) {
            Bid storage bidToCheck = bids[msg.sender][i];
            (uint value, bool fake, bytes32 secret) =
                    (_values[i], _fake[i], _secret[i]);
            if (bidToCheck.blindedBid != keccak256(abi.encodePacked(value, fake, secret))) {
                // Bid was not actually revealed.
                // Do not refund deposit.
                continue;
            }
            refund += bidToCheck.deposit;
            if (!fake && bidToCheck.deposit >= value) {
                if (placeBid(msg.sender, value))
                    refund -= value;
            }
            // Make it impossible for the sender to re-claim
            // the same deposit.
            bidToCheck.blindedBid = bytes32(0);
        }
        payable(msg.sender).transfer(refund);
    }

    /// Withdraw a bid that was overbid.
    function withdraw() public {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before `transfer` returns (see the remark above about
            // conditions -> effects -> interaction).
            pendingReturns[msg.sender] = 0;

            payable(msg.sender).transfer(amount);
        }
    }

    /// End the auction and send the highest bid
    /// to the beneficiary.
    function auctionEnd()
        public
        onlyAfter(revealEnd)
    {
        if (ended) revert AuctionEndAlreadyCalled();
        emit AuctionEnded(highestBidder, highestBid);
        ended = true;
        beneficiary.transfer(highestBid);
    }

    // This is an "internal" function which means that it
    // can only be called from the contract itself (or from
    // derived contracts).
    function placeBid(address bidder, uint value) internal
            returns (bool success)
    {
        if (value <= highestBid) {
            return false;
        }
        if (highestBidder != address(0)) {
            // Refund the previously highest bidder.
            pendingReturns[highestBidder] += highestBid;
        }
        highestBid = value;
        highestBidder = bidder;
        return true;
    }
    }

 Safe Remote Purchase
  // SPDX-License-Identifier: GPL-3.0
  pragma solidity ^0.8.4;
  contract Purchase {
    uint public value;
    address payable public seller;
    address payable public buyer;

    enum State { Created, Locked, Release, Inactive }
    // The state variable has a default value of the first member, `State.created`
    State public state;

    modifier condition(bool _condition) {
        require(_condition);
        _;
    }

    /// Only the buyer can call this function.
    error OnlyBuyer();
    /// Only the seller can call this function.
    error OnlySeller();
    /// The function cannot be called at the current state.
    error InvalidState();
    /// The provided value has to be even.
    error ValueNotEven();

    modifier onlyBuyer() {
        if (msg.sender != buyer)
            revert OnlyBuyer();
        _;
    }

    modifier onlySeller() {
        if (msg.sender != seller)
            revert OnlySeller();
        _;
    }

    modifier inState(State _state) {
        if (state != _state)
            revert InvalidState();
        _;
    }

    event Aborted();
    event PurchaseConfirmed();
    event ItemReceived();
    event SellerRefunded();

    // Ensure that `msg.value` is an even number.
    // Division will truncate if it is an odd number.
    // Check via multiplication that it wasn't an odd number.
    constructor() payable {
        seller = payable(msg.sender);
        value = msg.value / 2;
        if ((2 * value) != msg.value)
            revert ValueNotEven();
    }

    /// Abort the purchase and reclaim the ether.
    /// Can only be called by the seller before
    /// the contract is locked.
    function abort()
        public
        onlySeller
        inState(State.Created)
    {
        emit Aborted();
        state = State.Inactive;
        // We use transfer here directly. It is
        // reentrancy-safe, because it is the
        // last call in this function and we
        // already changed the state.
        seller.transfer(address(this).balance);
    }

    /// Confirm the purchase as buyer.
    /// Transaction has to include `2 * value` ether.
    /// The ether will be locked until confirmReceived
    /// is called.
    function confirmPurchase()
        public
        inState(State.Created)
        condition(msg.value == (2 * value))
        payable
    {
        emit PurchaseConfirmed();
        buyer = payable(msg.sender);
        state = State.Locked;
    }

    /// Confirm that you (the buyer) received the item.
    /// This will release the locked ether.
    function confirmReceived()
        public
        onlyBuyer
        inState(State.Locked)
    {
        emit ItemReceived();
        // It is important to change the state first because
        // otherwise, the contracts called using `send` below
        // can call in again here.
        state = State.Release;

        buyer.transfer(value);
    }

    /// This function refunds the seller, i.e.
    /// pays back the locked funds of the seller.
    function refundSeller()
        public
        onlySeller
        inState(State.Release)
    {
        emit SellerRefunded();
        // It is important to change the state first because
        // otherwise, the contracts called using `send` below
        // can call in again here.
        state = State.Inactive;

        seller.transfer(3 * value);
    }
    }



==============================================================
SPDX license 
 //SPDX license identifiers. Every source file should start with a comment indicating its license:
 // SPDX-License-Identifier: MIT
 //If you do not want to specify a license or if the source code is not open-source, please use the special value UNLICENSED.       READ MORE YOU DEGEN
pragma solidity >=0.5.0 <0.9.0;
  //specify more complex rules for the compiler version, these follow the same syntax used by npm.
  //https://docs.npmjs.com/cli/v6/using-npm/semver
 pragma abicoder v1 or pragma abicoder v2 
  //you can select between the two implementations of the ABI encoder and decoder
   //The new ABI coder (v2) is able to encode and decode arbitrarily nested arrays and structs. It might produce less optimal code and has not received as much testing as the old encoder, but is considered non-experimental as of Solidity 0.6.0. You still have to explicitly activate it using pragma abicoder v2;. Since it will be activated by default starting from Solidity 0.8.0, there is the option to select the old coder using pragma abicoder v1;.

   //The set of types supported by the new encoder is a strict superset of the ones supported by the old one. Contracts that use it can interact with ones that do not without limitations. The reverse is possible only as long as the non-abicoder v2 contract does not try to make calls that would require decoding types only supported by the new encoder. The compiler can detect this and will issue an error. Simply enabling abicoder v2 for your contract is enough to make the error go away.

   Note

    This pragma applies to all the code defined in the file where it is activated, regardless of where that code ends up eventually. This means that a contract whose source file is selected to compile with ABI coder v1 can still contain code that uses the new encoder by inheriting it from another contract. This is allowed if the new types are only used internally and not in external function signatures.

 pragma experimental ABIEncoderV2
  //Because the ABI coder v2 is not considered experimental anymore, it can be selected via 
  pragma abicoder v2
   The second pragma is the experimental pragma. It can be used to enable features of the compiler or language that are not yet enabled by default. The following experimental pragmas are currently supported:
 pragma experimental SMTChecker;
  //This component has to be enabled when the Solidity compiler is built and therefore it is not available in all Solidity binaries. The build instructions explain how to activate this option. It is activated for the Ubuntu PPA releases in most versions, but not for the Docker images, Windows binaries or the statically-built Linux binaries. It can be activated for solc-js via the smtCallback if you have an SMT solver installed locally and run solc-js via node (not via the browser).

  //If you use pragma experimental SMTChecker;, then you get additional safety warnings which are obtained by querying an SMT solver. The component does not yet support all features of the Solidity language and likely outputs many warnings. In case it reports unsupported features, the analysis may not be fully sound.



  Supplying this comment of course does not free you from other obligations related  to licensing like having to mention a specific license header in each source file or the original copyright holder. 
  https://spdx.dev/ids/#how

IMPORT DIRECTIVE
CONTRACT DEFINITION
INTERFACE DEFINITION
LIBRARY 
FUNCTION
 useful functions
  The getter function  
   function balances(address _account) external view returns (uint) {
   return balances[_account];
   }
   //The getter function created by the public keyword is more complex in the case of a mapping. //use this function to query the balance of a single account.

  The require function call 
    .//defines conditions that reverts all changes if not met.
    //example   ensures that only the creator of the contract can call mint
    require(msg.sender == minter); 

  the contsructer 
   //is a special function that is executed during the creation of the contract and cannot be called afterwards. In this case, it permanently stores the address of the person creating the contract.
   Coin.Sent().watch({}, '', function(error, result) {
   if (!error) {
   console.log("Coin transfer: " + result.args.amount +
   " coins were sent from " + result.args.from +
   " to " + result.args.to + ".");
   console.log("Balances now:\n" +
   "Sender: " + Coin.balances.call(result.args.from) +
   "Receiver: " + Coin.balances.call(result.args.to));
   }
   })



  Delegatecall / Callcode and Libraries
   //There exists a special variant of a message call, named delegatecall which is identical to a message call apart from the fact that the code at the target address is executed in the context of the calling contract and msg.sender and msg.value do not change their values.

   //This means that a contract can dynamically load code from a different address at runtime. Storage, current address and balance still refer to the calling contract, only the code is taken from the called address.
   //This makes it possible to implement the “library” feature in Solidity: Reusable library code that can be applied to a contract’s storage, e.g. in order to implement a complex data structure.
   
   contract and msg.sender
   msg.value

  function minter() external view returns (address) { return minter; }
   //You could add a function like the above yourself, but you would have a function and state variable with the same name. You do not need to do this, the compiler figures it out for you.
  mapping (address => uint) public balances; 
   //also creates a public state variable, but it is a more complex datatype. The mapping type maps addresses to unsigned integers.
   //Mappings can be seen as hash tables which are virtually initialised such that every possible key exists from the start and is mapped to a value whose byte-representation is all zeros. However, it is neither possible to obtain a list of all keys of a mapping, nor a list of all values. Record what you added to the mapping, or use it in a context where this is not needed. Or even better, keep a list, or use a more suitable data type.
 =============
 functions 
  Function Visibility Specifiers
   //function myFunction() <visibility specifier> returns (bool) { return true; }
  public: 
   //visible externally and internally (creates a getter function for storage/state variables)

  private:  
   //only visible in the current contract

  external: 
   //only visible externally (only for functions) - i.e. can only be message-called (via this.func)

  internal: 
   //only visible internally
  ================
  Modifiers
  pure for functions: 
    //Disallows modification or access of state.
  view for functions: 
    //Disallows modification of state.
  payable for functions: 
    //Allows them to receive Ether together with a call.
  constant for state variables: 
    //Disallows assignment (except initialisation), does not occupy storage slot.
  immutable for state variables: 
    //Allows exactly one assignment at construction time and is constant afterwards. Is stored in code.
  anonymous for events: 
    //Does not store event signature as topic.
  indexed for events parameters: 
    //Stores the parameter as topic.
  virtual for functions and modifiers: 
    //Allows the function’s or modifier’s behaviour to be changed in derived contracts.
  override: 
    //States that this function, modifier or public state variable changes the behaviour of a function or modifier in a base contract.
 ================
 Builtin functions in the EVM Yul dialect.
  'stop'
  'add'
  'sub'
  'mul'
  'div'
  'sdiv'
  'mod'
  'smod'
  'exp'
  'not'
  'lt'
  'gt'
  'slt'
  'sgt'
  'eq'
  'iszero'
  'and'
  'or'
  'xor'
  'byte'
  'shl'
  'shr'
  'sar'
  'addmod'
  'mulmod'
  'signextend'
  'keccak256'
  'pop'
  'mload'
  'mstore'
  'mstore8'
  'sload'
  'sstore'
  'msize'
  'gas'
  'address'
  'balance'
  'selfbalance'
  'caller'
  'callvalue'
  'calldataload'
  'calldatasize'
  'calldatacopy'
  'extcodesize'
  'extcodecopy'
  'returndatasize'
  'returndatacopy'
  'extcodehash'
  'create'
  'create2'
  'call'
  'callcode'
  'delegatecall'
  'staticcall'
  'return'
  'revert'
  'selfdestruct'
  'invalid'
  'log0'
  'log1'
  'log2'
  'log3'
  'log4'
  'chainid'
  'origin'
  'gasprice'
  'blockhash'
  'coinbase'
  'timestamp'
  'number'
  'difficulty'
  'gaslimit'
  'basefee'
CONSTANT VARIABLE
 Global Variables
 abi.decode(bytes memory encodedData, (...)) returns (...): 
  //ABI-decodes the provided data. The types are given in parentheses as second argument. Example: (uint a, uint[2] memory b, bytes memory c) = abi.decode(data, (uint, uint[2], bytes))

 abi.encode(...) returns (bytes memory): 
  //ABI-encodes the given arguments

 abi.encodePacked(...) returns (bytes memory): 
  //Performs packed encoding of the given arguments. Note that this encoding can be ambiguous!

 abi.encodeWithSelector(bytes4 selector, ...) returns (bytes memory): 
  //ABI-encodes the given arguments starting from the second and prepends the given four-byte selector

 abi.encodeWithSignature(string memory signature, ...) returns (bytes memory): 
  //Equivalent to abi.encodeWithSelector(bytes4(keccak256(bytes(signature)), ...)`

 bytes.concat(...) returns (bytes memory): 
  //Concatenates variable number of arguments to one byte array

 block.basefee (uint): 
  //current block’s base fee (EIP-3198 and EIP-1559)

 block.chainid (uint): 
  //current chain id

 block.coinbase (address payable): 
  //current block miner’s address

 block.difficulty (uint):  
  //current block difficulty

 block.gaslimit (uint): c
  //urrent block gaslimit

 block.number (uint): 
  //current block number

 block.timestamp (uint):
  //current block timestamp

 gasleft() returns (uint256): 
  //remaining gas

 msg.data (bytes): 
  //complete calldata

 msg.sender (address): 
  //sender of the message (current call)

 msg.value (uint):  
  //number of wei sent with the message

 tx.gasprice (uint): 
  //gas price of the transaction

 tx.origin (address): 
  //sender of the transaction (full call chain)

 assert(bool condition): 
  //abort execution and revert state changes if condition is false (use for internal error)

 require(bool condition): 
  //abort execution and revert state changes if condition is false (use for malformed input or error in external component)

 require(bool condition, string memory message): 
  //abort execution and revert state changes if condition is false (use for malformed input or error in external component). Also provide error message.

 revert(): 
  //abort execution and revert state changes

 revert(string memory message): 
  //abort execution and revert state changes providing an explanatory string

 blockhash(uint blockNumber) returns (bytes32): 
  //hash of the given block - only works for 256 most recent blocks

 keccak256(bytes memory) returns (bytes32): 
  //compute the Keccak-256 hash of the input

 sha256(bytes memory) returns (bytes32): 
  //compute the SHA-256 hash of the input

 ripemd160(bytes memory) returns (bytes20): 
  //compute the RIPEMD-160 hash of the input

 ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address): 
  //recover address associated with the public key from elliptic curve signature, return zero on error

 addmod(uint x, uint y, uint k) returns (uint): 
   //compute (x + y) % k where the addition is performed with arbitrary precision and does not wrap around at 2**256. Assert that k != 0 starting from version 0.5.0.

 mulmod(uint x, uint y, uint k) returns (uint): 
  //compute (x * y) % k where the multiplication is performed with arbitrary precision and does not wrap around at 2**256. Assert that k != 0 starting from version 0.5.0.

 this (current contract’s type): 
   //the current contract, explicitly convertible to address or address payable

 super: 
  //the contract one level higher in the inheritance hierarchy

 selfdestruct(address payable recipient): 
  //destroy the current contract, sending its funds to the given address

 <address>.balance (uint256): 
  //balance of the Address in Wei 

 <address>.code (bytes memory): 
   //code at the Address (can be empty)

 <address>.codehash (bytes32): 
  //the codehash of the Address

 <address payable>.send(uint256 amount) returns (bool): 
  //send given amount of Wei to Address, returns false on failure

 <address payable>.transfer(uint256 amount): 
   //send given amount of Wei to Address, throws on failure

 type(C).name (string): 
  //the name of the contract

 type(C).creationCode (bytes memory): 
  //creation bytecode of the given contract, see Type Information.

 type(C).runtimeCode (bytes memory): 
  //runtime bytecode of the given contract, see Type Information.

 type(I).interfaceId (bytes4): 
   //value containing the EIP-165 interface identifier of the given interface, see Type Information.

 type(T).min (T): 
  //the minimum value representable by the integer type T, see Type Information.

 type(T).max (T): 
  //the maximum value representable by the integer type T, see Type Information.
STRUCT
ENUM
ERROR
 JSONError: 
  //JSON input doesn’t conform to the required format, e.g. input is not a JSON object, the language is not supported, etc.
 IOError: 
  //IO and import processing errors, such as unresolvable URL or hash mismatch in supplied sources.

 ParserError: 
  //Source code doesn’t conform to the language rules.

 DocstringParsingError: 
  //The NatSpec tags in the comment block cannot be parsed.

 SyntaxError: 
  //Syntactical error, such as continue is used outside of a for loop.

 DeclarationError: 
  //Invalid, unresolvable or clashing identifier names. e.g. Identifier not found

 TypeError: 
  //Error within the type system, such as invalid type conversions, invalid assignments, etc.

 UnimplementedFeatureError: 
  //Feature is not supported by the compiler, but is expected to be supported in future versions.

 InternalCompilerError: 
  //Internal bug triggered in the compiler - this should be reported as an issue.

 Exception: 
  //Unknown failure during compilation - this should be reported as an issue.

 CompilerError: 
  //Invalid use of the compiler stack - this should be reported as an issue.

 FatalError: 
  //Fatal error not processed correctly - this should be reported as an issue.

 Warning: 
  //A warning, which didn’t stop the compilation, but should be addressed if possible.
======================
=====continue on 
https://docs.soliditylang.org/en/v0.8.7/internals/layout_in_storage.html

solc commandline compiler 
 https://docs.soliditylang.org/en/v0.8.7/using-the-compiler.html
 https://docs.soliditylang.org/en/v0.8.7/analysing-compilation-output.html
======================

word list and definitions with examples
 ================
 a
    address public minter; 
     //The line address public minter; declares a state variable of type address. The address type is a 160-bit value that does not allow any arithmetic operations. It is suitable for storing addresses of contracts, or a hash of the public half of a keypair belonging to external accounts.
    account
    address
    amount
 ================
 b
    bloom filters
    balance
    balances
    bool
    bytes32
    block
 ================
 c
    constructor
    contract
    Coin
    create
     //Contracts can even create other contracts using a special opcode (i.e. they do not simply call the zero address as a transaction would). The only difference between these create calls and normal message calls is that the payload data is executed and the result stored as code and the caller / creator receives the address of the new contract on the stack.
 ================
 d
    Delegatecall / Callcode and Libraries
     //There exists a special variant of a message call, named delegatecall which is identical to a message call apart from the fact that the code at the target address is executed in the context of the calling contract and msg.sender and msg.value do not change their values.

     //This means that a contract can dynamically load code from a different address at runtime. Storage, current address and balance still refer to the calling contract, only the code is taken from the called address.

     //This makes it possible to implement the “library” feature in Solidity: Reusable library code that can be applied to a contract’s storage, e.g. in order to implement a complex data structure. 
    data
    selfdestruct
      //Even if a contract’s code does not contain a call to selfdestruct, it can still perform that operation using delegatecall or callcode.

      //If you want to deactivate your contracts, you should instead disable them by changing some internal state which causes all functions to revert. This makes it impossible to use the contract, as it returns Ether immediately.
 ================
 e
    EVM
    emit 
    else
    event
    external
    external payable
 ================
 f
    Function Modifiers
     //Function modifiers can be used to amend the semantics of functions in a declarative way
    filename 
     // is called an import path. This statement imports all global symbols from “filename” (and symbols imported there) into the current global scope (different than in ES6 but backwards-compatible for Solidity). This form is not recommended for use, because it unpredictably pollutes the namespace. If you add new top-level items inside “filename”, they automatically appear in all files that import like this from “filename”. It is better to import specific symbols explicitly.
    fallback
    function
     //executable units of code. Functions are usually defined inside a contract, but they can also be defined outside of contracts.   
     //a collection of code (its functions) and data (its state) that resides at a specific address on the Ethereum blockchain
     // function call defines conditions that reverts all changes if not met
 ================
 g
    gas
    get
      used to retrieve the value of the variable
    gas_price * gas
      //a value set by the creator of the transaction, who has to pay gas_price * gas up front from the sending account. If some gas is left after the execution, it is refunded to the creator in the same way.

     //If the gas is used up at any point (i.e. it would be negative), an out-of-gas exception is triggered, which reverts all modifications made to the state in the current call frame.
 ================
 h
 ================
 i
    if
      //condition evaluates to true if ... if codition isnt met it reverts the operation of transaction to fail
    import
    Instruction Set
     //The instruction set of the EVM is kept minimal in order to avoid incorrect or inconsistent implementations which could cause consensus problems. All instructions operate on the basic data type, 256-bit words or on slices of memory (or other byte arrays). The usual arithmetic, bit, logical and comparison operations are present. Conditional and unconditional jumps are possible. Furthermore, contracts can access relevant properties of the current block like its number and timestamp.

     //For a complete list, please see the list of opcodes as part of the inline assembly documentation. 
 ================
 l
    long_variable
    logs
     //it is possible to store data in a specially indexed data structure that maps all the way up to the block level. This feature called logs is used by Solidity in order to implement events. Contracts cannot access log data after it has been created, but they can be efficiently accessed from outside the blockchain. Since some part of the log data is stored in bloom filters, it is possible to search for this data in an efficient and cryptographically secure way, so network peers that do not download the whole blockchain (so-called “light clients”) can still find these logs
 ================
 m
  mint
     //The functions that make up the contract, and that users and contracts can call 
  map
  mapping
  modifier
  msg.sender
    //always the address where the current (external) function call came from.
  msg.tx
      //special global variable that contains properties which allow access to the blockchain
  msg.sender
    // special global variable that contains properties which allow access to the blockchain
  Message Calls
   //Contracts can call other contracts or send Ether to non-contract accounts by the means of message calls. Message calls are similar to transactions, in that they have a source, a target, data payload, Ether, gas and return data. In fact, every transaction consists of a top-level message call which in turn can create further message calls.

   ///A contract can decide how much of its remaining gas should be sent with the inner message call and how much it wants to retain. If an out-of-gas exception happens in the inner call (or any other exception), this will be signaled by an error value put onto the stack. In this case, only the gas sent together with the call is used up. In Solidity, the calling contract causes a manual exception by default in such situations, so that exceptions “bubble up” the call stack.

   ///As already said, the called contract (which can be the same as the caller) will receive a freshly cleared instance of memory and has access to the call payload - which will be provided in a separate area called the calldata. After it has finished execution, it can return data which will be stored at a location in the caller’s memory preallocated by the caller. All such calls are fully synchronous.

   //Calls are limited to a depth of 1024, which means that for more complex operations, loops should be preferred over recursive calls. Furthermore, only 63/64th of the gas can be forwarded in a message call, which causes a depth limit of a little less than 1000 in practice.
 ================
 n
    newOwner
    Number
    “nonce”
    null
    npm / node.js and other useful sofware
     //Use npm for a convenient and portable way to install solcjs, a Solidity compiler. The solcjs program has fewer features than the ways to access the compiler described further down this page. The Using the Commandline Compiler documentation assumes you are using the full-featured compiler, solc. The usage of solcjs is documented inside its own repository.
     https://docs.soliditylang.org/en/v0.8.7/using-the-compiler.html#commandline-compiler
     https://github.com/ethereum/solc-js
     https://docs.soliditylang.org/en/v0.8.7/installing-solidity.html

     //Note: The solc-js project is derived from the C++ solc by using Emscripten which means that both use the same compiler source code. solc-js can be used in JavaScript projects directly (such as Remix). Please refer to the solc-js repository for instructions.
 ================
 o

    overflow
    onlyOwner
    options
    owner
 ================
 p
    payable 
    “payload”
    param1   param2   param3  amd so on
    percent
    pragma
    priced
    Private
    public    
      //makes variables accessible from outside the contract
    public pure     
      //values are stored locally and not on the blockchain 
    public pure onlyOwner returns     
    public pure override
    public pure returns
    public virtual pure
    public view returns
    publicKey
    Purchase 
 ================
 r
    reciever
    receive
    recipient
    registeredAddresses
    require
    return
    returns
    revert
     //will cause the operation to fail while providing the sender with error details using the InsufficientBalance error.
 ================
 s  
    state varible
     //State variables are variables whose values are permanently stored in contract storage.
    symbolName 
     // creates a new global symbol symbolName whose members are all the global symbols from "filename"
     import * as symbolName from "filename";
      which results in all global symbols being available in the format symbolName.symbol.

      A variant of this syntax that is not part of ES6, but possibly useful is:

     import "filename" as symbolName;
      which is equivalent to import * as symbolName from "filename";.

      If there is a naming collision, you can rename symbols while importing. For example, the code below creates new global symbols alias and symbol2 which reference symbol1 and symbol2 from inside "filename", respectively.
     import {symbol1 as alias, symbol2} from "filename";
    Source files 
     can contain an arbitrary number of contract definitions, import directives, pragma directives and struct, enum, function, error and constant variable definitions.
    semantic versioning
      // https://semver.org/
    Sent
    storedData;  
      //declares a state variable called storedData of type uint (unsigned integer of 256 bits). You can think of it as a single slot in a database that you can query and alter by calling functions of the code that manages the database. In
    SimpleStorage 
     //SPDX-License-Identifier:
    selfdestruct
    sender
    solidity
    spam
    str
    struct
    set 
    send 
     // used modify the value of the variable.
     //one The functions that make up the contract, and that users and contracts can call 
     //can be used by anyone (who already has some of these coins) to send coins to another eth address
    stack overlow 
     overlow definition = if a sum value is greater then any possible sums of a unit (8 257+   would remain values 1+ overflow)
 ================
 t
    tx
    TokenRecipient
    transferOwnership
    this
     To access a state variable of the current contract, you do not typically add the this. prefix, you just access it directly via its name.
     
 ================
 u
    uint
    uint256
    unit
    UNLICENSED
     //If you do not want to specify a license
 ================
 v
    virtual filesystem or VFS
     //In order to be able to support reproducible builds on all platforms, the Solidity compiler has to abstract away the details of the filesystem where source files are stored. For this reason import paths do not refer directly to files in the host filesystem. Instead the compiler maintains an internal database
     //Using the Standard JSON API it is possible to directly provide the names and content of all the source files as a part of the compiler input. In this case source unit names are truly arbitrary. If, however, you want the compiler to automatically find and load source code into the VFS, your source unit names need to be structured in a way that makes it possible for an import callback to locate them. When using the command-line compiler the default import callback supports only loading source code from the host filesystem, which means that your source unit names must be paths. Some environments provide custom callbacks that are more versatile. For example the Remix IDE provides one that lets you import files from HTTP, IPFS and Swarm URLs or refer directly to packages in NPM registry.
     //For a complete description of the virtual filesystem and the path resolution logic used by the compiler see Path Resolution.
     https://docs.soliditylang.org/en/v0.8.7/path-resolution.html#path-resolution
    
     links
      https://docs.soliditylang.org/en/v0.8.7/using-the-compiler.html#compiler-api
      https://docs.soliditylang.org/en/v0.8.7/path-resolution.html#import-callback
      https://remix-ide.readthedocs.io/en/latest/import.html
    
    value
    view 
 ================
 winningProposal
  //will return the proposal with the largest number of votes.

==============================================================
bytes - uint -int
 uint
  'uint'
  'uint8'
  'uint16'
  'uint24'
  'uint32'
  'uint40'
  'uint48'
  'uint56'
  'uint64'
  'uint72'
  'uint80'
  'uint88'
  'uint96'
  'uint104'
  'uint112'
  'uint120'
  'uint128'
  'uint136'
  'uint144'
  'uint152'
  'uint160'
  'uint168'
  'uint176'
  'uint184'
  'uint192'
  'uint200'
  'uint208'
  'uint216'
  'uint224'
  'uint232'
  'uint240'
  'uint248'
  'uint256'
 int
  'int'
  'int8'
  'int16'
  'int24'
  'int32'
  'int40'
  'int48'
  'int56'
  'int64'
  'int72'
  'int80'
  'int88'
  'int96'
  'int104'
  'int112'
  'int120'
  'int128'
  'int136'
  'int144'
  'int152'
  'int160'
  'int168'
  'int176'
  'int184'
  'int192'
  'int200'
  'int208'
  'int216'
  'int224'
  'int232'
  'int240'
  'int248'
  'int256'
 bytes
  'bytes1'
  'bytes2'
  'bytes3'
  'bytes4'
  'bytes5'
  'bytes6'
  'bytes7'
  'bytes8'
  'bytes9'
  'bytes10'
  'bytes11'
  'bytes12'
  'bytes13'
  'bytes14'
  'bytes15'
  'bytes16'
  'bytes17'
  'bytes18'
  'bytes19'
  'bytes20'
  'bytes21'
  'bytes22'
  'bytes23'
  'bytes24'
  'bytes25'
  'bytes26'
  'bytes27'
  'bytes28'
  'bytes29'
  'bytes30'
  'bytes31'
  'bytes32
statements
  variable-declaration
  expression
  if
  for
  while
  do-while
  continue
  break
  try
  return
  emit
  revert
  assembly
  yul-statements
   yul-block
   yul-variable-declaration
   yul-assignment
   yul-function-call
   yul-if-statement
   yul-for-statement
   yul-switch-statement
   leave
   break
   continue
   yul-function-definition
  yul-boolean
   true
   false
  yul-literal
   yul-decimal-number
   yul-string-literal
   yul-hex-number
   yul-boolean
   hex-string
  yul-expression
   yul-path
   yul-function-call
   yul-literal
comments
 // Single-line comments 

 /*
 This is a
 multi-line comment.
 */
Order of Precedence of Operators
 Postfix
  ++, --
   //Postfix increment and decrement
  new <typename>
   //New expression
  <array>[<index>]
   //Array subscripting
  <object>.<member>
   //Member access
  <func>(<args...>)
   //Function-like call
  (<statement>)
   //Parentheses
 =====================
 prefix 
  ++, --
   //Prefix increment and decrement
  -
   //Unary minus
  delete
   //Unary operations
  !
   //Logical NOT
  ~
   //Bitwise NOT
  **
   //Exponentiation
  * 
   //Multiplication
  /
   //division 
  %
   //modulo
  +
   //Addition 
  -
   //subtraction
  <<,   >>
   //Bitwise shift operators
  &
   //Bitwise AND
  ^
   //Bitwise XOR
  |
   //Bitwise OR
  <
  >
  <=
  >=
  ==
   //Inequality operators
  !=
   //Equality operators
  &&
   //Logical AND
  ||
   //Logical OR
Ternary operator
 <conditional> ? <if-true> : <if-false>
Assignment operators
 =
  //
 |= 
  // 
 ^=
  //
 &=
  //
 <<=
 >>= 
 +=
 -=
 *=
 /=
 %=
Comma operator
 ,
NatSpec comment  
  used directly above function declarations or statements
  ///
 
  /**      */

==============================================================
Tags
 All tags are optional. The following table explains the 
   purpose of each NatSpec tag and where it may be used. 
   As a special case, if no tags are used then the Solidity 
   compiler will interpret a /// or /** comment in the same 
   way as if it were tagged with @notice.

 @title    
  >>should describe the contract/interface  
  >> where to use--contract, library, interface
 @author    
  >>The name of the author  
  >> where to use--contract, library, interface
 @notice    >
  >used to Explain to an end user what this does  
  >> where to use--contract, library, interface, function, public state variable, event
 @dev    
  >>Explain to a developer any extra details  
  >> where to use--contract, library, interface, function, state variable, event
 @param    
  >>Documents a parameter just like in Doxygen (must be  followed by parameter name)  
  >> where to use--function, event
 @return    
  >>Documents the return variables of a contract’s function  
  >> where to use--function, public state variable
 @inheritdoc    
  >>Copies all missing tags from the base function (must be followed by the contract name)  
  >> where to use--function, public state variable
 @custom:    >>Custom tag, semantics is application-defined  
  >> where to use--everywhere

==============================================================
Unit denomination for numbers
 'wei'
 'gwei'
 'ether'
 'seconds'
 'minutes'
 'hours'
 'days'
 'weeks'
 'years'
math and operators 

  Addition (x + y)   ++, 
   Postfix increment and decrement ++, --
   New expression    new <typename>
   Array subscripting  <array>[<index>]
   Member access   <object>.<member>
   Function-like call  <func>(<args...>)
   Parentheses   (<statement>)


  Subtraction: (x – y)   --
    Unary minus -

   Unary operations delete

   Logical NOT    !

   Bitwise NOT  ~
   Bitwise shift operators  <<, >>
   Bitwise AND  &
   Bitwise XOR  ^
   Bitwise OR  |
  Multiplication (x * y)     *
  Division (x / y)       /
  Modulus (x % y)       %
   //https://www.youtube.com/watch?v=kz4iIS0peMI
  Exponential  (x**y)    **
  Inequality operators  <, >, <=, >=
  Equality operators   ==, !=
  Logical AND &&
  Logical OR  ||
  Ternary operator  <conditional> ? <if-true> : <if-false>
  Assignment operators  =, |=, ^=, &=, <<=, >>=, +=, -=, *=, /=, %=
  Comma operator   ,

==============================================================
safe math  
 only available for uint and int       max 256 bit interger bits 
 1 eth equals  1,000,000,000,000,000,000 wei  or 1 ether is 10**18 wei
 uint (2**256 - 1)
 uint 
 uint8 can equal any value between 0 and 256
 2**8= 256 (256 equals the highest unique value possible from uint8) 
 can not be set to 256 (255) 255+1=256) x=254 + 1= 255
 int 
 stack overlow 
  overlow definition = if a sum value is greater then any possible sums of a unit (8 257+   would remain values 1+ overflow)

==============================================================
further oraganization by type of structure 
 Struct Names
 Event Names
 Function Names
 Function Argument Names
 Local and State Variable Names
 Local and State Variable Names
 Constants
 Modifier Names
 Enums
 NatSpec
 boolean
 integer
 fixed point numbers
 fixed-size byte arrays
 dynamically-sized byte arrays
 Rational and integer literals
 String literals
 Hexadecimal literals
 Enums
==============================================================
notes 

 public pure = values are stored locally and not on the blockchain 
==============================================================

Notes

  Do not rely on block.timestamp or blockhash as a source of randomness, unless you know what you are doing.

  Both the timestamp and the block hash can be influenced by miners to some degree. Bad actors in the mining community can for example run a casino payout function on a chosen hash and just retry a different hash if they did not receive any money.

  The current block timestamp must be strictly larger than the timestamp of the last block, but the only guarantee is that it will be somewhere between the timestamps of two consecutive blocks in the canonical chain.

 Note

  The block hashes are not available for all blocks for scalability reasons. You can only access the hashes of the most recent 256 blocks, all other values will be zero.

 Note

  In version 0.5.0, the following aliases were removed: suicide as alias for selfdestruct, msg.gas as alias for gasleft, block.blockhash as alias for blockhash and sha3 as alias for keccak256.

 Note

  In version 0.7.0, the alias now (for block.timestamp) was removed.


Reserved Keywords
 These keywords are reserved in Solidity. They might become part of the syntax in the future:

 after, alias, apply, auto, byte, case, copyof, default, define, final, implements, in, inline, let, macro, match, mutable, null, of, partial, promise, reference, relocatable, sealed, sizeof, static, supports, switch, typedef, typeof, var.
