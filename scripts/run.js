const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("ProjectNFT")
    const nftContract = await nftContractFactory.deploy()
    await nftContract.deployed();

    console.log("run.js: Contract deployed to:", nftContract.address)

    let txn = await nftContract.makeAnEpicNFT() // Mint NFT #0
    await txn.wait()  // Wait for it to be mined.

    txn = await nftContract.makeAnEpicNFT() // Mint another NFT #1
    await txn.wait()  // Wait for it to be mined.

    console.log("run.js: Done minting NFTs !")
}

const runMain = async () => {
    try {
        await main()
        process.exit(0)
    } catch (error) {
        console.log(error)
        process.exit(1)
    }
}

runMain()
