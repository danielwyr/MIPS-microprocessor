module IF(instruction, 
			 icm_pc, 
			 clk, 
			 reset, 
			 branchSel, 
			 Jump, 
			 JumpReg, 
			 PCWrite,
			 branchTrue, 
			 icm_pc_wb,
			 readData1_ex,
			 jumpAddr_wb,
			 pcProbe);
	output [31:0] instruction, icm_pc;
	input [31:0] branchTrue, readData1_ex, jumpAddr_wb, icm_pc_wb;
	input clk, reset;
	input branchSel, Jump, JumpReg, PCWrite;
	
	output [31:0] pcProbe;
	assign pcProbe = p_counter;
	

	/*----------------------------------------------------------------------*/
	// program counter circuit
	// output p_counter --> instruction_mem
	// input <-- Jump, signExtendedInst, branchSel, instruction
	reg [31:0] p_counter, n_counter;
	wire [31:0] sft_instruction, sft_signExtendedInst;
	wire [31:0] branchTrue, branchFalse;
	wire [31:0] jumpTrue, jumpFalse;
	wire [31:0] jumpRegTrue, jumpRegFalse;
	
	pc program_counter (p_counter, clk, reset, PCWrite, n_counter);
	
	assign icm_pc = p_counter + 32'b100; // pc + 4
	
	
	
	assign branchFalse = icm_pc;
	mux2_1 branch_mux (jumpFalse, branchFalse, branchTrue, branchSel); // bgt datapath
	
	assign jumpTrue = jumpAddr_wb;
	mux2_1 jump_mux (jumpRegFalse, jumpFalse, jumpTrue, Jump); // jump datapath
	
	assign jumpRegTrue = readData1_ex << 2;
	mux2_1 jumpReg_mux (n_counter, jumpRegFalse, jumpRegTrue, JumpReg); // jump register datapath
	/*----------------------------------------------------------------------*/
	
	
	/*----------------------------------------------------------------------*/
	// instruction memory circuit
	// output instruction
	// input p_counter
	reg [31:0] instruction;
	instruction_mem im (instruction, reset, p_counter[8:2]);
	/*----------------------------------------------------------------------*/

endmodule
