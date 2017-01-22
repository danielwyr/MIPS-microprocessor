module SRAM (data, clk, addr, wr, enableOutput, SRAMProbe, SW);
	inout [15:0] data;
	//output [15:0] probe;
	input [10:0] addr;
	input clk;
	input wr, enableOutput; // wr: 0 for write, 1 for read
	
	
	
	//////////////////////////////////////////////////////////
	output [31:0] SRAMProbe;
	input [4:0] SW;
	
	assign SRAMProbe = m[SW];
	//////////////////////////////////////////////////////////
	
	
	
	//reg [15:0] m[2047:0];
	//reg [15:0] m[1023:0];
	reg [15:0] m [127:0];
	
	reg [15:0] dataReg;
	
	assign data = !enableOutput ? dataReg : 16'bz; // low true output enbale
	
	always@(addr)
	dataReg = m[addr];
	
	
	always@(posedge clk)
	if(enableOutput & !wr)
	m[addr] <= data; // write
	else
	m <= m;
endmodule
