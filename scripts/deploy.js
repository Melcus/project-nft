const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("ProjectNFT");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("deploy.js: Contract deployed to:", nftContract.address);

    let txn = await nftContract.makeAnEpicNFT()     // Call the function.
    await txn.wait()     // Wait for it to be mined.
    console.log("deploy.js: Minted NFT #1")

    txn = await nftContract.makeAnEpicNFT()
    await txn.wait() // Wait for it to be mined.
    console.log("deploy.js: Minted NFT #2")
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
