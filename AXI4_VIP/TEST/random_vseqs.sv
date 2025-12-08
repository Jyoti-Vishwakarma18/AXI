/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : random_vseqs.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : SEP 22
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef AXI_RANDOM_VSEQS_UVM	
`define AXI_RANDOM_VSEQS_UVM

class random_vseqs#(int ADDR_WIDTH = 32 , DATA_WIDTH = 32, ID_WIDTH = 16) extends axi_mas_vir_base_sequence#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH);

 
 `uvm_object_param_utils(random_vseqs)
 
 function new(string name = "random_vseqs");
 super.new(name);
 endfunction

 seqs_random#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  seqs_h;

 task body();
  
  seqs_h = seqs_random#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("seqs_h");
  void'(seqs_h.randomize() with {no_of_packet == 5;});
  seqs_h.start(p_sequencer.mas_seqr_h[0]);

 endtask

endclass
`endif
