module fifo(clk,reset,data_in,data_out,push,pop,empty,full);
   parameter DATA_WIDTH = 1;
   parameter ADDR_WIDTH = 1;
   parameter FIFO_DEPTH = 1 << ADDR_WIDTH;
 
   //Output signals 
   output reg empty,full;
   output reg [DATA_WIDTH-1:0] data_out;

   //Input signals
   input wire clk,reset;
   input wire push,pop;
   input wire [DATA_WIDTH-1:0] data_in;

   //Internal signals
   reg [ADDR_WIDTH-1:0] rd_ptr;
   reg [ADDR_WIDTH-1:0] wr_ptr;
   reg [ADDR_WIDTH:0] counter;

   always @( posedge clk, posedge reset )
   begin
      if ( reset )
      begin   
	rd_ptr <= 'b0;
        wr_ptr <= 'b0;
        counter <= 'b0;
      end
      else
      begin
	if ( pop && !push && !empty )
	  counter <= counter - 1;
	else if ( push && !pop && !full )
	  counter <= counter + 1;

	if ( pop && !empty )
	  rd_ptr = rd_ptr + 1;
	
	if ( push && !full )
	  wr_ptr = wr_ptr + 1;
      end
   end

   always @( posedge clk, posedge reset )
   begin
     if ( reset )
     begin
       full <= 1'b0;
       empty <= 1'b0;
     end
     else
     begin
	if ( (counter == 1 && pop && !push) || counter == 0 && !push )
	  empty <= 1'b1;
	else 
	  empty <= 1'b0;

	if  ( (counter == (FIFO_DEPTH-1) && push && !pop) || (counter == FIFO_DEPTH && !pop))
	  full <= 1'b1;
	else 
	  full <= 1'b0;
     end

   end

endmodule //fifo
