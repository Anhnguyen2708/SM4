	module test_wr(
    input         iClk,
    input         iReset_n,
    input         iChipSelect_n,
    input         iWrite_n,
    input         iRead_n,
    input  [4:0]  iAddress,
    input  [31:0] iData,
    output reg [31:0] oData,
	 output reg keyexp_en,
    output reg encdec_enable_in,
	 output reg  [127:0] in_data, // nhan 4 lan data 32 bit dau vao de truyen vao IP 128b
	output reg  [127:0] in_key, // nhan 4 lan data 32 bit dau vao de truyen vao IP 128b 
	output wire roundkey_ready,
	output reg data_in_ready_tmp,
	output wire ready_out,
	output wire [127:0] CipherText
	 
);		reg[30:0] tmp;
	 reg encdec_sel_in;
	//	 reg keyexp_en;
    // reg encdec_enable_in;
		//  reg  [127:0] in_data; // nhan 4 lan data 32 bit dau vao de truyen vao IP 128b
	 // reg  [127:0] in_key; // nhan 4 lan data 32 bit dau vao de truyen vao IP 128b 
	 //	 wire roundkey_ready;
	 // reg data_in_ready_tmp;
	 // wire ready_out;
	 // wire [127:0] CipherText;
	 
    wire         Ready_new_input; // tin hieu bat dau de bat dau qua trinh Enc/Dec moi
	 reg  [127:0] temp_result; // luu output 128b de truyen len bus tach ouput ra lam 4 lan 32b
	 reg tmp_out;
	 sm4_top SM4(
			.clk(iClk), // xung Clk
			.reset_n(iReset_n), // tin hieu RST
			
			.data_in(in_data), // i_plaintext vao 128b
			.user_key_in(in_key), // i_key vao 128b
			
			.ready_out(ready_out), // o_tin hieu da co ket qua
			.result_out(CipherText), // o_ket qua
			
			.encdec_sel_in(encdec_sel_in), // i_lua chon Enc = 0 / Dec = 1
			.key_exp_ready_out(roundkey_ready), // signal for auto signal o_hoan thanh mo rong khoa
			.encdec_enable_in(encdec_enable_in), // auto_Bat dau Enc/Dec
			.enable_key_exp_and_valid_data_in(keyexp_en) // auto_bat dau tao key
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
				data_in_ready_tmp <= 1'b0;
				encdec_enable_in <= 1'b0;
        end 
		  else begin 
            if (~iChipSelect_n && ~iWrite_n) begin
                case (iAddress)
                    4'd0: in_key[127:96] <= iData;
                    4'd1: in_key[95:64]  <= iData;
                    4'd2: in_key[63:32]  <= iData;
                    4'd3: in_key[31:0]   <= iData;
                    4'd4: begin 
									keyexp_en	<= 1'b1;
									end
						  4'd5: in_data[127:96] <= iData;
                    4'd6: in_data[95:64]  <= iData;
                    4'd7: in_data[63:32]  <= iData;
                    4'd8: in_data[31:0]   <= iData;
                    4'd9: begin
										data_in_ready_tmp		<= 1'b1;	
									end
						  4'd10: {tmp,encdec_sel_in} <= iData;
						  4'd16: temp_result <= CipherText; //idle
                endcase
            end
            if (~iChipSelect_n && ~iRead_n) begin
					 rst_reg <= 1'b0;
                case (iAddress)
                    4'd11: oData <= temp_result[127:96];
                    4'd12: oData <= temp_result[95:64];
                    4'd13: oData <= temp_result[63:32];
                    4'd14: oData <= temp_result[31:0];
                    4'd15: begin
									oData <= {31'd0, tmp_out}; 
							end
							4'd16: temp_result <= CipherText; //idle
                    default: oData <= 32'd0;
						  
                endcase
            end
				if (data_in_ready_tmp)
					encdec_enable_in <= 1'b1;
				if(ready_out) begin
					temp_result <= CipherText;
					tmp_out <= 1'b1;
					data_in_ready_tmp <= 1'b0;
					encdec_enable_in <= 1'b0;
				end
				if (roundkey_ready) begin
					keyexp_en <= 1'b0;
				end
					
        end
    end

endmodule