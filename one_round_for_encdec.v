`timescale 1ns / 100ps
module one_round_for_encdec(
    input   [127:0] data_in,
    input   [31:0] round_key_in,
    output  [127:0] result_out
);
    wire [31:0] data_for_transform;
    wire [31:0] data_after_transform;
    
    assign data_for_transform = (data_in[95:64] ^ data_in[63:32]) ^ (data_in[31:0] ^ round_key_in);
    transform_for_encdec transform_for_encdec(.data_in(data_for_transform), .result_out(data_after_transform));
	 
    assign result_out = {data_in[95:64], data_in[63:32], data_in[31:0], data_after_transform ^ data_in[127:96]};
    
endmodule