/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : burst_vseqs.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : SEP 15
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef AXI_BURST_VSEQS_UVM	
`define AXI_BURST_VSEQS_UVM

class burst_vseqs#(int ADDR_WIDTH = 32 , DATA_WIDTH = 32, ID_WIDTH = 16) extends axi_mas_vir_base_sequence#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH);

  //Factory registration
 
 `uvm_object_param_utils(burst_vseqs)
 
 function new(string name = "burst_vseqs");
 super.new(name);
 endfunction

 seqs_burst#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) burst_h;
 seqs_write#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  write_h;
 task body();
  
  write_h = seqs_write#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("write_h");
  void'(write_h.randomize());
  write_h.start(p_sequencer.mas_seqr_h[0]);
  
  burst_h =  seqs_burst#( ADDR_WIDTH, DATA_WIDTH , ID_WIDTH )::type_id::create("burst_h");
  void'(burst_h.randomize());
  burst_h.start(p_sequencer.mas_seqr_h[0]);
    

 endtask

endclass
`endif
