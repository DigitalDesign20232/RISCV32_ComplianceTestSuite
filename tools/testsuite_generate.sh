#!/bin/bash
BASE_DIR="../arch"
ARCH_R_DIR="rv32r"

# Given "test_suite" = array of "test"
# Format of "test": "<list of instruction>:<macro>:<template contain placeholder {$0}, {$1}, {$2}>:<range of $0>:<range of $1>:<range of $2>:<number of tests>:<output directory>"
test_suite=(
    "add sub:TEST_R_TYPE:x{\$0}, x{\$1}, x{\$2}:2,31:0,31:0,31:10:$BASE_DIR/$ARCH_R_DIR"
    "and or xor:TEST_R_TYPE:x{\$0}, x{\$1}, x{\$2}:2,31:0,31:0,31:10:$BASE_DIR/$ARCH_R_DIR"
)

for test in "${test_suite[@]}"; do
    # Step 1: Split the string by ":"
    IFS=':' read -r instr_set macro template range0 range1 range2 num_of_test output_dir <<< "$test"

    # Step 2: Store in an array
    params=("$macro($instr_set $template)" "$range0" "$range1" "$range2" "$num_of_test" "$output_dir")

    # Step 3: Call example_command with parameters
    gen_test() {
        ./singletest_generate.sh "${params[@]}"
    }

    read -a instructions <<< "$instr_set"
    for instr in "${instructions[@]}"; do
        params=("$macro($instr $template)" "$range0" "$range1" "$range2" "$num_of_test" "$output_dir/$instr.S")
        gen_test
    done
done
