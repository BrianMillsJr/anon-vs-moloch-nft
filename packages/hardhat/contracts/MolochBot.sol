//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Moloch Bot NFT Contract
/// @author jaxcoder, ghostffcode
/// @notice
/// @dev
contract MolochBot is ERC721URIStorage, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    uint256 public lastMinted = 0;

    // this lets you look up a token by the uri (assuming there is only one of each uri for now)
    mapping(bytes32 => uint256) public uriToTokenId;

    string[] private uris;

    constructor() ERC721("Moloch", "MOLOCH") {
        uris = ["Baleful_Abaddon.json","Cruel_Fenriz.json","Heinous_Sammael.json","Inhuman_Kali.json","Malicious_Melek.json","Nefarious_Mephistopheles.json","Vile_Bast.json","Baleful_Adramalech.json","Cruel_Gorgo.json","Hellish_Abaddon.json","Inhuman_Mastema.json","Malicious_Midgard.json","Nefarious_Nergal.json","Vile_Chemosh.json","Baleful_Baalberith.json","Cruel_Hecate.json","Hellish_Adramalech.json","Inhuman_Mictian.json","Malicious_Naamah.json","Nefarious_Nija.json","Vile_Emma-o.json","Baleful_Beelzebub.json","Cruel_Ishtar.json","Hellish_Ahpuch.json","Inhuman_Pluto.json","Malicious_Nergal.json","Nefarious_Pluto.json","Vile_Fenriz.json","Baleful_Beherit.json","Cruel_O-yama.json","Hellish_Asmodeus.json","Inhuman_Proserpine.json","Malicious_Nija.json","Nefarious_Proserpine.json","Vile_Hecate.json","Baleful_Dagon.json","Cruel_Pwcca.json","Hellish_Azazel.json","Inhuman_Pwcca.json","Malicious_Sabazios.json","Nefarious_Sabazios.json","Vile_Lilith.json","Baleful_Diabolus.json","Cruel_Shaitan.json","Hellish_Baphomet.json","Inhuman_Sammael.json","Malicious_Tan-mo.json","Nefarious_Shaitan.json","Vile_Loki.json","Baleful_Dracula.json","Cruel_Tan-mo.json","Hellish_Emma-o.json","Inhuman_Samnu.json","Malicious_Tezcatlipoca.json","Nefarious_Shiva.json","Vile_Marduk.json","Baleful_Hecate.json","Cruel_Thamuz.json","Hellish_Proserpine.json","Inhuman_Sekhmet.json","Malicious_Thamuz.json","Nefarious_Tan-mo.json","Vile_Melek.json","Baleful_Kali.json","Evil_Ahriman.json","Hellish_Sabazios.json","Inhuman_Shiva.json","Malignant_Adramalech.json","Nefarious_Tunrida.json","Vile_Midgard.json","Baleful_Mammon.json","Evil_Balaam.json","Hellish_Sammael.json","Inhuman_Tan-mo.json","Malignant_Asmodeus.json","Savage_Abaddon.json","Vile_Mormo.json","Baleful_Mania.json","Evil_Baphomet.json","Hellish_Sekhmet.json","Inhuman_Tezcatlipoca.json","Malignant_Astaroth.json","Savage_Ahpuch.json","Vile_Nihasa.json","Baleful_Midgard.json","Evil_Behemoth.json","Hellish_Tezcatlipoca.json","Inhuman_Tunrida.json","Malignant_Baalberith.json","Savage_Coyote.json","Vile_Pluto.json","Baleful_Nihasa.json","Evil_Diabolus.json","Immoral_Behemoth.json","Iniquitous_Abaddon.json","Malignant_Baphomet.json","Savage_Dagon.json","Vile_Proserpine.json","Baleful_O-yama.json","Evil_Fenriz.json","Immoral_Bile.json","Iniquitous_Bile.json","Malignant_Bast.json","Savage_Demogorgon.json","Vile_Tunrida.json","Baleful_Pwcca.json","Evil_Metztli.json","Immoral_Haborym.json","Iniquitous_Dagon.json","Malignant_Dagon.json","Savage_Kali.json","Villainous_Beelzebub.json","Baleful_Rimmon.json","Evil_Mictian.json","Immoral_Mantus.json","Iniquitous_Damballa.json","Malignant_Demogorgon.json","Savage_Lilith.json","Villainous_Euronymous.json","Baleful_Samnu.json","Evil_Mormo.json","Immoral_Melek.json","Iniquitous_Midgard.json","Malignant_Emma-o.json","Savage_Metztli.json","Villainous_Ishtar.json","Baleful_Sedit.json","Evil_Naamah.json","Immoral_Mictian.json","Iniquitous_Mormo.json","Malignant_Euronymous.json","Savage_Moloch.json","Villainous_Mantus.json","Barbarous_Amon.json","Evil_O-yama.json","Immoral_Mormo.json","Iniquitous_Naamah.json","Malignant_Ishtar.json","Savage_Naamah.json","Villainous_Mictian.json","Barbarous_Azazel.json","Evil_Rimmon.json","Immoral_O-yama.json","Iniquitous_Nija.json","Malignant_Midgard.json","Sinister_Ahpuch.json","Villainous_Nihasa.json","Barbarous_Baphomet.json","Evil_Sabazios.json","Immoral_Proserpine.json","Iniquitous_Pluto.json","Malignant_Mormo.json","Sinister_Azazel.json","Villainous_O-yama.json","Barbarous_Bile.json","Ferocious_Azazel.json","Immoral_Rimmon.json","Iniquitous_Supay.json","Malignant_Nija.json","Sinister_Bile.json","Villainous_Pan.json","Barbarous_Haborym.json","Ferocious_Beherit.json","Immoral_Sabazios.json","Iniquitous_Typhon.json","Malignant_Proserpine.json","Sinister_Chemosh.json","Villainous_Shaitan.json","Barbarous_Lilith.json","Ferocious_Bile.json","Immoral_Tan-mo.json","Malevolent_Amon.json","Malignant_Rimmon.json","Sinister_Euronymous.json","Villainous_Thoth.json","Barbarous_Loki.json","Ferocious_Midgard.json","Immoral_Yaotzin.json","Malevolent_Apollyon.json","Malignant_Yaotzin.json","Sinister_Ishtar.json","Villainous_Tunrida.json","Barbarous_Mantus.json","Ferocious_Mormo.json","Infernal_Amon.json","Malevolent_Astaroth.json","Monstrous_Amon.json","Sinister_Mania.json","Villainous_Typhon.json","Barbarous_Marduk.json","Ferocious_Naamah.json","Infernal_Asmodeus.json","Malevolent_Chemosh.json","Monstrous_Azazel.json","Sinister_Moloch.json","Villainous_Yaotzin.json","Barbarous_Melek.json","Ferocious_O-yama.json","Infernal_Baphomet.json","Malevolent_Demogorgon.json","Monstrous_Baphomet.json","Sinister_Naamah.json","Wicked_Amon.json","Barbarous_Milcom.json","Ferocious_Rimmon.json","Infernal_Behemoth.json","Malevolent_Dracula.json","Monstrous_Beelzebub.json","Sinister_Samnu.json","Wicked_Apollyon.json","Barbarous_Nija.json","Ferocious_Sabazios.json","Infernal_Dagon.json","Malevolent_Ishtar.json","Monstrous_Dagon.json","Sinister_Tchort.json","Wicked_Azazel.json","Barbarous_Sammael.json","Ferocious_Sekhmet.json","Infernal_Loki.json","Malevolent_Kali.json","Monstrous_Diabolus.json","Vicious_Adramalech.json","Wicked_Bast.json","Black_Adramalech.json","Ferocious_Supay.json","Infernal_Mantus.json","Malevolent_Lilith.json","Monstrous_Fenriz.json","Vicious_Balaam.json","Wicked_Emma-o.json","Black_Beherit.json","Ferocious_Tezcatlipoca.json","Infernal_Melek.json","Malevolent_Mammon.json","Monstrous_Hecate.json","Vicious_Chemosh.json","Wicked_Gorgo.json","Black_Dagon.json","Ferocious_Tunrida.json","Infernal_Metztli.json","Malevolent_Marduk.json","Monstrous_Mammon.json","Vicious_Euronymous.json","Wicked_Hecate.json","Black_Ishtar.json","Ferocious_Typhon.json","Infernal_O-yama.json","Malevolent_Mictian.json","Monstrous_Mania.json","Vicious_Lilith.json","Wicked_Ishtar.json","Black_Mictian.json","Heinous_Amon.json","Infernal_Pwcca.json","Malevolent_Nihasa.json","Monstrous_Milcom.json","Vicious_Metztli.json","Wicked_Mastema.json","Black_Sammael.json","Heinous_Balaam.json","Infernal_Sammael.json","Malevolent_Proserpine.json","Monstrous_Naamah.json","Vicious_Moloch.json","Wicked_Mephistopheles.json","Black_Supay.json","Heinous_Baphomet.json","Infernal_Tchort.json","Malevolent_Rimmon.json","Monstrous_Sammael.json","Vicious_Nija.json","Wicked_Naamah.json","Black_Thamuz.json","Heinous_Bast.json","Infernal_Tezcatlipoca.json","Malevolent_Thamuz.json","Monstrous_Tchort.json","Vicious_Pan.json","Wicked_Nergal.json","Cruel_Ahriman.json","Heinous_Beelzebub.json","Inhuman_Adramalech.json","Malicious_Ahriman.json","Monstrous_Tezcatlipoca.json","Vicious_Proserpine.json","Wicked_Nija.json","Cruel_Amon.json","Heinous_Bile.json","Inhuman_Asmodeus.json","Malicious_Amon.json","Monstrous_Typhon.json","Vicious_Sedit.json","Wicked_Pan.json","Cruel_Beelzebub.json","Heinous_Ishtar.json","Inhuman_Balaam.json","Malicious_Balaam.json","Nefarious_Ahpuch.json","Vicious_Shaitan.json","Wicked_Set.json","Cruel_Beherit.json","Heinous_Loki.json","Inhuman_Beherit.json","Malicious_Diabolus.json","Nefarious_Bile.json","Vicious_Tchort.json","Wicked_Shaitan.json","Cruel_Chemosh.json","Heinous_Mammon.json","Inhuman_Damballa.json","Malicious_Loki.json","Nefarious_Mania.json","Vicious_Thamuz.json","Wicked_Supay.json","Cruel_Damballa.json","Heinous_Naamah.json","Inhuman_Hecate.json","Malicious_Marduk.json","Nefarious_Mantus.json","Vile_Amon.json","Wicked_Typhon.json"];
    }

    function _baseURI() internal pure override returns (string memory) {
        return
            "https://gateway.pinata.cloud/ipfs/QmZtE5UiiHtQMh17VJmuAT2vfqB7pyfuFBX5sqDSPWSn3F/";
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
