pragma solidity ^0.5.16;

contract Context {
    constructor () internal {}

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }
}
