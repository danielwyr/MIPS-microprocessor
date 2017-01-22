module hexDisplay(rst, hexOut, numIn);
  output [6:0] hexOut;
  input [3:0] numIn;
  input rst;
  
  reg [6:0] hexVal;

  parameter DISPLAY = 1'b0;         // If HEX needs to be displayed
  parameter OFF = 7'b1111111;       // HEX display off when HEX is not needed
  parameter ZERO = 7'b1000000;      // HEX value 0
  parameter ONE = 7'b1111001;       // HEX value 1
  parameter TWO = 7'b0100100;       // HEX value 2
  parameter THREE = 7'b0110000;     // HEX value 3
  parameter FOUR = 7'b0011001;      // HEX value 4
  parameter FIVE = 7'b0010010;      // HEX value 5
  parameter SIX = 7'b0000010;       // HEX value 6
  parameter SEVEN = 7'b1111000;     // HEX value 7
  parameter EIGHT = 7'b0000000;     // HEX value 8
  parameter NINE = 7'b0010000;      // HEX value 9
  parameter TEN = 7'b0001000;       // HEX value 10(a)
  parameter ELEVEN = 7'b0000011;    // HEX value 11(b)
  parameter TWELVE = 7'b0100111;    // HEX value 12(c)
  parameter THIRTEEN = 7'b0100001;  // HEX value 13(d)
  parameter FOURTEEN = 7'b0000110;  // HEX value 14(e)
  parameter FIFTEEN = 7'b0001110;   // HEX value 15(f)
  parameter NUM_ZERO = 4'b0000;     // Input num value 0
  parameter NUM_ONE = 4'b0001;      // Input num value 1
  parameter NUM_TWO = 4'b0010;      // Input num value 2
  parameter NUM_THREE = 4'b0011;    // Input num value 3
  parameter NUM_FOUR = 4'b0100;     // Input num value 4
  parameter NUM_FIVE = 4'b0101;     // Input num value 5
  parameter NUM_SIX = 4'b0110;      // Input num value 6
  parameter NUM_SEVEN = 4'b0111;    // Input num value 7
  parameter NUM_EIGHT = 4'b1000;    // Input num value 8
  parameter NUM_NINE = 4'b1001;     // Input num value 9
  parameter NUM_TEN = 4'b1010;      // Input num value 10
  parameter NUM_ELEVEN = 4'b1011;   // Input num value 11
  parameter NUM_TWELVE = 4'b1100;   // Input num value 12
  parameter NUM_THIRTEEN = 4'b1101; // Input num value 13
  parameter NUM_FOURTEEN = 4'b1110; // Input num value 14
  parameter NUM_FIFTEEN = 4'b1111;  // Input num value 15
  
  
  always @(*)
  begin
    case(numIn)
		NUM_ZERO     : hexVal = ZERO;
		NUM_ONE      : hexVal = ONE;
		NUM_TWO      : hexVal = TWO;
		NUM_THREE    : hexVal = THREE;
		NUM_FOUR     : hexVal = FOUR;
		NUM_FIVE     : hexVal = FIVE;
		NUM_SIX      : hexVal = SIX;
		NUM_SEVEN    : hexVal = SEVEN;
		NUM_EIGHT    : hexVal = EIGHT;
	   NUM_NINE     : hexVal = NINE;
		NUM_TEN      : hexVal = TEN;
		NUM_ELEVEN   : hexVal = ELEVEN;
		NUM_TWELVE   : hexVal = TWELVE;
		NUM_THIRTEEN : hexVal = THIRTEEN;
		NUM_FOURTEEN : hexVal = FOURTEEN;
		NUM_FIFTEEN  : hexVal = FIFTEEN;
      default      : hexVal = OFF;
    endcase
  end
  
  assign hexOut = hexVal;

endmodule
