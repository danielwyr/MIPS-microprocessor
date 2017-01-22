module registerRow(data, clk, reset, dataIn);
	output [31:0] data;
	input [31:0] dataIn;
	input clk, reset;
	
	generate 
	genvar i;
	for(i = 0; i < 32; i++) begin: df
	Dflipflop d (data[i], clk, reset, dataIn[i]);
	end
	endgenerate
endmodule
