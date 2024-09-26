#!/bin/bash

# Given data
data="add sub:TEST_R_TYPE:x{\$0}, x{\$1}, x{\$2}:2,31:0,31:0,31:10:."

# Step 1: Split the string by ":"
IFS=':' read -r instr_set macro template range0 range1 range2 num_of_test output_dir <<< "$data"

# Step 2: Store in an array
params=("$macro($instr_set $template)" "$range0" "$range1" "$range2" "$num_of_test" "$output_dir")

# Step 3: Example command (function) to pass parameters to
example_command() {
    echo "Parameters received: $1 - $2 - $3 - $4 - $5 - $6"
}

gen_test() {
    ./auto_gen_test.sh "${params[@]}"
}

# Step 4: Call example_command with parameters
# example_command "${params[@]}"
read -a instructions <<< "$instr_set"
for instr in "${instructions[@]}"; do
    params=("$macro($instr $template)" "$range0" "$range1" "$range2" "$num_of_test" "$output_dir/$instr.S")
    gen_test
done
