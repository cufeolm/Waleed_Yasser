if [file exists "work"] {vdel -all}
vlib work
onerror {quit}

vlog -f ../testing_amber/dut_amber.f 

vlog +incdir+../testing_amber+../common+../common/inst_h+../common/Tests+../common/sequences ../testing_amber/target_pkg.sv
vlog ../testing_amber/amber_interface.sv
vlog ../testing_amber/top.sv

vsim -novopt top +UVM_TESTNAME=add_test +ARG_INST=A

add wave -position insertpoint sim:/top/bfm/*
add wave -position insertpoint sim:/top/bfm/send_data/*
add wave -position insertpoint sim:/top/bfm/send_inst/*
add wave -position insertpoint sim:/top/bfm/get_cpc/*
add wave -position insertpoint sim:/top/dut/u_execute/u_register_bank/*

log /* -r

run -all
quit