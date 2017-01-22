module comparator (ifLess, ifEqual, bit0, bit1, enable);
	output ifLess, ifEqual;
	input bit0, bit1, enable;
	
	assign ifLess = enable & (~bit0 & bit1);
	assign ifEqual = enable & (bit0 ~^ bit1);
endmodule
