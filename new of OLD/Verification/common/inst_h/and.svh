function void verify_and(target_seq_item cmd_trans,GUVM_result_transaction res_trans);
	bit [31:0] hc, i1, i2, h1;
	hc = res_trans.result;
	i1 = cmd_trans.operand1; 
	i2 = cmd_trans.operand2;
	h1 = i1 & i2;
	$display("i1=%b, i2=%b, h1=%b",i1,i2,h1);
	if(h1 == hc)
		begin
			`uvm_info ("bitwise AND_pass", $sformatf("Actual Calculation=%b Expected Calculation=%b ", res_trans.result, h1),UVM_LOW)
		end
	else
		begin
			`uvm_error("bitwise AND_fail", $sformatf("Actual Calculation=%b Expected Calculation=%b ", res_trans.result, h1))
		end
endfunction