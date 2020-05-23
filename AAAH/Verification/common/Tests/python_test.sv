class python_test extends uvm_test;
    `uvm_component_utils(python_test);
    function new(string name = "python_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new
    
    GUVM_env       env_h;
    python_sequence generic_sequence_h;
    uvm_cmdline_processor cmdline_proc;

    function void build_phase(uvm_phase phase);
        cmdline_proc = uvm_cmdline_processor::get_inst();
        env_h   = GUVM_env::type_id::create("env_h",this);
        generic_sequence_h = python_sequence::type_id::create("generic_sequence_h");
    endfunction: build_phase 

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        $display("test have started ");
        generic_sequence_h.clp(cmdline_proc);
        generic_sequence_h.start(env_h.agent.sequencer);
        phase.drop_objection(this);
    endtask: run_phase

endclass: python_test

