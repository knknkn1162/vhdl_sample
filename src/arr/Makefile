F=dummy
VHDL=vhdl

clean:
	rm -f work-obj93.cf *.o *.vcd
open:
	open out.vcd

er:
	ghdl -e ${F}_tb
	ghdl -r ${F}_tb --vcd=out.vcd
a:
	make clean
	ghdl -a ${F}.${VHDL}
all:
	make a
	ghdl -a ${F}_tb.$(VHDL)
	ghdl -r ${F}_tb --vcd=out.vcd
pc_add:
	make clean
	ghdl -a perceptron_type.vhdl perceptron_and.vhdl perceptron_and_tb.vhdl
	make er F=perceptron_and
