module MEM_WB_CtPath(/* Output */
							RegWrite_wb,
							MemtoReg_wb,
							Jump_wb,
							JumpReg_wb,
							branchSel_wb,
							
							/* Else */
							clk, 
							reset,
							
							/* Input */
							RegWrite_mem,
							MemtoReg_mem,
							Jump_mem,
							JumpReg_mem,
							branchSel_mem);
	output RegWrite_wb,
			 MemtoReg_wb,
			 Jump_wb,
			 JumpReg_wb,
			 branchSel_wb;
	input clk, reset;
	input RegWrite_mem,
			MemtoReg_mem,
			Jump_mem,
			JumpReg_mem,
			branchSel_mem;
			
	always@(posedge clk)
	if(reset) begin
		RegWrite_wb <= RegWrite_mem;
		MemtoReg_wb <= MemtoReg_mem;
		Jump_wb <= Jump_mem;
		JumpReg_wb <= JumpReg_mem;
		branchSel_wb <= branchSel_mem;
	end
	else begin
		RegWrite_wb <= 1'b0;
		MemtoReg_wb <= 1'b0;
		Jump_wb <= 1'b0;
		Jump_wb <= 1'b0;
		branchSel_wb <= 1'b0;
	end
endmodule
