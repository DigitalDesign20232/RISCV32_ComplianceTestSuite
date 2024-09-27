# RISCV32 COMPLIANCE TEST SUITE

## 1. Quick Start

> Run `make help` to quickly get the guide

- Run command `make clean build_single ARCH=<arch> INSTR=<instruction>` to build the corresponding test
- Example: `make clean build_single ARCH=rv32i INSTR=addi` will build the test in ./arch/rv32i/addi.S
- To build all test in directory arch/, run `make clean all`

## 2. Test Suite Generator

- Change directory to [tools/](tools/), then follow the instruction in [README.md](tools/README.md)
