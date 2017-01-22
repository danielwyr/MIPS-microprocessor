module regDisplay(clk, rst, sel, regVal1, regVal2, led);
	output [7:0] led;
	input [31:0] regVal1, regVal2;
	input clk, rst, sel;

	parameter LOW = 1'b1;
	parameter HIGH = 1'b0;
	parameter ZERO = 4'b0000;
	parameter ONE = 4'b0001;
	parameter OFF = 8'b00000000;

	reg [7:0] curReg;
	reg [7:0] curDisplay;
	
	always @(*)
	if (sel == LOW)
	begin
		curReg = regVal1[7:0];
	end
	else
	begin
		curReg = regVal2[7:0];
	end
	
	
	always @(posedge clk) 
	if (!rst)
	begin	
		curDisplay <= OFF;
		led <= OFF;
	end
	else
	begin
		curDisplay <= curReg;
		led <= curDisplay;
	end
	

endmodule
