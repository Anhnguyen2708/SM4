`timescale 1ns / 100ps

module key_expansion (
    input            clk,
    input            reset_n,
    input            enable_key_exp_and_valid_data_in,
    input   [127:0]  user_key_in,
    output reg       key_exp_finished_out,
    output reg [1:0] current,
    output reg [31:0] rk00_out, rk01_out, rk02_out, rk03_out,
                      rk04_out, rk05_out, rk06_out, rk07_out,
                      rk08_out, rk09_out, rk10_out, rk11_out,
                      rk12_out, rk13_out, rk14_out, rk15_out,
                      rk16_out, rk17_out, rk18_out, rk19_out,
                      rk20_out, rk21_out, rk22_out, rk23_out,
                      rk24_out, rk25_out, rk26_out, rk27_out,
                      rk28_out, rk29_out, rk30_out, rk31_out
);

    `define IDLE          2'b00
    `define KEY_EXPANSION 2'b01

    reg  [1:0]    next;
    reg  [4:0]    count_round;
    reg  [4:0]    reg_count_round;
    reg  [127:0]  reg_user_key;
    reg  [127:0]  reg_data_after_round;
    wire [4:0]    count_for_reg;
    wire [31:0]   cki;
    wire [127:0]  data_for_round;
    wire [127:0]  data_after_round;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current <= `IDLE;
        else
            current <= next;
    end

    always @(*) begin
        next = `IDLE;
        case (current)
            `IDLE: begin
                if (enable_key_exp_and_valid_data_in)
                    next = `KEY_EXPANSION;
                else
                    next = `IDLE;
            end
            `KEY_EXPANSION: begin
                if (reg_count_round == 5'd31)
                    next = `IDLE;
                else
                    next = `KEY_EXPANSION;
            end
            default:
                next = `IDLE;
        endcase
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            count_round <= 5'd0;
        else if (next == `KEY_EXPANSION)
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

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            key_exp_finished_out <= 1'b0;
        else if (current == `KEY_EXPANSION && reg_count_round == 5'd31)
            key_exp_finished_out <= 1'b1;
        else
            key_exp_finished_out <= 1'b0;
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            reg_user_key <= 128'h0;
        else
            reg_user_key <= user_key_in;
    end

    assign data_for_round = (reg_count_round != 5'd0)
                            ? reg_data_after_round
                            : reg_user_key;

    get_cki u_get_cki (
        .clk            (clk),
        .count_round_in (count_round),
        .cki_out        (cki)
    );

    one_round_for_key_exp u_one_round (
        .count_round_in  (reg_count_round),
        .data_in         (data_for_round),
        .ck_parameter_in (cki),
        .result_out      (data_after_round)
    );

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            reg_data_after_round <= 128'd0;
        else if (current == `KEY_EXPANSION)
            reg_data_after_round <= data_after_round;
    end

    assign count_for_reg = reg_count_round;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            rk00_out <= 32'd0;  rk01_out <= 32'd0;  rk02_out <= 32'd0;  rk03_out <= 32'd0;
            rk04_out <= 32'd0;  rk05_out <= 32'd0;  rk06_out <= 32'd0;  rk07_out <= 32'd0;
            rk08_out <= 32'd0;  rk09_out <= 32'd0;  rk10_out <= 32'd0;  rk11_out <= 32'd0;
            rk12_out <= 32'd0;  rk13_out <= 32'd0;  rk14_out <= 32'd0;  rk15_out <= 32'd0;
            rk16_out <= 32'd0;  rk17_out <= 32'd0;  rk18_out <= 32'd0;  rk19_out <= 32'd0;
            rk20_out <= 32'd0;  rk21_out <= 32'd0;  rk22_out <= 32'd0;  rk23_out <= 32'd0;
            rk24_out <= 32'd0;  rk25_out <= 32'd0;  rk26_out <= 32'd0;  rk27_out <= 32'd0;
            rk28_out <= 32'd0;  rk29_out <= 32'd0;  rk30_out <= 32'd0;  rk31_out <= 32'd0;
        end else if (current == `KEY_EXPANSION) begin
            case (count_for_reg)
                5'd0:  rk00_out <= data_after_round[31:0];
                5'd1:  rk01_out <= data_after_round[31:0];
                5'd2:  rk02_out <= data_after_round[31:0];
                5'd3:  rk03_out <= data_after_round[31:0];
                5'd4:  rk04_out <= data_after_round[31:0];
                5'd5:  rk05_out <= data_after_round[31:0];
                5'd6:  rk06_out <= data_after_round[31:0];
                5'd7:  rk07_out <= data_after_round[31:0];
                5'd8:  rk08_out <= data_after_round[31:0];
                5'd9:  rk09_out <= data_after_round[31:0];
                5'd10: rk10_out <= data_after_round[31:0];
                5'd11: rk11_out <= data_after_round[31:0];
                5'd12: rk12_out <= data_after_round[31:0];
                5'd13: rk13_out <= data_after_round[31:0];
                5'd14: rk14_out <= data_after_round[31:0];
                5'd15: rk15_out <= data_after_round[31:0];
                5'd16: rk16_out <= data_after_round[31:0];
                5'd17: rk17_out <= data_after_round[31:0];
                5'd18: rk18_out <= data_after_round[31:0];
                5'd19: rk19_out <= data_after_round[31:0];
                5'd20: rk20_out <= data_after_round[31:0];
                5'd21: rk21_out <= data_after_round[31:0];
                5'd22: rk22_out <= data_after_round[31:0];
                5'd23: rk23_out <= data_after_round[31:0];
                5'd24: rk24_out <= data_after_round[31:0];
                5'd25: rk25_out <= data_after_round[31:0];
                5'd26: rk26_out <= data_after_round[31:0];
                5'd27: rk27_out <= data_after_round[31:0];
                5'd28: rk28_out <= data_after_round[31:0];
                5'd29: rk29_out <= data_after_round[31:0];
                5'd30: rk30_out <= data_after_round[31:0];
                5'd31: rk31_out <= data_after_round[31:0];
            endcase
        end
    end

endmodule
