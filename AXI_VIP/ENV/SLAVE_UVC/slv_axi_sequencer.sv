/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : slv_axi_sequencer sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef SLAVE_AXI_SEQR_UVM
`define SLAVE_AXI_SEQR_UVM

class slv_axi_sequencer#(int ADDR_WIDTH = 32 , DATA_WIDTH =32 , ID_WIDTH =16)  extends uvm_sequencer #(slv_axi_seq_item#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH));

  `uvm_component_param_utils(slv_axi_sequencer)

  uvm_tlm_analysis_fifo#( slv_axi_seq_item#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)) store_fifo;

  function new(string  name = "slv_axi_sequencer",uvm_component parent = null);
  super.new(name, parent);
  store_fifo = new("store_fifo", this);
  endfunction
  
 
   
 function write(slv_axi_seq_item#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) trans_h);
 endfunction
  
 
 task run_phase(uvm_phase phase);
 
   
 
 endtask
 
   

endclass
`endif
