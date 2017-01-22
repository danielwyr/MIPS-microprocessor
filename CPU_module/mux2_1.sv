module mux2_1 (c, a, b, sel);
	output [31:0] c;
	input [31:0] a, b;
	input sel;

	
	wire [31:0] o1, o2;
	wire nsel, ysel;
	not n1 (nsel, sel);
	buf n2 (ysel, sel);
	
	generate
	genvar i;
	for(i = 0; i < 32; i++) begin: mux21
		and a1 (o1[i], a[i], nsel);
		and a2 (o2[i], b[i], ysel);
		or out (c[i], o1[i], o2[i]);
	end
	endgenerate
endmodule
