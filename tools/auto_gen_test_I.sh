#!/bin/bash

instr_list=("addi" "xori" "ori" "andi" "slli" "srli" "srai" "slti" "sltiu")
test_dir="generated/auto_gen_test_I"
range0="2,31"
range1="0,31"
range2="-2048,2047"
command_count="512"

mkdir -p $test_dir/

gen_test() {
    local instr=$1
    cat header.txt > $test_dir/$instr.S
    ./auto_gen_test.sh "$instr x{\$0}, x{\$1}, {\$2}" $range0 $range1 $range2 $command_count $test_dir/$instr.S
}

for item in "${instr_list[@]}"; do
    echo "Generating test for instruction: $item..."
    gen_test "$item"
    echo ""
    echo ""
done

