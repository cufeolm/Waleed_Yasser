function void verify_add(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
	bit [31:0]hc,i1,i2,h1 ;
	i1 = hist_trans.get_reg_data(cmd_trans.rs1); 
	i2 = hist_trans.get_reg_data(cmd_trans.rs2); 
	h1 = i1 + i2 ;
	$display("i1=%h i2=%h h1=%h",i1,i2,h1);
	//hist_trans.updateflags (h1);


	if (cmd_trans.SOM == SB_HISTORY_MODE)
	begin	
		hist_trans.loadreg(h1[31:0],cmd_trans.rd);	
	end
	else if (cmd_trans.SOM == SB_VERIFICATION_MODE)begin
		foreach(hist_trans.item_history[i])begin
			if (hist_trans.item_history[i].res_trans.result!==0) begin
				 hc = hist_trans.item_history[i].res_trans.result ; 
				 break ; 
			end
		end
		//hc = res_trans.result;
		h1 = hist_trans.get_reg_data(cmd_trans.rd);
		if((h1) == (hc))
		begin
			`uvm_info ("ADDITION_PASS", $sformatf("DUT Calculation=%h SB Calculation=%h ", hc, h1), UVM_LOW)
		end
		else
		begin
			`uvm_error("ADDITION_FAIL", $sformatf("DUT Calculation=%h SB Calculation=%h ", hc, h1))
		end
	end


endfunction