module EX_MEM (branchTrue_mem, 
					icm_pc_mem,
					aluResult_mem, 
					writeDataToSRAM_mem,
					jumpAddr_mem,
					readData1_mem, 
					writeRegOut_mem,
					zero_mem,
					overflow_mem, 
					carryOut_mem, 
					negative_mem,
					clk,
					reset,
					branchTrue_ex, 
					icm_pc_ex,
					aluResult_ex, 
					writeDataToSRAM_ex,
					jumpAddr_ex,
					readData1_ex,
					writeRegOut_ex,
					zero_ex, 
					overflow_ex, 
					carryOut_ex, 
					negative_ex);
					
	output [31:0] branchTrue_mem, aluResult_mem, writeDataToSRAM_mem, jumpAddr_mem, readData1_mem, icm_pc_mem;
	output [4:0] writeRegOut_mem;
	output zero_mem, overflow_mem, carryOut_mem, negative_mem;
	input [31:0] branchTrue_ex, aluResult_ex, writeDataToSRAM_ex, jumpAddr_ex, readData1_ex, icm_pc_ex;
	input [4:0] writeRegOut_ex;
	input zero_ex, overflow_ex, carryOut_ex, negative_ex;
	input clk, reset;

	always@(posedge clk)
	if(reset) begin
		branchTrue_mem <= branchTrue_ex;
		icm_pc_mem <= icm_pc_ex;
		aluResult_mem <= aluResult_ex;
		writeDataToSRAM_mem <= writeDataToSRAM_ex;
		writeRegOut_mem <= writeRegOut_ex;
		zero_mem <= zero_ex;
		overflow_mem <= overflow_ex;
		carryOut_mem <= carryOut_ex;
		negative_mem <= negative_ex;
		jumpAddr_mem <= jumpAddr_ex;
		readData1_mem <= readData1_ex;
	end
	else begin
		branchTrue_mem <= 32'b0;
		icm_pc_mem <= 32'b0;
		aluResult_mem <= 32'b0;
		writeDataToSRAM_mem <= 32'b0;
		writeRegOut_mem <= 5'b0;
		zero_mem <= 1'b0;
		overflow_mem <= 1'b0;
		carryOut_mem <= 1'b0;
		negative_mem <= 1'b0;
		jumpAddr_mem <= 32'b0;
		readData1_mem <= 32'b0;
	end
endmodule
