module mux32_5 (out, sel, in);
	output [31:0]out;
	input [4:0] sel;
	input [31:0] in[31:0];
	
	wire [31:0] n0[15:0]; // node level 0
	wire [31:0] n1[7:0]; // node level 1
	wire [31:0] n2[3:0]; // node level 2
	wire [31:0] n3[1:0]; // node level 3
	
	// mux2_1 level 0 (16 * 32 in total)
	generate 
	genvar i;
	for (i = 0; i < 16; i++) begin: mLevel0
	mux2_1 level0 (n0[i], in[2 * i], in[2 * i + 1], sel[0]);
	end
	endgenerate

	// mux2_1 level 1 (8 * 32 in total)
	generate 
	genvar j, q;
	for (j = 0; j < 8; j++) begin: mLevel1
	mux2_1 level1 (n1[j], n0[2 * j], n0[2 * j + 1], sel[1]);
	end
	endgenerate

	// mux2_1 level 2 (4 * 32 in total)
	generate 
	genvar k, r;
	for (k = 0; k < 4; k++) begin: mLevel2
	mux2_1 level2 (n2[k], n1[2 * k], n1[2 * k + 1], sel[2]);
	end
	endgenerate
	
	// mux2_1 level 3 (2 * 32 in total)
	mux2_1 mux3_0 (n3[0], n2[0], n2[1], sel[3]);
	mux2_1 mux3_1 (n3[1], n2[2], n2[3], sel[3]);
	
	// mux2_1 level 4 (1 * 32 in total)
	mux2_1 mux4_0 (out, n3[0], n3[1], sel[4]);
endmodule
