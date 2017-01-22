module signExtended (out, in);
	output [31:0] out;
	input [15:0] in;
	
	assign out[31:16] = in[15] ? 16'b1111111111111111 : 16'b0000000000000000;
	assign out[15:0] = in[15:0];
endmodule

