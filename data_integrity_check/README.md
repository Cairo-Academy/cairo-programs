# Data Integrity Verification

This program verifies the integrity of a small piece of data using Poseidon hash, returning `1` if the data matches the expected hash, `0` if not, and provides a STARK proof of the check.

## Executing the Program

### Run the `scarb execute` command with a data value and expected hash via an arguments file

### The execution creates a folder under `./target/execute/data_integrity_check/execution1`

```bash
scarb execute -p data_integrity_check --arguments-file args.json --print-program-output
```

- Example `args.json`: `["0x2a", "0x<actual_hash>"]` (replace `<actual_hash>` with the Poseidon hash of `0x2a`).

## Generate Proof

### Run the `scarb prove` command to generate a proof, `--execution-id 1` points to the first execution

### The proof is saved in `./target/execute/data_integrity_check/execution1/proof/proof.json`

```bash
scarb prove --execution-id 1
```

## Verify Proof

### Verify the proof with the `scarb verify` command

```bash
scarb verify --execution-id 1
```

## Testing

Validate the program with the test suite.

```bash
scarb cairo-test
```

- Tests cover:
  - Correct hashes for `0`, `42`, and `927456318`.
  - Incorrect hash detection.
  - Panic on invalid verification.

Use tests like `test_small_positive_correct_hash` to compute valid hashes for `args.json`.

## Installation

1. Clone the repo:

   ```bash
   git clone <repo-url>
   cd data_integrity_check
   ```

2. Build:

   ```bash
   scarb build
   ```
