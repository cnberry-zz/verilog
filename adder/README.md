This example shows 3 different ways to describe a 1-bit full adder 

   1) structural : using conical logic gates (2-input AND,XOR)
   2) behavioral : using high level "+" opperator in RTL sytle
   3) dataflow   : using assign statement with bitwise operators

This is the example is used when TA'ing EE201 to explain these different
modeling patterns. The structural implementation uses the following boolean 
description:

   sum  = a ^ b ^ cin
   cout = (a * b) ^ (cin * (a ^ b)

however a more intuitive expression for cout is:
  
   cout = (a * b) | (a * cin) | (b * cin)

which is what I use in the dataflow module.
