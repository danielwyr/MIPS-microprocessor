module partialFullAdder(P, G, A, B, Cin, Enable);
	output wire P, G;
	input A, B, Cin, Enable;
	
	assign P = (A ^ B) & (~Enable);
	assign G = (A & B) & (~Enable);

endmodule 