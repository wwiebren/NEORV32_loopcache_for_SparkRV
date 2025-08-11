#### Template script for rtlstim2gate flow, generated from Joules(TM) RTL Power Solution, Version v22.13-s063_1 (Sep  6 2023 23:14:53)
if { [file exists /proc/cpuinfo] } {
    sh grep "model name" /proc/cpuinfo
    sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"

##############################################################################
## Preset global variables and attributes
##############################################################################
set DESIGN top
set SYN_EFF medium
set MAP_EFF low


# ::legacy::set_attribute init_lib_search_path {. ./lib} / 
# ::legacy::set_attribute script_search_path {. <path>} /
# ::legacy::set_attribute init_hdl_search_path {. ./rtl} /

set_db information_level 9
applet load report_histogram

###############################################################
## Library setup
###############################################################

# Placeholder for technology files


####################################################################
## Load Design
####################################################################

# CHANGE NEXT LINE FOR EACH EXPERIMENT:
cd ..
read_hdl -library neorv32 -language mixvlog -f file_list_synthesis_verilog.f
read_hdl -library neorv32 -language vhdl    -f file_list_synthesis_vhdl.f
cd joules_workspace


# Turn on TNS, affects global and incr opto (doesn't do much w/ global map)
set_db lp_insert_clock_gating true
set_db hdl_enable_real_support true


elaborate $DESIGN
check_design -unresolved


####################################################################
## tag a cell as memory 
####################################################################
# tag_memory -cell IN22FDX_*





# ################################################################################################
# ## read in stimulus file.
# ################################################################################################
read_stimulus -file ../waves.shm -dut_instance /:/neorv32_top_inst -frame_count 1000 -start 1015194ns -end 133952182ns
# -start 0us -end 300us
# read_stimulus -file <stimulus_file_name_2> -dut_instance <dut_instance_name> -append

# ################################################################################################
# ## write SDB.
# ################################################################################################
# write_sdb -out <sdb_file_name>

# ####################################################################
# ## constraints setup
# ####################################################################
set_units -time ps
read_sdc ../constraints_genus_22nm.sdc


################################################################################
# synthesize to gates
################################################################################

power_map -effort $MAP_EFF 

# Create the clock tree before computing power
create_clock_tree -force
# Verify the generated clock tree
report_clock_tree -summary

write_db -all -to_file $joulesWorkDir/proto.db
# read_stimulus -file <sdb_file_name>

################################################################################
# Finally power measurements
################################################################################

compute_power -mode average
set_db power_format %.5e
report_power -by_hier -levels all -unit W
# report_power -by_hier -levels all -out power.csv -csv -unit W

compute_power -mode time_based
write_power_profile -format shm -levels all -rtl_type hier -out power

# report_icgc_efficiency -out outputs/output_report_file -append
# puts "Final Runtime & Memory."
# timestat FINAL


quit