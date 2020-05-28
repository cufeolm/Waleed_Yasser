package target_package;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    // instructions opcodes verified in this core 
    typedef enum logic [31:0] {
        LDW= 32'b11xxxxx000011xxxxx1xxxxxxxxxxxxx,
        A=32'b10xxxxx000000xxxxx000000000xxxxx,
        ADDCC=32'b10xxxxx010000xxxxx000000000xxxxx,
        ADDX =32'b10xxxxx001000xxxxx000000000xxxxx,
        Ai=32'b10xxxxx000000xxxxx1xxxxxxxxxxxxx,
        Jalr_cpc=32'b10xxxxx111000xxxxx10000000001100,
        Jalrr=32'b10xxxxx111000xxxxx000000000xxxxx,
        NOP=32'b00000001000000000000000000000000,
        S=32'b10xxxxx000100xxxxx000000000xxxxx,
        SUBCC=32'b10xxxxx010100xxxxx000000000xxxxx,

        BIEF=32'b0010001010xxxxxxxxxxxxxxxxxxxxxx,
        BCSF = 32'b0010101010xxxxxxxxxxxxxxxxxxxxxx,
        BNEGF = 32'b0010110010xxxxxxxxxxxxxxxxxxxxxx,
        BVSF = 32'b0010111010xxxxxxxxxxxxxxxxxxxxxx,

        BA= 32'b0001000010xxxxxxxxxxxxxxxxxxxxxx,
        //BIEF=32'b0010001010xxxxxxxxxxxxxxxxxxxxxx,
        Store =32'b11xxxxx0001000000010000000000000,
        Load = 32'b11xxxxx0000000000010000000000000
    } opcode;
    // mutual instructions between cores have the same name so we can verify all cores using one scoreboard

    opcode si_a [] ;    // opcodes array to store enums so we can randomize and use them
    integer supported_instructions ;    // number of instructions in the array
    `include "leon_defines.sv"
	`include"GUVM.sv"   // including GUVM classes 


    // fill supported instruction array
    function void fill_si_array();
    // this does NOT  affect generalism
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
    `endif
    endfunction
        // used in if conditions to compare between (x) and (1 or 0)
    function bit xis1 (logic[31:0] a,logic[31:0] b);
        logic x;
        x = (a == b);
        if(x==1) return 1 ;
        else if (x === 1'bx)
            begin
                return 1'b1;
            end
        else
            begin
                return 1'b0;
            end
        endfunction : xis1


endpackage