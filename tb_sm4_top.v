`timescale 1ns / 100ps
module tb_sm4_top;
    // Clock & reset
    reg clk;
    reg reset_n;
    // Control signals
    reg encdec_enable_in;
    reg encdec_sel_in;
    reg enable_key_exp_and_valid_data_in;
    // Data inputs
    reg [127:0] data_in;
    reg [127:0] user_key_in;
    // Outputs
    wire ready_out;
    wire [127:0] result_out;
    wire key_exp_ready_out;
    wire key_exp_ready_signal;
    // Instantiate DUT
    sm4_top uut (.clk(clk), .reset_n(reset_n), 
        .encdec_enable_in(encdec_enable_in), .encdec_sel_in(encdec_sel_in), 
        .enable_key_exp_and_valid_data_in(enable_key_exp_and_valid_data_in),
        .data_in(data_in), .user_key_in(user_key_in), .ready_out(ready_out),
        .result_out(result_out), .key_exp_ready_out(key_exp_ready_out),
        .key_exp_ready_signal(key_exp_ready_signal)
    );
    // Clock generation: 100 MHz
    initial clk = 0;
    always #2 clk = ~clk;
    // Test vectors
    initial begin
        // Initialize inputs
        reset_n = 0;
        encdec_enable_in = 0;
        encdec_sel_in = 0;
        enable_key_exp_and_valid_data_in = 0;
        // Deassert reset
        #8;
        reset_n = 1;
        #8;
        // Load plaintexts
        data_in = 128'h0123456789ABCDEF_FEDCBA9876543210;
        user_key_in = 128'h0123456789ABCDEF_FEDCBA9876543210; // example key
        @(posedge clk);
        enable_key_exp_and_valid_data_in = 1;
        @(posedge clk);
        enable_key_exp_and_valid_data_in = 0;
        @(posedge clk);
        encdec_enable_in = 1;
        @(posedge clk);
        encdec_enable_in = 0;
        wait (ready_out == 1);
        $display("[%0t] Encrypt: P=0x%h C=0x%h", $time, data_in, result_out);
        #8
        encdec_sel_in = 1;
        data_in = result_out;
        @(posedge clk);
        encdec_enable_in = 1;
        @(posedge clk);
        encdec_enable_in = 0;
        wait (ready_out == 1);
        $display("[%0t] Decrypt: P=0x%h C=0x%h", $time, data_in, result_out);
        #8
        data_in = 128'h11111111111111111111111111111111;
        @(posedge clk);
        encdec_enable_in = 1;
        @(posedge clk);
        encdec_enable_in = 0;
        wait (ready_out == 1);
        #8
        $display("[%0t] Encrypt: P=0x%h C=0x%h", $time, data_in, result_out);
        $display("Testbench completed at %0t", $time);
        $stop;
    end
endmodule
