module test_phase2(GPIO_0, GPIO_1, zero, overflow, carryOut, negative, breakPoint, reset, clk, SW);
	output [31:0] GPIO_0;
	output [31:0] GPIO_1;
	output zero, overflow, carryOut, negative;
	input clk, reset, breakPoint;
	input [9:0] SW;
	
	
	reg setUp_run_p, setUp_run_n;
	reg run_STEP_p, run_STEP_n;
	reg [4:0] loadCounter_p, loadCounter_n;
	reg [15:0] dataToSRAM_p, dataToSRAM_n;
	reg [10:0] addressToSRAM_p, addressToSRAM_n;
	reg [31:0] dataToReg_p, dataToReg_n;
	reg [4:0] writeAddressToReg_p, writeAddressToReg_n; 
	reg [4:0] readAddressToReg1_p, readAddressToReg1_n;
	reg [4:0] readAddressToReg2_p, readAddressToReg2_n;

	reg SRAM_wr, sram_eo;
	reg regfile_wr;
	reg [2:0] Ctrl_p, Ctrl_n;
	
	wire [31:0] aluOut;
	wire [15:0] mainBus;
	wire [31:0] regData1, regData2;
	
	assign GPIO_0[15:0] = SW[0] ? regData1[15:0] : dataToSRAM_p;
	assign GPIO_0[31:16] = SW[1] ? regData2[15:0] : addressToSRAM_p;
	
	assign GPIO_1[15:0] = SW[2] ? mainBus : dataToReg_p[15:0];
	assign GPIO_1[20:16] = writeAddressToReg_p;
	assign GPIO_1[25:21] = readAddressToReg1_p;
	assign GPIO_1[30:26] = readAddressToReg2_p;
	
	
	//////////////////////////////////////////////////////////////////////////
	// Clock divider
	reg [31:0] divided_clocks;
	initial
	divided_clocks = 0;

	always @(posedge clk)
	divided_clocks = divided_clocks + 1;
	
	parameter SELECTED_CLOCK = 2;
	//////////////////////////////////////////////////////////////////////////
	
	parameter SETUP = 1'b0, RUN = 1'b1;
	parameter ENABLE = 1'b0, DISABLE = 1'b1;
	parameter READ = 1'b1, WRITE = 1'b0;
	parameter LOAD = 1'b0, DECODE =1'b1;
	
	
	//SRAM_mod sram (mainBus, divided_clocks[SELECTED_CLOCK + 1], addressToSRAM_p, SRAM_wr, sram_eo/*, probe[15:0]*/);
	SRAM sram (mainBus, addressToSRAM_p, SRAM_wr, sram_eo);
	registerFile regfile (regData1, regData2, divided_clocks[SELECTED_CLOCK + 1], reset, readAddressToReg1_p, readAddressToReg2_p, writeAddressToReg_p, dataToReg_p, regfile_wr);
	ALU alu (aluOut, zero, overflow, carryOut, negative, regData1, regData2, Ctrl_p);
	
	assign mainBus = !setUp_run_p ? dataToSRAM_p : 16'bz;
	// Setup-Run Logic
	always@(*)
	case(setUp_run_p)
	SETUP: if(loadCounter_p < 24) begin
				sram_eo = DISABLE;
				setUp_run_n	= SETUP; // within setup step
				run_STEP_n = LOAD;
				loadCounter_n = loadCounter_p + 5'b1;
				addressToSRAM_n = loadCounter_p/* + 11'b1*/;
				
				/*					SRAM
					address 				data
					0 - 7					0 - 7 -- data
					8 - 15				7 - 0 -- data
					15 - 23				0 - 7 -- instruction
				*/
				
				if(loadCounter_p < 8) begin
					dataToSRAM_n = loadCounter_p; // 0 - 8
				end
				else if((loadCounter_p >= 8) & (loadCounter_p < 16)) begin
					dataToSRAM_n = 5'b1111 - loadCounter_p; // 8 - 0
				end
				else begin
					dataToSRAM_n = loadCounter_p - 5'b10000;
				end
				
				//regFile bus
				//regfile_wr = READ;
				dataToReg_n = 32'b0;
				writeAddressToReg_n = 5'b0;
				readAddressToReg1_n = 5'b0;
				readAddressToReg2_n = 5'b0;
				
				// ALU bus
				Ctrl_n = 3'b0;
			end
			else begin
				sram_eo = DISABLE;
				// break point
				if(breakPoint == 1'b0) begin
					setUp_run_n = SETUP;
					run_STEP_n = LOAD;
					loadCounter_n = loadCounter_p;
				end
				else begin
					setUp_run_n = RUN;
					run_STEP_n = LOAD;
					loadCounter_n = 5'b0;
				end
				addressToSRAM_n = 11'b0;
				dataToSRAM_n = 16'b0;
				
				// regFile bus
				//regfile_wr = READ;
				dataToReg_n = 32'b0;
				writeAddressToReg_n = 5'b0;
				readAddressToReg1_n = 5'b0;
				readAddressToReg2_n = 5'b0;
				
				// ALU bus
				Ctrl_n = 3'b0;
			end
	RUN: begin
				sram_eo = ENABLE;
				setUp_run_n = RUN;
				case(run_STEP_p)
				LOAD: if(loadCounter_p < 16) begin // load data from SRAM to regFile
							run_STEP_n = LOAD;
							loadCounter_n = loadCounter_p + 5'b1;
							addressToSRAM_n = loadCounter_p + 11'b1;
							if(loadCounter_p == 0)
								writeAddressToReg_n = 5'b0;
							else
								writeAddressToReg_n = loadCounter_p/* - 5'b1*/;
							dataToReg_n = mainBus;
							//regfile_wr = WRITE;
							readAddressToReg1_n = 5'b0;
							readAddressToReg2_n = 5'b0;
							
							// ALU bus
							Ctrl_n = 3'b0;
						end
						else begin
							// break point
							if(breakPoint == 1'b0) begin
								run_STEP_n = LOAD;
								loadCounter_n = loadCounter_p;
								addressToSRAM_n = addressToSRAM_p;
								writeAddressToReg_n = writeAddressToReg_p;
								dataToReg_n = dataToReg_p;
								//regfile_wr = READ;
								readAddressToReg1_n = 5'b0;
								readAddressToReg2_n = 5'b0;
								
								// ALU bus
								Ctrl_n = 3'b0;
							end
							else begin
								run_STEP_n = DECODE;
								loadCounter_n = 5'b0;
								addressToSRAM_n = 11'b10000;
								writeAddressToReg_n = 5'b10000;
								dataToReg_n = 32'b0;
								//regfile_wr = READ;
								readAddressToReg1_n = 5'b0;
								readAddressToReg2_n = 5'b1000;
								
								// ALU bus
								Ctrl_n = 3'b0;
							end
						end
				DECODE: if(loadCounter_p < 8) begin // Decode Data from regFile and SRAM and store to regFile
								run_STEP_n = DECODE;
								loadCounter_n = loadCounter_p + 5'b1;
								addressToSRAM_n = loadCounter_p + 11'b10000 + 11'b1;
								//regfile_wr = WRITE;
								writeAddressToReg_n = 5'b10000 + loadCounter_p + 5'b1;
								dataToReg_n = aluOut;
								readAddressToReg1_n = loadCounter_p + 5'b1;
								readAddressToReg2_n = loadCounter_p + 5'b1000 + 5'b1;
								
								// ALU bus
								Ctrl_n = mainBus[2:0] + 3'b1;
								//Ctrl_n = loadCounter_p[2:0];
						  end
						  else begin
								run_STEP_n = DECODE;
								loadCounter_n = loadCounter_p;
								addressToSRAM_n = addressToSRAM_p;
								//regfile_wr = READ;
								writeAddressToReg_n = writeAddressToReg_p;
								dataToReg_n = aluOut;
								readAddressToReg1_n = readAddressToReg1_p;
								readAddressToReg2_n = readAddressToReg2_p;
								
								// ALU bus
								//Ctrl = mainBus[2:0];
								Ctrl_n = 3'b0;
						  end
				default: begin 
								sram_eo = ENABLE;
								setUp_run_n = RUN;
								run_STEP_n = LOAD;
								addressToSRAM_n = loadCounter_p;
								loadCounter_n = loadCounter_p;
								writeAddressToReg_n = loadCounter_p;
								dataToReg_n = dataToReg_p;
								//regfile_wr = READ;
								readAddressToReg1_n = 5'b0;
								readAddressToReg2_n = 5'b0;
								
								// ALU bus
								Ctrl_n = 3'b0;
							end
				endcase
		  end
	default begin 
					setUp_run_n = SETUP;
					sram_eo = ENABLE;
					run_STEP_n = DECODE;
					loadCounter_n = 5'b0;
					addressToSRAM_n = 11'b0;
					writeAddressToReg_n = 5'b0;
					dataToReg_n = 32'b0;
					//regfile_wr = READ;
					readAddressToReg1_n = 5'b0;
					readAddressToReg2_n = 5'b0;
					
					// ALU bus
					Ctrl_n = 3'b0;
			  end
	endcase
	
	
	// load sram data control
	always@(posedge divided_clocks[SELECTED_CLOCK + 1])
	if(reset) // low true
	begin
		// state machine control
		loadCounter_p <= loadCounter_n;
		setUp_run_p <= setUp_run_n;
		run_STEP_p <= run_STEP_n;
		
		// sram bus
		dataToSRAM_p <= dataToSRAM_n;
		addressToSRAM_p <= addressToSRAM_n;
		
		// regFile bus
		dataToReg_p <= dataToReg_n;
		writeAddressToReg_p <= writeAddressToReg_n;
		readAddressToReg1_p <= readAddressToReg1_n;
		readAddressToReg2_p <= readAddressToReg2_n;
		
		//ALU bus
		Ctrl_p <= Ctrl_n;
	end
	else 
	begin
		loadCounter_p <= 5'b0;
		setUp_run_p <= SETUP;
		run_STEP_p <= LOAD;
		
		// sram bus
		dataToSRAM_p <= 16'b0;
		addressToSRAM_p <= 11'b0;
		
		// regFile bus
		dataToReg_p <= 32'b0;
		writeAddressToReg_p <= 5'b0;
		readAddressToReg1_p <= 5'b0;
		readAddressToReg2_p <= 5'b0;
		
		//ALU bus
		Ctrl_p <= 3'b0;
	end
	
	// sram read-write control
	always@(posedge divided_clocks[SELECTED_CLOCK])
	if(reset) begin
	case(setUp_run_p)
		SETUP: begin 
					SRAM_wr = ~SRAM_wr;
				 end
		RUN: begin
					SRAM_wr = READ;
			  end
	default: begin
					SRAM_wr = READ;
				end
	endcase
	end
	else begin
		SRAM_wr = READ;
	end
	
	// regFile read-write control
	always@(posedge divided_clocks[SELECTED_CLOCK - 1])
	if(reset) begin
	case(setUp_run_p)
		SETUP: begin 
					regfile_wr = READ;
				 end
		RUN: begin
					regfile_wr = ~regfile_wr;
			  end
	default: begin
					regfile_wr = READ;
				end
	endcase
	end
	else begin
		regfile_wr = READ;
	end
	
endmodule



module test_phase2_testbench();
 reg clk, reset, breakPoint;
 wire [31:0] dataShow;
 wire [31:0] probe;
 wire zero, overflow, carryOut, negative;

 test_phase2 dut (dataShow, probe, zero, overflow, carryOut, negative, breakPoint, reset, clk);

 // Set up the clock.
 parameter CLOCK_PERIOD=10;
 initial clk=1;
 always begin
 #(CLOCK_PERIOD/2);
 clk = ~clk;
 end

 // Set up the inputs to the design. Each line is a clock cycle.
 initial begin
	#10 reset <= 0; breakPoint <= 1'b1; 
	#20 reset <= 1;
	#200000									
 $stop; // End the simulation.
 end
endmodule 