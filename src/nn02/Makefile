F=dummy
VHDL=vhdl

clean:
	rm -f work-obj93.cf *.o *.vcd
open:
	open out.vcd

er:
	ghdl -e ${F}_tb
	ghdl -r ${F}_tb --vcd=out.vcd

all:
	make clean
	ghdl -a nn_pkg.vhdl ${F}.${VHDL} ${F}_tb.$(VHDL)
	make er F=${F}

