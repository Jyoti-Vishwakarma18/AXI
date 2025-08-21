/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : scoreboard.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 17
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/
//Guard Statement
`ifndef SCOREBOARD_AXI_UVM
`define SCOREBOARD_AXI_UVM

 `uvm_analysis_imp_decl(_master)
 `uvm_analysis_imp_decl(_reference)

class axi_scoreboard#(ADDR_WIDTH = 32, DATA_WIDTH = 32, ID_WIDTH = 16) extends uvm_scoreboard;

  //________________________Factory Registration__________________________________
  `uvm_component_param_utils(axi_scoreboard)
  
 
  //________________________Declaration__________________________________________ 
   event request;

   //tlm_port for ref and scoreboard 
   uvm_blocking_put_imp#(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH),  axi_scoreboard)  act_imp;
  //analysis port connection of scoreboard to two monitor
   uvm_analysis_imp_master#(mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH,ID_WIDTH), axi_scoreboard) mas_an_imp;
 
   slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  exp_trans_h;
   mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  act_trans_h;
   mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  act_que[$];
   slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  exp_que[$];
 
   

  //________________________new function________________________________  
  function new(string name = "axi_scoreboard", uvm_component parent = null);
  super.new(name, parent);
  act_imp    = new("act_imp", this);
  mas_an_imp = new("mas_an_imp",this);
  endfunction

 //___________________________build_phase_____________________________________
 function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 endfunction
 
 function void write_master(mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH,ID_WIDTH) mtrans_h);
       //This task get actual data form master_monitor 
       //`uvm_info("SCOREBOARD ", " RDATA form master", UVM_LOW) 
       // $display($time," : READ DATA : %0p", mtrans_h.rdata_array);
       if(mtrans_h.enb == mtrans_h.READ) act_que.push_back(mtrans_h);
 endfunction

 
 task put(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH,ID_WIDTH) act_trans_h);
       //This task get expected data form reference
       exp_que.push_back(act_trans_h); 
       ->request;
 endtask 

task run_phase(uvm_phase phase);
     repeat(2) begin
       begin
        wait(act_que.size() != 0);
        act_trans_h = act_que.pop_front();
        exp_trans_h = exp_que.pop_front();
        $display($time,"EXPETED : %0p |ID : %0d", exp_trans_h.rdata_array,exp_trans_h.RID );
        $display($time,"ATUCAL: %0p | ID : %0d", act_trans_h.rdata_array, act_trans_h.RID);
        compare(exp_trans_h,act_trans_h );
       end
      end
      
endtask

      
 function void compare(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) exp_trans, mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) act_trans);
   int compare_count = 0;
   int pass_count = 0;
   compare_count = exp_trans.rdata_array.size();
   if(exp_trans.RID == act_trans.RID)
	 begin
	 $display("                           =================================================================");
	 $display("                                               SCOREBOARD");
	 $display("                                               ID MATCHED!!");
	 foreach(exp_trans.rdata_array[i]) if(exp_trans.rdata_array[i] == act_trans.rdata_array[i]) pass_count++;
	  
	 if(compare_count ==  pass_count)begin
	 $display("                                                RDATA MATCHED!!");
	 $display("                                           *****   ***    ***   ***");
         $display("                                           *   *  *   *  *     *   ");
         $display("                                           *****  *****   ***   ***");
         $display("                                           *      *   *      *     *");
         $display("                                           *      *   *  ***   ***");
	 $display("                           =================================================================");
					   end
                                           else $display(" RDATA UNMATCHED!!");
	end	  
 endfunction


 endclass
 `endif
