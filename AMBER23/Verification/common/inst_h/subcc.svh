function void verify_subcc(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
    bit [31:0]i1,i2,hc ;
    bit [32:0] h1 ; 
    i1 = hist_trans.get_reg_data(cmd_trans.rs1); 
	i2 = hist_trans.get_reg_data(cmd_trans.rs2); 
	h1 = i1 - i2 ;
	if (cmd_trans.SOM == SB_HISTORY_MODE)
	begin	
        hist_trans.carry=h1[32];
        hist_trans.neg = h1[31];
        hist_trans.zero = (h1[31:0]==0);
        hist_trans.loadreg(h1[31:0],cmd_trans.rd);
    end
    
    else if (cmd_trans.SOM == SB_VERIFICATION_MODE)
    begin
        foreach(hist_trans.item_history[i])begin
			if (hist_trans.item_history[i].res_trans.result!==0) begin
				 hc = hist_trans.item_history[i].res_trans.result ; 
				 break ; 
			end
		end
		//hc = res_trans.result;
		if((h1) == (hc))
		begin
			`uvm_info ("SUBcc_PASS", $sformatf("DUT Calculation=%h SB Calculation=%h ", hc, h1), UVM_LOW)
		end
		else
		begin
			`uvm_error("SUBcc_FAIL", $sformatf("DUT Calculation=%h SB Calculation=%h ", hc, h1))
		end
	end

endfunction
