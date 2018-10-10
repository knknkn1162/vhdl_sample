F=dummy
VHDL=vhdl

clean:
	rm -f work-obj93.cf *.o *.vcd
open:
	open out.vcd

er:
	make e
	make r
e:
	ghdl -e ${F}_tb
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
full_adder:
	make all F=full_adder
full_adder_using_ha:
	make clean
	ghdl -a half_adder.vhdl full_adder_using_ha.vhdl full_adder_tb.vhdl
	make er F=full_adder
adder:
	make all F=adder
ripple_carry_adder:
	make clean
	ghdl -a full_adder.vhdl adder.vhdl adder_tb.vhdl
	make er F=adder
