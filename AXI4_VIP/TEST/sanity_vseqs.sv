/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : sanity_vseqs.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : SEP 15
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef AXI_SANITY_VSEQS_UVM	
`define AXI_SANITY_VSEQS_UVM

class sanity_vseqs#(int ADDR_WIDTH = 32 , DATA_WIDTH = 32, ID_WIDTH = 16) extends axi_mas_vir_base_sequence#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH);

  //Factory registration
 
 `uvm_object_param_utils(sanity_vseqs)

 

 
 
 function new(string name = "sanity_vseqs");

 super.new(name);
 endfunction

 seqs_write#( ADDR_WIDTH, DATA_WIDTH , ID_WIDTH ) wr_seqs_h;
 seqs_read#( ADDR_WIDTH, DATA_WIDTH , ID_WIDTH )  rd_seqs_h;

 task body();
  
  wr_seqs_h =  seqs_write#( ADDR_WIDTH, DATA_WIDTH , ID_WIDTH )::type_id::create("wr_seqs_h");
  rd_seqs_h =  seqs_read#( ADDR_WIDTH, DATA_WIDTH , ID_WIDTH )::type_id::create("rd_seqs_h");

  void'(wr_seqs_h.randomize() with {no_of_packet == no_of_write_pkt; foreach( wr_addr_q[i]) wr_addr_q[i] == addr_q[i] ; });
  wr_seqs_h.start(p_sequencer.mas_seqr_h[0]);

  void'(rd_seqs_h.randomize() with {no_of_packet == no_of_read_pkt;  foreach( rd_addr_q[i] ) rd_addr_q[i] inside {addr_q}; });
  rd_seqs_h.start(p_sequencer.mas_seqr_h[0]);
  
  $display(" addr_q : %0p", addr_q); 

 endtask

endclass
`endif
