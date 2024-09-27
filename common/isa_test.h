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

#define TEST_I_TYPE_LOAD(instruction, rd, rs1, imm, reg_mem_addr) \
    instruction rd, imm(rs1); \
    sw rd, 0(reg_mem_addr); \
    addi reg_mem_addr, reg_mem_addr, 4;

#define TEST_S_TYPE(instruction, rs1, rs2, imm, reg_mem_addr) \
    instruction rs2, imm(rs1); \
    lw rs2, imm(rs1); \
    sw rs2, 0(reg_mem_addr); \
    addi reg_mem_addr, reg_mem_addr, 4;

#endif
