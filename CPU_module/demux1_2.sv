module demux1_2(a, b, in, sel);
	output [31:0] a, b;
	input [31:0] in;	
	input sel;
	
	wire in1, in2;
	not l1 (in1, sel);
	buf l2 (in2, sel);
	
	generate
	genvar i;
	for(i = 0; i < 32; i++) begin: demux12
		and a1 (a[i], in[i], in1);
		and a2 (b[i], in[i], in2);
	end
	endgenerate
endmodule
