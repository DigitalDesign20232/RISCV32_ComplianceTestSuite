# TEST SUITE GENERATOR 

## **1. Quick Start**

- Run command `make clean all` to generate full assembly test

## **2. Configure Test**

- Modify the `test_suite` variable in [testsuite_generate.sh](testsuite_generate.sh)
- Format for each `test` of `test_suite`: 
    `"<instr_set>:<macro>:<template>:<range0>:<range1>:<range2>:<num_of_tests>:<output_dir>"`
    - `<instr_set>`: Set of instruction, seperated by whitespace (e.g. "add sub and or xor")
    - `<macro>`: Macro name to wrap around the test. The macro should be define in [../common/isa_test.h](../common/isa_test.h) (e.g. "TEST_R_TYPE")
    - `<template>`: The template to pass to macro (e.g. for macro "ADD(x1, x2)" the template should be "x{$0}, x{$1}")
    - `<range0>`: The range value for integer $0 (e.g. "0,31" means $0 will be replace by random value from 0 to 31)
    - `<range1>`, `<range2>`: Same as `<range0>`, not mandatorily appear in `<template>` but must be provided
    - `<num_of_tests>`: The number of tests to generate for each `test` (e.g. 512)
    - `<output_dir>`: The directory to contain the generated tests. This directory must exist (e.g. ../arch/rv32r)
