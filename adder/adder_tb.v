// ----------------------------------------------------------------------
// Author: Chris Berry (cnberry@gmail.com)
// Date: September 3, 2016
// Description: Verilog version of adder. Simple tb, task, for loop 
// ------------------------------------------------------------------------

`timescale 1 ns / 100 ps

module adder_tb ;

reg Clk_tb;
reg Reset_tb;
reg [31:0] Clk_cnt;
reg a;
reg b;
reg c_in;

integer i,j,k;
wire s1,s2,s3;
wire c1,c2,c3;

//Instantiate module under test (DUT)
adder_dataflow ADD_dataflow(.sum(s1),.c_out(c1),.c_in(c_in),.a(a),.b(b));
adder_behavioral ADD_behavioral(.sum(s2),.c_out(c2),.c_in(c_in),.a(a),.b(b));
adder_structural ADD_structural(.sum(s3),.c_out(c3),.c_in(c_in),.a(a),.b(b));

//Instantiate synchronous assertion checks (self checking TB)
assert a_sum(.clk(Clk_tb),.expression(s1 === s2 && s2 === s3));
assert a_cout(.clk(Clk_tb),.expression(c1 === c2 && c2 === c3));

//Specify dump file for use with GTKWave
initial
  begin  : DUMPFILE
    $dumpfile("dump.vcd");
    $dumpvars(0,adder_tb);
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

    // Loop through all input combinations
    for (i=0;i<2;i++)
      for (j=0;j<2;j++)
	for (k=0;k<2;k++)
    	  test_vector(i,j,k);

    #10		//Wait 10ns just to do something

    ///////////////////////////////////////

    $display("end STIMULUS");
    $display("PASSED");
    $finish;  
	          
  end // STIMULUS

// Task to drive test sequenes
task test_vector;

  input a_val, b_val, c_val;

  begin  : TASK_TEST_VECTOR
        a = a_val;
        b = b_val;
        c_in = c_val;
        @(posedge Clk_tb);    // wait for a clock edge
        a = 'b0;
        b = 'b0;
        c_in = 'b0;
        @(posedge Clk_tb);    // wait for a clock edge
  end
endtask // testvecotr

endmodule  // adder_tb

module assert(input clk,input expression);
  always @(posedge clk)
  begin
    if (expression !== 1'b1)
    begin
      $display("ASSERTION FAILED in %m");	 
      $finish;
    end
  end
endmodule // assert
