#!/usr/bin/env bash

# Generate file-list files for the CPU and the entire processor/SoC
# using GHDL's elaborate option.

set -e
cd $(dirname "$0")

# top entities
CPU_TOP=neorv32_cpu
SOC_TOP=top

# file-list files
CPU_SIM_LIST=file_list_cpu_simulation.f
SOC_SIM_LIST=file_list_soc_simulation.f
CPU_SYN_LIST=file_list_cpu_synthesis.f
SOC_SYN_LIST=file_list_soc_synthesis.f

# rtl path placeholder
PLACEHOLDER="NEORV32_RTL_PATH_PLACEHOLDER"

#----------------- ------------------simulation file list ---------------------------------- #
# temporary GHDL project
mkdir -p ~build
ghdl -i --work=neorv32 --workdir=~build *.vhd core/*.vhd core/SRAM_simulation/*.vhd

# CPU core only
echo "Regenerating $CPU_SIM_LIST ..."
ghdl --elab-order --work=neorv32 --workdir=~build $CPU_TOP > ~$CPU_SIM_LIST
while IFS= read -r line; do
  echo "$PLACEHOLDER/$line"
done < ~$CPU_SIM_LIST > $CPU_SIM_LIST

# manualy add verilog modules
{ echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_simulation/IN22FDX_S1DU_NFUG_W08192B032M08C256.v"; \
  echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_simulation/MBH_MSNL_IN22FDX_S1DU_NFUG_W08192B032M08C256.v"; \
  echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_simulation/MBH_ZSNL_IN22FDX_S1DU_NFUG_W08192B032M08C256.v"; \
  echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_simulation/SRAM_SP_32b_8192w.v"; \
  cat $CPU_SIM_LIST; } > ~$CPU_SIM_LIST && mv ~$CPU_SIM_LIST $CPU_SIM_LIST

# full processor/SoC
echo "Regenerating $SOC_SIM_LIST ..."
ghdl --elab-order --work=neorv32 --workdir=~build $SOC_TOP > ~$SOC_SIM_LIST
while IFS= read -r line; do
  echo "$PLACEHOLDER/$line"
done < ~$SOC_SIM_LIST > $SOC_SIM_LIST

# manualy add verilog modules
{ echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_simulation/IN22FDX_S1DU_NFUG_W08192B032M08C256.v"; \
  echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_simulation/MBH_MSNL_IN22FDX_S1DU_NFUG_W08192B032M08C256.v"; \
  echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_simulation/MBH_ZSNL_IN22FDX_S1DU_NFUG_W08192B032M08C256.v"; \
  echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_simulation/SRAM_SP_32b_8192w.v"; \
  cat $SOC_SIM_LIST; } > ~$SOC_SIM_LIST && mv ~$SOC_SIM_LIST $SOC_SIM_LIST

# clean-up temporaries
rm -rf ~build ~$CPU_SIM_LIST ~$SOC_SIM_LIST

#----------------- ------------------synthesis file list ---------------------------------- #
# temporary GHDL project
mkdir -p ~build
ghdl -i --work=neorv32 --workdir=~build *.vhd core/*.vhd core/SRAM_synthesis/*.vhd

# CPU core only
echo "Regenerating $CPU_SYN_LIST ..."
ghdl --elab-order --work=neorv32 --workdir=~build $CPU_TOP > ~$CPU_SYN_LIST
while IFS= read -r line; do
  echo "$PLACEHOLDER/$line"
done < ~$CPU_SYN_LIST > $CPU_SYN_LIST

# manualy add verilog modules
{ echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_synthesis/IN22FDX_S1DU_NFUG_W08192B032M08C256.v"; \
  echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_synthesis/MBH_MSNL_IN22FDX_S1DU_NFUG_W08192B032M08C256.v"; \
  echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_synthesis/MBH_ZSNL_IN22FDX_S1DU_NFUG_W08192B032M08C256.v"; \
  echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_synthesis/SRAM_SP_32b_8192w.v"; \
  cat $CPU_SYN_LIST; } > ~$CPU_SYN_LIST && mv ~$CPU_SYN_LIST $CPU_SYN_LIST

# full processor/SoC
echo "Regenerating $SOC_SYN_LIST ..."
ghdl --elab-order --work=neorv32 --workdir=~build $SOC_TOP > ~$SOC_SYN_LIST
while IFS= read -r line; do
  echo "$PLACEHOLDER/$line"
done < ~$SOC_SYN_LIST > $SOC_SYN_LIST

# manualy add verilog modules
{ echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_synthesis/IN22FDX_S1DU_NFUG_W08192B032M08C256.v"; \
  echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_synthesis/MBH_MSNL_IN22FDX_S1DU_NFUG_W08192B032M08C256.v"; \
  echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_synthesis/MBH_ZSNL_IN22FDX_S1DU_NFUG_W08192B032M08C256.v"; \
  echo "NEORV32_RTL_PATH_PLACEHOLDER/core/SRAM_synthesis/SRAM_SP_32b_8192w.v"; \
  cat $SOC_SYN_LIST; } > ~$SOC_SYN_LIST && mv ~$SOC_SYN_LIST $SOC_SYN_LIST

# clean-up temporaries
rm -rf ~build ~$CPU_SYN_LIST ~$SOC_SYN_LIST