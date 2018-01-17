module clkdiv (
	input clk,
	input reset,
	output out
	);

	parameter N = 9;

	reg [31:0] pos_count, neg_count;

	always @(posedge clk) begin
		if (reset)
			pos_count <= 0;
		else if ( pos_count == N-1 )
			pos_count <= 0;
		else
			pos_count <= pos_count + 1'b1;
	end

	always @(negedge clk) begin
		if (reset)
			neg_count <= 0;
		else if ( neg_count == N-1 )
			neg_count <= 0;
		else
			neg_count <= neg_count + 1'b1;
	end

	assign out = ( pos_count > (N>>1) ) | ( neg_count > (N>>1) );

endmodule
