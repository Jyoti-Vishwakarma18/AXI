/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : seqs_random.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 17
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef SEQS_RANDOM_UVM
`define SEQS_RANDOM_UVM

class seqs_random#(int ADDR_WIDTH = 32 , DATA_WIDTH = 32, ID_WIDTH = 16) extends mas_axi_sequence#( ADDR_WIDTH , DATA_WIDTH, ID_WIDTH);
 
   `uvm_object_param_utils_begin(seqs_random)
   `uvm_object_utils_end

   mas_axi_seq_item#(ADDR_WIDTH , DATA_WIDTH, ID_WIDTH) trans_h;
   mas_axi_seq_item#(ADDR_WIDTH , DATA_WIDTH, ID_WIDTH) trans_copy;
    
     
   function new(string name = "seqs_random");
   super.new(name);
   endfunction 
   
   task body();

        trans_h = mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("trans_h");
        repeat(no_of_packet) begin
        start_item(trans_h);
        trans_h.randomize() with {AWLEN == 5; ARLEN == 5;};
        display(trans_h);
        finish_item(trans_h);
        end
 
	wait_trans(no_of_packet);
   endtask


  endclass
 `endif
   
