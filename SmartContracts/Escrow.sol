pragma solidity ^0.4.24;

contract Escrow {
    enum State {AWAITING_PAYMENT, AWAITING_SHIPMENT, AWAITING_DELIVERY, COMPLETE, REFUNDED}
    State public currentState;
    
    address public buyer;
    address public seller;
    address public arbiter;
    
    modifier buyerOnly() {
        require(msg.sender == buyer);
        _;
    }
    
    modifier sellerOnly() {
        require(msg.sender == seller || msg.sender == arbiter);
        _;
    } 
    
    modifier inState(State expectedState) {
        require(currentState == expectedState);
        _;
    }

    modifier notInState(State expectedState) {
        require(currentState != expectedState);
        _;
    }
    
    constructor(address _buyer, address _seller, address _arbiter) public {
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
        
        currentState = State.AWAITING_PAYMENT;
    }
    
    function getState() view public returns(int) {
        return int(currentState);
    }

    function sendPayment() public payable buyerOnly inState(State.AWAITING_PAYMENT) {
        currentState = State.AWAITING_SHIPMENT;
    }
    
    function confirmShipment() public sellerOnly inState(State.AWAITING_SHIPMENT) {
        currentState = State.AWAITING_DELIVERY;
    }

    function confirmDelivery() public buyerOnly inState(State.AWAITING_DELIVERY) {
        currentState = State.COMPLETE;
        seller.transfer(address(this).balance);
    }
    
    function refundBuyer() public sellerOnly notInState(State.COMPLETE) notInState(State.REFUNDED) {
        currentState = State.REFUNDED;
        buyer.transfer(address(this).balance);
    }
    
}