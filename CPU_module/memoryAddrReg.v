module memoryAddrReg (addrOut,clk, addrIn);
	output reg [10:0] addrOut;
	input [10:0] addrIn;
	input clk;
	
	always@(posedge clk)
	addrOut <= addrIn;
endmodule
