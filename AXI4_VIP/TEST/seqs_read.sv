/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : seqs_sanity.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 17
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef SEQS_READ_UVM
`define SEQS_READ_UVM

class seqs_read#(int ADDR_WIDTH = 32 , DATA_WIDTH = 32, ID_WIDTH = 16) extends mas_axi_sequence#(ADDR_WIDTH , DATA_WIDTH, ID_WIDTH);
 
   `uvm_object_param_utils_begin(seqs_read)
   `uvm_object_utils_end

   mas_axi_seq_item#(ADDR_WIDTH , DATA_WIDTH, ID_WIDTH) trans_read;
 
   function new(string name = "seqs_read");
   super.new(name);
   endfunction 
 
  
     task body();

        trans_read = mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("trans_read");
	repeat(no_of_packet) begin
        start_item(trans_read);
        trans_read.randomize() with { enb == READ; ARLEN == rd_len_q.pop_front(); ARADDR == rd_addr_q.pop_front(); };
        //display(trans_read);
        finish_item(trans_read);
        end
	wait_trans(no_of_packet);

   endtask


  endclass
 `endif
   
