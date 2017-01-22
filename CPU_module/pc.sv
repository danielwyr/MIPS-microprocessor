module pc(out, clk, reset, PCWrite, in);
	output [31:0] out;
	input [31:0] in;
	input clk, reset, PCWrite;

	
	always@(posedge clk)
	if(reset) begin
		if(!PCWrite)
			out <= in;
		else 
			out<= out;
	end
	else 
		out <= 32'b0;
endmodule
