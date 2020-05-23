// interface GUVM_interface(input clk);
//     import target_package::*; // importing amber core package

//     // core interface ports
//     logic       clk_pseudo;
//     logic       i_irq;
//     logic       i_firq;
//     logic       i_system_rdy;

//     logic [31:0] o_wb_adr;
//     logic [15:0] o_wb_sel;
//     logic o_wb_we;
//     logic [127:0] i_wb_dat;
//     logic [127:0] o_wb_dat;

// /*    logic [127:0] output_data; // to solve o_wb_data toggling problem + the always block below
//     logic [127:0] x=0;
//     logic [127:0] y;*/

//     logic o_wb_cyc;
//     logic o_wb_stb;
//     logic i_wb_ack;
//     logic i_wb_err;

//     // temp. registers
//     logic [3:0] Rd;
//     logic [31:0] same_inst;
//     logic [31:0] data_in;


//     logic [31:0]next_pc=0;
//     // declaring the monitor
//     GUVM_result_monitor result_monitor_h;

//     command_monitor command_monitor_h;

//     bit allow_pseudo_clk;

//     // initializing the clk_pseudo signal
//     initial begin
//         clk_pseudo=0;
//         allow_pseudo_clk=0;
//     end

//     always @(clk) begin
//         if (allow_pseudo_clk)begin
//             clk_pseudo = clk;
//         end
//     end

//     task toggle_clk(integer i);
//         if(same_inst!=32'b11111111111111111111111111111111) begin
//             allow_pseudo_clk=1;
//             repeat(i*5) @(posedge clk_pseudo);
//             allow_pseudo_clk=0;
//         end
//     endtask

//     // sending data to the core
//     task send_data(logic [31:0] data);
//         data_in = data;
//     endtask

//     // sending instructions to the core
//     task send_inst(logic [31:0] inst);
//         if(inst!=32'b11111111111111111111111111111111) begin
//             same_inst = inst;
//             Rd = inst[15:12]; // destination register address bits: 4 bits
//             $display("inst = %h", inst);
//             if(inst == {{16'haaaa}, {Rd}, {12'haaa}}) begin // accessing the register file by forcing
//                 i_wb_dat = {{16'haaaa}, {Rd}, {12'haaa}};
//                 case(Rd)
//                     4'b0000: dut.u_execute.u_register_bank.r0 = data_in;
//                     4'b0001: dut.u_execute.u_register_bank.r1 = data_in;
//                     4'b0010: dut.u_execute.u_register_bank.r2 = data_in;
//                     4'b0011: dut.u_execute.u_register_bank.r3 = data_in;
//                     4'b0100: dut.u_execute.u_register_bank.r4 = data_in;
//                     4'b0101: dut.u_execute.u_register_bank.r5 = data_in;
//                     4'b0110: dut.u_execute.u_register_bank.r6 = data_in;
//                     4'b0111: dut.u_execute.u_register_bank.r7 = data_in;
//                     default: $display("Error in SEL");
//                 endcase
//             end else begin
//                 i_wb_dat = inst;
//             end
//         end
//     endtask

//     function void update_command_monitor(GUVM_sequence_item cmd);
//         if(same_inst!=32'b11111111111111111111111111111111) begin
//             command_monitor_h.write_to_cmd_monitor(cmd);
//         end
//     endfunction

//     task update_result_monitor();
// /*        if(same_inst!=32'b11111111111111111111111111111111) begin
//             if(same_inst[11:0]==12'b000000000000 && same_inst[31:20]==17'b1110010110000) begin
//                 forever begin
//                     if(o_wb_we == 1) begin
//                         result_monitor_h.write_to_monitor(o_wb_dat,next_pc);
//                         break;
//                     end else begin
//                         repeat(1) begin
//                             #10 clk_pseudo = ~clk_pseudo;
//                         end
//                     end
//                 end
//             end else begin
//                 result_monitor_h.write_to_monitor(o_wb_dat,next_pc);
//             end
//         end*/
//         result_monitor_h.write_to_monitor(o_wb_dat,next_pc);
//     endtask

//     function logic[31:0] get_cpc();
//         if(same_inst!=32'b11111111111111111111111111111111) begin
//             $display("current_pc = %h       %t", dut.u_execute.u_register_bank.o_pc, $time);
//             return dut.u_execute.u_register_bank.o_pc;
//         end
//     endfunction

//     // initializing the core
//     task set_Up();
//         i_irq = 1'b0;
//         i_firq = 1'b0;
//         i_system_rdy = 1'b1;
//         i_wb_ack = 1'b1;
//         i_wb_err = 1'b0;
//         // dut.u_execute.u_register_bank.r15=0;
//     endtask: set_Up

//     task reset_dut();
//         // amber does not have a reset signal in the core interface
//     endtask : reset_dut

// endinterface: GUVM_interface

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


    logic o_wb_cyc;
    logic o_wb_stb;
    logic i_wb_ack;
    logic i_wb_err;

    // temp. registers
    logic [3:0] Rd;
    logic [31:0] same_inst;
    logic [31:0] data_in;
    logic u=0;
    logic [31:0] current_pc=0; 


    logic [31:0]next_pc=0;
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
        /*if(u==0) begin
            repeat(5) begin
                #10 clk_pseudo = ~clk_pseudo;
            end
        end*/
        data_in = data;
        //u++;
    endtask

    // sending instructions to the core
    task send_inst(logic [31:0] inst);
        same_inst = inst;
        Rd = inst[15:12]; // destination register address bits: 4 bits
        $display("inst = %h", inst);
        if(inst == {{16'haaaa}, {Rd}, {12'haaa}}) begin // accessing the register file by forcing
            i_wb_dat = {{16'haaaa}, {Rd}, {12'haaa}};
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
            i_wb_dat = inst;
        end
        // current_pc = current_pc+4;
    endtask

    function void update_command_monitor(GUVM_sequence_item cmd);
        command_monitor_h.write_to_cmd_monitor(cmd);
    endfunction

    task update_result_monitor();
        /*if(same_inst[11:0]==12'b000000000000 && same_inst[31:20]==17'b111001011000) begin
            forever begin
                if(o_wb_we == 1) begin
                    result_monitor_h.write_to_monitor(o_wb_dat,next_pc);
                    break;
                end else begin
                    repeat(1) begin
                        #10 clk_pseudo = ~clk_pseudo;
                    end
                end
            end
        end else begin
            result_monitor_h.write_to_monitor(o_wb_dat,next_pc);
        end*/
        result_monitor_h.write_to_monitor(dut.u_mem.i_write_data,next_pc);
    endtask

    function logic[31:0] get_cpc();
        /*$display("current_pc = %h       %t", current_pc, $time);
        return current_pc;*/
        $display("current_pc = %h       %t", dut.u_execute.u_register_bank.o_pc, $time);
        return dut.u_execute.u_register_bank.o_pc;
    endfunction

    // initializing the core
    task set_Up();
        i_irq = 1'b0;
        i_firq = 1'b0;
        i_system_rdy = 1'b1;
        i_wb_ack = 1'b1;
        i_wb_err = 1'b0;
        //toggle_clk(1);
    endtask: set_Up

    task reset_dut();
        // amber does not have a reset signal in the core interface
    endtask : reset_dut

endinterface: GUVM_interface
