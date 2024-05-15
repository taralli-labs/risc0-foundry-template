use std::io::Read;

use alloy_sol_types::SolValue;
use risc0_zkvm::guest::env;

use guest::square::SquareJournal;

fn main() {
    let mut input_bytes = Vec::<u8>::new();
    env::stdin().read_to_end(&mut input_bytes).unwrap();

    let journal = <SquareJournal>::abi_decode(&input_bytes, true).unwrap();

    let square = journal.input * journal.input;

    assert_eq!(journal.square, square);

    env::commit_slice(journal.abi_encode().as_slice())
}
