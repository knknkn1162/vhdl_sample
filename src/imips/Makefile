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
imips:
	make clean
	ghdl -a alu.vhdl mux2.vhdl flopr.vhdl imem.vhdl sgnext.vhdl regfile.vhdl dmem.vhdl slt2.vhdl imips.vhdl imips_tb.vhdl
	make er F=imips
