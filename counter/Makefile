###############################################################################
#Auther: Chris Eerry (christnb@usc.edu)
#Date: October 6, 2013
#Description: This makefile contols the simulation, synthysis, and programing
#of a Nexys3 board with an Xilinx xc6slx16 FPGAa. Xilinx ISE 14.7 and FPGALink
#should be installed in the /opt dir for the paths listed here to work.


#----------------------------PROJECT FILES-------------------------------------
#This makefile will pickup all the *v files in this directory and create the
#appropriate project files for Xilinx synthysis and impact.  Any file named
#*top.v will be considered the top module for the design. Any file named *tb.v
#will be considered the testbemnch file for simulation.  The only restrictions
#are :
#	Only 1 *_top.v should be present
#	Only 1 *_tb.v should be present
###############################################################################
top_files	  := $(wildcard *top.v)
testbench_files	  := $(wildcard *tb.v)
simulation_files  := $(filter-out $(top_files), $(wildcard *.v))
synthysis_files	  := $(filter-out $(testbench_files), $(wildcard *.v))
top 		  := $(firstword $(basename $(top_files)))
###############################################################################

###############################################################################
p 		  := xc6slx16-3-csg324
project_files	  := nexys3.ucf project/${top}.xst project/${top}.prj
###############################################################################

dummy: 
	echo "\tNo default target, type 'make help' for list of options"

a.out: $(simulation_files)
	iverilog -o $@ $(simulation_files)

dump.vcd : a.out
	vvp a.out

project: Makefile
	mkdir -p project
	mkdir -p project/xstdir
	mkdir -p project/xstdir/projnav.tmp
	#Create synthysis file
	echo "set -tmpdir \"xstdir/projnav.tmp\"" > project/${top}.xst
	echo "set -xsthdpdir \"xstdir\"" >> project/${top}.xst
	echo "run" >> project/${top}.xst
	echo "-ifn ${top}.prj" >> project/${top}.xst
	echo "-ifmt mixed" >> project/${top}.xst
	echo "-ofn ${top}" >> project/${top}.xst
	echo "-ofmt NGC" >> project/${top}.xst
	echo "-p ${p}" >> project/${top}.xst
	echo "-top ${top}" >> project/${top}.xst
	echo "-opt_mode Speed" >> project/${top}.xst
	echo "-opt_level 1" >> project/${top}.xst
	#Create project file
	echo "verilog work ../${word 1, $(synthysis_files)}" > project/${top}.prj
	echo "verilog work ../${word 2, $(synthysis_files)}" >> project/${top}.prj
	#Create impact command file
	echo "setMode -bs" > project/impact.cmd
	echo "setCable -port xsvf -file \"${top}.xsvf\"" >> project/impact.cmd
	echo "addDevice -p 1 -file \"${top}.bit\"" >> project/impact.cmd
	echo "Program -p 1 -e -defaultVersion 0" >> project/impact.cmd
	echo "quit" >> project/impact.cmd


project/$(top).ngc: $(synthysis_files) project $(project_files)
	cd project && /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/xst -intstyle ise -ifn $(top).xst
	#grep WARNINGS project/* | grep -Eq "XST_NUMBER_OF_WARNINGS\" value=\"0\""
	touch project/$(top).ngc

project/$(top).ngd: project/$(top).ngc nexys3.ucf
	cd project && /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/ngdbuild -intstyle silent -dd _ngo -nt timestamp -uc ../nexys3.ucf -p $(p) $(top).ngc $(top).ngd

project/$(top)_map.ncd: project/$(top).ngd
	cd project && /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/map -intstyle silent -p $(p) -w -u -ol high -t 1 -xt 0 -global_opt off -lc off -o $(top)_map.ncd $(top).ngd $(top).pcf

project/$(top).ncd: project/$(top)_map.ncd
	cd project && /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/par -w -intstyle silent -ol high $(top)_map.ncd $(top).ncd $(top).pcf

project/$(top).twr: $(top).ncd
	cd project && /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/trce -intstyle silent -v 3 -s 3 -n 3 -fastpaths -xml $(top).twx $(top).ncd -o $(top).twr $(top).pcf

project/$(top).bit: project/$(top).ncd
	cd project && /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/bitgen -intstyle silent -w $(top).ncd

project/$(top).xsvf: project/$(top).bit project/impact.cmd
	cd project && /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/impact -batch impact.cmd

.PHONY: cleanall clean help xst ngdbuild map par trace bitgen source waves sim
.SILENT: help dummy

xst : project/$(top).ngc
ngdbuild : project/$(top).ngd
map : project/$(top)_map.ncd
par : project/$(top).ncd
trce: project/$(top).twr
bitgen: project/$(top).bit
prog: project/$(top).xsvf
	cd project && /opt/libfpgalink/linux.x86_64/rel/flcli -i 1443:0007 -v 1443:0007 -x $(top).xsvf
waves : dump.vcd
	gtkwave dump.vcd dump.gtkw &
sim : dump.vcd

clean: 
	rm -rf project/_xmsgs project/xstdir project/*.lso project/*.ngc project/*.ngr project/*.srp project/*.xrpt
	rm -rf project/_ngo project/xlnx_auto_0_xdb project/*.ngd project/*.bld 
	rm -rf project/*.map project/*.mrp project/*.ncd project/*.ngm project/*.pcf project/*.xml
	rm -rf project/*.pad project/*.csv project/*.txt project/*.par project/*.ptwx project/*.unroutes project/*xpi project/*.html
	rm -rf project/*.twr project/*.twx
	rm -rf project/*.bgn project/*.xwbt project/*.drc project/*.log
	rm -rf a.out

cleanall: clean
	rm -rf project
	rm -rf dump*

help:
	echo "This makefile has the following options:"
	echo "  help:        print this message"
	echo "  sim:         simulate the testbench"
	echo "  waves:        simulate the testbench and open GTKWave"
	echo "  project:     create the required Xilinx project dir/files"
	echo "  prog:        program the board"
	echo "  clean:       remove all temporary files"
	echo "  cleanall:    remove all generated files, including .bit, .xsvf and dump* files"


