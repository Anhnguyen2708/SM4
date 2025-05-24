library verilog;
use verilog.vl_types.all;
entity sm4_top_vlg_check_tst is
    port(
        key_exp_ready_out: in     vl_logic;
        key_exp_ready_signal: in     vl_logic;
        ready_out       : in     vl_logic;
        result_out      : in     vl_logic_vector(127 downto 0);
        sampler_rx      : in     vl_logic
    );
end sm4_top_vlg_check_tst;
