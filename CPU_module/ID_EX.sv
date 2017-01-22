module ID_EX (instruction_ex,
				  icm_pc_ex,
				  readData1_ex,
				  readData2_ex,
				  signExtendedInst_ex,
				  readReg2_ex,
				  writeReg_ex,
				  Rs_ex,
				  Rt_ex,
				  Rd_ex,
				  clk,
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
	output [31:0] instruction_ex, icm_pc_ex, readData1_ex, readData2_ex, signExtendedInst_ex;
	output [4:0] readReg2_ex, writeReg_ex;
	output [4:0] Rs_ex, Rt_ex, Rd_ex;
	input [31:0] instruction_id, icm_pc_id, readData1_id, readData2_id, signExtendedInst_id;
	input [4:0] readReg2_id, writeReg_id;
	input [4:0] Rs_id, Rt_id, Rd_id;
	input clk, reset, Stall;
	
	
	always@(posedge clk) 
	if(reset & !Stall) begin
		icm_pc_ex <= icm_pc_id;
		readData1_ex <= readData1_id;
		readData2_ex <= readData2_id;
		signExtendedInst_ex <= signExtendedInst_id;
		readReg2_ex <= readReg2_id;
		writeReg_ex <= writeReg_id;
		instruction_ex <= instruction_id;
		Rs_ex <= Rs_id;
		Rt_ex <= Rt_id;
		Rd_ex <= Rd_id;
	end
	else begin
		icm_pc_ex <= 32'b0;
		readData1_ex <= 32'b0;
		readData2_ex <= 32'b0;
		signExtendedInst_ex <= 32'b0;
		readReg2_ex <= 5'b0;
		writeReg_ex <= 5'b0;
		instruction_ex <= 32'b0;
		Rs_ex <= 5'b0;
		Rt_ex <= 5'b0;
		Rd_ex <= 5'b0;
	end
endmodule
