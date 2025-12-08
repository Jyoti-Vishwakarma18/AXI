/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : error_resp_vseqs.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : SEP 26
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef AXI_ERROR_RESP_VSEQS_UVM	
`define AXI_ERROR_RESP_VSEQS_UVM

class error_resp_vseqs#(int ADDR_WIDTH = 32 , DATA_WIDTH = 32, ID_WIDTH = 16) extends axi_mas_vir_base_sequence#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH);

 seqs_write#( ADDR_WIDTH, DATA_WIDTH , ID_WIDTH ) wr_seqs_h;
 seqs_read#( ADDR_WIDTH, DATA_WIDTH , ID_WIDTH )  rd_seqs_h;
 
 `uvm_object_param_utils(error_resp_vseqs)
 
 function new(string name = "error_resp_vseqs");

     super.new(name);
     endfunction



 task body();
  
     wr_seqs_h =  seqs_write#( ADDR_WIDTH, DATA_WIDTH , ID_WIDTH )::type_id::create("wr_seqs_h");
     void'(wr_seqs_h.randomize() with {no_of_packet == 2;});
     wr_seqs_h.start(p_sequencer.mas_seqr_h[0]);
     rd_seqs_h =  seqs_read#( ADDR_WIDTH, DATA_WIDTH , ID_WIDTH )::type_id::create("rd_seqs_h");
     void'(rd_seqs_h.randomize() with {no_of_packet == 2;});
     rd_seqs_h.start(p_sequencer.mas_seqr_h[0]);
     endtask

endclass
`endif
