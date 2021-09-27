pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// Import helper function
import { Base64 } from "./libraries/Base64.sol";

contract ProjectNFT is ERC721URIStorage {

	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	// We split the SVG at the part where it asks for the background color.
	string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
	string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

	// I create three arrays, each with their own theme of random words.
	// Pick some random funny words, names of anime characters, foods you like, whatever!
	string[] firstWords = ["Fund", "Wrist", "Deserve", "Note", "Voyage", "Basis", "Colon", "Promote", "Bean", "End", "Minority", "Length", "Ook"];
	string[] secondWords = ["Live", "Beneficiary", "Seller", "Excuse", "Elegant", "Hypnothize", "Worm", "Suburb", "Absent", "Sour", "Letter", "Pull"];
	string[] thirdWords = ["Detail", "Comment", "Penny", "Technique", "Eye", "Mask", "Lounge", "Crack", "Pie", "Hell", "Law"];

	string[] colors = ["#6B7280", "#EF4444", "#F59E0B", "#10B981", "#3B82F6", "#6366F1", "", "8B5CF6", "EC4899", "black"];

	event NewEpicNFTMinted(address sender, uint256 tokenId);

	constructor() ERC721("SquareNFT", "Square"){
		console.log("sol: NFT constructor");
	}

	// I create a function to randomly pick a word from each array.
	function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
		// I seed the random generator. More on this in the lesson.
		uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
		// Squash the # between 0 and the length of the array to avoid going out of bounds.
		rand = rand % firstWords.length;
		return firstWords[rand];
	}

	function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
		uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
		rand = rand % secondWords.length;
		return secondWords[rand];
	}

	function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
		uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
		rand = rand % thirdWords.length;
		return thirdWords[rand];
	}

	// Same old stuff, pick a random color.
	function pickRandomColor(uint256 tokenId) public view returns (string memory) {
		uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
		rand = rand % colors.length;
		return colors[rand];
	}

	function random(string memory input) internal pure returns (uint256) {
		return uint256(keccak256(abi.encodePacked(input)));
	}

	function makeAnEpicNFT() public {
		uint256 newItemId = _tokenIds.current();

		string memory first = pickRandomFirstWord(newItemId);
		string memory second = pickRandomSecondWord(newItemId);
		string memory third = pickRandomThirdWord(newItemId);
		string memory combinedWord = string(abi.encodePacked(first, second, third));

		// Add the random color in.
		string memory randomColor = pickRandomColor(newItemId);
		string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));

		string memory json = Base64.encode(
			bytes(
				string(
					abi.encodePacked(
						'{"name": "',
						combinedWord,
						'", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
						Base64.encode(bytes(finalSvg)),
						'"}'
					)
				)
			)
		);

		string memory finalTokenUri = string(
			abi.encodePacked("data:application/json;base64,", json)
		);

		console.log("\n--------------------");
		console.log(finalTokenUri);
		console.log("--------------------\n");

		_safeMint(msg.sender, newItemId);

		_setTokenURI(newItemId, finalTokenUri);

		_tokenIds.increment();
		console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
		emit NewEpicNFTMinted(msg.sender, newItemId);
	}
}
