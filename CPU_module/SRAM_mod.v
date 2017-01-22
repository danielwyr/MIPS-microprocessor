module SRAM_mod (mainBus, clk, mainBusAddr, wr, enableOutput/*, probe*/);
	inout [15:0] mainBus;
	//output [15:0] probe;
	input [10:0] mainBusAddr;
	input wr, clk, enableOutput; // wr: 0 for write, 1 for read
	//output [6:0] hex0, hex1;
	
	wire [15:0] SRAMBus;
	wire [10:0] SRAMAddrBus;
	
	//assign probe = wr ? SRAMBus : 16'bz;
	
	memoryDataReg mdr (SRAMBus, mainBus, clk, wr); 
	SRAM sram (SRAMBus, SRAMAddrBus, wr, enableOutput/*, probe*/);
	memoryAddrReg mar (SRAMAddrBus, clk, mainBusAddr);
endmodule
