F=dummy
VHDL=vhdl
MEM=dummy

clean:
	rm -f work-obj93.cf *.o *.vcd
open:
	open out.vcd
e:
	ghdl -e ${F}_tb
r:
	ghdl -r ${F}_tb --vcd=out.vcd
a:
	make clean
	ghdl -a ${F}.${VHDL}
er:
	make e
	make r
all:
	ghdl -a $(F).${VHDL} ${F}_tb.$(VHDL)
	ghdl -e ${F}_tb
	ghdl -r ${F}_tb --vcd=out.vcd
mips_all : forwarding_addi_add forwarding_add_add stall_lw_add
mips: datapath controller mip
	ghdl -a ./tests/mips_${F}_tb.vhdl
	make er F=mips_${F}
mip: 
	ghdl -a mips.vhdl
forwarding_addi_add:
	make mips F=forwarding_addi_add
forwarding_add_add:
	make mips F=forwarding_add_add
stall_lw_add:
	make mips F=stall_lw_add
datapath: memrw decode regrw calc memadr
	make all F=datapath
controller: instr_shift_register
	ghdl -a controller_pkg.vhdl controller.vhdl
memrw: mem
	make all F=memrw
decode: flopr_en
	make all F=decode
regrw: reg sgnext mux2 shift_register2
	make all F=regrw
calc: flopr_en alu mux2 slt2
	make all F=calc
memadr: flopr_en mux4
	make all F=memadr
instr_shift_register: flopr_en
	make all F=instr_shift_register
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
