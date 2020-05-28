interface GUVM_interface(input clk);
    import target_package::*; // importing amber core package

    // core interface ports
    logic       clk_pseudo;
    logic       i_irq;
    logic       i_firq;
    logic       i_system_rdy;

    logic [31:0] o_wb_adr;
    logic [15:0] o_wb_sel;
    logic o_wb_we;
    logic [127:0] i_wb_dat;
    logic [127:0] o_wb_dat;
    
    logic       [127:0]         icache_wb_read_data; // instruction logic
    logic       [127:0]         dcache_wb_cached_rdata;
    logic       [127:0]         dcache_wb_write_data; // output data
    logic                       icache_wb_ready;
    logic                       dcache_wb_cached_ready;
    logic                       dcache_wb_uncached_ready;


    logic o_wb_cyc;
    logic o_wb_stb;
    logic i_wb_ack;
    logic i_wb_err;

    // temp. registers
    logic [3:0] Rd;
    logic [31:0] same_inst;
    logic [31:0] data_in;



    logic [31:0] next_pc=0;
    // declaring the monitor
    GUVM_result_monitor result_monitor_h;

    command_monitor command_monitor_h;

    bit allow_pseudo_clk;

    // initializing the clk_pseudo signal
    initial begin
        clk_pseudo=0;
        allow_pseudo_clk=0;
    end

    always @(clk) begin
        if (allow_pseudo_clk)begin
            clk_pseudo = clk;
        end
    end

    task toggle_clk(integer i);
        allow_pseudo_clk=1;
        repeat(i) @(posedge clk_pseudo);
        allow_pseudo_clk=0;
    endtask

    // sending data to the core
    task send_data(logic [31:0] data);
        data_in = data;
        // dcache_wb_cached_rdata = data;
    endtask

    // sending instructions to the core
    task send_inst(logic [31:0] inst);
        same_inst = inst;
        Rd = inst[15:12]; // destination register address bits: 4 bits
        $display("inst = %h", inst);
        if(inst == {16'haaaa, Rd, 12'haaa}) begin // accessing the register file by forcing
            icache_wb_read_data = {16'hF080, Rd, 12'h003};
            case(Rd)
                4'b0000: dut.u_execute.u_register_bank.r0 = data_in;
                4'b0001: dut.u_execute.u_register_bank.r1 = data_in;
                4'b0010: dut.u_execute.u_register_bank.r2 = data_in;
                4'b0011: dut.u_execute.u_register_bank.r3 = data_in;
                4'b0100: dut.u_execute.u_register_bank.r4 = data_in;
                4'b0101: dut.u_execute.u_register_bank.r5 = data_in;
                4'b0110: dut.u_execute.u_register_bank.r6 = data_in;
                4'b0111: dut.u_execute.u_register_bank.r7 = data_in;
                default: $display("Error in SEL");
            endcase
        end else begin
            icache_wb_read_data = inst;
        end
    endtask

    function void update_command_monitor(GUVM_sequence_item cmd);
        command_monitor_h.write_to_cmd_monitor(cmd);
    endfunction

    task update_result_monitor();
        if(same_inst == {{16'haaaa}, {Rd}, {12'haaa}}) begin
            dcache_wb_write_data=0;
            result_monitor_h.write_to_monitor(dcache_wb_write_data[31:0], next_pc);
        end else begin
            result_monitor_h.write_to_monitor(dcache_wb_write_data[31:0], next_pc);
        end
    endtask

    function logic[31:0] get_cpc();
        $display("current_pc = %h       %t", dut.u_execute.u_register_bank.r15, $time);
        return dut.u_execute.u_register_bank.r15;
    endfunction

    // initializing the core
    task set_Up();
        i_irq = 1'b0;
        i_firq = 1'b0;
        i_system_rdy = 1'b1;
        icache_wb_ready=1'b1;
        dcache_wb_cached_ready=1'b1;
        dcache_wb_uncached_ready=1'b1;

        toggle_clk(1);
    endtask: set_Up

    task reset_dut();
        // amber does not have a reset signal in the core interface
    endtask : reset_dut

endinterface: GUVM_interface
