package target_package;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

    // instructions opcodes verified in this core 
	typedef enum logic[31:0] {
		//LW = 32'bxxxxxxxxxxxxxxxxx010xxxxx0000011,
		A = 32'b0000000xxxxxxxxxx000xxxxx0110011,
		//SW = 32'bxxxxxxxxxxxxxxxxx010xxxxx0100011,
		NOP =32'h0000001B ,
		Jal=32'bxxxxxxxxxxxxxxxxxxxxxxxxx1101111,
		Jalr=32'bxxxxxxxxxxxxxxxxx000xxxxx1100111,
		BIER=32'bxxxxxxxxxxxxxxxxx000xxxxx1100011,
		Store =32'b0000000xxxxx00000010000000100011,
        Load = 32'b00000000000000000010xxxxx0000011
	} opcode;
    // mutual instructions between cores have the same name so we can verify all cores using one scoreboard

	opcode si_a [];	// opcodes array to store enums so we can randomize and use them
    integer supported_instructions;	 // number of instructions in the array
	`include "riscy_defines.sv"
	`include "GUVM.sv"	// including GUVM classes 
   

    // fill supported instruction array
	function void fill_si_array();
		// this does NOT  affect generalism this makes sure you dont run
		// the same function twice in a test bench
		`ifndef SET_UP_INSTRUCTION_ARRAY
		`define SET_UP_INSTRUCTION_ARRAY
			opcode si_i ; // for iteration only
			supported_instructions = si_i.num();
			si_a = new [supported_instructions];
			si_i = si_i.first();
			for(integer i=0; i<supported_instructions; i++) begin
				si_a[i] = si_i;
				si_i = si_i.next();
			end
		`endif
	endfunction


    // function to determine format of verfied instruction and fill its operands


    // used in if conditions to compare between (x) and (1 or 0)
	function bit xis1 (logic[31:0] a,logic[31:0] b);
		logic x;
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
	   endfunction : xis1

endpackage