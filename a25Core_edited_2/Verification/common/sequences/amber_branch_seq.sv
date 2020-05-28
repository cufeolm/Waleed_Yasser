class amber_branch_seq extends GUVM_sequence;
    `uvm_object_utils(add_sequence);

    target_seq_item command, nop, reset;

    function new(string name = "amber_branch_seq");
        super.new(name);
    endfunction: new

    task body();
        repeat(10) begin

            command = target_seq_item::type_id::create("command");
            command.ran_constrained(findOP(clp_inst));
            
            //nop.ran_constrained(NOP);
            $display("before the setup %d", command.data);
            command.setup();//set up the instruction format fields 
            $display("after the setup %d", command.data);

            resetSeq();
			//send the sequence
            
            send(command);
            genNop(5, 0);

            temp = copy(command);
            temp.SOM = SB_VERIFICATION_MODE; 
            send(temp);

            resetSeq();
        end
    endtask : body


endclass : add_sequence

