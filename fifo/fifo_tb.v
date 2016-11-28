// ----------------------------------------------------------------------
// Author: Chris Berry (cnberry@gmail.com)
// Date: September 3, 2016
// Description: Verilog version of a 'Hello World' program. Simple tb and fifo
// ------------------------------------------------------------------------

`timescale 1 ns / 100 ps

module fifo_tb ;

reg Clk_tb;
reg Reset_tb;
reg [31:0] Clk_cnt;
reg push_tb;
reg pop_tb;

//Instantiate module under test (DUT)
fifo #(.DATA_WIDTH(32),
	.ADDR_WIDTH(2),
	.FIFO_DEPTH(4)) 

	DUT(.clk(Clk_tb),
		.reset(Reset_tb),
		.data_in(),
		.data_out(),
		.push(push_tb),
		.pop(pop_tb),
		.empty(),
		.full());

//Specify dump file for use with GTKWave
initial
  begin  : DUMPFILE
    $dumpfile("dump.vcd");
    $dumpvars(0,fifo_tb);
  end

//Create a 100MHz clock
parameter CLK_PERIOD = 10;
initial
  begin  : CLK_GENERATOR
    $display("begin CLK_GENERATOR");
    Clk_tb = 0;
    forever
       begin
	      #(CLK_PERIOD/2) Clk_tb = ~Clk_tb;
       end 
  end

//Generate a 2 clk wide reset
initial
  begin  : RESET_GENERATOR
    $display("begin RESET_GENERATOR");
    Reset_tb = 1;
    #(2 * CLK_PERIOD) Reset_tb = 0;
  end

//Count clocks. Sometime this is usefull
initial
  begin  : CLK_COUNTER
    Clk_cnt = 0;
    $display("begin CLK_COUNTER");
    forever
       begin
	      #(CLK_PERIOD) Clk_cnt = Clk_cnt + 1;
       end 
  end

//Main part of testbench, do stuff or just wait
initial
  begin  : STIMULUS
    $display("\nbegin STIMULUS");

    wait (!Reset_tb);    // wait until reset is over
    @(posedge Clk_tb);    // wait for a clock edge
    $display("\tRESET over");

    ////////////////////////////////////////
    // Put your stimulus here

    push_tb = 1'b0;
    pop_tb = 1'b0;
    repeat(3) @(posedge Clk_tb);    // wait for a clock edge
    push_tb = 1'b1;
    pop_tb = 1'b0;
    repeat(10) @(posedge Clk_tb);    // wait for a clock edge
    push_tb = 1'b0;
    pop_tb = 1'b1;
    repeat(10) @(posedge Clk_tb);    // wait for a clock edge
    push_tb = 1'b0;
    pop_tb = 1'b0;
    repeat(10) @(posedge Clk_tb);    // wait for a clock edge

    ///////////////////////////////////////

    $display("end STIMULUS");
    $finish;  
	          
  end // STIMULUS


endmodule  // fifo_tb
