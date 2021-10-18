//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Eth Bot NFT Contract
/// @author jaxcoder, ghostffcode
/// @notice
/// @dev
contract EthBot is ERC721URIStorage, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    uint256 public lastMinted = 0;

    // this lets you look up a token by the uri (assuming there is only one of each uri for now)
    mapping(bytes32 => uint256) public uriToTokenId;

    string[] private uris;

    constructor() ERC721("EthBot", "ETHBOT") {
        uris = ["Beneficent_Adam.json", "Benign_Cyborg.json", "Celestial_Alice.json", "Godly_Ilia.json", "Heavenly_Lucia.json", "Moral_Maria.json", "Sainted_Lucia.json", "Beneficent_Ava.json", "Benign_Doc.json", "Celestial_Astor.json", "Godly_Kronos.json", "Heavenly_Metallo.json", "Moral_Marvin.json", "Sainted_Lydia.json", "Beneficent_Bb-8.json", "Benign_Elle.json", "Celestial_Atom.json", "Godly_Maria.json", "Heavenly_Piper.json", "Moral_Motoko.json", "Sainted_Marcus.json", "Beneficent_Casella.json", "Benign_Galaxina.json", "Celestial_Avery.json", "Godly_Nuke.json", "Heavenly_Qrio.json", "Moral_Optimus.json", "Sainted_Mukuro.json", "Beneficent_Garth.json", "Benign_Genghis.json", "Celestial_Bishop.json", "Godly_Piper.json", "Heavenly_Rachael.json", "Moral_Qrio.json", "Sainted_Ro-man,.json", "Beneficent_Gigan.json", "Benign_Irona.json", "Celestial_Dolores.json", "Godly_Robotman.json", "Heavenly_Robot.json", "Moral_Samantha.json", "Sainted_Robots.json", "Beneficent_Irona.json", "Benign_Jinx.json", "Celestial_Galaxina.json", "Godly_Rom.json", "Heavenly_Rom.json", "Moral_Shakey.json", "Sainted_Shakey.json", "Beneficent_Kampf.json", "Benign_Kampf.json", "Celestial_Gigan.json", "Godly_S1mone.json", "Heavenly_Shakey.json", "Moral_Spirit.json", "Sainted_Vanessa.json", "Beneficent_Katie.json", "Benign_Lucia.json", "Celestial_Gort.json", "Godly_Shakey.json", "Heavenly_Spirit.json", "Moral_Talos.json", "Sainted_Wall-e.json", "Beneficent_Marcus.json", "Benign_Marcus.json", "Celestial_Ilia.json", "Godly_Sonny.json", "Heavenly_Technology.json", "Moral_Torg.json", "Saintly_Adam.json", "Beneficent_Moguera.json", "Benign_Max.json", "Celestial_John.json", "Godly_Technology.json", "Heavenly_Tima.json", "Moral_Ultron.json", "Saintly_Alex.json", "Beneficent_Motoko.json", "Benign_Mukuro.json", "Celestial_Kimiko.json", "Godly_Tobor.json", "Holy_Adam.json", "Righteous_Adam.json", "Saintly_Astronema.json", "Beneficent_P2.json", "Benign_P2.json", "Celestial_Kryton.json", "Godly_Victor.json", "Holy_Alice.json", "Righteous_Amee.json", "Saintly_Baymax.json", "Beneficent_Pris.json", "Benign_Piper.json", "Celestial_Marcus.json", "Good_Alex.json", "Holy_Bender.json", "Righteous_Astor.json", "Saintly_Dante.json", "Beneficent_Qrio.json", "Benign_Qrio.json", "Celestial_Nuke.json", "Good_Ava.json", "Holy_C-3po.json", "Righteous_Baymax.json", "Saintly_Doc.json", "Beneficent_Robby.json", "Benign_Robot.json", "Celestial_Pickles.json", "Good_Avery.json", "Holy_Eve.json", "Righteous_Bb-8.json", "Saintly_Elle.json", "Beneficent_Rom.json", "Benign_Samantha.json", "Celestial_Robby.json", "Good_Batou.json", "Holy_Galaxina.json", "Righteous_Casella.json", "Saintly_Genos.json", "Beneficent_Samantha.json", "Benign_Shakey.json", "Celestial_Robonaut.json", "Good_Bb-8.json", "Holy_Grievous.json", "Righteous_Dillon.json", "Saintly_Metallo.json", "Beneficent_Sonny.json", "Benign_Tima.json", "Celestial_Robot.json", "Good_Bunnie.json", "Holy_Ilia.json", "Righteous_Elle.json", "Saintly_Mukuro.json", "Beneficent_Tobor.json", "Benign_Ultron.json", "Celestial_S1mone.json", "Good_Cameron.json", "Holy_Irona.json", "Righteous_Genghis.json", "Saintly_Pearl.json", "Benevolent_Aibo.json", "Benignant_Adam.json", "Celestial_Spirit.json", "Good_Cassandra.json", "Holy_Marvin.json", "Righteous_Grievous.json", "Saintly_Rachael.json", "Benevolent_Atom.json", "Benignant_Aibo.json", "Celestial_Talos.json", "Good_Colussus.json", "Holy_Pearl.json", "Righteous_Irona.json", "Saintly_Ultron.json", "Benevolent_Chani.json", "Benignant_Amee.json", "Celestial_Technology.json", "Good_Doc.json", "Holy_Pickles.json", "Righteous_Kampf.json", "Virtuous_Alex.json", "Benevolent_Dante.json", "Benignant_Batou.json", "Ethical_Adam.json", "Good_Genghis.json", "Holy_Tobor.json", "Righteous_Katie.json", "Virtuous_Astor.json", "Benevolent_Irona.json", "Benignant_Baymax.json", "Ethical_Arbeit.json", "Good_Gigan.json", "Holy_Ultron.json", "Righteous_Killian.json", "Virtuous_Atom.json", "Benevolent_John.json", "Benignant_Bunnie.json", "Ethical_Ash.json", "Good_Irona.json", "Holy_Vanessa.json", "Righteous_Moguera.json", "Virtuous_Bb-8.json", "Benevolent_Katie.json", "Benignant_Cameron.json", "Ethical_Batou.json", "Good_Jaime.json", "Moral_Adam.json", "Righteous_Piper.json", "Virtuous_Briareos.json", "Benevolent_Lydia.json", "Benignant_Deathstryke.json", "Ethical_Bb-8.json", "Good_Killian.json", "Moral_Alita.json", "Righteous_Ro-man,.json", "Virtuous_C-3po.json", "Benevolent_Marcus.json", "Benignant_Elle.json", "Ethical_Bender.json", "Good_Lydia.json", "Moral_Astor.json", "Righteous_Robby.json", "Virtuous_Cassandra.json", "Benevolent_Moguera.json", "Benignant_Irona.json", "Ethical_Bishop.json", "Good_Metallo.json", "Moral_Astroboy.json", "Sainted_Adam.json", "Virtuous_Dante.json", "Benevolent_Robby.json", "Benignant_Jinx.json", "Ethical_Box.json", "Good_Mukuro.json", "Moral_Austin.json", "Sainted_Alita.json", "Virtuous_Genos.json", "Benevolent_Robot.json", "Benignant_Katie.json", "Ethical_Cassandra.json", "Good_Nuke.json", "Moral_Avery.json", "Sainted_Astronema.json", "Virtuous_Irona.json", "Benevolent_Vanessa.json", "Benignant_Kryton.json", "Ethical_Chani.json", "Good_Omega.json", "Moral_Batou.json", "Sainted_Barry.json", "Virtuous_Metallo.json", "Benign_Adam.json", "Benignant_Mukuro.json", "Ethical_Colussus.json", "Good_Spirit.json", "Moral_Box.json", "Sainted_Baymax.json", "Virtuous_Motoko.json", "Benign_Alex.json", "Benignant_Optimus.json", "Ethical_Ilia.json", "Good_Torg.json", "Moral_Bunnie.json", "Sainted_Bb-8.json", "Virtuous_Omega.json", "Benign_Arbeit.json", "Benignant_P2.json", "Ethical_Jinx.json", "Good_Ultron.json", "Moral_Cappy.json", "Sainted_Bender.json", "Virtuous_Opportunity.json", "Benign_Avery.json", "Benignant_Piper.json", "Ethical_Marcus.json", "Heavenly_Alice.json", "Moral_Chani.json", "Sainted_Box.json", "Virtuous_Optimus.json", "Benign_Batou.json", "Benignant_Pris.json", "Ethical_P2.json", "Heavenly_Ava.json", "Moral_Elle.json", "Sainted_Cameron.json", "Virtuous_Robonaut.json", "Benign_Bender.json", "Benignant_Qrio.json", "Ethical_Piper.json", "Heavenly_Bb-8.json", "Moral_Genghis.json", "Sainted_Chappie.json", "Virtuous_Robot.json", "Benign_Bishop.json", "Benignant_Robot.json", "Ethical_Vanessa.json", "Heavenly_Casella.json", "Moral_Gigan.json", "Sainted_Deathstryke.json", "Virtuous_Robotman.json", "Benign_Briareos.json", "Benignant_Talos.json", "Godly_Arbeit.json", "Heavenly_Chani.json", "Moral_Ilia.json", "Sainted_Dolores.json", "Virtuous_Rom.json", "Benign_Bunnie.json", "Benignant_Technology.json", "Godly_Austin.json", "Heavenly_Elle.json", "Moral_Jaime.json", "Sainted_Galaxina.json", "Virtuous_Samantha.json", "Benign_Casella.json", "Benignant_Wall-e.json", "Godly_Bishop.json", "Heavenly_Jaime.json", "Moral_John.json", "Sainted_Irona.json", "Benign_Cherry.json", "Celestial_Adam.json", "Godly_Elsie.json", "Heavenly_Katie.json", "Moral_Kimiko.json", "Sainted_Killian.json"];
    }

    function _baseURI() internal pure override returns (string memory) {
        return
            "https://gateway.pinata.cloud/ipfs/QmVVUny3kh5vVw35a7XrZLKDYGFiBZaZrvKug4chMVVRXV/";
    }

    function contractURI() public view returns (string memory) {
        return "";
    }

    function lastMintedToken() external view returns (uint256 id) {
        id = _tokenIds.current();
    }

    function mintItem(address to, string memory tokenURI)
        private
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 id = _tokenIds.current();
        _mint(to, id);
        _setTokenURI(id, tokenURI);

        return id;
    }

    function mint(address user) external onlyOwner returns (uint256 id) {
        id = _tokenIds.current();

        mintItem(user, uris[id]);

        lastMinted = id;

        // TODO : how do we setup the URI?

        return id;
    }
}
