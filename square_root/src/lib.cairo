/// Calculate the Square Root of an Integer.
///
/// # Arguments
///
/// * `n` - The number to check.
///
/// # Returns
///
/// * `u128` The square root of the number.
fn calculate_sqrt(n: u128) -> u128 {
    // Handle edge cases
    if n == 0 {
        return 0;
    }

    let mut left: u128 = 1;
    let mut right: u128 = n;
    let mut result: u128 = 0;

    while left <= right {
        let mid = left + (right - left) / 2;
        
        if mid <= n.into() / mid {
            result = mid;
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    };

    return result.into();
}


#[executable]
fn main(input: u128) -> u128 {
    calculate_sqrt(input)
}


#[cfg(test)]
mod tests {
    use super::calculate_sqrt;

    #[test]
    fn sqrt_0() {
        assert(calculate_sqrt(0) == 0, 'it works!');
    }

    #[test]
    fn sqrt_16() {
        assert(calculate_sqrt(16) == 4, 'it works!');
    }

    #[test]
    fn sqrt_25() {
        assert(calculate_sqrt(25) == 5, 'it works!');
    }

    #[test]
    fn sqrt_100() {
        assert(calculate_sqrt(100) == 10, 'it works!');
    }

    #[test]
    fn sqrt_835210000() {
        assert(calculate_sqrt(835210000) == 28900, 'it works!');
    }

    #[test]
    fn sqrt_99999980000001() {
        assert(calculate_sqrt(99999980000001) == 9999999, 'it works!');
    }

    #[test]
    #[should_panic()]
    fn sqrt_100_failed() {
        assert(calculate_sqrt(100) == 11, 'it works!');
    }
}


