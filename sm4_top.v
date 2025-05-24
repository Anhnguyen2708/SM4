module sm4_top(
	input clk,
	input reset_n,
	input encdec_enable_in,
	input encdec_sel_in,
	input enable_key_exp_and_valid_data_in,
	input [127:0] data_in ,
	input [127:0] user_key_in,
	output ready_out,
	output [127:0] result_out,
	output key_exp_ready_out,
	output key_exp_ready_signal
); 
	reg rkey_ready;
		always @(posedge clk or negedge reset_n) begin
			if (~reset_n)
				rkey_ready <= 1'b0;
			else if (key_exp_ready_out == 1'b1)
				rkey_ready <= 1'b1;
			else if (enable_key_exp_and_valid_data_in == 1'b1)
				rkey_ready <= 0;
		end
    wire [31:0] 	rk_00, rk_01, rk_02, rk_03, rk_04, 
						rk_05, rk_06, rk_07, rk_08, rk_09, 
						rk_10, rk_11, rk_12, rk_13, rk_14, 
						rk_15, rk_16, rk_17, rk_18, rk_19, 
						rk_20, rk_21, rk_22, rk_23, rk_24, 
						rk_25, rk_26, rk_27, rk_28, rk_29, 
						rk_30, rk_31;
    sm4_encdec u_encdec (
        .clk (clk), .reset_n (reset_n),.encdec_enable_in (encdec_enable_in),
		  .key_exp_ready_in (rkey_ready),.encdec_sel_in (encdec_sel_in), .data_in (data_in),
        .rk_data_in({ 
            rk_31, rk_30, rk_29, rk_28, rk_27, rk_26, rk_25, rk_24,
            rk_23, rk_22, rk_21, rk_20, rk_19, rk_18, rk_17, rk_16,
            rk_15, rk_14, rk_13, rk_12, rk_11, rk_10, rk_09, rk_08,
            rk_07, rk_06, rk_05, rk_04, rk_03, rk_02, rk_01, rk_00}),
        .done (ready_out), .result_out (result_out)
    );
    key_expansion u_key(
        .clk (clk), .reset_n (reset_n),.user_key_in (user_key_in),
        .enable_key_exp_and_valid_data_in (enable_key_exp_and_valid_data_in),
        .key_exp_finished_out (key_exp_ready_out),
        .rk00_out (rk_00), .rk01_out (rk_01), .rk02_out (rk_02), .rk03_out (rk_03),
        .rk04_out (rk_04), .rk05_out (rk_05), .rk06_out (rk_06), .rk07_out (rk_07),
        .rk08_out (rk_08), .rk09_out (rk_09), .rk10_out (rk_10), .rk11_out (rk_11),
        .rk12_out (rk_12), .rk13_out (rk_13), .rk14_out (rk_14), .rk15_out (rk_15),
        .rk16_out (rk_16), .rk17_out (rk_17), .rk18_out (rk_18), .rk19_out (rk_19),
        .rk20_out (rk_20), .rk21_out (rk_21), .rk22_out (rk_22), .rk23_out (rk_23),
        .rk24_out (rk_24), .rk25_out (rk_25), .rk26_out (rk_26), .rk27_out (rk_27),
        .rk28_out (rk_28), .rk29_out (rk_29), .rk30_out (rk_30), .rk31_out (rk_31));
endmodule
