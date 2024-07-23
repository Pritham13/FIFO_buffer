#!/bin/zsh
top="fifo"
file="${top}.v"
netlist="netlist_${top}.v"
tb="${top}_tb.v"
yosys -p "read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib ;

	read_verilog $file;

	synth -top $top -flatten;

	dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib ;

	abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib ;

	show $top;

	write_verilog -noattr $netlist"

iverilog -o ${top}_post_syn ../verilog_model/primitives.v ../verilog_model/sky130_fd_sc_hd_edited.v $netlist $tb;
./${top}_post_syn
gtkwave ${top}.vcd
