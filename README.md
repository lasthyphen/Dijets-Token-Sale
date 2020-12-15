# Dijets-Token-Sale
Solidity Contracts for Dijets Public Sale Launch on 14.12.2020

DJT Token Sale Contracts
===================================

  - Circulation supply is 65,000,000, of which:
  - 65% has been allocated for the 3 tiers public sale
  - 15% allocated for team and advisors
  - 12% allocated for the long term budget
  - 5% allocated for token sale costs
  - 3% allocated for bounties, referrals and Air drop
  - DJT Public sale is a fully automated and transparent process
  - Once deployed, the contract assumes ownership and distributes DJT itself.
  - The function for DJT rates for all 3 Tiers is already hardcoded into the contract.

**1. Tier 1 Public Sale**

- After deploying contracts on the network, the Tier is automatically initialised as "Created";
- Dijets Team is only able to execute function of "setSalePhase();" to define the Tier parameters;
- Total amount of DJT tokens allocated for the sale is 65,000,000 tokens, at Tier 1 rate of 830 DJT tokens per 1 ETH;
- The price per DJT is set to increase with each Tier. Where Tier 3 has the highest and Tier 1 has the lowest price;
- Tier 1 sale is set to run from 14th December 2020 to 25th December 2020.

**2. Tier 2 Public Sale**

- Calling on the function of "setSalePhase()" the team will set next phase to "Tier2Running";
- A memory persisting target of 50% DJT will override the function to add any unsold tokens from Tier 1; 
- The Smart contract is able to receive funds from contributors and those funds are forwarded to a pre-defined wallet address;
- Contributors will automatically and instantly receive their DJT tokens based on the Currency exchange Ratio;
- Transfers and manipulation with token is blocked until the very last function call of "FinalisePublicSale";
- Tier 2 sale is set to run from 25th December 2020 to 05th January 2021.

**3. Tier 3 - Public Sale**

- See Tier 2 details above;
- All contract functions set to remain unchanged except "TokenValue" and "setSalePhase()"; 
- Team is able to pause the receiving of the funds on the smart contract;
- In this phase, no one is able to buy the tokens;
- Contract deployer/"Owner" has to "setSalePhase()" to "PublicSaleFinished" to then be able to call "Finalise PublicSale:
- Tier 3 sale is set to run from 05th January 2021 to 12th January 2021.

**5. Post Public Sale**

- Two pre-defined functions for stop triggers are "All tokens sold" and/or Deadline from "setSalePhase()" arrived;
- Tokens allocated for the long term budget, team and advisors are sent to the vesting smart contract;
- Tokens allocated for bounty, referral, Air drop and token sale costs will be released immediately after finishing the token sale;
- Tokens from pre-sale and crowdsale are unpaused (manually) so contributors are able to interact with their Dijets;
- Unsold or unallocated tokens are automatically burnt;

**6. Vesting Period**

- Upon completion of the Public Sale, vesting smart contract receives tokens allocated for long term budget, team and founders;
- Tokens distributed to core team members will be subject to vesting, in 20% increments over a period of 72 weeks commencing at the end of the token sale.
- Vesting will be handled by calling on a different set of functions and instance of smart contract.
