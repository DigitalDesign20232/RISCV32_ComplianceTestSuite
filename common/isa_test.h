#ifndef ISA_TEST_H
#define ISA_TEST_H

#define TEST_I_TYPE(instruction, rd, rs1, imm, reg_mem_addr) \
    instruction rd, rs1, imm; \
    sw rd, 0(reg_mem_addr); \
    addi reg_mem_addr, reg_mem_addr, 4;

#define TEST_R_TYPE(instruction, rd, rs1, rs2, reg_mem_addr) \
    instruction rd, rs1, rs2; \
    sw rd, 0(reg_mem_addr); \
    addi reg_mem_addr, reg_mem_addr, 4;

#endif
