

function void verify_bief(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
	logic [31:0] pc ;
	logic  dc ;
	dc=0;
	if (cmd_trans.SOM == SB_HISTORY_MODE)
	begin	

		
    end
    
    else if (cmd_trans.SOM == SB_VERIFICATION_MODE)
	begin
		foreach(hist_trans.item_history[i])begin
			if (i>0)begin
				if (hist_trans.item_history[i].cmd_trans.current_pc!=hist_trans.item_history[i-1].cmd_trans.current_pc+4) begin
				 //hc = hist_trans.item_history[i].res_trans.result ; 
					pc = hist_trans.item_history[i].cmd_trans.current_pc;
					dc =1 ;
					//`uvm_info ("bie_PASS", $sformatf("DUT Calculation=%h SB Calculation=%h ", pc, pc), UVM_LOW);
				 break ; 
				end
				else begin
					
					dc=0;
				end
			end
		end
		if (hist_trans.zero&&dc)begin
			`uvm_info ("bie_PASS", $sformatf("DUT Calculation=%h SB Calculation=%h ", pc, pc), UVM_LOW);
		end
		else begin
			`uvm_info ("bie_fail", $sformatf("DUT Calculation=%h SB Calculation=%h ", pc, pc), UVM_LOW);
		end
		
	end

endfunction