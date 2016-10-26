module axi4lite(clk,reset,awaddr,awvalid,awready,wdata,wvalid,bvalid,bready);

  //Input list (fixed 32 bite address/data)
  input clk, reset;
  input  awvalid, wvalid, bready;
  input [31:0]  awaddr, wdata;

  //Output list
  output bvalid, awready, wready;

  axi4lite_write_fsm write_fsm(.clk(clk),
			     .reset(reset),
			     .awaddr(awaddr),
			     .awvalid(awvalid),
			     .awready(awready),
			     .wdata(wdata),
			     .wvalid(wvaild),
			     .bvalid(bvalid),
			     .bready(bready),
			     .aw_transfer(),
			     .w_transfer());

endmodule // axi4lite_fsm
