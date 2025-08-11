#Additional flags for seting up the original MAKE file

# Override the default CPU ISA (M & Floating-Point Extension also enabled)
MARCH = rv32im_zicsr_zifencei_zfinx #rv32im_zicsr_zifencei 

# Override the default RISC-V GCC prefix
#RISCV_PREFIX ?= riscv32-unknown-elf-

# Override default optimization goal
EFFORT = -Os

# Add extended debug symbols
USER_FLAGS += -ggdb -gdwarf-3

# Adjust processor IMEM size
USER_FLAGS += -Wl,--defsym,__neorv32_rom_size=32K

# Adjust processor DMEM size
USER_FLAGS += -Wl,--defsym,__neorv32_ram_size=1K

# Adjust maximum heap size
#USER_FLAGS += -Wl,--defsym,__neorv32_heap_size=1K

# Generate MAP file for layout
USER_FLAGS += -Wl,-Map=output.map

# Sim mode for UART0 (use XBUS)
#USER_FLAGS+=-DUART0_SIM_MODE

# Additional sources
#APP_SRC += $(wildcard ./*.c)
#APP_INC += -I .

# Modify this variable to fit your NEORV32 setup (neorv32 home folder)
NEORV32_HOME ?= ../../..

include $(NEORV32_HOME)/sw/common/common.mk
