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
sigmoidal:
	make clean
	ghdl -a nn_pkg.vhdl sigmoidal.vhdl sigmoidal_tb.vhdl
	make er F=sigmoidal
dot:
	make clean
	ghdl -a nn_pkg.vhdl dot.vhdl dot_tb.vhdl
	make er F=dot
nn:
	make clean
	ghdl -a nn_pkg.vhdl dot.vhdl sigmoidal.vhdl nn.vhdl
	make er F=nn

