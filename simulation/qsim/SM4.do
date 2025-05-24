onerror {quit -f}
vlib work
vlog -work work SM4.vo
vlog -work work SM4.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.sm4_top_vlg_vec_tst
vcd file -direction SM4.msim.vcd
vcd add -internal sm4_top_vlg_vec_tst/*
vcd add -internal sm4_top_vlg_vec_tst/i1/*
add wave /*
run -all
