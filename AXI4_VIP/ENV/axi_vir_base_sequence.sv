/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : axi_master_vir_base_sequence.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : Sep 12
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef MAXI_VIRTUAL_SEQUENCE_UVM
`define MAXI_VIRTUAL_SEQUENCE_UVM

class axi_mas_vir_base_sequence#(int ADDR_WIDTH = 32 , DATA_WIDTH = 32, ID_WIDTH = 16) extends uvm_sequence#( uvm_sequence_item);
 
   `uvm_object_param_utils_begin(axi_mas_vir_base_sequence)
   `uvm_object_utils_end

    `uvm_declare_p_sequencer(axi_vir_base_sequencer)


   //All sequencer Handles
   mas_axi_sequencer#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) mas_seqr_h;
   slv_axi_sequencer#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) slv_seqr_h;

   rand int no_of_read_pkt; 
   rand int no_of_write_pkt; 
   rand bit [ADDR_WIDTH-1 : 0] addr_q[$];

   constraint size_of_addr_q {addr_q.size() == no_of_write_pkt;};
   
   function new(string name = "axi_mas_vir_base_sequence");
   super.new(name);
   
   endfunction 
 
   task pre_body();

   //mas_seqr_h = p_sequencer.mas_seqr_h;
   //slv_seqr_h = p_sequencer.slv_seqr_h;
   endtask


  endclass
 `endif
 
