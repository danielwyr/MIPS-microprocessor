module EX_MEM_CtPath (/* Output */
							 RegWrite_mem, /* WB */
							 MemtoReg_mem,
							 Jump_mem,
							 JumpReg_mem,
							 
							 Branch_mem, /* M */
							 MemRead_mem,
							 MemWrite_mem,
							 
							 /* Else */
							 clk,
							 reset,
							 
							 /* Input */
							 RegWrite_ex, /* WB */
							 MemtoReg_ex,
							 Jump_ex,
							 JumpReg_ex,
							 
							 Branch_ex, /* M */
							 MemRead_ex,
							 MemWrite_ex);
	output RegWrite_mem, /* WB */
			 MemtoReg_mem,
			 Jump_mem,
			 JumpReg_mem,
							 
			 Branch_mem, /* M */
			 MemRead_mem,
			 MemWrite_mem;
	
	input clk, reset;
	input RegWrite_ex, /* WB */
		   MemtoReg_ex,
			Jump_ex,
			JumpReg_ex,
		   
		   Branch_ex, /* M */
		   MemRead_ex,
		   MemWrite_ex;
			
	always@(posedge clk)
	if(reset) begin
		RegWrite_mem <= RegWrite_ex;
		MemtoReg_mem <= MemtoReg_ex;
		Branch_mem <= Branch_ex;
		MemRead_mem <= MemRead_ex;
		MemWrite_mem <= MemWrite_ex;
		Jump_mem <= Jump_ex;
		JumpReg_mem <= JumpReg_ex;
	end
	else begin
		RegWrite_mem <= 1'b0;
		MemtoReg_mem <= 1'b0;		 
		Branch_mem <= 1'b0;
		MemRead_mem <= 1'b0;
		MemWrite_mem <= 1'b0;
		Jump_mem <= 1'b0;
		JumpReg_mem <= 1'b0;
	end
endmodule
