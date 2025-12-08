/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : axi_vir_base_sequencer sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef AXI_VIRTUAL_SEQR_UVM
`define AXI_VIRTUAL_SEQR_UVM

class axi_vir_base_sequencer#(int ADDR_WIDTH = 32 , DATA_WIDTH =32 , ID_WIDTH =16)  extends uvm_sequencer #(uvm_sequence_item);

  `uvm_component_param_utils(axi_vir_base_sequencer)

   //All sequencer Handles
   mas_axi_sequencer#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) mas_seqr_h[];
   slv_axi_sequencer#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) slv_seqr_h[];
 

  function new(string  name = "axi_vir_base_sequencer",uvm_component parent = null);
      super.new(name, parent);
      mas_seqr_h = new[`NO_OF_MASTER];
      slv_seqr_h = new[`NO_OF_SLAVE];

  endfunction
  
 
  
 
 task run_phase(uvm_phase phase);
 
   
 
 endtask
 
   

endclass
`endif
