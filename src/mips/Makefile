F=dummy
VHDL=vhdl

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
mips: memrw decode regrw calc memadr controller
	ghdl -a mips.vhdl mips_tb.vhdl
	make er F=mips
controller:
	ghdl -a controller.vhdl
memrw: mem
	make all F=memrw
decode: flopr_en
	make all F=decode
regrw: regfile sgnext mux2
	make all F=regrw
calc: flopr_en alu mux2
	make all F=calc
memadr: flopr_en mux2
	make all F=memadr
flopr:
	make all F=flopr
flopr_en:
	make all F=flopr_en
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
