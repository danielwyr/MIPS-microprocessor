module demux1_32_1bit (dataIn, sel, in);
	output [31:0] dataIn;
	input [4:0] sel;
	input in;
	
	wire [1:0] n0;
	wire [3:0] n1;
	wire [7:0] n2;
	wire [15:0] n3;
	
	// demux1_32 level 0 (1 in total)
	demux1_2 d0_0 (n0[0], n0[1], in, sel[4]);
	
	// demux1_32 level 1 (2 in total)
	demux1_2 d1_0 (n1[0], n1[1], n0[0], sel[3]);
	demux1_2 d1_1 (n1[2], n1[3], n0[1], sel[3]);
	
	// demux1_32 level 2 (4 in total)
	generate
	genvar i;
	for(i = 0; i < 4; i++) begin: dmLevel2
	demux1_2 level2 (n2[i * 2], n2[i * 2 + 1], n1[i], sel[2]);
	end
	endgenerate
	
	// demux1_32 level 3 (8 in total)
	generate
	genvar j;
	for(j = 0; j < 8; j++) begin: dmLevel3
	demux1_2 level3 (n3[j * 2], n3[j * 2 + 1], n2[j], sel[1]);
	end
	endgenerate
	
	// demux1_32 level 4 (16 in total)
	generate
	genvar k;
	for(k = 0; k < 16; k++) begin: dmLevel4
	demux1_2 level4 (dataIn[k * 2], dataIn[k * 2 + 1], n3[k], sel[0]);
	end
	endgenerate
endmodule
