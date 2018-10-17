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
	make a
	ghdl -a ${F}_tb.$(VHDL)
	ghdl -e ${F}_tb
	ghdl -r ${F}_tb --vcd=out.vcd
mips:
	make clean
	ghdl -a alu.vhdl mux2.vhdl flopr.vhdl imem.vhdl sgnext.vhdl regfile.vhdl dmem.vhdl datapath.vhdl controller.vhdl mips.vhdl mips_tb.vhdl
	make er F=mips
