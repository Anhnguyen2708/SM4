library verilog;
use verilog.vl_types.all;
entity sm4_top is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        encdec_enable_in: in     vl_logic;
        encdec_sel_in   : in     vl_logic;
        enable_key_exp_and_valid_data_in: in     vl_logic;
        data_in         : in     vl_logic_vector(127 downto 0);
        user_key_in     : in     vl_logic_vector(127 downto 0);
        ready_out       : out    vl_logic;
        result_out      : out    vl_logic_vector(127 downto 0);
        key_exp_ready_out: out    vl_logic;
        key_exp_ready_signal: out    vl_logic
    );
end sm4_top;
