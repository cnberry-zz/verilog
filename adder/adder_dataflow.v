module adder_dataflow(sum, c_out, a,b,c_in);
   output sum;
   output c_out;

   input a;
   input b;
   input c_in;

   assign sum = a ^ b ^ c_in;
   assign c_out = (a&b) | (a&c_in) | (b&c_in);

endmodule //adder
