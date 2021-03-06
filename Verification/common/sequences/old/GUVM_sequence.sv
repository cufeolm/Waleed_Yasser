
//generates the sequence of instructions needed to test an add instruction 

class GUVM_sequence extends uvm_sequence #(GUVM_sequence_item);
    `uvm_object_utils(GUVM_sequence);
    target_seq_item command,load1,load2,store,nop , temp ,reset;
    target_seq_item c;
    function new(string name = "GUVM_sequence");
        super.new(name);
    endfunction : new

    task genNop(integer i , logic[31:0] data );
        repeat(i) begin
            nop = target_seq_item::type_id::create("nop");
            nop.ran_constrained(NOP); 
            nop.data = data ; 
            start_item(nop);
            finish_item(nop);
        end
    endtask
    /*
    function  copy(target_seq_item targ);
        temp = target_seq_item::type_id::create("temp");
        temp.do_copy(targ);
    endfunction
    */
    function target_seq_item copy(target_seq_item targ);
        target_seq_item x ;
        x = target_seq_item::type_id::create("x");
        x.do_copy(targ);
        return x ;
    endfunction
    
    
    task send(target_seq_item targ);
        start_item(targ);
        finish_item(targ);
    endtask

    task body();
        repeat(10)
        begin
            reset=target_seq_item::type_id::create("reset");
            load1 = target_seq_item::type_id::create("load1"); //load register x with data dx
            load2 = target_seq_item::type_id::create("load2"); //load register y with data dy
            command = target_seq_item::type_id::create("command");//send add instruction (or any other instruction under test)
            store = target_seq_item::type_id::create("store");//store the result from reg z to memory location (dont care)
            //nop = target_seq_item::type_id::create("nop"); 
            //opcode x=A ;
           // $display("hello , this is the sequence,%d",command.upper_bit);
            reset.SOM = SB_RESET_MODE;
            command.ran_constrained(A); // first randomize the instruction as an add (A is the enum code for add)
            //nop.ran_constrained(NOP);
            command.setup();//set up the instruction format fields 
            if ($isunknown(command.rs1))
                load1.load(0);
            else
            begin
                load1.load(command.rs1);//specify regx address
                load1.rd=command.rs1;
            end
            if ($isunknown(command.rs2))
                load2.load(0);
            else
            begin
                load2.load(command.rs2);//specify regx address  
                load2.rd=command.rs2;
            end 
            store.store(command.rd);//specify regz address

            
			//send the sequence
            //load1.data=load1.data*4;
            //load2.data=load2.data*4;
            send(reset);

            send(load1);
            
            genNop(5,load1.data);
            
            send(load2);
            
            genNop(5,load2.data);
            
            send(command);
            // temp=copy(command);
            // send(temp);
            
            genNop(5,0);
            
            send(store);
            temp = copy(store);
            send(temp);

            genNop(5,0);
            temp = copy(command);
            temp.SOM = SB_VERIFICATION_MODE ; 
            send(temp);

            send(reset);
            
            //genNop(10);
            
        end
    endtask : body


endclass : GUVM_sequence

