pragma solidity ^0.5.16;

import './Address.sol';
import './SafeMath.sol';
import './SafeERC20.sol';
import './ERC20Detailed.sol';
import './ERC20.sol';


contract CodeToken is ERC20, ERC20Detailed {

    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint;
    uint128 public  hballRate = 10000;

    address payable public governance;
    event BuyTokens(address buyer, uint256 amountOfBNB, uint256 amountOfTokens);

    mapping (address => bool) public minters;


    constructor () public ERC20Detailed("Happiness Balloon Token", "HBALL", 10) {
        governance = tx.origin;
    }


    function mint(address account, uint256 amount) public {
        require(minters[msg.sender], "!minter");
        _mint(account, amount);
    }


    function setGovernance(address payable _governance) public {
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }


    function addMinter(address _minter) public {
        require(msg.sender == governance, "!governance");
        minters[_minter] = true;
    }


    function removeMinter(address _minter) public {
        require(msg.sender == governance, "!governance");
        minters[_minter] = false;
    }

    function getContarctAddress() public view returns(address) {
        return address(this);
    }

    function getSellerAddressBalance() public view returns(uint256 amount){
        return balanceOf(governance);
    }

    function getRateVersity(uint256 BNB_amount) public view returns(uint256 tokenAmount) {
        return  BNB_amount * hballRate;
    }


    function BuyHBALL() public payable returns(bool success) {
        require(msg.value > 0, "Send BNB to buy some HBALLs");
        uint256 amountToBuy = msg.value / 100000000 * hballRate;
        uint256 vendorBalance = balanceOf(governance);
        require(vendorBalance >= amountToBuy, "contract has not enough tokens in its balance");
        governance.transfer(msg.value);
        _approve(governance, msg.sender, amountToBuy);
        transferFrom(governance, msg.sender, amountToBuy);
        return success;
    }

    function setHabllRate(uint128 newHballRate) public returns(bool){
        require(newHballRate >= 1, "! not balance");
        require(msg.sender == governance, "No Permission !");
        hballRate = newHballRate;
        return true;
    }
    function getHabllRate() public  view returns(uint128){
        return hballRate;
    }
}
