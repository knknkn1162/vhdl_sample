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
	ghdl -a ${F}.${VHDL} ${F}_tb.$(VHDL)
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
cla_block:
	make clean
	ghdl -a carry_lookahead_adder.vhdl cla_block_tb.vhdl
	make er F=cla_block
flopr1:
	ghdl -a flopr1.vhdl flopr1_tb.vhdl
floplrn: floplr1 floplrn floplrn_tb
	ghdl -a mux1.vhdl flopr1.vhdl floplr1.vhdl floplrn.vhdl floplrn_tb.vhdl
	make er F=floplrn
floplrn_scannable: floplr1 floplrn_scannable
	ghdl -a mux1.vhdl flopr1.vhdl floplr1.vhdl floplrn_scannable.vhdl floplrn_scannable_tb.vhdl
	make er F=floplrn
mult_dff1: flopr1
	ghdl -a flopr1.vhdl mult_dff1.vhdl mult_dff1_tb.vhdl
mult_dffn : mult_dff1
	ghdl -a mult_dffn.vhdl mult_dffn_tb.vhdl
mult_dffn_rev : mult_dff1
	ghdl -a mult_dffn_rev.vhdl mult_dffn_rev_tb.vhdl
div_dff1: flopr1
	ghdl -a div_dff1.vhdl div_dff1_tb.vhdl
div_dffn: div_dff1
	make all F=div_dffn
