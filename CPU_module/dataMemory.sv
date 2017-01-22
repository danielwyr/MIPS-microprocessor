module dataMemory (readData, 
						 clk, 
						 reset,
						 MemWrite, 
						 MemRead, 
						 writeData, 
						 address, 
						 SRAMProbe, 
						 SW);
	output [31:0] readData;
	input [31:0] writeData;
	input [10:0] address;
	input clk, reset, MemWrite, MemRead;

	//////////////////////////////////////////////////////////
	output [31:0] SRAMProbe;
	input [4:0] SW;
	//////////////////////////////////////////////////////////
	
	
	parameter READ = 1'b1, WRITE = 1'b0;
	parameter ENABLE = 1'b0, DISABLE = 1'b1;
	
	wire sram_wr, sram_eo;
	
	assign readData = (sram_eo & !sram_wr) ? writeData : 16'bz;
	
	SRAM sram (readData, clk, address, sram_wr, sram_eo, SRAMProbe, SW);
	
	
	
	assign sram_wr = (reset & MemWrite & ~MemRead) ? WRITE : READ;
	assign sram_eo = (reset & ~MemWrite & MemRead) ? ENABLE : DISABLE;
	
	/*always@(negedge clk)
	if(reset) begin
		if(MemWrite & ~MemRead) begin // write
			sram_wr = WRITE;
			sram_eo = DISABLE;
		end
		else if(~MemWrite & MemRead) begin // read
			sram_wr = READ;
			sram_eo = ENABLE;
		end
		else begin
			sram_wr = READ;
			sram_eo = DISABLE;
		end
	end
	else begin
		sram_wr = READ;
		sram_eo = DISABLE;
	end*/
endmodule
