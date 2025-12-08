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

   event request;
   func_cvg#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)                                                  axi_cvg_h;
   uvm_blocking_put_imp#(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH),  axi_scoreboard)  exp_tlm_imp;      //to get expected transcation form reference model
   uvm_analysis_imp_master#(mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH,ID_WIDTH), axi_scoreboard) mas_an_imp[]; //to get actual transcation form AXI master monitor
   slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)                                          exp_trans_h;
   mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)                                          act_trans_h;
   mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)                                          act_ar[int];
   slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)                                          exp_ar[int];
   int                                                                                          id;
   

  //________________________Factory Registration__________________________________
  `uvm_component_param_utils(axi_scoreboard)
  
 
   
  function new(string name = "axi_scoreboard", uvm_component parent = null);

     super.new(name, parent);
     exp_tlm_imp    = new("exp_tlm_imp", this);
     axi_cvg_h  = func_cvg#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("axi_cvg_h",this);

     mas_an_imp = new[`NO_OF_MASTER];
     foreach(mas_an_imp[i]) mas_an_imp[i] = new($sformatf("mas_an_imp[%0d]",i),this);
     endfunction

 function void build_phase(uvm_phase phase);

     super.build_phase(phase);


     endfunction
 
 function void write_master(mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH,ID_WIDTH) act_trans_h);

     if(act_trans_h.enb == act_trans_h.READ) begin
     this.id = act_trans_h.RID;
     act_ar[act_trans_h.RID] = act_trans_h;
     ->request;
     end
     endfunction

 
 task put(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH,ID_WIDTH) exp_trans_h);

       axi_cvg_h.trans_h = exp_trans_h;
       axi_cvg_h.sample_cvg(exp_trans_h);
       if(exp_trans_h.enb == exp_trans_h.READ) begin

       exp_ar[exp_trans_h.RID] = exp_trans_h; 
       end
     endtask 

 task run_phase(uvm_phase phase);

     forever begin
       begin
        
	@(request);
	if(exp_ar.exists(id)) exp_trans_h = exp_ar[id];
        else `uvm_error("REFERENCE",$sformatf("expected  Id : %0d does not exits", id))
	act_trans_h = act_ar[id];

	act_ar.delete(id);
	exp_ar.delete(id);

        $display($time,"EXPETED : %0p | ID : %0d", exp_trans_h.rdata_array, exp_trans_h.RID );
        $display($time,"ATUCAL  : %0p | ID : %0d", act_trans_h.rdata_array, act_trans_h.RID);
	
        if(exp_trans_h==null)`uvm_fatal(get_full_name(),"exp_trans_h is null")
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
                                           else `uvm_error(get_full_name," RDATA UNMATCHED!!")
	end	  
 endfunction
 


 endclass
 `endif
