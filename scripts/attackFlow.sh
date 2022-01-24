#!/bin/sh

# Adjust the following paths to the corresponding tools
DIR_SAT=$HOME/repos/mithril/20_RE/sat_attack_tool
DIR_SAT_BIN=${DIR_SAT}/bin
DIR_SAT_LL=${DIR_SAT}/source/src
DIR_PROP_RLL_BIN=$HOME/repos/lef/bin
DIR_YOSYS=$HOME/repos/yosys
DIR_RANE=$HOME/repos/RANE

# Adjust the following paths to the modules to be locked and unlocked
DIR_AES=${HOME}/repos/SAT-LL/benchmarks/aes
DIR_ARIANE=${HOME}/repos/SAT-LL/benchmarks/ariane
DIR_SCRIPTS=${HOME}/repos/SAT-LL/scripts

# Adjust DIR_AES or DIR_ARIANE
DIR_RTL_ORIG=${DIR_AES}/1_rtl_orig
DIR_ASSIGN_ORIG=${DIR_AES}/2_assign_orig/dc# yosys #dc
DIR_BENCH_ORIG=${DIR_AES}/3_bench_orig/dc #yosys #dc
DIR_BENCH_OBF=${DIR_AES}/4_bench_obf/dc #yosys #dc


# Use any of the modules in the benchmark folder or add other (combinational) modules
#MODULE=aes_sbox
MODULE=alu
# Pass the key-input size as an argument or the fraction (0.05, 0.1, 0.25, 0.5)
KEYS=$1

# *** Synth with Yosys ***
# Change the parameters in `yosys.tcl`
#${DIR_YOSYS}/yosys yosys.tcl

# *** Synth with DC ***
# Execute `dc.tcl`
# Change the folder paths above to `dc` subdirectories

# *** Convert original to blif ***
cd $DIR_YOSYS
./yosys -o ${DIR_BENCH_ORIG}/${MODULE}.blif -S /home/majmal01/repos/SAT-LL/benchmarks/ariane/2_assign_orig/dc/alu.v
#${DIR_ASSIGN_ORIG}/${MODULE}.v

# *** Convert original to bench ***
# NOTE: modify the paths in the `blif2bench_orig` file accordingly!
$DIR_YOSYS/yosys-abc -F ${DIR_SCRIPTS}/blif2bench_orig

# *** Some manual adjustmets, removing '[]' from bench files ***
# replace '[',']' with ''
sed -i 's/\[//g' ${DIR_BENCH_ORIG}/${MODULE}.bench
sed -i 's/\]//g' ${DIR_BENCH_ORIG}/${MODULE}.bench


# *** Lock with the SAT tool ***
cd $DIR_SAT_LL
# pass the key-input size as an argument
#./sle -r -k ${KEYS} -o ${DIR_BENCH_OBF}/${MODULE}.bench ${DIR_BENCH_ORIG}/${MODULE}.bench


# alternatively, pass the percentage of key-gates as an argument
# NOTE: for some reason, the locking with percentage works on more module, the locking with key size gives errors at times
./sle -i -f ${KEYS} -o ${DIR_BENCH_OBF}/${MODULE}.bench ${DIR_BENCH_ORIG}/${MODULE}.bench


# *** Unlock with the SAT Tool ***
./sld ${DIR_BENCH_OBF}/${MODULE}.bench ${DIR_BENCH_ORIG}/${MODULE}.bench | tee  ${DIR_BENCH_OBF}/statistics.txt


# *** Unlock with RANE ***
# Note: some manual modifications are needed to the signals. The SAT tool has changed the names of some OUTPUTS, so they do not match between the original and locked version. Make sure the I/O have the exact same names

#python3 ${DIR_RANE}/main_formal.py  -b ${DIR_BENCH_ORIG}/${MODULE}.bench -o ${DIR_BENCH_OBF}/.bench
