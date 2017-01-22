module Dflipflop (Q, clk, reset, D);
	output reg Q;
	input D, clk, reset;
		
	always@(negedge clk)
	if(reset)
	Q <= D;
	else 
	Q <= 1'b0;
endmodule 