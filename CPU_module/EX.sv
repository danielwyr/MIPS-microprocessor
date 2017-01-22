module EX (aluResult_ex, 
			  writeDataToSRAM_ex, 
			  branchTrue_ex, 
			  jumpAddr_ex,
			  writeRegOut_ex,
			  zero_ex, 
			  overflow_ex, 
			  carryOut_ex, 
			  negative_ex,
			  readData1_ex, 
			  readData2_ex, 
			  signExtendedInst_ex,
			  instruction_ex,
			  icm_pc_ex,
			  writeDataToReg_wb,
			  aluResult_mem,
			  readReg2_ex,
			  writeReg_ex,
			  ALUCtrl,
			  ALUSrc,
			  RegDst,
			  ForwardA, 
			  ForwardB);
	output [31:0] aluResult_ex, branchTrue_ex, writeDataToSRAM_ex, jumpAddr_ex;
	output [4:0] writeRegOut_ex;
	output zero_ex, overflow_ex, carryOut_ex, negative_ex;
	input [31:0] readData1_ex, readData2_ex, signExtendedInst_ex, instruction_ex, icm_pc_ex;
	input [31:0] writeDataToReg_wb, aluResult_mem;
	input [4:0] readReg2_ex, writeReg_ex;
	input [2:0] ALUCtrl;
	input [1:0] ForwardA, ForwardB;
	input ALUSrc, RegDst;
	
	
	 
	
	/*----------------------------------------------------------------------*/
	wire [31:0] sft_signExtendedInst_ex, sft_instruction;
	
	assign sft_instruction = instruction_ex << 2;
	assign jumpAddr_ex[27:0] = sft_instruction[27:0];
	assign jumpAddr_ex[31:28] = icm_pc_ex[31:28];
	
	
	
	
	assign sft_signExtendedInst_ex = signExtendedInst_ex << 2;
	assign branchTrue_ex = sft_signExtendedInst_ex + icm_pc_ex;
	assign writeDataToSRAM_ex = operand2_fwd;
	assign writeRegOut_ex = RegDst ? writeReg_ex : readReg2_ex;
	/*----------------------------------------------------------------------*/
	// ALU circuit
	// input readData1_ex, readData2_ex, signExtendedInst_ex
	wire [31:0] operand1, operand2;
	
	/*----------------------------------------------------------------------*/
	
	
	wire [31:0] operand1_fwd, operand2_fwd;
	
	assign operand1_fwd = (ForwardA == 2'b00) ? readData1_ex : 
								 (ForwardA == 2'b01) ? writeDataToReg_wb : aluResult_mem;
								 
	assign operand2_fwd = (ForwardB == 2'b00) ? readData2_ex : 
								 (ForwardB == 2'b01) ? writeDataToReg_wb : aluResult_mem;
	
	
	assign operand1 = operand1_fwd;
	mux2_1 ALUSrc_mux (operand2, operand2_fwd, signExtendedInst_ex, ALUSrc);
	/*----------------------------------------------------------------------*/
	// ALU circuit
	// input operand1, operand2, ALUCtrl
	// output zero_ex, overflow_ex, carryOut_ex, negative_ex, aluResult_ex
	
	ALU alu (aluResult_ex, 
				zero_ex, 
				overflow_ex, 
				carryOut_ex, 
				negative_ex, 
				operand1, 
				operand2, 
				ALUCtrl);
	/*----------------------------------------------------------------------*/

endmodule

