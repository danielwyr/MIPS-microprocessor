module demux1_2_1bit(a, b, in, sel);
	output a, b;
	input sel, in;
	
	wire in1, in2;
	not l1 (in1, sel);
	buf l2 (in2, sel);

	and a1 (a, in, in1);
	and a2 (b, in, in2);
endmodule
