module ForwardingUnit(ForwardA, 
							 ForwardB, 
							 RegWrite_mem,
							 RegWrite_wb,
							 Rs_ex, 
							 Rt_ex, 
							 writeRegOut_mem,
							 writeRegOut_wb);
	output [1:0] ForwardA, ForwardB;
	input RegWrite_mem, RegWrite_wb;
	input [4:0] Rs_ex, Rt_ex, writeRegOut_mem, writeRegOut_wb;
	
	
	assign ForwardA =  (RegWrite_wb &
							 (writeRegOut_wb != 5'b0) &
							 !(RegWrite_mem & (writeRegOut_mem != 5'b0)) &
							 (writeRegOut_mem != writeRegOut_mem) &
							 (writeRegOut_wb == Rs_ex)) ? 2'b01 : 
							 
							 ((RegWrite_mem & (writeRegOut_mem != 5'b0)) & 
							  (RegWrite_wb & (writeRegOut_wb != 5'b0)) &
							  (Rs_ex == writeRegOut_wb)) ? 2'b01 : 
							  
							 ((RegWrite_mem & (writeRegOut_mem != 5'b0)) & 
							  (RegWrite_wb & (writeRegOut_wb != 5'b0)) &
							  (Rs_ex == writeRegOut_mem)) ? 2'b10 : 2'b00;
							 
	assign ForwardB =  (RegWrite_wb &
							 (writeRegOut_wb != 5'b0) &
							 !(RegWrite_mem & (writeRegOut_mem != 5'b0)) &
							 (writeRegOut_mem != writeRegOut_mem) &
							 (writeRegOut_wb == Rt_ex)) ? 2'b01 : 
							 
							 ((RegWrite_mem & (writeRegOut_mem != 5'b0)) & 
							  (RegWrite_wb & (writeRegOut_wb != 5'b0)) &
							  (Rt_ex == writeRegOut_wb)) ? 2'b01 : 
							  
							 ((RegWrite_mem & (writeRegOut_mem != 5'b0)) & 
							  (RegWrite_wb & (writeRegOut_wb != 5'b0)) &
							  (Rt_ex == writeRegOut_mem)) ? 2'b10 : 2'b00;
endmodule
