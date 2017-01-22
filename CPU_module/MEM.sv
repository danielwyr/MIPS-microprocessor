module MEM (readDataSRAM,
				readDataRegFile,
				branchSel_mem,
				clk,
				reset,
				aluResult,
				writeDataToSRAM,
				zero_mem,
				overflow_mem, 
				carryOut_mem, 
				negative_mem,
				MemWrite_mem,
				MemRead_mem,
				Branch_mem,
				SRAMProbe,
				SW);
	output [31:0] readDataSRAM, readDataRegFile;
	output branchSel_mem;
	input [31:0] aluResult, writeDataToSRAM;
	input clk, reset;
	input zero_mem, overflow_mem, carryOut_mem, negative_mem;
	input MemWrite_mem, MemRead_mem, Branch_mem;

	output [31:0] SRAMProbe;
	input [4:0] SW;
	
	wire [10:0] address;
	wire [31:0] readDataSRAM;
	wire branchIfPositive;


	nor ifPositive (branchIfPositive, zero_mem, negative_mem);
	and branchCtrl (branchSel_mem, Branch_mem, branchIfPositive);
	
	assign readDataRegFile = aluResult;
	assign address = aluResult[10:0];
	dataMemory dm (readDataSRAM, 
						clk, 
						reset, 
						MemWrite_mem, 
						MemRead_mem, 
						writeDataToSRAM, 
						address, 
						SRAMProbe, 
						SW);

endmodule
