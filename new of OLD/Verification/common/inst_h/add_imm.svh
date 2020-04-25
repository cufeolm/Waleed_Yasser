function void verify_add_imm(target_seq_item cmd_trans, GUVM_result_transaction res_trans);
	bit [31:0] hc, i1, i2, h1;
	hc = res_trans.result;
	i1 = cmd_trans.operand1;
	i2 = {{ext_bits{cmd_trans.inst[to_ext]}}, cmd_trans.inst[last_imm:first_imm]};
	h1 = i1 + i2;
	$display("i1=%b, i2=%b, h1=%b",i1,i2,h1);
	if(h1 == hc)
		begin
			`uvm_info ("ADDIMMEDIATE_PASS", $sformatf("Actual Calculation=%d Expected Calculation=%d ", res_trans.result, h1), UVM_LOW)
		end
	else
		begin
			`uvm_error("ADDIMMEDIATE_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d ", res_trans.result, h1))
		end
endfunction