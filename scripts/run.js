// npx hardhat run scripts/run.js

const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame'); // compiling
    const gameContract = await gameContractFactory.deploy(
      ["toptekno", "midtekno", "kicktekno", "subtekno", "topdub", "middub", "kickdub", "subdub", "topjungle", "midjungle", "kickjungle", "subjungle"],       // Names
      ["top", "mid", "kick", "sub", "top", "mid", "kick", "sub", "top", "mid", "kick", "sub"],                    // frequences
      ["tekno", "tekno", "tekno", "tekno", "dub", "dub", "dub", "dub", "jungle", "jungle", "jungle", "jungle"],                    // moods
      ["QmaCyhjGKVv7ctGTqxD9zDEWvuHM12tWYqPAo2kD8HLeDt", // tekno top
      "QmUNgESyVv65FCnRFAFQidd6vcf9szgJ6Zux7fygsFT9mv", 
      "QmbRmEBegpTQHbtthHK8UioPkwp9og3fKPuPmjKoF3bh8Q", 
      "QmNvRYe3aWUXPFmsAVrARB8iK4TtcDXn6oaFwybAZcpauL", 
      "QmXAMdL2TpUj8KYwQ6YcASDeVjKnnsf3rFt9kaV6ELAess", // dub
      "QmTeCKCpKnEuWgzLmhy5YTvMB1wurvXA8FtZugGwo1gvk8", 
      "QmbSyj8sHkHjvuf7TMB5H4x5usDxsWNhGATVxCVwPzYz4j", 
      "QmX195iGxKaK5JQEHmBNs1JGERyfvWFXKx8x5jjWnEhzaR", 
      "QmYfARoTJZSghovyQj6ukVepZkn8YRUhX51Ro9RAqfPkDk", // jungle
      "QmTi2adypcZoBWnSL6yzprCPUnKHQWixe7kXyZsp7BeQu7",
      "QmaxPAto9RbRRRAmN6oPPbDxfnYGvubs5XGDhbdKSjmrWb", 
      "QmaM1ozSSXSdr3v1TBAQdibgMkoSFy3RS6cJokwrN1FXzE"]
  );  // deploying locally, what we give to constructor

    await gameContract.deployed(); // constructor run after we re deployed
    console.log("Contract deployed to:", gameContract.address);

    /*
    let txn;
    txn = await gameContract.checkIfUserHasNFT();
    await txn.wait();
    console.log("Minted NFT #1");
  };
  */

  let txn;
  txn = await gameContract.hostAParty(100);
  await txn.wait();
 // console.log("txn : ", txn);

 let txn2;
 txn2 = await gameContract.lastHostedAt();
 await txn2.wait();
 console.log("txn2 : ", txn2);

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