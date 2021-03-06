package target_package;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    typedef enum logic [31:0] {
        LDW=32'b11xxxxx000011xxxxx1xxxxxxxxxxxxx,
        A=32'b10xxxxx000000xxxxx000000000xxxxx,
        Ai=32'b10xxxxx000000xxxxx1xxxxxxxxxxxxx,
        UIM=32'b10xxxxx001010xxxxx000000000xxxxx,   // unsigned integer multiply
        SIM=32'b10xxxxx001011xxxxx000000000xxxxx,   // signed integer multiply
        Awc=32'b10xxxxx001000xxxxx000000000xxxxx,
        Aami=32'b10xxxxx010000xxxxx000000000xxxxx,
        UId=32'b10xxxxx001110xxxxx000000000xxxxx,
        BwA=32'b10xxxxx000001xxxxx000000000xxxxx,
        BAwc=32'b10xxxxx000101xxxxx000000000xxxxx,  // bitwise and with complement
        BAI=32'b10xxxxx000001xxxxx1xxxxxxxxxxxxx,   // bitwise and immdeiate
        BAIwc=32'b10xxxxx000101xxxxx1xxxxxxxxxxxxx,  // bit wise and immediate with complement
        BX=32'b10xxxxx000011xxxxx000000000xxxxx,   //xor
        BXI=32'b10xxxxx000011xxxxx1xxxxxxxxxxxxx,  // xor immediate
        BXwc=32'b10xxxxx000111xxxxx000000000xxxxx, // xor complement
        BXIwc=32'b10xxxxx000111xxxxx1xxxxxxxxxxxxx, // xor complement imm
        BO=32'b10xxxxx000010xxxxx000000000xxxxx,
        BOI=32'b10xxxxx000010xxxxx1xxxxxxxxxxxxx,   // or imm
        BOwc=32'b10xxxxx000110xxxxx000000000xxxxx,  // or complement
        BOIwc=32'b10xxxxx000110xxxxx1xxxxxxxxxxxxx, // or imm complement
        N=32'b00000001000000000000000000000000,
        S=32'b10xxxxx000100xxxxx000000000xxxxx,
        Sim=32'b10xxxxx000100xxxxx1xxxxxxxxxxxxx, // sub imm
        Sll=32'b10xxxxx100101xxxxx000000000xxxxx,   // shift logic left
        Slli=32'b10xxxxx100101xxxxx100000000xxxxx,  // shift logic left imm
        Srl=32'b10xxxxx100110xxxxx000000000xxxxx,   // shift logic right
        Srli=32'b10xxxxx100110xxxxx100000000xxxxx,   // shift right logic imm
        Sra=32'b10xxxxx100111xxxxx000000000xxxxx,  // shift right arithmetic
        Srai=32'b10xxxxx100111xxxxx100000000xxxxx, // shift right arithmetic imm
        Sh2b=32'b00xxxxx100xxxxxxxxxxxxxxxxxxxxxx, // set high-order 22 bit
        Store=32'b11xxxxx0001000000010000000000000,
        Load = 32'b11xxxxx0000000000010000000000000
    } opcode;

/*
    typedef enum logic [31:0] {
    Load = 32'b11xxxxx0000000000010000000000000,
    //N=32'b00000001000000000000000000000000,
    Store =32'b11xxxxx0001000000010000000000000
    }special_op_t;//this op code for filling and reading the register files
*/
   // parameter immd_bits=12; 
    opcode si_a [] ;
    opcode reg_instruction;
    integer supported_instructions ;
     parameter ext_bits=19;
     parameter last_imm=12;
     parameter first_imm=0;
     parameter to_ext=12;
     parameter shamt_last=4;
    //includes
	`include"GUVM.sv"




    function void fill_si_array();// fill supported instruction array
    // this does NOT  affect generalism this makes sure you dont run
    // the same function twice in a test bench
    `ifndef SET_UP_INSTRUCTION_ARRAY
        `define SET_UP_INSTRUCTION_ARRAY
        opcode si_i ; // for iteration only
        supported_instructions = si_i.num() ;
        si_a=new [supported_instructions] ;

        si_i = si_i.first();
        for (integer i=0 ; i < supported_instructions ; i++ )
            begin
                si_a [i]= si_i ;
                si_i=si_i.next();

            end
        $display("array is filled and ready to use");
    `endif
    endfunction


        function GUVM_sequence_item get_format (logic [31:0] inst);
            target_seq_item ay;
            GUVM_sequence_item k ;
            k = new("k");
            ay = new("ay");
            ay.inst=inst;
            ay.op = inst[31:30];
            case (ay.op)
                2'b01 :
                    //call format1
                    ay.disp30 = inst[29:0];
                2'b00 : begin
                    ay.op2 = inst[24:22];
                    case (ay.op2)
                        3'b100,3'b000 :
                            //sethi & no op & unimplemnted format 2
                            begin
                                ay.rd = inst[29:25];
                                ay.imm22 = inst[21:0];
                            end
                        3'b010, 3'b110, 3'b111 :
                            //branch & fp branch & co branch format 2
                            begin
                                ay.a = inst[29];
                                ay.cond = inst[28:25];
                                ay.disp22 = inst[21:0];
                            end
                        default: uvm_report_error("k.instruction", "k.instruction format not defined");
                    endcase
                end
                2'b10, 2'b11 : begin
                    ay.i = inst[13];
                    ay.rd = inst[29:25];
                    ay.op3 = inst[24:19];
                    ay.rs1 = inst[18:14];
                    if (!ay.i)
                        //format 3 register register
                        begin
                            ay.asi = inst[12:5];
                            ay.rs2 = inst[4:0];
                        end
                    else
                        //format 3 register immediate
                        begin
                            ay.imm13 = inst[12:0];
                        end

                end
                default: uvm_report_error("k.instruction", "k.instruction format not defined");
            endcase

            if (!($cast(k,ay)))
                $fatal(1,"failed to cast transaction to leon's transaction");
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
	    endfunction : xis1

endpackage