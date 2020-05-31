package target_package;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // instructions opcodes verified in  this core 
    typedef enum logic[31:0] { 
        A  = 32'b1110000010000xxx0xxx000000000xxx,
        Awc=32'b1110000010100xxx0xxx000000000xxx, // add with carry  

        S=32'b1110000001000xxx0xxx000000000xxx,
        Rs=32'b1110000001100xxx0xxx000000000xxx,
        Swc=32'b1110000011000xxx0xxx000000000xxx, // sub with carry

        C=32'b1110000101010xxx0xxx000000000xxx,
        
        
        BwA=32'b1110000000000xxx0xxx000000000xxx, // bitwise and
        BAwc=32'b1110000111000xxx0xxx000000000xxx, // bitwise and with complement
        BX=32'b1110000000100xxx0xxx000000000xxx, // xor
        BO=32'b1110000110000xxx0xxx000000000xxx,

        BR =32'b11101010xxxxxxxxxxxxxxxxxxxxxxxx,
        BRL=32'b11101011xxxxxxxxxxxxxxxxxxxxxxxx,

        Mov=32'b1110000110100xxx0xxx000000000xxx,
        Mn=32'b1110000111100xxx0xxx000000000xxx,

        M=32'b1110000000000xxx00000xxx10010xxx,
        MA=32'b1110000000100xxx0xxx0xxx10010xxx, // multiply accumlate

        // NOP = 32'b111101101000xxxxxxxxxxxxxxxxxxxx,
        NOP = 32'b1111000010000xxx0xxx000000000xxx,
        // NOP = 32'b00000000000000000000000000000000,
        Store = 32'b1110010110000xxx0xxx000000000000,
        // Load  = 32'b11100101100100000xxx000000000000
        // Load =  32'b10101010101010100xxx101010101010
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