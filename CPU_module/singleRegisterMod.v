module singleRegisterMod (dataOut, clk, reset, dataIn, wr);
	output [31:0] dataOut;
	input clk, reset, wr;
	input [31:0] dataIn;

	wire [31:0] D;
	mux2_1 wrctrl (D, dataIn, dataOut, wr);
	registerRow rr (dataOut, clk, reset, D);
endmodule
