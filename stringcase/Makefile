###############################################################################
tb_files   := $(wildcard *tb.v)
src_files  := $(filter-out $(tb_files), $(wildcard *.v))
###############################################################################

simv: $(tb_files) $(src_files)
	vcs -sverilog $(tb_files) $(src_files)

dump.vcd : simv
	./simv

.PHONY: cleanall clean help source waves sim
.SILENT: help dummy

waves : dump.vcd
	gtkwave dump.vcd dump.gtkw &
sim : dump.vcd

clean: 
	rm -rf simv*
	rm -rf csrc ucli.key
	rm -rf prj.prj rev_1/ stdout.log  synlog.tcl

cleanall: clean
	rm -rf dump*

help:
	echo "This makefile has the following options:"
	echo "  help:        print this message"
	echo "  sim:         simulate the testbench"
	echo "  waves:       simulate the testbench and open GTKWave"
	echo "  clean:       remove all temporary files"
	echo "  cleanall:    remove all generated files, including .bit, .xsvf and dump* files"


