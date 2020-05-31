class aBranch_sequence extends GUVM_sequence;
    `uvm_object_utils(add_sequence);
    target_seq_item command, nop, temp, reset;

    function new(string name = "aBranch_sequence");
        super.new(name);
    endfunction: new

    task body();
        repeat(10) begin
            command = target_seq_item::type_id::create("command");
            command.ran_constrained(findOP(clp_inst));
            
            $display("before the setup %d", command.data);
            command.setup(); //set up the instruction format fields 
            $display("after the setup %d", command.data);

            resetSeq();
            
                send(command);
                genNop(10, 0);

                temp = copy(command);
                temp.SOM = SB_VERIFICATION_MODE; 
                send(temp);

            resetSeq();
        end
    endtask: body


endclass: add_sequence

