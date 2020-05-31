function void verify_aBranch(GUVM_sequence_item cmd_trans, GUVM_result_transaction res_trans, GUVM_history_transaction hist_trans);
	bit [31:0] current_pc, result, hc;
	bit [23:0] offset;
	// bit [23:0] current_pc, offset, hc, result;
	bit [31:0] offset_shifted;

	if(cmd_trans.SOM == SB_HISTORY_MODE) begin	
		//		
	end else if(cmd_trans.SOM == SB_VERIFICATION_MODE) begin
		offset = cmd_trans.inst[23:0];
		offset_shifted = offset << 2;
		current_pc = hist_trans.item_history[0].cmd_trans.current_pc;
		result = offset_shifted + current_pc;
		// result = offset + current_pc;
		$display("offset=%h offset_shifted=%h current_pc=%h result=%h", offset, offset_shifted, current_pc, result);
		/*foreach(hist_trans.item_history[i]) begin
			if(hist_trans.item_history[i].res_trans.result!==0) begin
				hc = hist_trans.item_history[i].res_trans.result; 
				break; 
			end
		end*/
		hc = hist_trans.item_history[2].cmd_trans.current_pc;
		$display("hc=%h", hc);
		if(result == hc) begin
			`uvm_info ("AMBER_BRANCH_PASS", $sformatf("DUT Calculation=%h SB Calculation=%h ", hc, result), UVM_LOW)
		end else begin
			`uvm_error("AMBER_BRANCH_FAIL", $sformatf("DUT Calculation=%h SB Calculation=%h ", hc, result))
		end
	end
endfunction