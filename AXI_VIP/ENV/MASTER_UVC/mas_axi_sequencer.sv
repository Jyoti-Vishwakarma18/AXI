/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : mas_axi_sequencer sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef MASTER_AXI_SEQR_UVM
`define MASTER_AXI_SEQR_UVM

class mas_axi_sequencer#(int ADDR_WIDTH = 32 , DATA_WIDTH = 32, ID_WIDTH = 16) extends uvm_sequencer#( mas_axi_seq_item#(ADDR_WIDTH , DATA_WIDTH, ID_WIDTH));

  `uvm_component_param_utils(mas_axi_sequencer)

  function new(string  name = "mas_axi_sequencer",uvm_component parent = null);
  super.new(name, parent);
  endfunction

endclass
`endif
