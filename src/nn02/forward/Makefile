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
	ghdl -a ../nn_pkg.vhdl ${F}.${VHDL} ${F}_tb.$(VHDL)
	make er F=${F}
single_layer:
	make clean
	ghdl -a ../nn_pkg.vhdl sigmoid.vhdl affine.vhdl single_layer.vhdl single_layer_tb.vhdl
	make er F=single_layer
softmax:
	make clean
	ghdl -a ../nn_pkg.vhdl min.vhdl softmax.vhdl softmax_tb.vhdl
	make er F=softmax
two_layer:
	make clean
	ghdl -a ../nn_pkg.vhdl affine.vhdl sigmoid.vhdl softmax_with_loss.vhdl umax.vhdl two_layer.vhdl
	make er F=two_layer
