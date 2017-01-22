module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, GPIO_0, GPIO_1); 
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output [9:0] LEDR;
	output [35:0] GPIO_0;
	output [35:0] GPIO_1;
	input [3:0] KEY;
	input [9:0] SW;
	input CLOCK_50;
	
	
	cpuCore cpu (CLOCK_50, KEY[0], GPIO_0, GPIO_1, SW);
endmodule
