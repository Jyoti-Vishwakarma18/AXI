/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : mas_axi_driver.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Gaurd Statement
`ifndef MASTER_DRIVER_AXI_UVM
`define MASTER_DRIVER_AXI_UVM

class mas_axi_driver#(int ADDR_WIDTH  = 32 , DATA_WIDTH = 32, ID_WIDTH =16) extends uvm_driver#( mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH));

   //______________________________________________Factory Registration_____________________________________________________
   `uvm_component_param_utils(mas_axi_driver)
   
   //______________________________________________Declaration______________________________________________________________
   //master interface 
   virtual mas_axi_interface#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) minf_drv;
   mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) mas_trans_h;
   
     mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) write_addr_que[$] , wraddr_h;
     mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) wrdata_que[$]     , wrdata_h  ;
     mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) read_addr_que[$]  , rdaddr_h  ;
     event finish;
     int count = 1;
   //______________________________________________NEW_FUNCTION_____________________________________________________________  
   function new(string name = "mas_axi_driver", uvm_component parent = null);
   super.new(name, parent);

   mas_trans_h =mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("mas_trans_h", this);
 
   endfunction

   function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   endfunction :build_phase
   
   task run_phase(uvm_phase phase);
       forever begin
          seq_item_port.get_next_item(req);
          mas_trans_h = new req;
          if(mas_trans_h.enb == mas_trans_h.WR)begin
	                           write_addr_que.push_back(mas_trans_h);
                                   wrdata_que.push_back(mas_trans_h); //All write data wille store in oddered.
                                   read_addr_que.push_back(mas_trans_h);
	                           end
          if(mas_trans_h.enb == mas_trans_h.WRITE)begin
	                           write_addr_que.push_back(mas_trans_h);
                                   wrdata_que.push_back(mas_trans_h); //All write data wille store in oddered.
	                           end
         if(mas_trans_h.enb == mas_trans_h.READ)begin
                                   read_addr_que.push_back(mas_trans_h);
	                           end 
	  drive(); 
          //`uvm_info("MASTER_DRIVER", "TRANSCATION sended to MINOTER", UVM_LOW)
	  seq_item_port.item_done(req);
       end
   endtask 

   //___________________________________________DRIVE_TASK______________________________________________________
   task drive();
          begin
          @(posedge minf_drv.mas_axi_drv_cb); 
          fork
	    
          wait(wraddr_h == null)   write_addr_channel();
	  wait(wrdata_h == null)   write_data_channel();
	  wait(rdaddr_h == null)   read_addr_channel();
          write_response_channel();  
          read_data_channel(); //it consist response also
	   
      join_none
    end

   endtask


   //_______________________________________WRITE_ADDRESS_CHANNEL_________________________________
   task write_addr_channel(); 
    
     //Write address channels ( AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWVALID, AWREADY)
        if(write_addr_que.size() != 0) begin 
        wraddr_h = new write_addr_que.pop_front();
        minf_drv.mas_axi_drv_cb.AWVALID <= 1'b1; 

	//Sampling write address and control signals
        minf_drv.mas_axi_drv_cb.AWID    <= wraddr_h.AWID;
        minf_drv.mas_axi_drv_cb.AWADDR  <= wraddr_h.AWADDR;
        minf_drv.mas_axi_drv_cb.AWLEN   <= wraddr_h.AWLEN;
        minf_drv.mas_axi_drv_cb.AWSIZE  <= wraddr_h.AWSIZE;
        minf_drv.mas_axi_drv_cb.AWBURST <= wraddr_h.AWBURST;


        @(minf_drv.mas_axi_drv_cb iff minf_drv.mas_axi_drv_cb.AWREADY);
        if(write_addr_que.size() == 0) minf_drv.mas_axi_drv_cb.AWVALID <= 1'b0; 
        wraddr_h = null;//Empty the class so that new transfer can take place
	end
   endtask
   
   //_______________________________________WRITE_DATA_CHANNEL___________________________________
   
   task write_data_channel(); 
       //WID, WDATA, WSTRB, WLAST,  WVALID, WREADY
        
	if(wrdata_que.size() != 0) begin
        wrdata_h = new wrdata_que.pop_front(); 
	//Sampling all data signals
        while(wrdata_h.wdata_array.size() != 0) begin  
  //      $display($time,  " : size of array %0d count: %0d", wrdata_h.wdata_array.size(),count);
          if(wrdata_h == null) `uvm_fatal("WRITE_DATA", "wrdata_h is null");
          minf_drv.mas_axi_drv_cb.WVALID  <= 1'b1;
          minf_drv.mas_axi_drv_cb.WID    <= wrdata_h.WID;
          minf_drv.mas_axi_drv_cb.WDATA  <= wrdata_h.wdata_array.pop_front();
 //	  $display("                                          ");
 //	  $display("minf_drv.mas_axi_drv_cb.WDATA %0h" , minf_drv.mas_axi_drv_cb.WDATA );
 //       $display("                                          ");
          minf_drv.mas_axi_drv_cb.WSTRB  <= wrdata_h.write_strobe.pop_front();
          if(wrdata_h.wdata_array.size() == 0) minf_drv.mas_axi_drv_cb.WLAST  <= 1'b1; //Array is empty which means this one was last data.

         @(minf_drv.mas_axi_drv_cb iff minf_drv.mas_axi_drv_cb.WREADY);
        
	 minf_drv.mas_axi_drv_cb.WLAST   <= 1'b0;
         if(wrdata_que.size() == 0) minf_drv.mas_axi_drv_cb.WVALID  <= 1'b0;
	 count++;
	 end
       wrdata_h = null;
       end
   endtask
   
   //_______________________________________WRITE_RESPONSE_CHANNEL_______________________________
   
   task write_response_channel;
       //Write response channels (BID, BRESP, BVALID, BREADY)
       //On getting error response for BRESP master must drive PSRTB to be 'b0
       //for rest of the trasncation 
        begin
          minf_drv.mas_axi_drv_cb.BREADY <= 1'b1;
        end
   endtask
 
   //_______________________________________READ_ADDRESS_CHANNEL_________________________________

   task read_addr_channel();
   //Read address channels ( ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID, ARREADY)

        if(read_addr_que.size() != 0) begin
        rdaddr_h = new read_addr_que.pop_front();
        minf_drv.mas_axi_drv_cb.ARVALID <= 1'b1;

        minf_drv.mas_axi_drv_cb.ARID    <= rdaddr_h.ARID;
        minf_drv.mas_axi_drv_cb.ARADDR  <= rdaddr_h.ARADDR;
        minf_drv.mas_axi_drv_cb.ARLEN   <= rdaddr_h.ARLEN;
        minf_drv.mas_axi_drv_cb.ARSIZE  <= rdaddr_h.ARSIZE;
        minf_drv.mas_axi_drv_cb.ARBURST <= rdaddr_h.ARBURST;
	
	@(minf_drv.mas_axi_drv_cb iff minf_drv.mas_axi_drv_cb.ARREADY);
         minf_drv.mas_axi_drv_cb.ARVALID <= 1'b0;
         rdaddr_h = null;
        end
     endtask
 
  //________________________________________READ_DATA_CHANNEL____________________________________
   task read_data_channel();
   //Read data channels (RID, RDATA, RRESP, RLAST, RVALID, RREADY)
        minf_drv.mas_axi_drv_cb.RREADY <= 1'b1;
   
   endtask
  

endclass
`endif


     
