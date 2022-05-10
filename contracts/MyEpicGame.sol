// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol"; // new sono
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
// Helper we wrote to encode in Base64
import "./libraries/Base64.sol";

contract MyEpicGame is ERC721Enumerable {

// -----   VARIABLES   -----

struct BoxAttributes {
  uint boxIndex;
  string frequence;
  string mood;
  string imageURI;        
}

using Counters for Counters.Counter;
Counters.Counter private _tokenIds;

uint256 private seed1; // proba to mint
uint256 private seed2; // box index to mint

BoxAttributes[] defaultBoxes; // defaultBoxes is an array of boxAttributes that is used for mint

struct Party {
  address host;
  uint256 timestamp;
}

Party[] parties;

//   -----   MAPPINGS   -----

mapping(uint256 => BoxAttributes) public nftHolderAttributes; // mapping from the nft's tokenId => that NFTs attributes.
mapping(address => uint256) public lastHostedAt; // for cooldown

//   -----   EVENTS   -----

event BoxNFTMinted(address sender, uint256 tokenId, uint256 boxIndex);
event PartyComplete(uint256 timestamp, bool cooldownRespected);

//   -----   CONSTRUCTOR   -----
constructor(
  string[] memory boxNames,
  string[] memory boxFrequences,
  string[] memory boxMoods,
  string[] memory boxImageURIs
)
ERC721("Boxes", "BOX")
{
//   ---   setting DefaultBoxes at deploy   ---
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
 _tokenIds.increment();
// Set the initial seeds
  seed1 = (block.timestamp + block.difficulty) % 1000;
  seed2 = (block.timestamp + block.difficulty) % 12;
}

//   -----   FUNCTIONS   -----
function mintBoxNFT(uint _boxIndex) private {
  // Get current tokenId (starts at 1 since we incremented in the constructor).
  uint256 newItemId = _tokenIds.current();
  _safeMint(msg.sender, newItemId);
  // We map the tokenId => their attributes.
  nftHolderAttributes[newItemId] = BoxAttributes({
    boxIndex: _boxIndex,
    frequence: defaultBoxes[_boxIndex].frequence,
    mood: defaultBoxes[_boxIndex].mood,
    imageURI: defaultBoxes[_boxIndex].imageURI
  });
  console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _boxIndex);
  // Keep an easy way to see who owns what NFT.
  // nftHolders[msg.sender] = newItemId; // old, change that for multiple NFTs
  // Increment the tokenId for the next person that uses it.
  _tokenIds.increment();
  emit BoxNFTMinted(msg.sender, newItemId, _boxIndex);
}


function hostAParty(uint _probatomint) external {
  bool cooldownRespected = true;
  cooldownRespected = lastHostedAt[msg.sender] + 2 minutes < block.timestamp;
    if(cooldownRespected) {
  lastHostedAt[msg.sender] = block.timestamp;
  parties.push(Party(msg.sender, block.timestamp));
  seed1 = (block.difficulty + block.timestamp + seed1) % 1000;
  seed2 = (block.difficulty + block.timestamp + seed2) % 12;
    if(seed1 <= _probatomint) {
      mintBoxNFT(seed2);
      console.log("minted");
    } // if -> mint
} // if cooldown
else {
  cooldownRespected = false;
  console.log("wait a bit");
  } 
emit PartyComplete(block.timestamp, cooldownRespected);
}


// original

function tokenURI(uint256 _tokenId) public view override returns (string memory) {
  BoxAttributes memory bAttributes = nftHolderAttributes[_tokenId];
  /*
  string memory strFrequence = bAttributes.frequence;
  string memory strMood = bAttributes.mood;

  string memory json = Base64.encode(
    abi.encodePacked(
      '{"name": "',
      bAttributes.frequence,
      ' -- NFT #: ',
      Strings.toString(_tokenId),
      '", "description": "A soundsystem box", "image": "ipfs://',
      bAttributes.imageURI,
      '", "attributes": [ { "frequence": ',strFrequence,', "mood":',strMood,'} ]}'
    )
  );
  string memory output = string(
    abi.encodePacked("data:application/json;base64,", json)
  );
  return output;
}
*/

  string memory json = Base64.encode(
    bytes(
      string(
        abi.encodePacked(
          '{"name": " CryptoSonosNFT #: ',
          Strings.toString(_tokenId),
          '", "description": "A soundsystem box", "image": "ipfs://',
          bAttributes.imageURI,
          '", "attributes": [ { "trait_type": "frequence", "value": "',bAttributes.frequence,'"}, { "trait_type": "mood", "value": "',bAttributes.mood,'"} ]}'
        )
      )
    )
  );
  string memory output = string(
    abi.encodePacked("data:application/json;base64,", json)
  );
  return output;
}

function getTokenIds(address _owner) public view returns (uint[] memory) { // thanks to NFTEnumerable
        uint[] memory _tokensOfOwner = new uint[](ERC721.balanceOf(_owner));
        uint i;

        for (i=0;i<ERC721.balanceOf(_owner);i++){
            _tokensOfOwner[i] = ERC721Enumerable.tokenOfOwnerByIndex(_owner, i);
        }
        return (_tokensOfOwner);
    }

function getNftHolderAttributes(uint tokenId) external view returns (BoxAttributes memory) { // new sono
return nftHolderAttributes[tokenId];
}
}