/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : mas_axi_seq_item.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef MASTER_AXI_SEQ_ITEM
`define MASTER_AXI_SEQ_ITEM

class mas_axi_seq_item#(int ADDR_WIDTH = 32, DATA_WIDTH = 32, ID_WIDTH = 16) extends uvm_sequence_item;
   
 // All signal of Master AXI
  
 //enum declaration 
  typedef enum bit[1:0] {FIXED ,INCR ,WRAP, RESERVED} burst;

  typedef enum bit[1:0] {WRITE, READ, WR} Operation;

   rand  Operation                 enb; 
 //Write address channel signals
   rand  bit [ADDR_WIDTH - 1 : 0]  AWADDR;
   rand bit [ID_WIDTH - 1   : 0]   AWID;
   rand   burst                    AWBURST;
   rand  bit [7:0]                 AWLEN;
   rand  bit [2:0] 		   AWSIZE;
   
 //Write data channel signals
   randc bit [ID_WIDTH - 1   : 0]  WID;
   rand  bit 	  	           WLAST;
   bit 		       		   WVALID;
   bit 		       		   WREADY;

  //arrays for data , strobe
   rand bit [DATA_WIDTH - 1  : 0]  wdata_array[$];
        bit [DATA_WIDTH - 1  : 0]  rdata_array[$];
   
   rand bit [DATA_WIDTH/8 ]   write_strobe[$];
 
 //Write response channel signals
   randc bit [ID_WIDTH - 1   : 0]  BID;
   bit [1:0]                 	   BRESP;

 //Read address channel signals
   randc bit [ID_WIDTH - 1   : 0]  ARID;
   rand  bit [ADDR_WIDTH - 1 : 0]  ARADDR;
   rand  bit [2:0] 		   ARSIZE;
   rand  burst          	   ARBURST;
   rand  bit [7:0]	           ARLEN;

 //Read data channel signals 
   bit [ID_WIDTH - 1   : 0]  RID;
   bit                       RLAST;
   bit 		             RRESP;

//local variable 
   rand int no_of_byte;
   rand int data_lane;
   rand int start_lane;
   rand int burst_length_wr;
   rand int burst_length_rd;

   //Factory registration 
   `uvm_object_param_utils_begin(mas_axi_seq_item)
       
    `uvm_field_int(no_of_byte, UVM_ALL_ON| UVM_UNSIGNED)
    `uvm_field_int(data_lane , UVM_ALL_ON| UVM_UNSIGNED)
    `uvm_field_int(start_lane, UVM_ALL_ON| UVM_UNSIGNED)
    `uvm_field_int(burst_length_wr, UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(burst_length_rd, UVM_ALL_ON | UVM_UNSIGNED)

    `uvm_field_queue_int(wdata_array  ,UVM_ALL_ON  | UVM_UNSIGNED  )
    `uvm_field_queue_int(rdata_array  ,UVM_ALL_ON  | UVM_UNSIGNED  )
    `uvm_field_queue_int(write_strobe ,UVM_ALL_ON | UVM_BIN)


    `uvm_field_int(RID     ,UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(RLAST   ,UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(RRESP   ,UVM_ALL_ON | UVM_UNSIGNED)
    
    `uvm_field_int(AWSIZE  ,UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(AWLEN   ,UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(AWBURST ,UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(AWADDR  ,UVM_ALL_ON | UVM_UNSIGNED)
    

    `uvm_field_int(WID     ,UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(WLAST   ,UVM_ALL_ON | UVM_UNSIGNED)

    `uvm_field_int(BID     ,UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(BRESP   ,UVM_ALL_ON | UVM_UNSIGNED)
    
    `uvm_field_int(ARADDR  ,UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(ARID    ,UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(ARSIZE  ,UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(ARBURST ,UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(ARLEN   ,UVM_ALL_ON | UVM_UNSIGNED)
    
    `uvm_field_int(enb,     UVM_ALL_ON | UVM_UNSIGNED)

   `uvm_object_utils_end

   
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   //List of all CONSTRAINT
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
   constraint reserved             { AWBURST != RESERVED; ARBURST != RESERVED; }

   constraint aligned_address      { (AWBURST == WRAP) -> (AWADDR % (2**AWSIZE) == 0); (ARBURST == WRAP) -> (ARADDR %(2**ARSIZE) == 0);   }

   constraint transcation_id       { AWID == WID;}
   
 

   constraint write_channel_length { if(enb == WRITE || enb == WR) {
	                              burst_length_wr inside {[1: 256]};
	                             (AWBURST == WRAP) -> (burst_length_wr%2 ==0);
                                     (AWBURST == WRAP || AWBURST == FIXED) -> burst_length_wr inside { [1:16]};
		                     (AWBURST == INCR) -> burst_length_wr inside {[1: 256]};
				      AWLEN + 1 == burst_length_wr ;   }
   }


   constraint read_channel_length  {  if(enb == READ || enb == WR) {
	                             burst_length_rd inside {[1:256]};
                                     (ARBURST == WRAP) -> (burst_length_rd%2 ==0);
                                     (ARBURST == WRAP || ARBURST == FIXED) -> burst_length_rd inside { [1:16]};
		                     (ARBURST == INCR) -> burst_length_rd inside {[1: 256]};
                                     ARLEN + 1 == burst_length_rd; }
 
   }

   constraint wdata_generation     { wdata_array.size() == AWLEN + 1 ; solve AWLEN before wdata_array; write_strobe.size() == AWLEN + 1 ;
   }
   

   constraint  strobe_calc         {  no_of_byte <= data_lane || no_of_byte == data_lane;
                                      no_of_byte == 2**AWSIZE;    //Number of byte which we have to transfer at a time.
                                      data_lane  == DATA_WIDTH/8; //Number of available lane to transfer data (each lane represent bunch of 8bit(1Byte)) 
				      
                                      start_lane == AWADDR%data_lane  ;                                      
				      //For normal transfer
                                      if(no_of_byte == data_lane){

					                           foreach( write_strobe[i,j]) { if(i==0){ if(j >= start_lane) (write_strobe[i][j]) == 1'b1;
								                                           else (write_strobe[i][j]) == 1'b0;
												 }
												 else  (write_strobe[i][j]) == 1'b1;    
																			
								   }
                                       }                                      
    }

   function void post_randomize();
         int temp_index;  
         int array[] =  new[data_lane/no_of_byte];
         int strobe_bound;
         
    if(no_of_byte <= data_lane) begin
        temp_index = start_lane;       
        foreach (array[i]) array[i] = i*no_of_byte;
      

        foreach(write_strobe[i,j]) begin
	
             if(temp_index == data_lane) temp_index = 0;
        
	     foreach(array[i])begin
                  
	            if(temp_index == array[i]) begin
	                   // strobe_bound = array[i+1] ;
	                   strobe_bound = array[i] + no_of_byte;
	           	   break;
	           	   end
	           
	            if(temp_index > array[i] && temp_index < array[i+1]) begin
	                   strobe_bound = array[i+1] ;
                           break;
	                   end
	     end    //Till we have calculated strobe_bound
                  
          	    if(j == temp_index  || (j > temp_index && j < strobe_bound))  begin
				  write_strobe[i][j] = 1'b1;
                                  end


            else begin  
	          write_strobe[i][j] = 1'b0;
	          end
	          
            if(j == (data_lane -1))temp_index = strobe_bound ;
       end
    

    end
    
    endfunction
   
  
 endclass

`endif
