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
pc_and:
	make clean
	ghdl -a perceptron_type.vhdl perceptron_and.vhdl perceptron_and_tb.vhdl
	make er F=perceptron_and
pc_nand:
	make clean
	ghdl -a perceptron_type.vhdl perceptron_nand.vhdl perceptron_nand_tb.vhdl
	make er F=perceptron_and
pc_nor:
	make clean
	ghdl -a perceptron_type.vhdl perceptron_nor.vhdl perceptron_nor_tb.vhdl
	make er F=perceptron_nor
weight:
	make clean
	ghdl -a weight_pkg.vhdl weight.vhdl weight_tb.vhdl
	make er F=weight
relu:
	make clean
	ghdl -a relu.vhdl relu_tb.vhdl
	make er F=relu
relu_n:
	make clean
	ghdl -a weight_pkg.vhdl relu.vhdl relu_n.vhdl relu_n_tb.vhdl
	make er F=relu_n
nn3:
	make clean
	ghdl -a weight_pkg.vhdl relu.vhdl relu_n.vhdl weight.vhdl nn3.vhdl nn3_tb.vhdl
	make er F=nn3
sigmoidal:
	make clean
	ghdl -a nn_pkg.vhdl sigmoidal.vhdl sigmoidal_tb.vhdl
	make er F=sigmoidal
dot:
	make clean
	ghdl -a nn_pkg.vhdl dot.vhdl dot_tb.vhdl
	make er F=dot
nn_ex:
	make clean
	ghdl -a nn_pkg.vhdl nn_const_pkg.vhdl weightmult.vhdl sigmoidal.vhdl nn_ex.vhdl
	make er F=nn_ex

