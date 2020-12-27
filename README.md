# Dijets-Token-Sale
Solidity Contracts for Dijets Public Sale Launch on 27.12.2020 - 21:00pm GMT

DJT Token Sale Contracts
===================================

  - Circulation supply is 65,000,000, of which:
  - 80% has been allocated for the 3 tiers public sale
  - 8% allocated for team and advisors
  - 7% allocated for the long term budget
  - 3% allocated for token sale costs
  - 2% allocated for bounties, referrals and Air drop
  - DJT Public sale is a fully automated and reviewable process
  - Once deployed, the contract assumes ownership of Tokens and distributes DJT itself.
  - DJT rates for all 3 Tiers are already set in the contract.
  
  (Please Note: Members who registered with Dijets before 27/11/2020 and added their Dijets Wallet address during registration will be eligible for 30% discount in Tier 1. You will get the bonus amount of tokens together with the purchased tokens. Please visit [Whitelist Check](https://whitelist.dijets.io) to see if your wallet is whitelisted and thus automatically qualified to receive the 30% bonus)

**1. Tier 1 Public Sale**

- After deploying contracts on the network, the Tier is automatically initialised as "Created";
- Dijets Team is only able to execute function of "setSalePhase();" to define the Tier parameters;
- Total amount of DJT tokens allocated for the sale is 52,000,000 tokens, at Tier 1 rate of 830 DJT tokens per 1 ETH;
- The price per DJT is set to increase with each Tier. Where Tier 3 has the highest and Tier 1 has the lowest price;
- Tier 1 sale is set to run from 27th December 2020 to 4th January 2021.

**2. Tier 2 Public Sale**

- Tier 2 rate of 710 DJT tokens per 1 ETH;
- Calling on the function of "setSalePhase()" the team will set next phase to "Tier2Running";
- A memory persisting target of 50% DJT will override the function to add any unsold tokens from Tier 1; 
- The Smart contract is able to receive funds from contributors and those funds are forwarded to a pre-defined wallet address;
- Contributors will automatically and instantly receive their DJT tokens based on the Currency exchange Ratio;
- Transfers and manipulation with token is blocked until the very last function call of "FinalisePublicSale";
- Tier 2 sale is set to run from 4th January 2021 to 12th January 2021.

**3. Tier 3 - Public Sale**

- See Tier 2 details above;
- Tier 3 rate of 620 DJT tokens per 1 ETH;
- All contract functions set to remain unchanged except "TokenValue" and "setSalePhase()"; 
- Team is able to pause the receiving of the funds on the smart contract;
- At the end of this phase, no one is able to buy the tokens anymore;
- Contract deployer/"Owner" has to "setSalePhase()" to "PublicSaleFinished" to then be able to call "Finalise PublicSale:
- Tier 3 sale is set to run from 12th January 2021 to 19th January 2021.

**5. Post Public Sale**

- Two pre-defined functions for stop triggers are "All tokens sold" and/or Deadline from "setSalePhase()" arrived;
- Tokens allocated for the long term budget, team and advisors are sent to the vesting smart contract;
- Tokens allocated for bounty, referral, Air drop and token sale costs will be released immediately after finishing the token sale;
- Tokens from pre-sale and crowdsale are unpaused (manually) so contributors are able to interact with their Dijets;
- All sold tokens will get distributed within 48 hours of the conclusion of the Public Sale. Each buyer will receive an email confirming their purchase and         instructions to add Dijets to their Dijets Wallet.
- Unsold or unallocated tokens are automatically burnt;

**6. Vesting Period**

- Upon completion of the Public Sale, vesting smart contract receives tokens allocated for long term budget, team and founders;
- Tokens distributed to core team members will be subject to vesting, in 20% increments over a period of 72 weeks commencing at the end of the token sale.
- Vesting will be handled by calling on a different set of functions and instance of smart contract.

Smart Contracts
=========================

- Transaction hash of the 1st smart contract (Dijets.sol) deployment can be found [here!](https://etherscan.io/tx/0xe8e30d27abc271f893a6d1c076a86083fbc138f5f141edc781175ada98a1c6ed)
- Transaction hash of the 2nd Smart Contract (Dijets-Token-Sale.sol) deployment can be found [here!](https://etherscan.io/tx/0xd890028e8e652725fc9a1e9ea84283d2cdbe82ef034c7a51cd4ac9c35aa622cb)
- Smart Contract can be found in this repository [here!](https://github.com/lasthyphen/Dijets-Token-Sale/blob/main/contracts/Dijets.sol)
