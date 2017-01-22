module control(Branch, 
					ALUOp, 
					MemRead, 
					MemWrite, 
					MemtoReg, 
					RegDst, 
					RegWrite, 
					ALUSrc, 
					Jump, 
					IF_Flush,
					OpCode_id,
					functionField,
					bgt_id);
		output reg				Branch;
		output reg [1:0]		ALUOp;
		output reg				MemRead, MemWrite, MemtoReg;
		output reg				RegDst, RegWrite, ALUSrc;
		output reg				Jump;
		output reg				IF_Flush;
		input  wire	[5:0]	OpCode_id, functionField;
		input  wire bgt_id;

		parameter R = 6'b000000,
					 ADDI = 6'b001000,
					 LW = 6'b100011, 
					 SW = 6'b101011, 
					 BGT = 6'b000111, 
					 J = 6'b000010; 
		
		
	always @(*) begin	
		case (OpCode_id)
			R: begin	/* R Type */
				ALUOp[1:0]	<= 2'b10;
				ALUSrc		<= 1'b0;
				Branch		<= 1'b0;
				MemRead		<= 1'b0;
				MemtoReg		<= 1'b0;
				MemWrite		<= 1'b0;
				RegDst		<= 1'b1;
				RegWrite		<= 1'b1;
				Jump			<= 1'b0;
				if(functionField == 6'b001000) //JR
				IF_Flush		<= 1'b1;
				else 
				IF_Flush		<= 1'b0;
			end
			ADDI: begin /* Add Immediately */
				ALUOp[1:0]	<= 2'b00;
				ALUSrc		<= 1'b1;
				Branch		<= 1'b0;
				MemRead		<= 1'b0;
				MemtoReg		<=	1'b0;
				MemWrite		<=	1'b0;
				RegDst		<=	1'b0;
				RegWrite		<=	1'b1;
				Jump			<= 1'b0;
				IF_Flush		<= 1'b0;
			end
			LW: begin	/* lw */
				ALUOp[1:0]	<= 2'b00;
				ALUSrc		<= 1'b1;
				Branch		<= 1'b0;
				MemRead		<= 1'b1;
				MemtoReg		<= 1'b1;
				MemWrite		<= 1'b0;
				RegDst		<= 1'b0;
				RegWrite		<= 1'b1;
				Jump			<= 1'b0;
				IF_Flush		<= 1'b0;
			end
			SW: begin	/* sw */
				ALUOp[1:0]	<= 2'b00;
				ALUSrc		<= 1'b1;
				Branch		<= 1'b0;
				MemRead		<= 1'b0;
				MemtoReg		<= 1'b0;
				MemWrite		<= 1'b1;
				RegDst		<= 1'bX;
				RegWrite		<= 1'b0;
				Jump			<= 1'b0;
				IF_Flush		<= 1'b0;
			end
			BGT: begin	/* bgt */
				ALUOp[1:0]	<= 2'b01;
				ALUSrc		<= 1'b0;
				Branch		<= 1'b1;
				MemRead		<= 1'b0;
				MemtoReg		<= 1'bX;
				MemWrite		<= 1'b0;
				RegDst		<= 1'bX;
				RegWrite		<= 1'b0;
				Jump			<= 1'b0;
				if(bgt_id == 1'b1) 
				IF_Flush		<= 1'b1;
				else 
				IF_Flush 	<= 1'b0;
			end
			J: begin		/* Jump */
				ALUOp[1:0]	<= 2'b11;
				ALUSrc		<= 1'b0;
				Branch		<= 1'b0;
				MemRead		<= 1'b0;
				MemtoReg		<= 1'b0;
				MemWrite		<= 1'b0;
				RegDst		<= 1'b0;
				RegWrite		<= 1'b0;
				Jump			<= 1'b1;
				IF_Flush		<= 1'b1;
			end
			
		
			default: begin/* defaults */
				ALUOp[1:0]	<= 2'b11;
				ALUSrc		<= 1'b0;
				Branch		<= 1'b0;
				MemRead		<= 1'b0;
				MemtoReg		<= 1'b0;
				MemWrite		<= 1'b0;
				RegDst		<= 1'b0;
				RegWrite		<= 1'b0;
				Jump			<= 1'b0;
				IF_Flush		<= 1'b0;
			end
		endcase
	end
endmodule
