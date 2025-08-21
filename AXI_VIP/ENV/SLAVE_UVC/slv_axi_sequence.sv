/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : slv_axi_sequence.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 17
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef SAXI_SEQUENCE_UVM
`define SAXI_SEQUENCE_UVM

class slv_axi_sequence#(int ADDR_WIDTH = 32 , DATA_WIDTH =32 , ID_WIDTH =16) extends uvm_sequence#(slv_axi_seq_item#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH));
 
   `uvm_object_param_utils(slv_axi_sequence)
   

   //________________________________DECLARATION____________________________________
 
   //`uvm_declare_p_sequencer(slv_axi_sequencer)
   `uvm_declare_p_sequencer(slv_axi_sequencer#(ADDR_WIDTH , DATA_WIDTH , ID_WIDTH ))
    
    slv_axi_seq_item#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)   trans_h;
    slv_axi_seq_item#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)   trans_h2;
  
    static  bit[DATA_WIDTH] memory [int]; 
 
    bit [ADDR_WIDTH]addr_array[];
    
  
   //________________________________NEW_FUNCTION___________________________________ 
   function new(string name = "slv_axi_sequence");
   super.new(name);
   endfunction 
  
   //________________________________BODY_TASK______________________________________
  
     
  task body();
    
    repeat(8)  
    begin
       // $display("p_sequencer wait started");     
        p_sequencer.store_fifo.get(trans_h2);
        trans_h = new trans_h2;
	
	if(trans_h.enb == trans_h.WRITE) write_operation();
        if(trans_h.enb == trans_h.READ)  read_operation();
	
        //`uvm_info("SLAVE_SEQ"," before wait_for_grant  and got trans_h", UVM_LOW);
         wait_for_grant();
	  // `uvm_info("SLAVE_SEQ"," after wait_for_grant", UVM_LOW);
       
          send_request(trans_h);
          //  trans_h.print(); 
      
        //`uvm_info("SLAVE_SEQ"," before item_done and after sed_request", UVM_LOW);
         wait_for_item_done();
          
       //   `uvm_info("SLAVE_SEQ"," after Item_done", UVM_LOW);
         end
    
   endtask   
 //________________________________________WRITING IN MEMORY______________________________________________________________________________________________________________________

  task write_operation();
  
       burst_calc(trans_h.AWADDR, trans_h.AWSIZE, trans_h.AWLEN, trans_h.AWBURST);
       
      // $display($time," : WRITE_QUEUE ADDRESS : %p",addr_array);
      // $display($time," : WRITE_QUEUE DATA    : %p",trans_h.wdata_array);
       
      //strobe application - WSTRB[n] --> WDATA[(8n) + 7 :(8n)] 
     
       foreach(trans_h.write_strobe[i,j]) 
               foreach(trans_h.wdata_array[k,l])
     	               begin
     	               if(i == k) begin
     	                         if(trans_h.write_strobe[i][j] == 0)  /* trans_h.wdata_array[k][((8*j) +7) : (8*j)] = ; */
     	                     	    if( l <= ((8*j)+7)  && l >= (8 *j))
     	                     	    trans_h.wdata_array[k][l] = 'b0;
     	                         end 
     	               end
      
       //foreach(trans_h.wdata_array[i]) $display($time," : AFTER STROBE WRITE_QUEUE DATA    : %8h   |  %4b",trans_h.wdata_array[i], trans_h.write_strobe[i]);
       
       foreach(addr_array[i])
       begin
           
           memory[addr_array[i]] = trans_h.wdata_array[i];
           //memory[addr_array[i]] = memory[addr_array[i]]^trans_h.wdata_array[i];
           //$display($time, "  %8h written at address :%0d", memory[addr_array[i]], addr_array[i]);
       end
       trans_h.BID   = trans_h.WID;
       trans_h.BRESP = trans_h.OKAY;
       trans_h.enb   = trans_h.WRITE;
         
  endtask

 //____________________________________________READ FORM MEMORY_________________________________________________________________________________________________________
  task read_operation();
  
      burst_calc(trans_h.ARADDR, trans_h.ARSIZE, trans_h.ARLEN, trans_h.ARBURST);
      //$display($time, " : READ_QUEUE ADDRESS : %p", addr_array);

      foreach(addr_array[i])
      begin trans_h.rdata_array.push_back(memory[addr_array[i]]) ;
      //$display($time, " : READ_QUEUE DATA : %8h at address :%0d",memory[addr_array[i]],  addr_array[i]);
      end
      //$display($time, " : READ_QUEUE DATA : %p", trans_h.rdata_array);
      trans_h.RID   = trans_h.ARID;
      trans_h.RRESP = trans_h.OKAY;
      trans_h.enb   = trans_h.READ;
  
  endtask

//_________________________________________   BURST CALCULATION______________________________________________________________________________________________________________

  function void burst_calc(input bit [ADDR_WIDTH -1 : 0]  addr,input  bit [2:0] AxSIZE,input bit [7:0] AxLEN,input bit[1:0] burst_type );

      bit[ADDR_WIDTH - 1: 0]  Start_Address = addr;
      int  Number_Bytes = 2 ** AxSIZE;
      int  Burst_Length = AxLEN + 1;
     // bit[ADDR_WIDTH] Aligned_Address = (Start_Address / Number_Bytes)  * Number_Bytes;
      
      addr_array = new[Burst_Length];
    
      if(burst_type == 2'b01) //for INCR
      foreach(addr_array[i]) addr_array[i] = Start_Address + i*Number_Bytes;
               
      if(burst_type == 2'b00) //for FIXED
      
      foreach(addr_array[i]) addr_array[i] = Start_Address;
       
      if(burst_type == 2'b10) //for WRAP
      begin
      bit [ADDR_WIDTH] Wrap_Boundary = (Start_Address / (Number_Bytes * Burst_Length)) * (Number_Bytes * Burst_Length);
    
      bit [ADDR_WIDTH] Address_N = Wrap_Boundary + (Number_Bytes * Burst_Length);
    
      foreach(addr_array[i]) 
        begin
           
           if(i == 0) addr_array[0] = Start_Address;
           else 
               begin
               addr_array[i] = addr_array[i-1] + Number_Bytes;
               if(addr_array[i] >= Address_N) addr_array[i] = Wrap_Boundary;
               end 
        end
      end 

  endfunction
 

 endclass
 `endif
   
