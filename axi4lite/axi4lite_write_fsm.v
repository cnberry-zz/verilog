module axi4lite_write_fsm(clk,reset,awaddr,awvalid,awready,wdata,wvalid,bvalid,bready,aw_transfer,w_transfer);
  /*
	This module use output state encoding because combinational logic in
	procedural statements is throwing an error in iverilog. It does not
	seem that iverilog can handle non-blocking assignment in always 
	blocks.
  */

  //Input list (fixed 32 bite address/data)
  input clk, reset;
  input  awvalid, wvalid, bready;
  input [31:0]  awaddr, wdata;

  //Output list
  output bvalid, awready, wready;
  output aw_transfer,w_transfer;

  parameter INIT = 3'b100,
	    DATA = 3'b010,
 	    RESP = 3'b001;

  //internal  declarations
  reg [1:0] state;

  // Single SM,NSL
  always @(posedge clk)
  begin : WRITE_FSM
    if (reset)
	state <= INIT;
    else
	case(state)
	  INIT: begin
		  if (awvalid)
		    state <= DATA;
		end	
	  DATA: begin
		  if (wvalid)
		    state <= RESP;
		end
	  RESP: begin
		  if (bready)
		    state <= INIT;
		end
	  default: begin 
		     state <= INIT;
		   end
 	endcase
  end //fsm

  //OFL
  assign {awread,wready,bvalid} = state;
  assign aw_transfer = awvalid & awready;
  assign w_transfer = wvalid & wready; 

endmodule // axi4lite_fsm
