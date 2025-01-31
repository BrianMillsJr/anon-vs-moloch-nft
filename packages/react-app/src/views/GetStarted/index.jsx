import { useContractReader } from "eth-hooks";
// import { ethers } from "ethers";
import React, { useState } from "react";
import { EthbotProgress } from "../../components";
import { Nav } from "../../themed-components";
import AuctionOne from "./AuctionOne";
import AuctionTwo from "./AuctionTwo";
import FinalBattle from "./FinalBattle";
import Prologue from "./Prologue";
import Read from "./Read";
import Winning from "./Winning";

import ComingSoon from "./ComingSoon";
// import { notification } from "antd";

// Steps component array
// const Steps = [Prologue, Read, AuctionOne, AuctionTwo, FinalBattle, Winning];
const Steps = [Prologue, Read, AuctionOne, AuctionTwo, ComingSoon, Winning];

const incrementPercent = "8";

function GetStarted({
  tx,
  readContracts,
  writeContracts,
  events,
  userSigner,
  loadWeb3Modal,
  initialStep = 1,
  address,
  faucetHint,
  localProvider,
  mainnetProvider,
  price,
  web3Modal,
  logoutOfWeb3Modal,
  blockExplorer,
  networkDisplay,
}) {
  const [currentStep, setCurrentStep] = useState(initialStep);
  const [mintingToken, setMintingToken] = useState(false);
  const [mintingStatue, setMintingStatue] = useState(false);
  // const [levelCompleted, setLevelCompleted] = useState(false);

  const tokenLevelDetails = useContractReader(readContracts, "GreatestLARP", "getDetailForTokenLevels");
  const statueLevelDetails = useContractReader(readContracts, "GreatestLARP", "getDetailForStatueLevels");

  const showWalletConnectionError = async () => {
    await loadWeb3Modal();
    // notification.error({
    //   message: "Please connect your wallet",
    //   description: "Connect your wallet to start LARPing",
    //   placement: "bottomRight",
    // });
  };

  const mintTokenBot = async level => {
    if (!userSigner) {
      return showWalletConnectionError();
    }
    setMintingToken(true);
    try {
      // fetch price for selected level
      const price = await readContracts.GreatestLARP.lastestPriceForTokenLevel(level);
      const value = price.add(price.mul(incrementPercent).div("100"));

      const result = tx(writeContracts.GreatestLARP.requestMint(level, { value }), async update => {
        console.log("📡 Transaction Update:", update);
        // reset minting
        if (update && (update.status === "confirmed" || update.status === 1)) {
          console.log(" 🍾 Transaction " + update.hash + " finished!");
          console.log(
            " ⛽️ " +
              update.gasUsed +
              "/" +
              (update.gasLimit || update.gas) +
              " @ " +
              parseFloat(update.gasPrice) / 1000000000 +
              " gwei",
          );
        }
      });
      console.log("awaiting metamask/web3 confirm result...", result);
      console.log(await result);
    } catch (err) {
      console.log(err);
      setMintingToken(false);
    }
    setMintingToken(false);
  };

  const mintTokenStatue = async level => {
    if (!userSigner) {
      return showWalletConnectionError();
    }
    setMintingStatue(true);
    try {
      // fetch price for selected level
      const price = await readContracts.GreatestLARP.lastestPriceForStatueLevel(level);
      const value = price.add(price.mul(incrementPercent).div("100"));

      const result = tx(writeContracts.GreatestLARP.requestMintStatue(level, { value }), async update => {
        console.log("📡 Transaction Update:", update);
        // reset minting
        if (update && (update.status === "confirmed" || update.status === 1)) {
          console.log(" 🍾 Transaction " + update.hash + " finished!");
          console.log(
            " ⛽️ " +
              update.gasUsed +
              "/" +
              (update.gasLimit || update.gas) +
              " @ " +
              parseFloat(update.gasPrice) / 1000000000 +
              " gwei",
          );
        }
      });
      console.log("awaiting metamask/web3 confirm result...", result);
      console.log(await result);
    } catch (err) {
      console.log(err);
      setMintingStatue(false);
    }
    setMintingStatue(false);
  };

  // Proceed to the next UI step
  const goToNextStep = () => {
    setCurrentStep(currentStep + 1);
  };

  const goToPrevStep = () => {
    setCurrentStep(currentStep - 1);
  };

  const CurrentStepComponent = Steps[currentStep];

  return (
    <>
      <Nav
        faucetHint={faucetHint}
        address={address}
        localProvider={localProvider}
        userSigner={userSigner}
        mainnetProvider={mainnetProvider}
        price={price}
        web3Modal={web3Modal}
        loadWeb3Modal={loadWeb3Modal}
        logoutOfWeb3Modal={logoutOfWeb3Modal}
        blockExplorer={blockExplorer}
        networkDisplay={networkDisplay}
      />
      {/* Hack to not move between coming soon and final boss */}
      <EthbotProgress progress={currentStep} />
      <section className="container flex flex-1 mx-auto my-20 pb-8">
        <CurrentStepComponent
          address={address}
          readContracts={readContracts}
          goToPrevStep={goToPrevStep}
          goToNextStep={goToNextStep}
          currentStep={currentStep}
          mintTokenBot={mintTokenBot}
          mintTokenStatue={mintTokenStatue}
          incrementPercent={incrementPercent}
          mintingToken={mintingToken}
          mintingStatue={mintingStatue}
          tokenLevelDetails={tokenLevelDetails}
          statueLevelDetails={statueLevelDetails}
        />
      </section>
    </>
  );
}

export default GetStarted;
