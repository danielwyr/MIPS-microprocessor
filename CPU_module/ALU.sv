module ALU(out, zero, overflow, carryOut, negative, busA, busB, Ctrl);
	output [31:0] out;
	output zero, overflow, carryOut, negative;
	input [31:0] busA, busB;
	input [2:0] Ctrl;
	
	
	parameter NOP = 3'b000;
	parameter ADD = 3'b001;
	parameter SUB = 3'b010;
	parameter AND = 3'b011;
	parameter OR = 3'b100;
	parameter XOR = 3'b101;
	parameter SLT = 3'b110;
	parameter SLL = 3'b111;
	
	wire [31:0] outMux[6:0];
	wire [6:0] enable;
	wire operator;

	assign enable = (Ctrl == NOP) ? 7'b1111111 : 
						 (Ctrl == ADD) ? 7'b1111101 : 
						 (Ctrl == SUB) ? 7'b1111101 : 
						 (Ctrl == AND) ? 7'b1111011 : 
						 (Ctrl == OR) ? 7'b1110111 : 
						 (Ctrl == XOR) ? 7'b1101111 : 
						 (Ctrl == SLT) ? 7'b1011111 : 7'b0111111;
					 
	assign operator = (Ctrl == SUB) ? 1'b1 : 1'b0;
	
	assign outMux[0] = 32'b0;
	
	arithmatic arm (outMux[1], carryOut, overflow, busA, busB, operator, enable[1]);
	
	andOperation andO (outMux[2], busA, busB, enable[2]);
	
	orOperation orO (outMux[3], busA, busB, enable[3]);
	
	xorOperation xorO (outMux[4], busA, busB, enable[4]);
	
	SLT slt (outMux[5], busA, busB, enable[5]);
	
	SLL sll (outMux[6], busA, busB[1:0], enable[6]);
	
	

	assign out = (Ctrl == NOP) ? outMux[0] : 
					 (Ctrl == ADD) ? outMux[1] : 
					 (Ctrl == SUB) ? outMux[1] : 
					 (Ctrl == AND) ? outMux[2] : 
					 (Ctrl == OR) ? outMux[3] : 
					 (Ctrl == XOR) ? outMux[4] : 
					 (Ctrl == SLT) ? outMux[5] : outMux[6];
	assign negative = out[31];
	assign zero = (out == 32'b0);
endmodule
