`timescale 1ns / 100ps

module sm4_encdec (
    input clk,
    input reset_n,
    input encdec_enable_in,
    input key_exp_ready_in,
    input [127:0] data_in,
    input [1023:0] rk_data_in,
    input encdec_sel_in,

    output reg done,
    output reg [127:0] result_out
	 //output key_exp_ready_signal
);

    // Internal signals
    wire key_exp_ready_signal;
    assign key_exp_ready_signal =(~encdec_sel_in) | (key_exp_ready_in);
    reg [4:0] count_round;
    reg [1:0] current, next;
    wire [127:0] data_for_round, data_after_round;
    wire [31:0] round_key_in;
    reg [127:0] reg_data_after_round;
    reg [127:0] reg_user_data;
    reg [4:0] reg_count_round;
    wire [4:0] count_for_reg;

    reg reg_key_valid = 1'b0;
    reg reg_encdec_enable_in;

    wire [31:0] rk_array [0:31];
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : unpack_rk_data
            assign rk_array[i] = rk_data_in[(i + 1) * 32 - 1 : i * 32];
        end
    endgenerate

    `define IDLE   2'b00
    `define ROUND  2'b01

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current <= `IDLE;
        //else if (encdec_enable_in)
            //current <= next;
        else
            //current <= `IDLE;
				current <= next;
    end

    always @(*) begin
        next = `IDLE;
        case (current)
            `IDLE:
                if (encdec_enable_in && key_exp_ready_signal)
                    next = `ROUND;
					else 
						next = `IDLE;
            `ROUND: begin
                if (reg_count_round == 5'd31)
                    next = `IDLE;
                else
                    next = `ROUND;
				end
            default: next = `IDLE;
        endcase
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            count_round <= 5'd0;
        else if (next == `ROUND)
            count_round <= count_round + 1'b1;
        else
            count_round <= 5'd0;
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            reg_count_round <= 5'd0;
        else
            reg_count_round <= count_round;
    end

    //always @(posedge clk or negedge reset_n) begin
      //  if (!reset_n)
            //done <= 1'd0;
       // else if (~encdec_enable_in)
           // done <= 1'd0;
       // else if (current == `ROUND && next == `IDLE)
            //done <= 1'b1;
   // end
	always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            done <= 1'b0;
			else if (current == `ROUND && reg_count_round == 5'd31)
				done <= 1'b1;
			else
				done <= 1'b0;
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            reg_user_data <= 128'h0;
        else
            reg_user_data <= data_in;
    end

    assign round_key_in = (encdec_sel_in == 1'b1) ? rk_array[5'd31 - count_round] : rk_array[count_round];
    assign data_for_round = (count_round == 0) ? data_in : reg_data_after_round;

    one_round_for_encdec u_00 (
        .data_in(data_for_round),
        .round_key_in(round_key_in),
        .result_out(data_after_round)
    );

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            reg_data_after_round <= 128'd0;
        else if (current == `ROUND)
            reg_data_after_round <= data_after_round;
        else if (current == `IDLE && next == `ROUND)
            reg_data_after_round <= data_after_round;
    end

    assign count_for_reg = count_round;

    wire [31:0] w0, w1, w2, w3;
    assign {w0, w1, w2, w3} = reg_data_after_round;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            result_out <= 128'b0;
        else if (current == `ROUND && next == `IDLE)
            result_out <= {w3, w2, w1, w0};
    end

endmodule
