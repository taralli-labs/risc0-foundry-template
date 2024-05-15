// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.20;

import {RiscZeroCheats} from "risc0/RiscZeroCheats.sol";
import {console2} from "forge-std/console2.sol";
import {Test} from "forge-std/Test.sol";
import {IRiscZeroVerifier} from "risc0/IRiscZeroVerifier.sol";
import {Square, Journal} from "../contracts/Square.sol";
import {Elf} from "./Elf.sol"; // auto-generated contract after running `cargo build`.

contract SquareTest is RiscZeroCheats, Test {
    Square public square;

    function setUp() public {
        IRiscZeroVerifier verifier = deployRiscZeroVerifier();

        square = new Square(verifier);

        Journal memory current = square.get();
        Journal memory expected = Journal(0, 0);

        assertEq(current.input, expected.input);
        assertEq(current.square, expected.square);
    }

    function test_SetSquare() public {
        uint256 input = 1_000;
        uint256 output = 1_000_000;

        Journal memory expected = Journal(input, output);

        (
            bytes memory journal_bytes,
            bytes32 post_state_digest,
            bytes memory seal
        ) = prove(Elf.SQUARE_PATH, abi.encode(expected));

        square.set(
            abi.decode(journal_bytes, (Journal)),
            post_state_digest,
            seal
        );

        Journal memory current = square.get();

        assertEq(current.input, expected.input);
        assertEq(current.square, expected.square);
    }

    function test_SetZero() public {
        uint256 input = 0;
        uint256 output = 0;

        Journal memory expected = Journal(input, output);

        (
            bytes memory journal_bytes,
            bytes32 post_state_digest,
            bytes memory seal
        ) = prove(Elf.SQUARE_PATH, abi.encode(expected));

        square.set(
            abi.decode(journal_bytes, (Journal)),
            post_state_digest,
            seal
        );

        Journal memory current = square.get();

        assertEq(current.input, expected.input);
        assertEq(current.square, expected.square);
    }
}
