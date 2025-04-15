/// Sorts a list of integers using bubble sort, returning the sorted array.
/// Uses u32 for safe integer operations. Built with Cairo 2.11.4.
/// Supports STARK proof generation via `scarb prove`.

use core::array::ArrayTrait;
use core::num::traits::SaturatingSub;

fn bubble_sort(mut arr: Array<u32>) -> Array<u32> {
    let len = arr.len();
    if len <= 1 {
        return arr;
    }

    let mut i: usize = 0;
    let mut swapped: bool = true;

    while swapped {
        swapped = false;
        let mut j: usize = 0;

        // Fixed loop condition with !=
        while j != len.saturating_sub(i + 1) {
            let current = *arr.at(j);
            let next = *arr.at(j + 1);

            if current > next {
                // Rebuild array with swapped elements
                let mut new_arr = ArrayTrait::new();
                for k in 0..len {
                    let value = if k == j {
                        next
                    } else if k == j + 1 {
                        current
                    } else {
                        *arr.at(k)
                    };
                    new_arr.append(value);
                }
                arr = new_arr;
                swapped = true;
            }
            j += 1;
        }
        i += 1;
    }
    arr
}

// Verifies if an array is sorted in ascending order
fn is_sorted(arr: @Array<u32>) -> bool {
    let len = arr.len();
    let mut i: usize = 0;
    // Fixed loop condition with !=
    while i != len.saturating_sub(1) {
        if *arr.at(i) > *arr.at(i + 1) {
            return false;
        }
        i += 1;
    }
    true
}

// Main executable function
#[executable]
fn main() -> Array<u32> {
    let input = array![4, 2, 1, 3]; // Hardcoded input
    bubble_sort(input)
}


#[cfg(test)]
mod tests {
    use core::array::ArrayTrait;
    use super::{bubble_sort, is_sorted};

    #[test]
    fn test_empty_array() {
        let arr = array![];
        let result = bubble_sort(arr);
        assert!(result.len() == 0, "Empty array");
    }

    #[test]
    fn test_single_element() {
        let mut arr = array![42];
        let result = bubble_sort(arr);
        assert!(is_sorted(@result), "Single element should be sorted");
        assert!(*result.at(0) == 42, "Single element should be unchanged");
    }

    #[test]
    fn test_sorted_array() {
        let mut arr = array![1, 2, 3, 4];
        let result = bubble_sort(arr);
        assert!(is_sorted(@result), "Sorted array should remain sorted");
        assert!(*result.at(0) == 1, "Element 0 should be 1");
        assert!(*result.at(1) == 2, "Element 1 should be 2");
        assert!(*result.at(2) == 3, "Element 2 should be 3");
        assert!(*result.at(3) == 4, "Element 3 should be 4");
    }

    #[test]
    fn test_unsorted_array() {
        let arr = array![4, 2, 1, 3];
        let result = bubble_sort(arr);
        assert!(is_sorted(@result), "Sorted check");
        assert!(*result.at(0) == 1, "Element 0");
        assert!(*result.at(3) == 4, "Element 3");
    }

    #[test]
    fn test_duplicates() {
        let mut arr = array![3, 1, 3, 2];
        let result = bubble_sort(arr);
        assert!(is_sorted(@result), "Array with duplicates should be sorted");
        assert!(*result.at(0) == 1, "Element 0 should be 1");
        assert!(*result.at(1) == 2, "Element 1 should be 2");
        assert!(*result.at(2) == 3, "Element 2 should be 3");
        assert!(*result.at(3) == 3, "Element 3 should be 3");
    }

    #[test]
    #[should_panic]
    fn test_panic_on_unsorted() {
        let mut arr = array![4, 2, 1, 3];
        let result = bubble_sort(arr);
        assert!(!is_sorted(@result), "Sorted array should not fail");
    }
}
