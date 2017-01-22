module ID_EX_CtPath(/* Output  */
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
						  clk,
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
	output RegWrite_ex, Branch_ex, RegDst_ex, ALUSrc_ex, MemRead_ex, MemWrite_ex, MemtoReg_ex, Jump_ex;
	output [1:0] ALUOp_ex;
	input clk, reset;
	input RegWrite_id, Branch_id, RegDst_id, ALUSrc_id, MemRead_id, MemWrite_id, MemtoReg_id, Jump_id;
	input [1:0] ALUOp_id;
	
	
	always@(posedge clk)
	if(reset) begin
		RegWrite_ex <= RegWrite_id;
		Branch_ex <= Branch_id;
		RegDst_ex <= RegDst_id;
		ALUSrc_ex <= ALUSrc_id;
		ALUOp_ex <= ALUOp_id;
		Jump_ex <= Jump_id;
		MemRead_ex <= MemRead_id;
		MemWrite_ex <= MemWrite_id;
		MemtoReg_ex <= MemtoReg_id;
	end
	else begin
		RegWrite_ex <= 1'b0;
		Branch_ex <= 1'b0;
		RegDst_ex <= 1'b0;
		ALUSrc_ex <= 1'b0;
		ALUOp_ex <= 2'b0;
		Jump_ex <= 1'b0;
		MemRead_ex <= 1'b0;
		MemWrite_ex <= 1'b0;
		MemtoReg_ex <= 1'b0;
	end
endmodule
