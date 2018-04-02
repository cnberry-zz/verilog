module disp_100mhz;
/* synthesis syn_black_box */
	initial begin
		$display("generated -- b:%b, s:%s","100mhz","100mhz");
	end		
endmodule
module disp_pll;
/* synthesis syn_black_box */
	initial begin
		$display("generated -- b:%b, s:%s","pll","pll");
	end		
endmodule
module disp_fpga;
/* synthesis syn_black_box */
	initial begin
		$display("generated -- b:%b, s:%s","fpga","fpga");
	end		
endmodule

typedef enum int {osc=1,fpga=2,pll=3} src;

module dut;
  parameter src inp [0:2] = {pll,fpga,osc};

/*
  initial begin
    $display("Here we go!");
    case ( inp[2] ) 
    	"100mhz" : begin
			$display("b:%b, s:%s","100mhz","100mhz");
		end
    	"pll" : begin
			$display("b:%b, s:%s","pll","pll");
		end
    	"fpga" : begin
			$display("b:%b, s:%s","fpga","fpga");
		end
    	default : $display("default");
    endcase
  end
*/
 	generate
		genvar i;
		for (i=0; i<=2; i=i+1) begin
			case ( inp[i] )
				osc: disp_100mhz u_100mhz();
				pll: disp_pll u_pll();
				fpga: disp_fpga u_fpga();
			endcase
		end
	endgenerate
endmodule

