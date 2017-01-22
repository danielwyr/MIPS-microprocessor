module WB (writeDataToReg,
			  readDataSRAM,
			  readDataRegFile,
			  MemtoReg);
	output [31:0] writeDataToReg;
	input [31:0] readDataSRAM, readDataRegFile;
	input MemtoReg;

	mux2_1 writeToReg_mux (writeDataToReg, readDataRegFile, readDataSRAM, MemtoReg);
endmodule
