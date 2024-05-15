// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IRiscZeroVerifier} from "risc0/IRiscZeroVerifier.sol";
import {ImageID} from "./ImageID.sol"; // auto-generated contract after running `cargo build`.

struct Journal {
    uint256 input;
    uint256 square;
}

/// @title Square Risc0 verifier contract.
/// @notice Proves that a number is a square.
/// @dev I just wanted an example where the output is different than the input.
contract Square {
    /// @notice RISC Zero verifier contract address.
    IRiscZeroVerifier public immutable verifier;
    /// @notice Image ID of the only zkVM binary to accept verification from.
    bytes32 public constant imageId = ImageID.SQUARE_ID;

    /// @notice A pair of numbers in which the second is the square of the first.
    Journal public current;

    /// @notice Initialize the contract, binding it to a specified RISC Zero verifier.
    constructor(IRiscZeroVerifier _verifier) {
        verifier = _verifier;
        current = Journal(0, 0);
    }

    /// @notice Set the square number stored on the contract. Requires a RISC Zero proof that
    ///         the number is a square.
    function set(
        Journal calldata journal,
        bytes32 postStateDigest,
        bytes calldata seal
    ) public {
        // Construct the expected journal data. Verify will fail if journal does not match.
        bytes memory journal_bytes = abi.encode(journal);
        require(
            verifier.verify(
                seal,
                imageId,
                postStateDigest,
                sha256(journal_bytes)
            )
        );
        current = journal;
    }

    /// @notice Returns the number stored.
    function get() public view returns (Journal memory) {
        return current;
    }
}
