module andOperation (out, operandOne, operandTwo, enable);
// Enable: LOW TRUE
	input [31:0] operandOne, operandTwo;
	input enable;
	output [31:0] out;
	assign out = ( operandOne & operandTwo ) & ( ~enable );

endmodule
 

