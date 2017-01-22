module Hazard_Detection_Unit (PCWrite,
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
	output PCWrite, IF_IDWrite, Stall;
	input MemRead_ex, MemWrite_ex, MemRead_id;
	input [4:0] writeReg_ex, Rs_id, Rt_id;
	input [31:0] readData1_id, aluResult_ex;
	
	always@(*)
	if(((MemRead_ex & ((writeReg_ex == Rs_id) | (writeReg_ex == Rt_id)))) |
		(MemRead_id & MemWrite_ex & (readData1_id == aluResult_ex)))begin
		PCWrite <= 1'b1;
		IF_IDWrite <= 1'b1;
		Stall <= 1'b1;
	end
	else begin
		PCWrite <= 1'b0;
		IF_IDWrite <= 1'b0;
		Stall <= 1'b0;
	end
endmodule
