module SLL(out, data, position, enable);
	output [31:0] out;
	input [31:0] data;
	input [1:0] position;
	input enable;
	
	wire [31:0] transitData1, transitData2;
	
	
	// enable input data
	generate 
	genvar i;
	for(i = 0; i < 32; i++) begin: enableData
	assign transitData1[i] = ~enable & data[i];
	end
	endgenerate
	
	wire [33:0] leftShift1;
	wire [32:0] leftShift2;
	
	// 2 bit left shifter
	assign leftShift1[0] = 1'b0;
	assign leftShift1[1] = 1'b0;
	generate 
	genvar j;
	for(j = 2; j < 34; j++) begin: layer1
	assign leftShift1[j] = transitData1[j - 2];
	end
	endgenerate
	
	assign transitData2 = position[1] ? leftShift1[31:0] : transitData1;
	
	
	// 1 bit left shifter
	assign leftShift2[0] = 1'b0;
	generate
	genvar k;
	for(k = 1; k < 33; k++) begin: layer2
	assign leftShift2[k] = transitData2[k - 1];
	end
	endgenerate
	
	assign out = position[0] ? leftShift2[31:0] : transitData2;
endmodule
