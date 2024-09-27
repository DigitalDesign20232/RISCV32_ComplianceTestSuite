SHELL := bash

ARCH ?= rv32i
INSTR ?= addi


RED = \033[31m
GREEN = \033[32m
YELLOW = \033[33m
RESET = \033[0m

RISCV_PREFIX   ?= riscv32-unknown-elf-
RISCV_GCC      ?= $(RISCV_PREFIX)gcc
RISCV_OBJDUMP  ?= $(RISCV_PREFIX)objdump
RISCV_OBJCOPY  ?= $(RISCV_PREFIX)objcopy
RISCV_READELF  ?= $(RISCV_PREFIX)readelf
RISCV_GCC_OPTS ?= -O0 -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -Tlink.ld

BUILD_DIR := build
INC_FLAGS := -I common

ARCH_DIR := arch
INSTRUCTION_TEST := $(INSTR)

# Find all .S files recursively
ASM_FILES := $(shell find ./arch/ -name "*.S")

# Create corresponding object files by replacing .S with .vmem
OBJ_FILES := $(ASM_FILES:.S=.vmem)

# Default target: build all object files
all:
	@echo -e "\n$(YELLOW)[MAKE] Creating directory: $(CURDIR)/$(BUILD_DIR)/...$(RESET)"
	-mkdir -p $(BUILD_DIR)
	@echo -e "\n$(YELLOW)[MAKE] Building testsuite...$(RESET)"
	@echo -e "\n$(GREEN)Generating <instruction>.elf/.objdump/.readelf/.bin/.vmem...$(RESET)"
	@$(MAKE) build && ([ $$? -eq 0 ] && echo -e "$(GREEN)Test files generated in $(CURDIR)/$(BUILD_DIR)/$(RESET)") || echo -e "$(RED)Building error: Compilation failed!$(RESET)"

build: $(OBJ_FILES)

# Rule to compile .S files into .o files
%.vmem: %.S
	@echo -e "$(GREEN) +) Compiling $<...$(RESET)"
	@$(RISCV_GCC) $(RISCV_GCC_OPTS) $(INC_FLAGS) -o $(BUILD_DIR)/$(basename $(notdir $<)).elf $<
	@$(RISCV_OBJDUMP) -D $(BUILD_DIR)/$(basename $(notdir $<)).elf > $(BUILD_DIR)/$(basename $(notdir $<)).objdump
	@$(RISCV_READELF) -a $(BUILD_DIR)/$(basename $(notdir $<)).elf > $(BUILD_DIR)/$(basename $(notdir $<)).readelf
	@$(RISCV_OBJCOPY) -O binary $(BUILD_DIR)/$(basename $(notdir $<)).elf $(BUILD_DIR)/$(basename $(notdir $<)).bin
	@srec_cat $(BUILD_DIR)/$(basename $(notdir $<)).bin -binary -offset 0x0000 -byte-swap 4 -o $(BUILD_DIR)/$(basename $(notdir $<)).vmem -vmem 32 --output_block_size 4 -data_only

build_single:
	-mkdir $(BUILD_DIR)
	$(RISCV_GCC) $(RISCV_GCC_OPTS) $(INC_FLAGS) -o $(BUILD_DIR)/$(INSTRUCTION_TEST).elf $(ARCH_DIR)/$(ARCH)/$(INSTRUCTION_TEST).S
	$(RISCV_OBJDUMP) -D $(BUILD_DIR)/$(INSTRUCTION_TEST).elf > $(BUILD_DIR)/$(INSTRUCTION_TEST).objdump
	$(RISCV_READELF) -a $(BUILD_DIR)/$(INSTRUCTION_TEST).elf > $(BUILD_DIR)/$(INSTRUCTION_TEST).readelf
	$(RISCV_OBJCOPY) -O binary $(BUILD_DIR)/$(INSTRUCTION_TEST).elf $(BUILD_DIR)/$(INSTRUCTION_TEST).bin
	srec_cat $(BUILD_DIR)/$(INSTRUCTION_TEST).bin -binary -offset 0x0000 -byte-swap 4 -o $(BUILD_DIR)/$(INSTRUCTION_TEST).vmem -vmem 32 --output_block_size 4 -data_only

	@echo "".data so they don’t collide during execution.
Memory Size: Adjust the RAM size (LENGTH) in the MEMORY block as per your actual hardware to ensure that the sections fit within the available memory.
	@echo "Test files generated in folder build/"

gen_test:
	$(MAKE) -C tools/ all

clean:
	@echo -e "\n$(YELLOW)[MAKE] Cleaning directory: $(CURDIR)/$(BUILD_DIR)/...$(RESET)"
	-rm -rf $(BUILD_DIR)

help:
	@echo -e "$(GREEN)Opening help page...$(RESET)"
	@echo -e ""
	@echo -e "\t1. Generate test: $(YELLOW)make gen_test$(RESET)"
	@echo -e "\t2. Build all test: $(YELLOW)make clean all$(RESET)"
	@echo -e "\t3. To build a particular test: $(YELLOW)make clean build_single ARCH=<arch> INSTR=<instruction>$(RESET)"
	@echo -e "\nList of value for $(GREEN)<arch>$(RESET):"
	@echo -e "\trv32i"
	@echo -e "\nList of value for $(GREEN)<instr>$(RESET): See the filename generated by $(YELLOW)make gen_test$(RESET)"
	@echo -e "E.g. If the filename is addi.S, so <instr> can be \"addi\""

.PHONY: clean all build gen_test build_single
