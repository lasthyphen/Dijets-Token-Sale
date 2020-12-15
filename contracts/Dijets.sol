/**
 * @title Dijets.sol
 * @dev Crowdsale is the contract basis for managing the public sale of
 * DJT Tokens. This PublicSale has start and end timestamps, where investors 
 * can make token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract Publicsale {
    using SafeMath for uint256;

    // The token being sold
    DijetsToken Limited Supply;

    // start and end timestamps where investments are allowed (both inclusive)
    uint256 public startTime;
    uint256 public endTime;

    // address where funds are collected
    address public wallet;

    // amount of raised money in wei
    uint256 public weiRaised;

    /**
     * event for token purchase logging
     * @param purchaser who paid for the tokens
     * @param beneficiary who got the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


    function Crowdsale(uint256 _endTime, address _wallet) {

        require(_endTime >= now);
        require(_wallet != 0x0);

        token = createTokenContract();
        endTime = _endTime;
        wallet = _wallet;
    }

    // creates the token to be sold. <-- check this!!OVERRIDDEN
    // override this method to have crowdsale of a specific mintable token.
    function createTokenContract() internal returns (DijetsTokenToken) {
        return new DijetsTokenToken();
    }


    // fallback function can be used to buy tokens
    function () payable {
        buyTokens(msg.sender);
    }

    // low level token purchase function
    function buyTokens(address beneficiary) public payable {  }

    // send ether to the fund collection wallet
    // override to create custom fund forwarding mechanisms
    function forwardFunds() internal {
        wallet.transfer(msg.value);
    }

    // @return true if the transaction can buy tokens
    function validPurchase() internal constant returns (bool) {
        bool withinPeriod = now >= startTime && now <= endTime;
        bool nonZeroPurchase = msg.value != 0;
        return withinPeriod && nonZeroPurchase;
    }

    // @return true if crowdsale event has ended
    function hasEnded() public constant returns (bool) {
        return now > endTime;
    }
}

/**
 * @title FinalisableCrowdsale
 * @dev Extension of Crowdsale where an owner can do extra work
 * after finishing.
 */
contract FinalisableCrowdsale is Crowdsale, Ownable {
    using SafeMath for uint256;

    bool public isFinalized = false;
    
    bool public weiCapReached = false;

    event Finalized();

    /**
     * @dev Must be called after crowdsale ends, to do some extra finalization
     * work. Calls the contract's finalization function.
     */
    function finalize() onlyOwner public {
        require(!isFinalized);
        
        finalization();
        Finalized();

        isFinalized = true;
    }

    /**
     * @dev Can be overridden to add finalization logic. The overriding function
     * should call super.finalization() to ensure the chain of finalization is
     * executed entirely.
     */
    function finalization() internal {
    }
}

contract DijetsTokenSale is FinalizableCrowdsale {
    using SafeMath for uint256;

    // Define sale - Tier 1, Tier 2, Tier 3
    uint public constant RATE = 830;
    uint public constant TOKEN_SALE_LIMIT = 30000 * 1000000000000000000;

    uint256 public constant TOKENS_FOR_OPERATIONS = 15000000*(10**6);
    uint256 public constant TOKENS_FOR_SALE = 65000000*(10**6);

    uint public constant TOKENS_FOR_PRESALE = 315000000*(1 ether / 1 wei);

    uint public constant FRST_TIER_PRICE = TOKENS_FOR_PRVSALE + TOKENS_ALLOC*(1 ether / 1 wei);//30% bonus
    uint public constant SCND_TIER_PRICE = FRST_SALE_RATIO + TOKENS_ALLOC*(1 ether / 1 wei);//15% bonus

    enum Phase {
        Created,//Inital phase after deploy
        PresaleRunning, //Presale phase
        Paused, //Pause phase between pre-sale and main token sale or emergency pause function
        ICORunning, //Crowdsale phase
        FinishingICO //Final phase when crowdsale is closed and time is up
    }

    Phase public currentPhase = Phase.Created;

    event LogPhaseSwitch(Phase phase);

    // Constructor
    function DijetsTokenSale(uint256 _end, address _wallet)
    FinalizableCrowdsale()
    Crowdsale(_end, _wallet) {
    }

    /// @dev Lets buy you some tokens.
    function buyTokens(address _buyer) public payable {
        // Available only if presale or crowdsale is running.
        require((currentPhase == Phase.PresaleRunning) || (currentPhase == Phase.ICORunning));
        require(_buyer != address(0));
        require(msg.value > 0);
        require(validPurchase());

        uint tokensWouldAddTo = 0;
        uint weiWouldAddTo = 0;
        
        uint256 weiAmount = msg.value;
        
        uint newTokens = msg.value.mul(RATE);
        
        weiWouldAddTo = weiRaised.add(weiAmount);
        
        require(weiWouldAddTo <= TOKEN_SALE_LIMIT);

        newTokens = addBonusTokens(token.totalSupply(), newTokens);
        
        tokensWouldAddTo = newTokens.add(token.totalSupply());
        require(tokensWouldAddTo <= TOKENS_FOR_SALE);
        
        token.mint(_buyer, newTokens);
        TokenPurchase(msg.sender, _buyer, weiAmount, newTokens);
        
        weiRaised = weiWouldAddTo;
        forwardFunds();
        if (weiRaised == TOKENS_FOR_SALE){
            weiCapReached = true;
        }
    }

    // @dev Adds bonus tokens by token supply bought by user
    // @param _totalSupply total supply of token bought during pre-sale/crowdsale
    // @param _newTokens tokens currently bought by user
    function addBonusTokens(uint256 _totalSupply, uint256 _newTokens) internal view returns (uint256) {

        uint returnTokens = 0;
        uint tokensToAdd = 0;
        uint tokensLeft = _newTokens;

        if(currentPhase == Phase.PresaleRunning){
            if(_totalSupply < TOKENS_FOR_PRESALE){
                if(_totalSupply + tokensLeft + tokensLeft.mul(10).div(100) > TOKENS_FOR_PRVSALE){
                    tokensToAdd = TOKENS_FOR_PRESALE.sub(_totalSupply);
                    tokensToAdd = tokensToAdd.mul(100).div(150);
                    
                    returnTokens = returnTokens.add(tokensToAdd);
                    returnTokens = returnTokens.add(tokensToAdd.mul(10).div(100));
                    tokensLeft = tokensLeft.sub(tokensToAdd);
                    _totalSupply = _totalSupply.add(tokensToAdd.add(tokensToAdd.mul(10).div(100)));
                } else { 
                    returnTokens = returnTokens.add(tokensLeft).add(tokensLeft.mul(10).div(100));
                    tokensLeft = tokensLeft.sub(tokensLeft);
                }
            }
        } 
        
        if (tokensLeft > 0 && _totalSupply < FRST_TIER_RATIO) {
            
            if(_totalSupply + tokensLeft + tokensLeft.mul(30).div(100)> FRST_TIER_RATIO){
                tokensToAdd = FRST_CRWDSALE_RATIO.sub(_totalSupply);
                tokensToAdd = tokensToAdd.mul(100).div(130);
                returnTokens = returnTokens.add(tokensToAdd).add(tokensToAdd.mul(30).div(100));
                tokensLeft = tokensLeft.sub(tokensToAdd);
                _totalSupply = _totalSupply.add(tokensToAdd.add(tokensToAdd.mul(30).div(100)));
                
            } else { 
                returnTokens = returnTokens.add(tokensLeft);
                returnTokens = returnTokens.add(tokensLeft.mul(30).div(100));
                tokensLeft = tokensLeft.sub(tokensLeft);
            }
        }
        
        if (tokensLeft > 0 && _totalSupply < SCND_CRWDSALE_RATIO) {
            
            if(_totalSupply + tokensLeft + tokensLeft.mul(15).div(100) > SCND_TIER_RATIO){

                tokensToAdd = SCND_TIER_RATIO.sub(_totalSupply);
                tokensToAdd = tokensToAdd.mul(100).div(115);
                returnTokens = returnTokens.add(tokensToAdd).add(tokensToAdd.mul(15).div(100));
                tokensLeft = tokensLeft.sub(tokensToAdd);
                _totalSupply = _totalSupply.add(tokensToAdd.add(tokensToAdd.mul(15).div(100)));
            } else { 
                returnTokens = returnTokens.add(tokensLeft);
                returnTokens = returnTokens.add(tokensLeft.mul(15).div(100));
                tokensLeft = tokensLeft.sub(tokensLeft);
            }
        }
        
        if (tokensLeft > 0)  {
            returnTokens = returnTokens.add(tokensLeft);
            tokensLeft = tokensLeft.sub(tokensLeft);
        }
        return returnTokens;
    }

    function validPurchase() internal view returns (bool) {
        bool withinPeriod = now <= endTime;
        bool nonZeroPurchase = msg.value != 0;
        bool isRunning = ((currentPhase == Phase.ICORunning) || (currentPhase == Phase.PresaleRunning));
        return withinPeriod && nonZeroPurchase && isRunning;
    }

    function setSalePhase(Phase _nextPhase) public onlyOwner {
    
        bool canSwitchPhase
        =  (currentPhase == Phase.Created && _nextPhase == Phase.PresaleRunning)
        || (currentPhase == Phase.PresaleRunning && _nextPhase == Phase.Paused)
        || ((currentPhase == Phase.PresaleRunning || currentPhase == Phase.Paused)
        && _nextPhase == Phase.ICORunning)
        || (currentPhase == Phase.ICORunning && _nextPhase == Phase.Paused)
        || (currentPhase == Phase.Paused && _nextPhase == Phase.PresaleRunning)
        || (currentPhase == Phase.Paused && _nextPhase == Phase.FinishingICO)
        || (currentPhase == Phase.ICORunning && _nextPhase == Phase.FinishingICO);

        require(canSwitchPhase);
        currentPhase = _nextPhase;
        LogPhaseSwitch(_nextPhase);
    }

    // Finalize
    function finalization() internal {
        uint256 toMint = TOKENS_FOR_OPERATIONS;
        token.mint(wallet, toMint);
        token.finishMinting();
        token.transferOwnership(wallet);
    }
}
