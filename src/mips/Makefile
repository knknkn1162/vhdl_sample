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
	ghdl -a $(F).${VHDL} ${F}_tb.$(VHDL)
	ghdl -e ${F}_tb
	ghdl -r ${F}_tb --vcd=out.vcd
mips: mem regfile flopr_en sltn alu mux2 sgnext
	ghdl -a mips.vhdl mips_tb.vhdl
	make er F=mips
fetch: mem mux2 flopr_en
	make all F=fetch
decode_writeback: regfile sgnext flopr_en
	make all F=decode_writeback
flopr:
	make all F=flopr
flopr_en:
	make all F=flopr_en
sltn:
	make all F=sltn
alu:
	make all F=alu
mux2:
	make all F=mux2
sgnext:
	make all F=sgnext
mem:
	make all F=mem
regfile:
	make all F=regfile
