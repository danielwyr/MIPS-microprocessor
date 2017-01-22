module ID (readData1, 
			  readData2, 
			  readReg2,
			  writeReg,
			  signExtendedInst,
			  Rs_id,
			  Rt_id,
			  Rd_id, 
			  bgt_id,
			  ForwardA_id,
			  ForwardB_id,
			  clk, 
			  reset, 
			  writeDataToReg, 
			  instruction,  
			  aluResult_mem,
			  aluResult_ex,
			  writeRegOut_wb,
			  RegWrite,
			  regFileProbe, 
			  SW);
			  
	output [31:0] readData1, readData2, signExtendedInst;
	output [4:0] readReg2, writeReg;
	output [4:0] Rs_id, Rt_id, Rd_id;
	output bgt_id;
	input [1:0] ForwardA_id, ForwardB_id;
	input [31:0] writeDataToReg, instruction, aluResult_mem, aluResult_ex;
	input [4:0] writeRegOut_wb;
	input clk, reset;
	input RegWrite;
	
	output [31:0] regFileProbe;
	input [4:0] SW;
	
	/*----------------------------------------------------------------------*/
	// register file memory circuit
	// output readData1, readData2
	// input readReg1, readReg2, writeReg, writeDataToReg, RegWrite, RegDst
	wire [4:0] readReg1;
	
	assign writeReg = instruction[15:11];
	assign readReg1 = instruction[25:21];
	assign readReg2 = instruction[20:16];
	
	assign Rd_id = instruction[15:11];
	assign Rt_id = instruction[20:16];
	assign Rs_id = instruction[25:21];
	

	/*regFileMemory rfm (readData1, 
							 readData2, 
							 clk, 
							 reset, 
							 readReg1, 
							 readReg2,
							 writeRegOut_wb, 
							 writeDataToReg, 
							 RegWrite, 
							 regFileProbe, 
							 SW);*/
	
	
	registerFile regfile (readData1, 
								 readData2,
								 clk, 
								 reset, 
								 readReg1, 
								 readReg2, 
								 writeRegOut_wb, 
								 writeDataToReg, 
								 ~RegWrite, 
								 regFileProbe, 
								 SW);
	

	
	/*----------------------------------------------------------------------*/
	
	
	/*----------------------------------------------------------------------*/
	// signExtention circuit
	// input instruction[15:0] //low 16 bits of instruction
	// output signExtendedInst
	wire [31:0] signExtendedInst;
	signExtended se (signExtendedInst, instruction[15:0]);
	/*----------------------------------------------------------------------*/
	
	wire [31:0] operand1, operand2;
	
	assign operand1 = (ForwardA_id == 2'b00) ? readData1 :
							(ForwardA_id == 2'b01) ? aluResult_mem : aluResult_ex;
							
	assign operand2 = (ForwardB_id == 2'b00) ? readData2 :
							(ForwardB_id == 2'b01) ? aluResult_mem : aluResult_ex;
							
	assign bgt_id = (operand1 > operand2);
	
endmodule
