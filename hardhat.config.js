require('@nomiclabs/hardhat-waffle');
require('dotenv').config();

module.exports = {
  solidity: '0.8.0',
  networks: {
    goerli: {
      url: process.env.STAGING_ALCHEMY_KEY,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};

/*
module.exports = {
  solidity: '0.8.0',
  networks: {
    aurora_testnet: {
      url: 'https://testnet.aurora.dev',
      accounts: [`0x${process.env.AURORA_TESTNET_PRIVATE_KEY}`],
      chainId: 1313161555
    },
    aurora_mainnet: {
      url: process.env.AURORA_RPC_URL,      
      accounts: [`0x${process.env.AURORA_MAINNET_PRIVATE_KEY}`],
      chainId: 1313161554,
    },
  },
  etherscan: {
    apiKey: process.env.AURORASCAN_API_KEY,
  },
};
*/