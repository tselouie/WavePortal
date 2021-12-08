//npx hardhat run scripts/run.js
//npx hardhat run scripts/deploy.js --network rinkeby
const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const adoptDinoFactory = await hre.ethers.getContractFactory('AdoptADino');
    const adoptADinoContract = await adoptDinoFactory.deploy({
        value: hre.ethers.utils.parseEther('0.1'),
      });
    await adoptADinoContract.deployed();

    console.log("Contract deployed by:", owner.address);
    console.log("Contract deployed to:", adoptADinoContract.address);

    let adoptCount;
   

    let contractBalance = await hre.ethers.provider.getBalance(
        adoptADinoContract.address
      );
      console.log(
        'Contract balance:',
        hre.ethers.utils.formatEther(contractBalance)
      );
        console.log("ADOPT 1");
   const adoptTxn = await adoptADinoContract.adopt();
    await adoptTxn.wait();


    adoptCount = await adoptADinoContract.getTotalDinos();

    contractBalance = await hre.ethers.provider.getBalance(adoptADinoContract.address);
    console.log(
      'Contract balance:',
      hre.ethers.utils.formatEther(contractBalance)
    );

    let allDinos = await adoptADinoContract.getAllDinos();
    console.log(allDinos);


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