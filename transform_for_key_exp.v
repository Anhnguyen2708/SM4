`timescale 1ns / 100ps

module transform_for_key_exp(
	input	[31 : 0]	data_in,
	output	[31 : 0]	data_after_linear_key_out
); 	

	wire [7:0] byte_0, byte_1, byte_2, byte_3;
	wire [7:0] byte_0_replaced, byte_1_replaced, byte_2_replaced, byte_3_replaced;
	wire [31:0] word_replaced;

	assign {byte_0, byte_1, byte_2, byte_3} =	data_in;
	assign word_replaced = {byte_0_replaced, byte_1_replaced, byte_2_replaced, byte_3_replaced};

	sbox_replace u_0(.data_in(byte_0), .result_out(byte_0_replaced));
	sbox_replace u_1(.data_in(byte_1), .result_out(byte_1_replaced));	
	sbox_replace u_2(.data_in(byte_2), .result_out(byte_2_replaced));
	sbox_replace u_3(.data_in(byte_3), .result_out(byte_3_replaced));																																				

	assign data_after_linear_key_out	= (word_replaced ^ {word_replaced[18:0], word_replaced[31:19]}) ^ {word_replaced[8:0], word_replaced[31:9]};

endmodule											
																								
