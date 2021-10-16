import { useContractReader } from "eth-hooks";
import { ethers } from "ethers";
import React, { useEffect, useState } from "react";
import { EthbotProgress } from "../../components";
import AuctionOne from "./AuctionOne";
import AuctionTwo from "./AuctionTwo";
import FinalBattle from "./FinalBattle";
import Read from "./Read";
import Winning from "./Winning";
import { Nav } from "../../themed-components";

// Steps component array
const Steps = [Read, AuctionOne, AuctionTwo, FinalBattle, Winning];

function GetStarted({ tx, readContracts, writeContracts, events, ...props }) {
  const [currentStep, setCurrentStep] = useState(0);
  const [mintingToken, setMintingToken] = useState(false);
  const [mintingStatue, setMintingStatue] = useState(false);
  const [levelCompleted, setLevelCompleted] = useState(false);

  const tokenPrices = (useContractReader(readContracts, "GreatestLARP", "tokenPrices") || []).map(v =>
    ethers.utils.formatUnits(v),
  );

  const statuePrices = (useContractReader(readContracts, "GreatestLARP", "statuePrices") || []).map(v =>
    ethers.utils.formatUnits(v),
  );

  const tokenLeftover = (useContractReader(readContracts, "GreatestLARP", "tokenLeftover") || []).map(v =>
    v.toString(),
  );

  const statueLeftover = (useContractReader(readContracts, "GreatestLARP", "statueLeftover") || []).map(v =>
    v.toString(),
  );

  // working on this
  useEffect(() => {
    if (tokenLeftover >= 297 && statueLeftover >= 2) {
      setLevelCompleted(true);
    }
  }, [tokenLeftover, statueLeftover, readContracts]);

  const mintTokenBot = async level => {
    setMintingToken(true);
    try {
      // fetch price for selected level
      const { price } = await readContracts.GreatestLARP.getDetailsForLevelBots(level);
      const result = tx(writeContracts.GreatestLARP.requestMint(level, { value: price }), async update => {
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
      setMintingToken(false);
    }
    setMintingToken(false);
  };

  const mintTokenStatue = async level => {
    setMintingStatue(true);
    try {
      // fetch price for selected level
      const { price } = await readContracts.GreatestLARP.getDetailsForLevelStatue(level);
      const boostedPrice = price + (price * .05);
      const result = tx(writeContracts.GreatestLARP.requestMintStatue(level, { value: boostedPrice }), async update => {
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
      setMintingStatue(false);
    }
    setMintingStatue(false);
  };

  // Proceed to the next UI step
  const goToNextStep = () => {
    setCurrentStep(currentStep + 1);
  };

  console.log(tokenPrices);
  console.log(statuePrices);

  const CurrentStepComponent = Steps[currentStep];

  return (
    <>
      <Nav {...props} />
      <EthbotProgress progress={currentStep} />
      <section className="container flex flex-1 mx-auto my-20">
        <CurrentStepComponent
          goToNextStep={goToNextStep}
          currentStep={currentStep}
          mintTokenBot={mintTokenBot}
          mintTokenStatue={mintTokenStatue}
          tokenLeftover={tokenLeftover}
          statueLeftover={statueLeftover}
          tokenPrices={tokenPrices}
          statuePrices={statuePrices}
          mintingToken={mintingToken}
          mintingStatue={mintingStatue}
          levelCompleted={levelCompleted}
        />
      </section>
    </>
  );
}

export default GetStarted;
