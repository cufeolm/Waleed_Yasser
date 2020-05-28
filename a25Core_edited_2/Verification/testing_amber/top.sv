module top;
    import uvm_pkg::*;
    import target_package::*;
    //import iface::*;

    `include "uvm_macros.svh"
    logic clk; 
	GUVM_interface bfm(clk);
    a25_core dut(
        .i_clk(bfm.clk_pseudo),
        .i_irq(bfm.i_irq),
        .i_firq(bfm.i_firq),
        .i_system_rdy(bfm.i_system_rdy),
        .o_wb_adr(bfm.o_wb_adr),
        .o_wb_sel(bfm.o_wb_sel),
        .o_wb_we(bfm.o_wb_we),
        .i_wb_dat(bfm.i_wb_dat),
        .o_wb_dat(bfm.o_wb_dat),
        .o_wb_cyc(bfm.o_wb_cyc),
        .o_wb_stb(bfm.o_wb_stb),
        .i_wb_ack(bfm.i_wb_ack),
        .i_wb_err(bfm.i_wb_err),

        .icache_wb_read_data(bfm.icache_wb_read_data),
        .dcache_wb_cached_rdata(bfm.dcache_wb_cached_rdata),
        .dcache_wb_write_data(bfm.dcache_wb_write_data),
        .icache_wb_ready(bfm.icache_wb_ready),
        .dcache_wb_cached_ready(bfm.dcache_wb_cached_ready),
        .dcache_wb_uncached_ready(bfm.dcache_wb_uncached_ready)
    );

    initial begin
        uvm_config_db#(virtual GUVM_interface)::set(null, "*", "bfm", bfm);
        fill_si_array();
        run_test();
    end

    initial begin 
        clk = 0 ;
        forever #10 clk=~clk;
    end
endmodule : top


