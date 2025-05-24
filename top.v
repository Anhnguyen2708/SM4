module top(
	input CLOCK_50,
	input [0:0] SW
);
	system inst (.clk_clk(CLOCK_50), .reset_reset_n(SW[0]));
	
endmodule