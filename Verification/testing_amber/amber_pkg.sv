package target_package;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // instructions opcodes verified in this core 
    typedef enum logic[31:0] { 
        //LW = 32'b111101101001xxxxxxxxxxxxxxxxxxxx,
        NOP = 32'b111101101000xxxxxxxxxxxxxxxxxxxx,
        //SW = 32'b111001011000xxxxxxxxxxxxxxxxxxxx,
        A  = 32'b1110000010000xxx0xxx000000000xxx,
        M=32'b1110000000000xxx00000xxx10010xxx,
        Store = 32'b11100101100000000xxx000000000000,
        Load =  32'b10101010101010100xxx101010101010 
    } opcode; 
    // mutual instructions between cores have the same name so we can verify all cores using one scoreboard
    
    opcode si_a[];  // opcodes array to store enums so we can randomize and use them
    integer supported_instructions; // number of instructions in the array
    `include "amber_defines.sv"
    `include "GUVM.sv"   // including GUVM classes 
    

    // fill supported instruction array
    function void fill_si_array();
    // this does NOT affect generalism
        `ifndef SET_UP_INSTRUCTION_ARRAY
        `define SET_UP_INSTRUCTION_ARRAY
            opcode si_i; // for iteration only
            supported_instructions = si_i.num();
            si_a = new[supported_instructions];

            si_i = si_i.first();
            for(integer i=0; i < supported_instructions; i++)
                begin
                    si_a[i] = si_i;
                    si_i = si_i.next();
                end
        `endif
    endfunction


    // function to determine format of verfied instruction and fill its operands
    
    // used in if conditions to compare between (x) and (1 or 0)
    function bit xis1 (logic[31:0] a,logic[31:0] b); 
        logic x;
        // $display("xis1:                 a=%h,b=%h",a,b);
        x = (a == b);
        if(x==1) return 1 ;
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