vcom -f leon/DUT_LEON.f 
vlog +incdir+leon+GUVM leon/target_pkg.sv
vlog leon/leon_interface.sv
vlog leon/top.sv

#+incdir+leon/DUT

vsim   top
#add wave -noupdate /top/dut/iuO/excute_stage
#add wave -noupdate /top/dut/rfO
#add wave -position insertpoint sim:/top/dut/rf0/inf/u0/*
#add wave -position insertpoint  \sim:/top/dut/iu0/ex
#add wave -position insertpoint  \sim:/top/dut/dci.edata
#add wave -position insertpoint sim:/top/dut/rf0/inf/u0/rfss/u1/*
#add wave -position insertpoint sim:/top/dut/*
add wave -r /*
run -all
log /* -r
quit
