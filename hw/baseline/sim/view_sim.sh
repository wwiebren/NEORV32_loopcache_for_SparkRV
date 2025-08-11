echo "Loading Module Xcelium"
echo "Module is:: $MODULEPATH"
#export MODULEPATH=/path/to/modulefiles:$MODULEPATH
module load cadence/xcelium/23.03.007

echo "Viewing waves database"
simvision -64BIT waves.shm

#work: Name of the working lib that will be used instead of default worklib nested in xcelium.d
#f: file list of all the rtl codes in order of execution
#top: name of top module . with the name of the working lib
#-v93: support features of VHDL 93
#timescale: timescale of all the verilog modules in the design

echo "UnLoading Module Xcelium"
module unload cadence/xcelium/23.03.00