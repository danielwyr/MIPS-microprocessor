module MEM_WB (readDataSRAM_wb, 
					readDataRegFile_wb,
					jumpAddr_wb,
					readData1_wb,
					branchTrue_wb,
					icm_pc_wb,
					writeRegOut_wb,
					clk,
					reset,
					readDataSRAM_mem, 
					readDataRegFile_mem,
					jumpAddr_mem,
					readData1_mem,
					branchTrue_mem,
					icm_pc_mem,
					writeRegOut_mem);
					
	output [31:0] readDataSRAM_wb, readDataRegFile_wb, jumpAddr_wb, branchTrue_wb, readData1_wb, icm_pc_wb;
	output [4:0] writeRegOut_wb;
	input [31:0] readDataSRAM_mem, readDataRegFile_mem, jumpAddr_mem, branchTrue_mem, readData1_mem, icm_pc_mem;
	input [4:0] writeRegOut_mem;
	input clk, reset;
	
	always@(posedge clk)
	if(reset) begin
		readDataSRAM_wb <=  readDataSRAM_mem;
		readDataRegFile_wb <= readDataRegFile_mem;
		writeRegOut_wb <= writeRegOut_mem;
		jumpAddr_wb <= jumpAddr_mem;
		branchTrue_wb <= branchTrue_mem;
		icm_pc_wb <= icm_pc_mem;
	end
	else begin
		readDataSRAM_wb <= 32'b0;
		readDataRegFile_wb <= 32'b0;
		writeRegOut_wb <= 5'b0;
		jumpAddr_wb <= 32'b0;
		branchTrue_wb <= 32'b0;
		icm_pc_wb <= 32'b0;
	end
endmodule
