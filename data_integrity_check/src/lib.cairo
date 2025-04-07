/// Verifies data integrity using Poseidon hash. Takes a `felt252` data value and expected hash,
/// returns 1 if they match, 0 if not. Built with Cairo 2.10.1 as an executable, supports STARK
/// proof generation via `scarb prove`. Tests validate zero, small, and large numbers, plus
/// incorrect hash cases.

use core::hash::HashStateTrait;
use core::poseidon::PoseidonTrait;

fn verify_data_integrity(data: felt252, expected_hash: felt252) -> bool {
    let computed_hash = PoseidonTrait::new().update(data).finalize();
    computed_hash == expected_hash
}

// Main executable function returning 1 for valid, 0 for invalid
#[executable]
fn main(data: felt252, expected_hash: felt252) -> felt252 {
    if verify_data_integrity(data, expected_hash) {
        1
    } else {
        0
    }
}


#[cfg(test)]
mod tests {
    use core::hash::HashStateTrait;
    use core::poseidon::PoseidonTrait;
    use super::verify_data_integrity;

    // Zero data with correct hash
    #[test]
    fn test_zero_data_correct_hash() {
        let data = 0;
        let expected_hash = PoseidonTrait::new().update(data).finalize();
        assert!(verify_data_integrity(data, expected_hash), "Zero data should verify");
    }

    // Small positive number with correct hash
    #[test]
    fn test_small_positive_correct_hash() {
        let data = 42;
        let expected_hash = PoseidonTrait::new().update(data).finalize();
        assert!(verify_data_integrity(data, expected_hash), "42 should verify");
    }

    // Larger number with correct hash
    #[test]
    fn test_large_number_correct_hash() {
        let data = 927456318;
        let expected_hash = PoseidonTrait::new().update(data).finalize();
        assert!(verify_data_integrity(data, expected_hash), "Large number should verify");
    }

    // Zero data with incorrect hash
    #[test]
    fn test_zero_data_incorrect_hash() {
        let data = 0;
        let correct_hash = PoseidonTrait::new().update(data).finalize();
        let wrong_hash = correct_hash + 1;
        assert!(!verify_data_integrity(data, wrong_hash), "Incorrect hash should fail");
    }

    // Panic on incorrect verification
    #[test]
    #[should_panic]
    fn test_incorrect_verification_panics() {
        let data = 42;
        let wrong_hash = PoseidonTrait::new().update(43).finalize();
        assert!(verify_data_integrity(data, wrong_hash), "Should fail and panic");
    }
}
