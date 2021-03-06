package target_package;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    typedef enum logic[31:0] {
        LW = 32'b111101101001xxxxxxxxxxxxxxxxxxxx,
        SW = 32'b111001011000xxxxxxxxxxxxxxxxxxxx,
        A  = 32'b111000010000xxx0xxx000000000xxx,
        S = 32'b1110000001000xxx0xxx000000000xxx,
        Rs= 32'b1110000001100xxx0xxx000000000xxx,
        Swc=32'b1110000011000xxx0xxx000000000xxx, // sub with carry
        C=32'b1110000101010xxx0xxx000000000xxx,
       // M=32'b1110000000000xxx00000xxx10010xxx,
        M=32'b1110000000000xxx0xxx0xxx10010xxx,
        MA=32'b1110000000100xxx0xxx0xxx10010xxx, // multiply accumlate
        Awc=32'b1110000010100xxx0xxx000000000xxx,   // add with carry
        BwA= 32'b1110000000000xxx0xxx000000000xxx,
        BAwc=32'b1110000111000xxx0xxx000000000xxx,  // bitwise and with complement
        BX=  32'b1110000000100xxx0xxx000000000xxx,   // xor
        BO= 32'b1110000110000xxx0xxx000000000xxx,
        Mov=32'b1110000110100xxx0xxx000000000xxx,
        Mn= 32'b1110000111100xxx0xxx000000000xxx,
        Store = 32'b11100101100000000xxx000000000000,
        Load =  32'b1111011010010xxx0xxx000000000xxx 
    } opcode;

    opcode si_a[];
    integer supported_instructions;
    opcode reg_instruction;

    parameter ext_bits=20;  // all are dummy variables
    parameter last_imm=31;
    parameter first_imm=19;
    parameter to_ext=19;
    parameter shamt_last=31;  
    `include"GUVM.sv"
    /*`include "GUVM_sequence_item.sv"
    `include "target_sequence_item.sv"
    `include "GUVM_sequence.sv"
    `include "GUVM_driver.sv"
    `include "GUVM_monitor.sv"
    `include "GUVM_scoreboard.sv"
    `include "GUVM_agent.sv"
    `include "GUVM_env.sv"
    `include "GUVM_test.sv"*/

    function void fill_si_array();
    // fill supported instruction array
    // this does NOT  affect generalism this makes sure you dont run
    // the same function twice in a test bench
        `ifndef SET_UP_INSTRUCTION_ARRAY
        `define SET_UP_INSTRUCTION_ARRAY
            opcode si_i; // for iteration only
            supported_instructions = si_i.num();
            si_a = new[supported_instructions];

            si_i = si_i.first();
            for(integer i=0; i < supported_instructions; i++)
                begin
                    $display("si_a[%0d] = %s",i,si_i.name);
                    si_a[i] = si_i;
                    si_i = si_i.next();
                end
                // $display("array is filled and ready to use");
        `endif
    endfunction

    function GUVM_sequence_item get_format (logic [31:0] inst);
        target_seq_item ay;
        GUVM_sequence_item k;
        k = new("k");
        ay = new("ay");
        ay.inst=inst;
        ay.cond = inst[31:28];
        case (inst[27:25])
            3'b000:
                begin
                    if(inst[4] == 1'b0)
                        begin
                            if(inst[11:7] == 5'b00000)
                                begin
                                    ay.rs1 = inst[19:16];
                                    ay.rd = inst[15:12];
                                    ay.rs2 = inst[3:0];
                                    ay.s = inst[20];
                                end
                            else
                                begin
                                    ay.shift = inst[6:5];
                                    ay.shift_imm = inst[11:7];
                                    ay.rs1 = inst[19:16];
                                    ay.rd = inst[15:12];
                                    ay.rs2 = inst[3:0];
                                    ay.s = inst[20];
                                end
                        end
                    else if(inst[7] == 1'b0)
                        begin
                            ay.rs1 = inst[19:16];
                            ay.rd = inst[15:12];
                            ay.rs2 = inst[3:0];
                            ay.s = inst[20];
                            ay.shift = inst[6:5];
                            ay.rs = inst[11:8];
                        end
                    else if (inst[24] == 1'b0)
                        begin
                            ay.rd = inst[19:16];
                            ay.rs1 = inst[15:12];
                            ay.rs = inst[11:8];
                            ay.rs2 = inst[3:0];
                            ay.s = inst[20];
                            ay.a = inst[21];
                        end
                    else
                        begin
                            ay.rs1 = inst[19:16];
                            ay.rd = inst[15:12];
                            ay.rs2 = inst[3:0];
                            ay.b = inst[22];
                        end
                end
                3'b001:
                    begin
                        ay.rs1 = inst[19:16];
                        ay.rd = inst[15:12];
                        ay.s = inst[20];
                        ay.encode_imm = inst[11:8];
                        ay.imm8 = inst[7:0];
                    end
                3'b010:
                    begin
                        ay.rs1 = inst[19:16];
                        ay.rd = inst[15:12];
                        ay.offset12 = inst[11:0];
                        ay.p = inst[24];
                        ay.u = inst[23];
                        ay.b = inst[22];
                        ay.w = inst[21];
                        ay.l = inst[20];
                    end
                3'b011:
                    begin
                        ay.rs1 = inst[19:16];
                        ay.rd = inst[15:12];
                        ay.rs2 = inst[3:0];
                        ay.p = inst[24];
                        ay.u = inst[23];
                        ay.b = inst[22];
                        ay.w = inst[21];
                        ay.l = inst[20];
                        ay.shift = inst[6:5];
                        ay.shift_imm = inst[11:7];
                    end
                3'b100:
                    begin
                        ay.rs1 = inst[19:16];
                        ay.register_list = inst[15:0];
                        ay.p = inst[24];
                        ay.u = inst[23];
                        ay.s = inst[22];
                        ay.w = inst[21];
                        ay.l = inst[20];
                    end
                3'b101:
                    begin
                        ay.l = inst[24];
                        ay.offset24 = inst[23:0];
                    end
                3'b110:
                    begin
                        ay.rs1 = inst[19:16];
                        ay.crd = inst[15:12];
                        ay.cphash = inst[11:8];
                        ay.offset8 = inst[7:0];
                        ay.p = inst[24];
                        ay.u = inst[23];
                        ay.n = inst[22];
                        ay.w = inst[21];
                        ay.l = inst[20];
                    end
                3'b111:
                    begin
                        if(inst[24] == 1'b0)
                            begin
                                if (inst[4] == 1'b0)
                                    begin
                                        ay.cp_opcode4 = inst[23:20];
                                        ay.crn = inst[19:16];
                                        ay.crd = inst[15:12];
                                        ay.cphash = inst[11:8];
                                        ay.cp = inst[7:5];
                                        ay.crm = inst[3:0];
                                    end
                                else
                                    begin
                                        ay.cp_opcode3 = inst[23:21];
                                        ay.l = inst[20];
                                        ay.crn = inst[19:16];
                                        ay.crd = inst[15:12];
                                        ay.cphash = inst[11:8];
                                        ay.cp = inst[7:5];
                                        ay.crm = inst[3:0];
                                    end
                            end
                        else
                            begin
                                ay.ibc = inst[23:0];
                            end

                    end
            endcase

            if(!($cast(k, ay)))
                $fatal(1, "failed to cast transaction to amber's transaction");
            return k;
    endfunction

    function bit xis1 (logic[31:0] a,logic[31:0] b);
        logic x;
        x = (a == b);
        if (x === 1'bx)
            begin
                return 1'b1;
            end
        else
            begin
                return 1'b0;
            end
    endfunction: xis1

endpackage