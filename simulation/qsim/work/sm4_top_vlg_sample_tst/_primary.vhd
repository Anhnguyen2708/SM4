library verilog;
use verilog.vl_types.all;
entity sm4_top_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        data_in         : in     vl_logic_vector(127 downto 0);
        enable_key_exp_and_valid_data_in: in     vl_logic;
        encdec_enable_in: in     vl_logic;
        encdec_sel_in   : in     vl_logic;
        reset_n         : in     vl_logic;
        user_key_in     : in     vl_logic_vector(127 downto 0);
        sampler_tx      : out    vl_logic
    );
end sm4_top_vlg_sample_tst;
