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
  
   rand int no_of_packet;
   rand bit [ADDR_WIDTH-1 : 0 ] wr_addr_q[$];
   rand bit [ADDR_WIDTH-1 : 0 ] rd_addr_q[$];
   rand bit [7:0] wr_len_q[$];
   rand bit [7:0] rd_len_q[$];
 
   `uvm_object_param_utils_begin(mas_axi_sequence)
   `uvm_field_int(no_of_packet, UVM_ALL_ON | UVM_UNSIGNED)
   `uvm_object_utils_end

   static int cnt;
   mas_axi_seq_item#(ADDR_WIDTH , DATA_WIDTH, ID_WIDTH) trans_h;
   mas_axi_seq_item#(ADDR_WIDTH , DATA_WIDTH, ID_WIDTH) trans_copy;
   
   constraint size_of_q      { wr_addr_q.size() == no_of_packet;
                               rd_addr_q.size() == no_of_packet;
			       wr_len_q.size()  == no_of_packet;  
			       rd_len_q.size() == no_of_packet;
			       };

   constraint lenght_contorl { foreach(wr_len_q[i]) wr_len_q[i] inside { [1:5]}; 
                               foreach(rd_len_q[i]) rd_len_q[i] inside { [1:5]};
                               };

   function new(string name = "mas_axi_sequence");
   super.new(name);
   endfunction 

   task wait_trans(int counter);
    repeat(counter)begin
     get_response(rsp);
     end
    endtask
 


   function void display(mas_axi_seq_item#(ADDR_WIDTH , DATA_WIDTH, ID_WIDTH) req);

     $display("                                ");
     $display("_____________________________________________________________________________________________________________________________________________________________");
     $display("                                ");
     $display("               TIME : %0d                      OPERATION  :   %s", $time,req.enb);

     $display("AWID    : %10d  |  ARID    : %10d  ", req.AWID   ,req.ARID   );  
     $display("AWADDR  : %10d  |  ARADDR  : %10d  ", req.AWADDR ,req.ARADDR ); 
     $display("AWLEN   : %10d  |  ARLEN   : %10d  ", req.AWLEN  ,req.ARLEN  ); 
     $display("AWSIZE  : %10d  |  ARSIZE  : %10d  ", req.AWSIZE ,req.ARSIZE ); 
     $display("AWBURST : %10d  |  ARBURST : %10d  ", req.AWBURST,req.ARBURST); 
     $display(" WID    : %10d  |",  req.WID   );
     $display(" WLAST  : %10d  |",  req.WLAST );


     $display("write_array : %p   ", req.wdata_array); 
     $display("_____________________________________________________________________________________________________________________________________________________________");
     $display("                                ");
     
     if(req.enb == req.WRITE || req.enb == req.WR)begin
     $write("  no_of_byte : %0d |" ,  req.no_of_byte); 
     $write("  data_lane  : %0d |" ,  req.data_lane ); 
     $write("  start_lane : %0d |\n" ,  req.start_lane); 
     foreach(req.write_strobe[i]) $write(" | [%0d] : %4b  | ", i , req.write_strobe[i]);
     $display("_____________________________________________________________________________________________________________________________________________________________");
     end

   endfunction


  endclass
 `endif
   
