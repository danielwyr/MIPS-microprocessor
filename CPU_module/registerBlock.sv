module registerBlock (dataOut, clk, reset, dataIn, readWriteCtrl);
	output [31:0] dataOut[31:0];
	input [31:0] dataIn[31:0];
	input [31:0] readWriteCtrl;
	input clk, reset; // 0 for write, 1 for read
	
	singleRegisterMod m0 (dataOut[0], clk, reset, dataIn[0], 1'b1); // set the reg0 to be 0 and cannot be changed
	generate
	genvar i;
	for (i = 1; i < 32; i++) begin: rB
	singleRegisterMod m (dataOut[i], clk, reset, dataIn[i], readWriteCtrl[i]);
	end
	endgenerate
endmodule
