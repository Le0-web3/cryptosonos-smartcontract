// npx hardhat run scripts/deploy.js --network rinkeby

const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    
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
  
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);
  
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