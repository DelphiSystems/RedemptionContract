pragma solidity ^0.4.9;

contract Token {
  function transferFrom(address from, address to, uint256 value) returns (bool success);
  function approve(address spender, uint256 value) returns (bool success);
  function allowance(address owner, address spender) constant returns (uint256 remaining);
}

contract RedemptionContract {
  address public token;         	    // the token address
  uint public exchangeRateNumerator;	// exchangeRateNumerator / exchangeRateDenominator = ETH per token
  uint public exchangeRateDenominator;	// exchangeRateNumerator / exchangeRateDenominator = ETH per token

  // exchangeRateNumerator      = 41490101
  // exchangeRateDenominator    = 100000000000

  event Redemption(address redeemer, uint tokensDeposited, uint redemptionAmount);

  function RedemptionContract(address _token, uint _exchangeRateNumerator, uint _exchangeRateDenominator) {
    token = _token;
    exchangeRateNumerator = _exchangeRateNumerator;
    exchangeRateDenominator = _exchangeRateDenominator;
  }

  function fund() payable {}

  function redeemTokens(uint amount) {
    // NOTE: redeemTokens will only work once the sender has approved 
    // the RedemptionContract address for (amount*exchangeRateDenominator)
    uint tokenTransferAmount = exchangeRateDenominator * amount;
    require(Token(token).transferFrom(msg.sender, this, tokenTransferAmount));
    
    uint redemptionValue = amount * exchangeRateNumerator;
    
    msg.sender.transfer(redemptionValue);
    
    Redemption(msg.sender, tokenTransferAmount, redemptionValue);
  }

}