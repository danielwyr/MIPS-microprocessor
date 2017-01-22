module SLT(out, data0, data1, enable);
	output [31:0] out;
	input [31:0] data0, data1;
	input enable;
	
	
	wire [32:0] en;
	wire [31:0] bitIfLess;
	assign en[32] = ~enable;
	
	generate
	genvar i;
	for(i = 31; i >= 0; i--) begin: cp
	comparator cpt (bitIfLess[i], en[i], data0[i], data1[i], en[i + 1]);
	end
	endgenerate
	
	//assign ifLess = 0;
	
	assign out[0] = (bitIfLess[0] |
						 bitIfLess[1] |
						 bitIfLess[2] |
						 bitIfLess[3] |
						 bitIfLess[4] |
						 bitIfLess[5] |
						 bitIfLess[6] |
						 bitIfLess[7] |
						 bitIfLess[8] |
						 bitIfLess[9] |
						 bitIfLess[10] |
						 bitIfLess[11] |
						 bitIfLess[12] |
						 bitIfLess[13] |
						 bitIfLess[14] |
						 bitIfLess[15] |
						 bitIfLess[16] |
						 bitIfLess[17] |
						 bitIfLess[18] |
						 bitIfLess[19] |
						 bitIfLess[20] |
						 bitIfLess[21] |
						 bitIfLess[22] |
						 bitIfLess[23] |
						 bitIfLess[24] |
						 bitIfLess[25] |
						 bitIfLess[26] |
						 bitIfLess[27] |
						 bitIfLess[28] |
						 bitIfLess[29] |
						 bitIfLess[30]) &
						 ~bitIfLess[31];
endmodule
