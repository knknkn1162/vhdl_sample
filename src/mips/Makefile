F=dummy
VHDL=vhdl
MEM=dummy
TESTBENCHES="lw_addi add_add addi_add forwarding_addi_add forwarding_add_add sw_lw stall_lw_add stall_lw_addi"

clean:
	rm -f work-obj93.cf *.o *.vcd
open:
	open out.vcd
e:
	ghdl -e ${F}_tb
r:
	ghdl -r ${F}_tb --vcd=out.vcd
a:
	ghdl -a ${F}.${VHDL}
er:
	make e
	make r
all:
	ghdl -a $(F).${VHDL} ${F}_tb.$(VHDL)
	ghdl -e ${F}_tb
	ghdl -r ${F}_tb --vcd=out.vcd
mips_all: mips
	echo ${TESTBENCHES} | xargs -n1 -ITB ghdl -a ./tests/mips_TB_tb.vhdl
	echo ${TESTBENCHES} | xargs -n1 -ITB make er F=mips_TB
mips_tb: mips
	ghdl -a ./tests/mips_${F}_tb.vhdl
	make er F=mips_${F}
mips: datapath controller debug_pkg
	ghdl -a mips.vhdl
forwarding_addi_add:
	make mips_tb F=forwarding_addi_add
add_add:
	make mips_tb F=add_add
addi_add:
	make mips_tb F=addi_add
lw_addi:
	make mips_tb F=lw_addi
forwarding_add_add:
	make mips_tb F=forwarding_add_add
sw_lw:
	make mips_tb F=sw_lw
stall_lw_add:
	make mips_tb F=stall_lw_add
stall_lw_addi:
	make mips_tb F=stall_lw_addi
datapath: memrw decode regrw2 calc memadr
	ghdl -a datapath.vhdl
controller: instr_shift_register controller_pkg debug_pkg mux2 regw_cache
	ghdl -a controller.vhdl
debug_pkg: state_pkg
	ghdl -a debug_pkg.vhdl
controller_pkg: state_pkg
	ghdl -a controller_pkg.vhdl
state_pkg:
	ghdl -a state_pkg.vhdl
memrw: mem shift_register2
	make all F=memrw
decode: flopr_en
	make all F=decode
regrw: reg sgnext mux2 flopr_en mux4
	make all F=regrw
regrw2: reg sgnext
	make all F=regrw2
regw_cache: shift_register2_load
	make all F=regw_cache
calc: flopr_en alu mux2 slt2
	make all F=calc
memadr: flopr_en mux4
	make all F=memadr
instr_shift_register: shift_register2
	make all F=instr_shift_register
shift_register2_load: flopr_en mux2
	make all F=shift_register2_load
shift_register2: flopr_en
	make all F=shift_register2
flopr:
	make all F=flopr
flopr_en:
	make all F=flopr_en
slt2:
	make all F=slt2
sltn:
	make all F=sltn
alu:
	make all F=alu
mux2:
	make all F=mux2
mux4:
	make all F=mux4
sgnext:
	make all F=sgnext
mem: tools_pkg
	make all F=mem
reg: tools_pkg
	make all F=reg
	ghdl -a reg_sample_tb.vhdl
	make er F=reg_sample
tools_pkg:
	ghdl -a tools_pkg.vhdl
