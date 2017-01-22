module fullAdder(a, b, c, sum, carry);
	input a, b, c;
	output sum, carry;
	wire sum, carry;

	assign sum = a ^ b ^ c; // sum bit
	assign carry = ((a & b) | (b & c) | (a & c)); // carry bit

endmodule 