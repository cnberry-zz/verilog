/* Problem: create a parameterized clk divider
 *			
 *	1. when ask about odd values, start with LO>HI
 *		this makes 50/50 duty cycle easier since 
 *		its just or of pos and neg versions
 *	2. try it for N = 4,5
 *
 *	3. create 50/50 duty cycle version. 
 *
 *	4. Extra: make sure posedge is aligned to posedge
 *		and negedge is aligned to negedge. 
 *
 */
module clkdiv (
	input clk,
	input reset,
	output out
	);

	parameter N = 8;
	parameter W = $clog2(N);

	reg [W:0] pos_count, neg_count;
	reg pos,neg;

	// reset sync to align positive edge to positve edge
	reg srst = 1;
	always @(negedge clk) begin
		srst <= reset;
	end

	// pos counter, can use for pos/odd divider
	always @(posedge clk) begin
		if (srst)
			pos_count <= 0;
		else if ( pos_count == N-1 )
			pos_count <= 0;
		else
			pos_count <= pos_count + 1'b1;
	end

	// odd counter, used only for ddr/odd divider
	always @(negedge clk) begin
		if (srst)
			neg_count <= 0;
		else if ( neg_count == N-1 )
			neg_count <= 0;
		else
			neg_count <= neg_count + 1'b1;
	end

	// pos toggle flop. Toggles 2 times per N count.
	// HI = LO+1 (ie LO > HI)
	// NOTE: (N-1)>>1 is for LO>HI
	// 		 (N>>1)-1 is for HI>LO
	// 		 (N>>1) will work for odd LO>HI, but not even
	always @(posedge clk) begin
		if (srst)
			pos <= 0;
		else if ( pos_count == N-1  || pos_count == ((N-1)>>1))
			pos <= ~pos;
	end
	
	// neg toggle flop. Toggles 2 times per N count.
	// HI = LO+1 (ie LO > HI)
	always @(negedge clk) begin
		if (srst)
			neg <= 0;
		else if ( neg_count == N-1  || neg_count == ((N-1)>>1))
			neg <= ~neg;
	end

	// use a generate to avoid a constant mux. Could also put neg inside
	// gernate
	generate
		if (N%2 == 0) begin: even
			assign out = pos;
		end
		else begin : odd
			assign out = pos | neg;
		end
	endgenerate

endmodule
