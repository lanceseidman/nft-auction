// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
 * @title Contract for NFT Auction
 *
 * @notice NFT Auction contract
 *
 * @author Lance Seidman
*/

interface IERC721 {
    function safeTransferFrom(
        address _from,
        address _to,
        uint _nftId
    ) external;
    function transferFrom(
        address,
        address,
        uint
    ) external;
    function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes calldata _data
  )
    external
    returns(bytes4);
}

contract NFTAuction {
    address private owner;
    uint public auctionsTotal;

    struct Auctions {
        address seller;
        IERC721 nft;
        address topBidder;
        address winner;
        uint nftId;
        uint id;
        uint winningBid;
        uint startingBid;
        uint minPrice;
        uint auctionStart;
        uint auctionExpires;
        bool auctionStarted;
        bool auctionCompleted;
    }
    mapping(address => uint) public incomingBids;
    mapping(address => Auctions) public auctions;

    event SendBid(address indexed bidder, uint BidAmount);
    event Widthdraw(address indexed winner, uint amount);
    event NewAuction(uint id, address seller, IERC721 nft);
    event RequestFunds(address account, address requestFrom, uint requestTotal);
    event AuctionEnded(address winner, uint winningBid);

    modifier onlyOwner {require(msg.sender != owner, 'Only the owner may perform this action!');  _;}
    constructor() { owner = msg.sender; }

    function createAuction(
        IERC721 _nft, 
        uint _nftId, 
        uint _minPrice,
        uint _auctionStart, 
        uint _auctionExpires) external 
    {
        auctions[msg.sender].seller = msg.sender;
        auctions[msg.sender].id = auctionsTotal;
        auctions[msg.sender].nft = _nft;
        auctions[msg.sender].nftId = _nftId;
        auctions[msg.sender].minPrice = _minPrice;
        auctions[msg.sender].auctionStart = _auctionStart;
        auctions[msg.sender].auctionExpires = _auctionExpires;
       
        emit NewAuction(auctionsTotal, msg.sender, _nft);
        auctionsTotal++;
    }

}
