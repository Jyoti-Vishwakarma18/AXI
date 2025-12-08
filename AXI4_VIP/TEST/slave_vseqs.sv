/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : slave_vseqs.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : SEP 15
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef AXI_SLAVE_VSEQS_UVM	
`define AXI_SLAVE_VSEQS_UVM

class slave_vseqs#(int ADDR_WIDTH = 32 , DATA_WIDTH = 32, ID_WIDTH = 16) extends axi_mas_vir_base_sequence#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH);
  //Factory registration
 
 `uvm_object_param_utils(slave_vseqs)
 
 function new(string name = "slave_vseqs");

 super.new(name);
 endfunction

 slv_axi_sequence#( ADDR_WIDTH, DATA_WIDTH , ID_WIDTH )  seqs_h;

 task body();
  
  seqs_h =  slv_axi_sequence#( ADDR_WIDTH, DATA_WIDTH , ID_WIDTH )::type_id::create("seqs_h");

  seqs_h.start(p_sequencer.slv_seqr_h[0]);

 endtask

endclass
`endif





