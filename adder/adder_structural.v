module adder_structural(sum, c_out, a,b,c_in);
   output sum;
   output c_out;

   input a;
   input b;
   input c_in;

   // Internal nets
   wire s1,c1,c2;

   // Sum path
   xor(s1,a,b);
   xor(sum,s1,c_in);
   
   // Carry out path
   and(c1,a,b);
   and(c2,s1,c_in); //reuse xor from sum path
   xor(c_out,c2,c1);

endmodule //adder
