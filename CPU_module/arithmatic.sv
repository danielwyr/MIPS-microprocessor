module arithmatic(Sum, Cout, Overflow, A, B, Sel, Enable);
	output wire [31:0] Sum;
	output wire Cout, Overflow;
	
	input wire [31:0] A;
	input wire [31:0] B;
	input wire Sel, Enable;
	
	wire [31:0] P, G, newB;
	wire [32:0] C;
	
	assign C[0] = 1'b0 & ~Enable;
	assign newB = Sel ? (~B + 1) : B;
	
	
	generate 
	genvar i;
	for (i = 0; i < 32; i++) begin: calculate0
		partialFullAdder add0 (P[i], G[i], A[i], newB[i], C[i], Enable);
		assign C[i+1] = (G[i] | (P[i] & C[i])) & (~Enable);
		assign Sum[i] = (P[i] ^ C[i]) & (~Enable);
	end
	endgenerate
	
	assign Cout = C[32] & ~Enable;
	assign Overflow = (Cout ^ C[31]) & (~Enable);
	
endmodule
