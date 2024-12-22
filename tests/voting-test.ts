import { Clarinet, Tx, Chain, Account } from "@hirosystems/clarinet-sdk";

Clarinet.test({
  name: "Vote for a candidate and check the count",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    let deployer = accounts.get("deployer")!;
    let voter = accounts.get("wallet_1")!;
    
    // Cast a vote
    let voteTx = Tx.contractCall("voting", "vote", ["'Alice"], voter.address);
    let voteResult = chain.mineBlock([voteTx]);

    voteResult.receipts[0].result.expectOk();

    // Check vote count
    let count = chain.callReadOnlyFn("voting", "get-votes", ["'Alice"], deployer.address);
    count.result.expectUint(1);
  },
});
