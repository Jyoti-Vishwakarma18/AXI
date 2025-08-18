/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : mas_axi_sequence.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 17
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef MAXI_SEQUENCE_UVM
`define MAXI_SEQUENCE_UVM

class mas_axi_sequence#(int ADDR_WIDTH = 32 , DATA_WIDTH = 32, ID_WIDTH = 16) extends uvm_sequence#( mas_axi_seq_item#(ADDR_WIDTH , DATA_WIDTH, ID_WIDTH));
 
   `uvm_object_param_utils_begin(mas_axi_sequence)
   `uvm_object_utils_end

   mas_axi_seq_item#(ADDR_WIDTH , DATA_WIDTH, ID_WIDTH) trans_h;
   mas_axi_seq_item#(ADDR_WIDTH , DATA_WIDTH, ID_WIDTH) trans_copy;
   
   function new(string name = "mas_axi_sequence");
   super.new(name);
   endfunction 
 
  
    task  wait_for_prev_transfer(int itr);
    int count = 1;
    
          repeat(itr) 
          begin
          get_response(req);
          count++;
          $display($time, " : GET_RESPONSE  %p", req);
          end
        //   wait(count == itr);
    endtask

   task body();
/* 
    mas_axi_seq_item#(ADDR_WIDTH , DATA_WIDTH, ID_WIDTH) que[$];

        trans_h = mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("trans_h");
        repeat(4) begin
        start_item(trans_h);
        trans_h.randomize() with {AWLEN == 5 ; ARLEN ==5; enb == WRITE; AWSIZE == ARSIZE; ARBURST == AWBURST; AWADDR == ARADDR;};
	trans_copy = new trans_h;
	que.push_back(trans_copy);
        //trans_h.print();
        display();
        finish_item(trans_h);
        end
	 
	  
        trans_h = mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("trans_h");
	repeat(4) begin
        start_item(trans_h);
        trans_h	= new que.pop_back();
	trans_h.enb = trans_h.READ;
        //trans_h.print();
        display();
        finish_item(trans_h);
        end
*/


        trans_h = mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("trans_h");
        repeat(5) begin
        start_item(trans_h);
        //trans_h.randomize();
        //trans_h.randomize() with { AWLEN == 5; ARLEN == 5;};
        trans_h.randomize() with { enb == WRITE; AWLEN == 5; ARLEN ==5; AWADDR inside { 2, 4, 66, 343}; ARADDR inside { 2, 4, 66, 343}; ARBURST == 2; AWBURST ==2; };
        display();
        finish_item(trans_h);
        end

	wait_for_prev_transfer(5);
        
	repeat(5) begin
        start_item(trans_h);
        //trans_h.randomize();
        //trans_h.randomize() with { AWLEN == 5; ARLEN == 5;};
        trans_h.randomize() with {  enb == READ;  AWLEN == 5; ARLEN ==5; AWADDR inside { 2, 4, 66, 343}; ARADDR inside { 2, 4, 66, 343}; ARBURST == 2; AWBURST ==2; };
        display();
        finish_item(trans_h);

        end
    
 
   endtask

   function display();
     $display("                                ");
     $display("_____________________________________________________________________________________________________________________________________________________________");
     $display("                                ");
     $display("               TIME : %0d                      OPERATION  :   %s", $time, trans_h.enb);

     $display("trans_h.AWID    : %10d,  trans_h. WID    : %10d,   |  trans_h.ARID    : %10d  ",  trans_h.AWID   , trans_h. WID     , trans_h.ARID   );  
     $display("trans_h.AWADDR  : %10d,  trans_h. WLAST  : %10d,   |  trans_h.ARADDR  : %10d  ",  trans_h.AWADDR , trans_h. WLAST   , trans_h.ARADDR ); 
     $display("trans_h.AWLEN   : %10d,  trans_h. WVALID : %10d,   |  trans_h.ARLEN   : %10d  ",  trans_h.AWLEN  , trans_h. WVALID  , trans_h.ARLEN  ); 
     $display("trans_h.AWSIZE  : %10d,                            |  trans_h.ARSIZE  : %10d  ",  trans_h.AWSIZE ,  trans_h.ARSIZE ); 
     $display("trans_h.AWBURST : %10d,                            |  trans_h.ARBURST : %10d  ",  trans_h.AWBURST,  trans_h.ARBURST); 
     $display("trans_h.write_array : %p   ", trans_h.wdata_array); 
     $display("                                ");
     
     if(trans_h.enb == trans_h.WRITE || trans_h.enb == trans_h.WR)begin
     $display("  trans_h.no_of_byte : %0d" ,  trans_h.no_of_byte); 
     $display("  trans_h.data_lane  : %0d" ,  trans_h.data_lane ); 
     $display("  trans_h.start_lane : %0d" ,  trans_h.start_lane); 
     foreach(trans_h.write_strobe[i]) $display("trans_h.write_strobe[%0d] : %4b   ", i , trans_h.write_strobe[i]);
     end

   endfunction


  endclass
 `endif
   
