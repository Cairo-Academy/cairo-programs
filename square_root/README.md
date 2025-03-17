# Square Root Function
This program calculates the integer square root of a given input and provides a proof of the calculation

## Executing the Program
### Run the scarb execute command and provide an integer as the argument
### The execution creates a folder under ./target/execute/square_root/execution1
`scarb execute -p square_root --print-program-output --arguments 100`

## Generate Proof

### Run the scarb prove command to generate a proof, --execution_id 1 points to the first execution (from the execution1 folder).
### The proof is saved in ./target/execute/square_root/execution1/proof/proof.json

`scarb prove --execution-id 1`

## Verify Proof

### Verify the proof with the scarb verify command

`scarb verify --execution-id 1`