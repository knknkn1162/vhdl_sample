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
mips : datapath controller
	ghdl -a mips.vhdl mips_${MEM}_tb.vhdl
	make er F=mips_${MEM}
forwarding_addi_add : datapath controller
	ghdl -a mips.vhdl mips_forwarding_addi_add_tb.vhdl
	make er F=mips_forwarding_addi_add

datapath: memrw decode regrw calc memadr
	make all F=datapath
controller: instr_shift_register
	ghdl -a controller_pkg.vhdl controller.vhdl
memrw: mem
	make all F=memrw
decode: flopr_en
	make all F=decode
regrw: regfile sgnext mux2
	make all F=regrw
calc: flopr_en alu mux2 slt2
	make all F=calc
memadr: flopr_en mux4
	make all F=memadr
instr_shift_register: flopr_en
	make all F=instr_shift_register
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
mem:
	make all F=mem
regfile:
	make all F=regfile
