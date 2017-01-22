module ALU_Control(ALUCtrl, functionField, ALUOp, JumpReg);
	output reg [2:0]ALUCtrl; // Control scheme 
	output reg JumpReg;
	input [5:0]functionField; // Function Fiedld
	input [1:0]ALUOp;		  // ALU Operation Code

	parameter DISABLE = 1'b0, ENABLE = 1'b1;
	parameter R_TYPE = 2'b10, I_TYPE = 2'b00, BGT_TYPE = 2'b01;
	parameter NOP = 3'b000, 
				 ADD = 3'b001, 
				 SUB = 3'b010, 
				 AND = 3'b011,
				 OR  = 3'b100,
				 XOR = 3'b101,
				 SLT = 3'b110,
				 SLL = 3'b111; 
always@(*)
	if(ALUOp == R_TYPE) begin
      case(functionField)        
         6'b100000: begin 
							ALUCtrl = ADD;    //ADDITION
							JumpReg = DISABLE;
						  end
         6'b100010: begin
							ALUCtrl = SUB;    //SUBTRACTION
							JumpReg = DISABLE;
						  end
         6'b100100: begin 
							ALUCtrl = AND;    //AND
							JumpReg = DISABLE;
						  end
         6'b100101: begin 
							ALUCtrl = OR;    //OR
							JumpReg = DISABLE;
						  end
         6'b100110: begin 
							ALUCtrl = XOR;    //XOR 
							JumpReg = DISABLE;
						  end
			6'b101010: begin
							ALUCtrl = SLT;    //SLT
							JumpReg = DISABLE;
						  end
         6'b000000: begin 
							ALUCtrl = SLL;    //SLL	  
							JumpReg = DISABLE;
						  end
			6'b001000: begin 
							ALUCtrl = NOP;		// JR
							JumpReg = ENABLE;
						  end
			default: begin 
							ALUCtrl = NOP;	//NON OPERATION
							JumpReg = DISABLE;
						end
		endcase
    end
    else if(ALUOp == I_TYPE) begin    //  LW/SW Type Instructions
        ALUCtrl = ADD;               //ADDITION irrespective of the FunctField.
		  JumpReg = DISABLE;
    end
    else if(ALUOp == BGT_TYPE) begin   //   BGT Type Instructions
        ALUCtrl = SUB;               //SUBTRACTION irrespective of the FunctField.
		  JumpReg = DISABLE;
    end
	else begin
		ALUCtrl = NOP;
		JumpReg = DISABLE;
	end        
 
endmodule  