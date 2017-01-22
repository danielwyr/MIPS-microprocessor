module cpuCore(clk, reset, GPIO_0, GPIO_1, SW);
	output [31:0] GPIO_0, GPIO_1;
	input [9:0] SW;
	input clk, reset;
	
	
	/*----------------------------------------------------------------------*/
	wire [31:0] regFileProbe, SRAMProbe, pcProbe;
	
	assign GPIO_0 = pcProbe;
	assign GPIO_1 = SW[9] ? regFileProbe : SRAMProbe;
	/*----------------------------------------------------------------------*/
	
	
	/*----------------------------------------------------------------------*/
	// Clock divider
	reg [31:0] divided_clocks;
	initial
	divided_clocks = 0;

	always @(posedge clk)
	divided_clocks = divided_clocks + 1;
	
	parameter SELECTED_CLOCK = 2;
	
	wire slow_clk;
	
	assign slow_clk = divided_clocks[SELECTED_CLOCK + 1];
	
	/*----------------------------------------------------------------------*/
	// hazard detection unit Signals
	wire PCWrite, IF_IDWrite, Stall;
	
	
	/*----------------------------------------------------------------------*/
	/*									IF:Instruction Fetch									*/
	wire [31:0] instruction_if, icm_pc_if;
	wire branchSel_mem;

	
	IF instruction_fetch (instruction_if, 
								 icm_pc_if, 
								 slow_clk, 
								 reset, 
								 branchSel_wb, 
								 Jump_wb, 
								 JumpReg_wb, 
								 PCWrite,
								 branchTrue_wb, 
								 icm_pc_wb,
								 readData1_wb,
								 jumpAddr_wb,
								 pcProbe);
	/*----------------------------------------------------------------------*/
	
	/*----------------------------------------------------------------------*/
	wire [31:0] instruction_id, icm_pc_id;
	wire IF_Flush;
	
	IF_ID if_id (instruction_id, 
				    icm_pc_id, 
				    slow_clk, 
				    reset, 
					 IF_IDWrite,
					 IF_Flush,
				    instruction_if, 
				    icm_pc_if);
	
	/*----------------------------------------------------------------------*/
	
	/*----------------------------------------------------------------------*/
	/* 								Control Module											*/
	wire RegDst_id, Jump_id, Branch_id, MemRead_id, 
		  MemtoReg_id, MemWrite_id, ALUSrc_id, RegWrite_id;
	wire [5:0] OpCode_id, functionField_id;
	wire [1:0] ALUOp_id;
	wire bgt_id;
	
	assign OpCode_id = instruction_id[31:26];
	assign functionField_id = instruction_id[5:0];
	control ctrl (Branch_id, 
					  ALUOp_id, 
					  MemRead_id, 
					  MemWrite_id, 
					  MemtoReg_id, 
					  RegDst_id, 
					  RegWrite_id, 
					  ALUSrc_id, 
					  Jump_id, 
					  IF_Flush,
					  OpCode_id,
					  functionField_id,
					  bgt_id);
	
	/*									ID:Instruction Decoder								*/
	wire [31:0] readData1_id, readData2_id, writeDataToReg_wb, signExtendedInst_id;
	wire [4:0] readReg2_id, writeReg_id;
	wire [4:0] Rs_id, Rt_id, Rd_id;
	wire [1:0] ForwardA_id, ForwardB_id;

	ID instruction_decoder (readData1_id, 
									readData2_id,
									readReg2_id,	
									writeReg_id,
									signExtendedInst_id, 
									Rs_id,
									Rt_id,
									Rd_id,
									bgt_id,
									ForwardA_id,
									ForwardB_id,
									slow_clk, 
									reset, 
									writeDataToReg_wb, 
									instruction_id, 
									aluResult_mem,
									aluResult_ex,
									writeRegOut_wb,
									RegWrite_wb,
									regFileProbe, 
									SW[4:0]);
	/*----------------------------------------------------------------------*/
	
	/*----------------------------------------------------------------------*/
	wire [31:0] instruction_ex, icm_pc_ex, readData1_ex, readData2_ex, signExtendedInst_ex;
	wire [4:0] writeReg_ex, readReg2_ex;
	wire [4:0] Rs_ex, Rt_ex, Rd_ex;
	
	ID_EX id_ex (instruction_ex,
					 icm_pc_ex,
				    readData1_ex,
				    readData2_ex,
				    signExtendedInst_ex,
					 readReg2_ex,
					 writeReg_ex,
					 Rs_ex,
					 Rt_ex,
					 Rd_ex,
				    slow_clk,
				    reset,
					 Stall,
					 instruction_id,
				    icm_pc_id,
				    readData1_id,
				    readData2_id,
				    signExtendedInst_id,
					 readReg2_id,
					 writeReg_id,
					 Rs_id,
					 Rt_id,
					 Rd_id);
	
	
	wire RegWrite_ex, Branch_ex, RegDst_ex, ALUSrc_ex, MemRead_ex, MemWrite_ex, MemtoReg_ex, Jump_ex;
	wire [1:0] ALUOp_ex;
	ID_EX_CtPath id_ex_ctpath (/* Output  */
									   RegWrite_ex, /* WB */
									   MemtoReg_ex,
										Jump_ex,
										  
									   Branch_ex,	/* M */
									   MemRead_ex, 
									   MemWrite_ex,
										  
									   RegDst_ex,	/* EX */
									   ALUSrc_ex,
									   ALUOp_ex,
										  
									   /* Else */
									   slow_clk,
									   reset,
										  
									   /* Input */
									   RegWrite_id, /* WB */
									   MemtoReg_id,
										Jump_id,
										  
									   Branch_id,	/* M */
									   MemRead_id, 
									   MemWrite_id,
										  
									   RegDst_id,	/* EX */
									   ALUOp_id,
									   ALUSrc_id);
	
	/*----------------------------------------------------------------------*/
	
	/*----------------------------------------------------------------------*/
	/*									EX:Execute/Address Calculation					*/
	wire [31:0] aluResult_ex, writeDataToSRAM_ex, branchTrue_ex, jumpAddr_ex;
	wire [4:0] writeRegOut_ex;
	wire [2:0] ALUCtrl_ex;
	wire [1:0] ForwardA, ForwardB;
	wire zero_ex, overflow_ex, carryOut_ex, negative_ex;
	
	EX execute_addrCal (aluResult_ex, 
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
							  ALUCtrl_ex,
							  ALUSrc_ex,
							  RegDst_ex,
							  ForwardA,
							  ForwardB);
							  
							  
	/* 								ALU Control circuit									*/
	wire JumpReg_ex;
	wire [5:0] functionField;
	
	assign functionField = signExtendedInst_ex[5:0];
	ALU_Control aluctrl (ALUCtrl_ex, functionField, ALUOp_ex, JumpReg_ex);
	
	/*----------------------------------------------------------------------*/
	
	/*----------------------------------------------------------------------*/
	wire [31:0] branchTrue_mem, aluResult_mem, writeDataToSRAM_mem, jumpAddr_mem, readData1_mem, icm_pc_mem;
	wire [4:0] writeRegOut_mem;
	wire zero_mem, overflow_mem, carryOut_mem, negative_mem;
	
	EX_MEM ex_mem (branchTrue_mem,
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
						slow_clk,
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
	
	wire RegWrite_mem, /* WB */
		  MemtoReg_mem,
		  Jump_mem,
		  JumpReg_mem,
							 
		  Branch_mem, /* M */
		  MemRead_mem,
		  MemWrite_mem;

	EX_MEM_CtPath ex_mem_ctpath (/* Output */
										  /*--------------------*/
										  RegWrite_mem,	/* WB */
										  MemtoReg_mem,
										  Jump_mem,
										  JumpReg_mem,
										  /*--------------------*/
										  Branch_mem, 		/* M  */
										  MemRead_mem,
										  MemWrite_mem,
										  /*--------------------*/
										  
										  /*--------------------*/
										  /* Else */
										  slow_clk,
										  reset,
										  /*--------------------*/
										  
										  /* Input */
										  /*--------------------*/
										  RegWrite_ex,		/* WB */
										  MemtoReg_ex,
										  Jump_ex,
										  JumpReg_ex,
										  /*--------------------*/
										  Branch_ex,		/* M  */
										  MemRead_ex,
										  MemWrite_ex);
	/*----------------------------------------------------------------------*/
	
	
	/*----------------------------------------------------------------------*/
	/*									MEM:Memory Access										*/
	wire [10:0] address;
	wire [31:0] readDataSRAM_mem, readDataRegFile_mem;
	
	MEM memory_access (readDataSRAM_mem,
							 readDataRegFile_mem,
							 branchSel_mem,
							 slow_clk,
							 reset,
							 aluResult_mem,
							 writeDataToSRAM_mem,
							 zero_mem,
							 overflow_mem, 
							 carryOut_mem, 
							 negative_mem,
							 MemWrite_mem,
							 MemRead_mem,
							 Branch_mem,
							 SRAMProbe,
							 SW[4:0]);
	/*----------------------------------------------------------------------*/
	
	/*----------------------------------------------------------------------*/
	wire [31:0] readDataSRAM_wb, readDataRegFile_wb, jumpAddr_wb, branchTrue_wb, readData1_wb, icm_pc_wb;
	wire [4:0] writeRegOut_wb;
	
	MEM_WB mem_wb (readDataSRAM_wb, 
						readDataRegFile_wb,
						jumpAddr_wb,
						readData1_wb,
						branchTrue_wb,
						icm_pc_wb,
						writeRegOut_wb,
						slow_clk,
						reset,
						readDataSRAM_mem, 
						readDataRegFile_mem,
						jumpAddr_mem,
						readData1_mem, 
						branchTrue_mem,
						icm_pc_mem, 
						writeRegOut_mem);
						
						
	wire RegWrite_wb, MemtoReg_wb, Jump_wb, JumpReg_wb, branchSel_wb;
	MEM_WB_CtPath mem_wb_ctpath (/* Output */
										  RegWrite_wb,
										  MemtoReg_wb,
										  Jump_wb,
										  JumpReg_wb,
										  branchSel_wb,
										
										  /* Else */
										  slow_clk, 
										  reset,
										
										  /* Input */
										  RegWrite_mem,
										  MemtoReg_mem,
										  Jump_mem,
										  JumpReg_mem,
										  branchSel_mem);
	
	/*----------------------------------------------------------------------*/
	
	
	/*----------------------------------------------------------------------*/
	/*									WB:Write Back											*/
	WB write_back (writeDataToReg_wb,
						readDataSRAM_wb,
						readDataRegFile_wb,
						MemtoReg_wb);
	/*----------------------------------------------------------------------*/
	
	
	ForwardingUnit forward_unit (ForwardA, 
										  ForwardB, 
										  RegWrite_mem,
										  RegWrite_wb,
										  Rs_ex, 
										  Rt_ex, 
										  writeRegOut_mem,
										  writeRegOut_wb);
	
	FlushForwardingUnit ffu (ForwardA_id, 
									 ForwardB_id, 
									 RegWrite_ex,
									 RegWrite_mem,
									 Rs_id, 
									 Rt_id, 
									 writeRegOut_ex,
									 writeRegOut_mem);
	
	Hazard_Detection_Unit hazard_detection_unit (PCWrite,
																IF_IDWrite,
																Stall,
																
																MemRead_ex,
																MemWrite_ex,
																MemRead_id,
																readData1_id,
																aluResult_ex,
																
																writeReg_ex,
																Rs_id,
																Rt_id);
																
	
endmodule
