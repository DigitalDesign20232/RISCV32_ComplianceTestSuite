#!/bin/bash
BASE_DIR="../arch"
ARCH_I_DIR="rv32i"
ARCH_R_DIR="rv32r"
ARCH_I_LOAD_DIR="rv32i"

NUM_OF_TEST_I=3584
NUM_OF_TEST_R=3584
# Given "test_suite" = array of "test"
# Format of "test": "<list of instruction>:<macro>:<template contain placeholder {$0}, {$1}, {$2}>:<range of $0>:<range of $1>:<range of $2>:<number of tests>:<output directory>"
test_suite=(
    "addi xori ori andi:TEST_I_TYPE:x{\$0}, x{\$1}, {\$2}, x1:2,31:0,31:-2048,2047:$NUM_OF_TEST_I:$BASE_DIR/$ARCH_I_DIR"
    "slli srli srai slti sltiu:TEST_I_TYPE:x{\$0}, x{\$1}, {\$2}, x1:2,31:0,31:0,31:$NUM_OF_TEST_I:$BASE_DIR/$ARCH_I_DIR"
    "add sub xor or and sll srl sra slt sltu:TEST_R_TYPE:x{\$0}, x{\$1}, x{\$2}, x1:2,31:0,31:0,31:$NUM_OF_TEST_R:$BASE_DIR/$ARCH_R_DIR"
    "lb lh lw lbu lhu:TEST_I_TYPE_LOAD:x{\$0}, x{\$1}, {\$2}, x1:2,31:0,31:-2048,2047:$NUM_OF_TEST_I:$BASE_DIR/$ARCH_I_LOAD_DIR"
)

for test in "${test_suite[@]}"; do
    # Step 1: Split the string by ":"
    IFS=':' read -r instr_set macro template range0 range1 range2 num_of_test output_dir <<< "$test"
    mkdir -p $output_dir

    # Step 2: Store in an array
    params=("$macro($instr_set $template)" "$range0" "$range1" "$range2" "$num_of_test" "$output_dir")

    # Step 3: Call example_command with parameters
    gen_test() {
        ./singletest_generate.sh "${params[@]}"
    }

    read -a instructions <<< "$instr_set"
    for instr in "${instructions[@]}"; do
        params=("$macro($instr, $template)" "$range0" "$range1" "$range2" "$num_of_test" "$output_dir/$instr.S")
        gen_test
    done
done
