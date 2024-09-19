ARCH ?= rv32i
INSTR ?= addi

RISCV_PREFIX   ?= riscv32-unknown-elf-
RISCV_GCC      ?= $(RISCV_PREFIX)gcc
RISCV_OBJDUMP  ?= $(RISCV_PREFIX)objdump
RISCV_OBJCOPY  ?= $(RISCV_PREFIX)objcopy
RISCV_READELF  ?= $(RISCV_PREFIX)readelf
RISCV_GCC_OPTS ?= -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -Tlink.ld

BUILD_DIR := build
INC_FLAGS := -I common

ARCH_DIR := arch
INSTRUCTION_TEST := $(INSTR)

clean:
	-rm -r $(BUILD_DIR)

build_single:
	-mkdir $(BUILD_DIR)
	$(RISCV_GCC) $(RISCV_GCC_OPTS) $(INC_FLAGS) -o $(BUILD_DIR)/$(INSTRUCTION_TEST).elf $(ARCH_DIR)/$(ARCH)/$(INSTRUCTION_TEST).S
	$(RISCV_OBJDUMP) -D $(BUILD_DIR)/$(INSTRUCTION_TEST).elf > $(BUILD_DIR)/$(INSTRUCTION_TEST).objdump
	$(RISCV_READELF) -a $(BUILD_DIR)/$(INSTRUCTION_TEST).elf > $(BUILD_DIR)/$(INSTRUCTION_TEST).readelf
	$(RISCV_OBJCOPY) -O binary $(BUILD_DIR)/$(INSTRUCTION_TEST).elf $(BUILD_DIR)/$(INSTRUCTION_TEST).bin
	srec_cat $(BUILD_DIR)/$(INSTRUCTION_TEST).bin -binary -offset 0x0000 -byte-swap 4 -o $(BUILD_DIR)/$(INSTRUCTION_TEST).vmem -vmem 32 --output_block_size 4 -data_only

	@echo ""
	@echo "Test files generated in folder build/"

.PHONY: clean build_single