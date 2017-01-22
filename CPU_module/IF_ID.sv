module IF_ID (instruction_n, 
				  icm_pc_n, 
				  clk, 
				  reset, 
				  IF_IDWrite,
				  IF_Flush,
				  instruction_p, 
				  icm_pc_p);
				  
	output reg [31:0] instruction_n, icm_pc_n;
	input [31:0] instruction_p, icm_pc_p;
	input clk, reset, IF_IDWrite, IF_Flush;
	
	reg [2:0] flush_n, flush_p;
	parameter END = 3'b11;
	
	always@(*)
	if(IF_Flush)
	flush_n <= END;
	else if(!IF_Flush & (flush_p != 3'b0))
	flush_n <= flush_p - 3'b1;
	else 
	flush_n <= flush_p;
	
	always@(posedge clk)
	flush_p <= flush_n;
	
	always@(posedge clk)
	if(reset & !IF_IDWrite) begin
		//if(flush == 2'b0) instruction_n[31:26] <= instruction_p[31:26];
		//else instruction_n[31:26] <= 6'b0;
		//instruction_n[25:0] <= instruction_p[25:0];
		
		if(flush_p == 3'b0)  begin 
			instruction_n <= instruction_p;
			icm_pc_n <= icm_pc_p;
		end
		else begin
			instruction_n <= 32'b0;
			icm_pc_n <= icm_pc_n;
		end
	end
	else begin
		instruction_n <= 32'b0;
		icm_pc_n <= 32'b0;
	end
endmodule
