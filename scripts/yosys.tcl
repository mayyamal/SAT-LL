# adjust
set DIR_AES /home/majmal01/repos/SAT-LL/benchmarks/aes
set DIR_ARIANE /home/majmal01/repos/SAT-LL/benchmarks/ariane

# adjust the module and the directory
set MODULE aes_sbox
#set MODULE alu
set DIR_MODULE_ORIG ${DIR_ARIANE}/1_rtl_orig
set DIR_MODULE_SYNTH ${DIR_ARIANE}/2_assign_orig/yosys


######################## FRONTEND ########################
# NOTE (ariane): yosys does not accept many .sv constructs, thus the original include packages are put in this file:
#yosys read_verilog -sv ${DIR_MODULE_ORIG}/ariane_all_includes.sv

# NOTE (arine): when reading. sv files add `- sv` option
#yosys read_verilog -sv ${DIR_MODULE_ORIG}/${MODULE}.sv
# NOTE: Remove the package import  when synthesizing with Yosys
yosys read_verilog  ${DIR_MODULE_ORIG}/${MODULE}.v



######################## PASSES ########################
yosys hierarchy -check -top ${MODULE}
#yosys proc; yosys opt; yosys fsm; yosys opt; yosys memory; yosys opt

yosys synth

# NOTE: techmap: mapping to internal cell library. Map coarse-grain RTL cells (adders, etc.) to fine-grain logic gates (AND, OR, NOT, etc.).
# yosys techmap
# yosys opt
# NOTE: show command gives a graphic representation
# yosys show

# NOTE: dfflibmap: mapping flip-flops to mycells.lib
# yosys dfflibmap -liberty /home/majmal01/repos/yosys/majaslibs/mycells.lib
# NOTE: abc: mapping logic to mycells.lib
# yosys abc -liberty /home/majmal01/repos/yosys/majaslibs/mycells.lib

# NOTE: diffmap and abc create .blif with .subckt
# NOTE: synth and techmap alone don't, they create the .blif with .names

#yosys flatten

yosys clean -purge


######################## BACKEND ########################
yosys write_verilog ${DIR_MODULE_SYNTH}/${MODULE}.v
