F=dummy
VHDL=vhdl

clean:
	rm -f work-obj93.cf *.o *.vcd
open:
	open out.vcd
r:
	ghdl -r ${F}_tb --vcd=out.vcd
a:
	make clean
	ghdl -a ${F}.${VHDL}
all:
	make a
	ghdl -a ${F}_tb.$(VHDL)
	ghdl -e ${F}_tb
	ghdl -r ${F}_tb --vcd=out.vcd
half_adder:
	make all F=half_adder
