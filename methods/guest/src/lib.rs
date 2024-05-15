pub mod square {
    use alloy_sol_macro::sol;

    sol! {
        struct SquareJournal {
            uint256 input;
            uint256 square;
        }
    }
}

// pub use square::SquareJournal;
