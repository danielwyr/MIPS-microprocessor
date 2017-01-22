module memoryDataReg (SRAMBus, mainBus, clk, wr);
	inout [15:0] SRAMBus, mainBus;
	input clk, wr; // wr: 0 for write, 1 for read
	
	reg [15:0] drIn, drOut;
	assign SRAMBus = !wr ? drIn : 16'bz;
	assign mainBus = !wr ? 16'bz: drOut;
	
	always@(posedge clk)
	if(!wr)
	drIn <= mainBus;
	else
	drOut <= SRAMBus;
endmodule
