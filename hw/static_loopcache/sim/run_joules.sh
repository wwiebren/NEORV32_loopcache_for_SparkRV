echo "Removing old files"
mkdir -p joules_workspace
rm -r joules_workspace/*
rm -r ._*

echo "Preparing file list"
SOC_LIST=../rtl/file_list_soc_synthesis.f

cp $SOC_LIST file_list.f

sed '1d; s/NEORV32_RTL_PATH_PLACEHOLDER/..\/rtl/g' file_list.f > file_list_synthesis_vhdl.f
sed '2,$d; s/NEORV32_RTL_PATH_PLACEHOLDER/..\/rtl/g' file_list.f > file_list_synthesis_verilog.f

module load cadence/joules/23.33
cd joules_workspace
joules -f ../joules_script.tcl
module unload cadence/joules/23.33