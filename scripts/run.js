// npx hardhat run scripts/run.js

const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame'); // compiling
    const gameContract = await gameContractFactory.deploy(
        ["toptekno", "midtekno", "kicktekno", "subtekno", "topdub", "middub", "kickdub", "subdub", "topjungle", "midjungle", "kickjungle", "subjungle"],       // Names
        ["top", "mid", "kick", "sub", "top", "mid", "kick", "sub", "top", "mid", "kick", "sub"],                    // frequences
        ["tekno", "tekno", "tekno", "tekno", "dub", "dub", "dub", "dub", "jungle", "jungle", "jungle", "jungle"],                    // moods
        ["https://i.imgur.com/pKd5Sdk.png", // Images
        "https://i.imgur.com/xVu4vFL.png", 
        "https://i.imgur.com/xVu4vFL.png", 
        "https://i.imgur.com/xVu4vFL.png", 
        "https://i.imgur.com/xVu4vFL.png", 
        "https://i.imgur.com/xVu4vFL.png", 
        "https://i.imgur.com/xVu4vFL.png", 
        "https://i.imgur.com/xVu4vFL.png", 
        "https://i.imgur.com/xVu4vFL.png", 
        "https://i.imgur.com/xVu4vFL.png", 
        "https://i.imgur.com/xVu4vFL.png", 
        "https://i.imgur.com/WMB6g9u.png"]
    );  // deploying locally, what we give to constructor
    await gameContract.deployed(); // constructor run after we re deployed
    console.log("Contract deployed to:", gameContract.address);

    let txn;
    // We only have three characters.
    // an NFT w/ the character at index 2 of our array.
    txn = await gameContract.mintBoxNFT(2);
    await txn.wait();
    
    // Get the value of the NFT's URI.
    let returnedTokenUri = await gameContract.tokenURI(1); // returns data attached to NFT
    console.log("Token URI:", returnedTokenUri);

    txn = await gameContract.mintBoxNFT(2);
    await txn.wait();

    txn = await gameContract.hostAParty();
    await txn.wait();
  };




  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();