module FlushForwardingUnit(ForwardA_id, 
									 ForwardB_id, 
									 RegWrite_ex,
									 RegWrite_mem,
									 Rs_id, 
									 Rt_id, 
									 writeRegOut_ex,
									 writeRegOut_mem);
	output [1:0] ForwardA_id, ForwardB_id;
	input RegWrite_ex, RegWrite_mem;
	input [4:0] Rs_id, Rt_id, writeRegOut_ex, writeRegOut_mem;
	
	
	assign ForwardA_id =  ((RegWrite_ex & (writeRegOut_ex != 5'b0)) & 
								  (RegWrite_mem & (writeRegOut_mem != 5'b0)) &
								  (Rs_id == writeRegOut_mem)) ? 2'b01 : 
								  
								 ((RegWrite_ex & (writeRegOut_ex != 5'b0)) & 
								  (RegWrite_mem & (writeRegOut_mem != 5'b0)) &
								  (Rs_id == writeRegOut_ex)) ? 2'b10 : 2'b00;
							 
	assign ForwardB_id =  ((RegWrite_ex & (writeRegOut_ex != 5'b0)) & 
								  (RegWrite_mem & (writeRegOut_mem != 5'b0)) &
								  (Rt_id == writeRegOut_mem)) ? 2'b01 : 
								  
								 ((RegWrite_ex & (writeRegOut_ex != 5'b0)) & 
								  (RegWrite_mem & (writeRegOut_mem != 5'b0)) &
								  (Rt_id == writeRegOut_ex)) ? 2'b10 : 2'b00;
endmodule
