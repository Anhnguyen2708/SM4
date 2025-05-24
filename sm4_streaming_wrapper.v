	module sm4_streaming_wrapper(
    input         iClk,
    input         iReset_n,
    input         iChipSelect_n,
    input         iWrite_n,
    input         iRead_n,
    input  [4:0]  iAddress,
    input  [31:0] iData,
    output reg [31:0] oData
);
	 reg encdec_sel_in;
	reg keyexp_en;
   reg encdec_enable_in;
	reg  [127:0] in_data;
	reg  [127:0] in_key;
	wire roundkey_ready;
	wire ready_out;
	wire [127:0] CipherText;
	 reg  [127:0] temp_result;
	 reg tmp_out;
	 sm4_top SM4(
			.clk(iClk),
			.reset_n(iReset_n),
			.data_in(in_data),
			.user_key_in(in_key),
			.ready_out(ready_out),
			.result_out(CipherText),
			.encdec_sel_in(encdec_sel_in),
			.key_exp_ready_out(roundkey_ready),
			.encdec_enable_in(encdec_enable_in),
			.enable_key_exp_and_valid_data_in(keyexp_en)
	);
	
	reg rst_reg;
    always @(posedge iClk or negedge iReset_n) begin
        if (~iReset_n) begin
				temp_result <= 128'd0;
				tmp_out <= 1'b0;
            in_data   <= 128'd0;
				in_key <= 128'd0;
            oData     <= 32'd0;
				rst_reg <= 1'b0;
				keyexp_en <= 1'b0;
				encdec_enable_in <= 1'b0;
        end 
		  else begin 
            if (~iChipSelect_n && ~iWrite_n) begin
						keyexp_en <= 0;
						encdec_enable_in <= 0;
                case (iAddress)
                    5'd0: in_key[127:96] <= iData;
                    5'd1: in_key[95:64]  <= iData;
                    5'd2: in_key[63:32]  <= iData;
                    5'd3: in_key[31:0]   <= iData;
                    5'd4: keyexp_en	<= 1'b1;
						  5'd5: in_data[127:96] <= iData;
                    5'd6: in_data[95:64]  <= iData;
                    5'd7: in_data[63:32]  <= iData;
                    5'd8: in_data[31:0]   <= iData;
                    5'd9: begin
									encdec_enable_in		<= 1'b1;	
									tmp_out <= 0;
								end
						  5'd10: encdec_sel_in <= iData;
                endcase
            end
            if (~iChipSelect_n && ~iRead_n) begin
					 rst_reg <= 1'b0;
                case (iAddress)
                    5'd11: oData <= temp_result[127:96];
                    5'd12: oData <= temp_result[95:64];
                    5'd13: oData <= temp_result[63:32];
                    5'd14: oData <= temp_result[31:0];
                    5'd15: oData <= {31'd0, tmp_out};
						  5'd16: oData <= {31'd0, roundkey_ready};
                    default: oData <= 32'd0;
						  
                endcase
            end
				if(ready_out) begin
					temp_result <= CipherText;
					tmp_out <= 1'b1;
				end
					
        end
    end
endmodule