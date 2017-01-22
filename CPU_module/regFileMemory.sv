module regFileMemory(regData1, regData2, clk, reset, instruction1, instruction2, writeAddressToReg, dataToReg, RegWrite, GPIO_1, SW);
	output [31:0] regData1, regData2;
	input [31:0] dataToReg;
	input [4:0] instruction1, instruction2, writeAddressToReg;
	input reset, RegWrite;
	input clk;

	
	//////////////////////////////////////////////////////////
	output [31:0] GPIO_1;
	input [4:0] SW;
	
	
	//////////////////////////////////////////////////////////
	
	wire regwr;
	
	registerFile regfile (regData1, 
								 regData2,
								 clk, 
								 reset, 
								 instruction1, 
								 instruction2, 
								 writeAddressToReg, 
								 dataToReg, 
								 ~RegWrite, 
								 GPIO_1, 
								 SW);
endmodule
