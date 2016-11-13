module adder_behavioral(sum, c_out, a,b,c_in);
   output sum;
   output c_out;

   input a;
   input b;
   input c_in;

   // Type declaration (wire is implicit)
   reg sum;
   reg c_out;

   always @( a or b or c_in)
      begin
	{c_out,sum} = a + b + c_in; 
      end


endmodule //adder
