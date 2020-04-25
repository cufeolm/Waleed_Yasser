
if [file exists "work"] {vdel -all}
vlib work
onerror {quit}

puts "Hello, World; - With  a semicolon inside the quotes"

vlog -f riscy/dut_riscy.f

vlog +incdir+riscy+GUVM riscy/target_pkg.sv 
vlog riscy/riscy_interface.sv
vlog riscy/top.sv

vsim top
add wave -r /*
#add wave -position insertpoint sim:/riscv_core/*
#add wave -position insertpoint sim:/riscv_core/id_stage_i/registers_i/*
#add wave -position insertpoint sim:/top/dut/riscv_core/id_stage_i/registers_i/*
#add wave -position insertpoint sim:/top/dut/riscv_core/*
#add wave -position insertpoint sim:/top/dut/id_stage_i/registers_i/*
run -all
log /* -r
quit
