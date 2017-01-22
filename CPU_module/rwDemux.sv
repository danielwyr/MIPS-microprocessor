module rwDemux(readWriteCtrl, addr, wr);
	output [31:0] readWriteCtrl;
	input [4:0] addr;
	input wr;
	
	wire [31:0] rwCtrl;
	wire wrIn;
	
	not in (wrIn, wr);

	demux1_32_1bit d (rwCtrl, addr, wrIn);
	
	// invert 32 read write signal
	generate 
	genvar i;
	for (i = 0; i < 32; i++) begin: wrL
		not wrLine (readWriteCtrl[i], rwCtrl[i]);
	end
	endgenerate
	
endmodule
