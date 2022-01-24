###NOTE: run the script with the command: dc_shell -f dc.tcl

# adjust the module names
#set topLevel aes_sbox
set topLevel alu


# set std cell library
set target_lib_path "/opt/synopsys/syn/Q-2019.12-SP5-1/libraries/syn/gtech.db"
set symbol_lib_path "/opt/synopsys/syn/Q-2019.12-SP5-1/libraries/syn/generic.slib"


set wireload_library [ ]
set target_library [ concat $wireload_library $target_lib_path ]
set symbol_library [ list $symbol_lib_path ]
set synthetic_library [ list standard.sldb dw_foundation.sldb ]
set link_library [ concat "*" $target_library $synthetic_library ]


set reports_path "./dc/reports/"
file mkdir ${reports_path}

define_design_lib WORK -path /WORK

# adjust the path
# read, analyze, elaborate RTL code
# AES
#analyze -autoread -format verilog /home/majmal01/repos/SAT-LL/benchmarks/aes/1_rtl_orig/aes_sbox.v

# Ariane
analyze -autoread -format sverilog /home/majmal01/repos/SAT-LL/benchmarks/ariane/1_rtl_orig/riscv_pkg.sv
analyze -autoread -format sverilog /home/majmal01/repos/SAT-LL/benchmarks/ariane/1_rtl_orig/ariane_pkg.sv
analyze -autoread -format sverilog /home/majmal01/repos/SAT-LL/benchmarks/ariane/1_rtl_orig/alu.sv


elaborate $topLevel -architecture verilog -library WORK
current_design $topLevel


set period 5.00
set clock_name "clk_i"
set reset_name "rst_ni"

create_clock -name ${clock_name} -period $period
# other constraints can be provided here


# check dependencies, perform synthesis
link
check_design
# compile_ultra for more precise synthesis
compile -exact_map -ungroup_all

# store result in verilog assignment format
define_name_rules verilog -preserve_struct_ports
set verilogout_equation true

# adjust the path
#set output_dir "/home/majmal01/repos/SAT-LL/benchmarks/aes/2_assign_orig/dc"
set output_dir "/home/majmal01/repos/SAT-LL/benchmarks/ariane/2_assign_orig/dc"
write_file -hierarchy -f verilog -o ${output_dir}/${topLevel}.v

# additional report generation here, report_area, report_timing, report_power
write_sdc -nosplit ${reports_path}/${topLevel}.sdc
report_area -hierarchy > ${reports_path}/${topLevel}.area
report_timing -significant_digits 4 > ${reports_path}/${topLevel}.timing
report_power > ${reports_path}/${topLevel}.power


exit
