# Simple Sorting Algorithm (Bubble Sort)

This Cairo program implements bubble sort to sort an array of integers, returning the sorted array. It generates STARK proofs to verify the correctness of the sorting process using Scarb.

## Features

- Sorts arrays of unsigned 32-bit integers using bubble sort
- Generates STARK proofs for sorting correctness
- Comprehensive test suite covering edge cases
- Cairo 2.11.4 compatibility

## Getting Started

### Prerequisites

- Install Scarb package manager: [Scarb Installation Guide](https://docs.swmansion.com/scarb/)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/Cairo-Academy/cairo-programs.git
cd simple_sorting_algorithm
```

2. Build the project:

```bash
scarb build
```

## Usage

### Execute the Program

Run with the hardcoded input array [4, 2, 1, 3]:

```bash
scarb execute -p simple_sorting_algorithm --print-program-output
```

Example output:

```bash
4  # Array length
1  # Sorted elements
2
3
4
```

### Generate Proof

Generate a STARK proof for the execution:

```bash
scarb prove --execution-id 1
```

Proof will be saved to: `target/execute/simple_sorting_algorithm/execution1/proof/proof.json`

### Verify Proof

Verify the generated proof:

```bash
scarb verify --execution-id 1
```

## Testing

Run the test suite to validate sorting correctness:

```bash
scarb cairo-test
```

Test cases include:

- Empty arrays
- Single-element arrays
- Pre-sorted arrays
- Unsorted arrays
- Arrays with duplicate values
- Proper error handling

## Implementation Details

### Bubble Sort Algorithm

1. Iterates through the array multiple times
2. Compares adjacent elements
3. Swaps elements if they're in the wrong order
4. Early termination if no swaps occur in a pass

### Proof Generation

- Uses Cairo's native proof system
- Verifies all comparison and swapping operations
- Ensures final array is sorted in ascending order
