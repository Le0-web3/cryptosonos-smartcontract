// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

// Helper we wrote to encode in Base64
import "./libraries/Base64.sol";

// Our contract inherits from ERC721, which is the standard NFT contract!
contract MyEpicGame is ERC721 {
  // We'll hold our box's attributes in a struct.
  struct BoxAttributes {
    uint boxIndex;
    string frequence;
    string mood;
    string imageURI;        
  }

  // The tokenId is the NFTs unique identifier, it's just a number that goes
  // 0, 1, 2, 3, etc.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // defaultBoxes is an array of boxAttributes to help us hold the default data for our boxes.
  // This will be helpful when we mint new boxes and need to know
  // things like their frequence, mood, etc.
  BoxAttributes[] defaultBoxes;

  // We create a mapping from the nft's tokenId => that NFTs attributes.
  mapping(uint256 => BoxAttributes) public nftHolderAttributes;

  // A mapping from an address => the NFTs tokenId. Gives me an ez way
  // to store the owner of the NFT and reference it later.
  mapping(address => uint256) public nftHolders;

  event BoxNFTMinted(address sender, uint256 tokenId, uint256 boxIndex);
  event PartyComplete(string newBoxFrequence, string newBoxMood);

  // Data passed in to the contract when it's first created initializing the boxes.
  // We're going to actually pass these values in from run.js.
    // Below, you can also see I added some special identifier symbols for our NFT.
    // This is the name and symbol for our token, ex Ethereum and ETH. I just call mine
    // Heroes and HERO. Remember, an NFT is just a token!
  constructor(
    string[] memory boxNames,
    string[] memory boxFrequences,
    string[] memory boxMoods,
    string[] memory boxImageURIs
  )
      ERC721("Boxes", "BOX")
  {
    // Loop through all the boxes, and save their values in our contract so
    // we can use them later when we mint our NFTs.
    for(uint i = 0; i < boxNames.length; i += 1) {
      defaultBoxes.push(BoxAttributes({
        boxIndex: i,
        frequence: boxFrequences[i],
        mood: boxMoods[i],
        imageURI: boxImageURIs[i]
      }));

      BoxAttributes memory c = defaultBoxes[i];
      console.log("Done initializing %s %s, img %s", c.frequence, c.mood, c.imageURI);
    }

    // I increment _tokenIds here so that my first NFT has an ID of 1.
    // More on this in the lesson!
    _tokenIds.increment();
  }
  // Users would be able to hit this function and get their NFT based on the
  // boxId they send in!
  function mintBoxNFT(uint _boxIndex) external {
    // Get current tokenId (starts at 1 since we incremented in the constructor).
    uint256 newItemId = _tokenIds.current();

    // The magical function! Assigns the tokenId to the caller's wallet address.
    _safeMint(msg.sender, newItemId);

    // We map the tokenId => their character attributes. More on this in
    // the lesson below.
    nftHolderAttributes[newItemId] = BoxAttributes({
      boxIndex: _boxIndex,
      frequence: defaultBoxes[_boxIndex].frequence,
      mood: defaultBoxes[_boxIndex].mood,
      imageURI: defaultBoxes[_boxIndex].imageURI
    });

    console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _boxIndex);
    
    // Keep an easy way to see who owns what NFT.
    nftHolders[msg.sender] = newItemId; // change that for multiple NFTs

    // Increment the tokenId for the next person that uses it.
    _tokenIds.increment();
    emit BoxNFTMinted(msg.sender, newItemId, _boxIndex);

  }

function tokenURI(uint256 _tokenId) public view override returns (string memory) {
  BoxAttributes memory boxAttributes = nftHolderAttributes[_tokenId];

  string memory strFrequence = boxAttributes.frequence;
  string memory strMood = boxAttributes.mood;

  string memory json = Base64.encode(
    abi.encodePacked(
      '{"frequence": "',
      boxAttributes.frequence,
      ' -- NFT #: ',
      Strings.toString(_tokenId),
      '", "description": "This is an NFT that lets people play in the game Metaverse Slayer!", "image": "',
      boxAttributes.imageURI,
      '", "attributes": [ { "frequence": ',strFrequence,', "mood":',strMood,' ]}'
    )
  );

  string memory output = string(
    abi.encodePacked("data:application/json;base64,", json)
  );
  
  return output;
}

function hostAParty() public {
  // Get the state of the player's NFT.
  uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
  BoxAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
  console.log("\nPlayer w/ hosting a party. frequence is %s and mood is %s", player.frequence, player.mood);
  emit PartyComplete(player.frequence, player.mood);
}

function checkIfUserHasNFT() public view returns (BoxAttributes memory) {
  // Get the tokenId of the user's character NFT
  uint256 userNftTokenId = nftHolders[msg.sender];
  // If the user has a tokenId in the map, return their character.
  if (userNftTokenId > 0) {
    return nftHolderAttributes[userNftTokenId];
  }
  // Else, return an empty character.
  else {
    BoxAttributes memory emptyStruct;
    return emptyStruct;
   }
}

function getAllDefaultBoxes() public view returns (BoxAttributes[] memory) {
  return defaultBoxes;
}



}