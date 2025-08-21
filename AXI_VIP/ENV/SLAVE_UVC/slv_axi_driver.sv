/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : slv_axi_driver.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/


//Gaurd Statement
`ifndef SLAVE_DRIVER_AXI_UVM
`define SLAVE_DRIVER_AXI_UVM

class slv_axi_driver#(int ADDR_WIDTH = 32 , DATA_WIDTH =32 , ID_WIDTH =16) extends uvm_driver#(slv_axi_seq_item#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH));

   `uvm_component_param_utils(slv_axi_driver)
    

   // slave virtual interface 
   virtual slv_axi_interface#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) sinf_drv;
   slv_axi_seq_item#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  write_rsp_que[$];

   slv_axi_seq_item#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  read_rsp_que[$];
   
   slv_axi_seq_item#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  slv_trans_h;

   //__________________________________________NEW_FUNCTION_____________________________________________________
   function new(string name = "slv_axi_driver", uvm_component parent = null);
    super.new(name, parent);
   endfunction

   //________________________________________ _BUILD_PHASE_______________________________________________________
   function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   endfunction :build_phase
  
    task run_phase(uvm_phase phase);
      fork
        forever begin
         drive();	 
         end

	forever begin
        //`uvm_info("SLAVE_DRV", " before next_item", UVM_LOW);

     	seq_item_port.get_next_item(req);
        //`uvm_info("SLAVE_DRV", " REQ CHECKER", UVM_LOW);
        // display();
        drive_data();
       
     	seq_item_port.item_done();
       //`uvm_info("SLAVE_DRV", " after itme_done", UVM_LOW);
       
        end
    join
   endtask 

   //___________________________________________DRIVE_TASK______________________________________________________
   task drive();
      @(posedge sinf_drv.slv_axi_drv_cb);
        fork
           write_addr_rsp();
           write_data_rsp();
           read_addr_rsp();
        join
   endtask

   task drive_data();
      @(posedge sinf_drv.slv_axi_drv_cb);
        //if(req.enb == req.WRITE) write_rsp_que.push_back(req);
        if(req.enb == req.READ) read_rsp_que.push_back(req);
        fork
	  if(req.enb == req.WRITE) write_response_channel();
	  if(req.enb == req.READ) begin
	                            wait(slv_trans_h == null) read_data_channel();
			            end
	join_none
  endtask

    
   //_______________________________________WRITE_ADDRESS_CHANNEL_________________________________
   task write_addr_rsp(); 
     sinf_drv.slv_axi_drv_cb.AWREADY  <=1'b1;
   endtask
 

   //_______________________________________WRITE_DATA_CHANNEL___________________________________
   
   task write_data_rsp(); 
     sinf_drv.slv_axi_drv_cb.WREADY <= 1'b1;
   endtask
   
      
   //_______________________________________WRITE_RESPONSE_CHANNEL_______________________________
   
   task write_response_channel();
   //Write response channels (BID, BRESP, BVALID, BREADY)

   //Slave OUTPUT
   sinf_drv.slv_axi_drv_cb.BVALID  <= 1'b1;
   sinf_drv.slv_axi_drv_cb.BRESP   <= req.BRESP;
   sinf_drv.slv_axi_drv_cb.BID     <= req.BID;
   @(sinf_drv.slv_axi_drv_cb iff sinf_drv.slv_axi_drv_cb.BREADY);
   if(sinf_drv.slv_axi_drv_cb.BVALID) seq_item_port.put_response(req);
   sinf_drv.slv_axi_drv_cb.BVALID  <= 1'b0;

   //$display($time, " SLAVE DRIVER WRITE_RESPONSE  REQ : %0p", req); 
   endtask
 
   //_______________________________________READ_ADDRESS_CHANNEL_________________________________

   task read_addr_rsp();
     sinf_drv.slv_axi_drv_cb.ARREADY <= 1'b1;
   endtask
 

  //________________________________________READ_DATA_CHANNEL____________________________________
   task read_data_channel();
   //Read data channels (RID, RDATA, RRESP, RLAST, RVALID, RREADY)
   
   slv_trans_h = slv_axi_seq_item#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("slv_trans_h", this);
   slv_trans_h = read_rsp_que.pop_front();
   if(slv_trans_h  == null) `uvm_fatal("SLAVE_DRIVER", "slv_tranh_h is null")

  //Slave OUTPUT
   
   while(slv_trans_h.rdata_array.size() != 0 ) begin 
   sinf_drv.slv_axi_drv_cb.RVALID <= 1'b1;
   sinf_drv.slv_axi_drv_cb.RID    <= slv_trans_h.RID;
   sinf_drv.slv_axi_drv_cb.RDATA  <= slv_trans_h.rdata_array.pop_front();
   sinf_drv.slv_axi_drv_cb.RRESP  <= slv_trans_h.RRESP;
   if(slv_trans_h.rdata_array.size() == 0) sinf_drv.slv_axi_drv_cb.RLAST <= 1'b1;

   @(sinf_drv.slv_axi_drv_cb iff sinf_drv.slv_axi_drv_cb.RREADY);
   
   sinf_drv.slv_axi_drv_cb.RLAST  <= 1'b0;
   sinf_drv.slv_axi_drv_cb.RVALID <= 1'b0;
  
   end
  
   slv_trans_h = null;
   endtask

    function display();
      $display("                                ");
      $display("_____________________________________________________________________________________________________________________________________________________________");
      $display("                                ");
      $display("                          SLAVE         DRIVER           OPERATION  :   %s", req.enb);
      if(req.enb == req.WRITE)begin
     
      $display("                      AWID    : %10d,   WID    : %10d,   ",  req.AWID   , req.WID  );  
      $display("                      AWADDR  : %10d,   BID    : %10d,   ",  req.AWADDR , req.BID  ); 
      $display("                      AWLEN   : %10d,   BRESP  :  %0s    ",  req.AWLEN  , req.BRESP); 
      $display("                      AWSIZE  : %10d,   AWBURST : %10d    ",  req.AWSIZE , req.AWBURST ); 
      $display("                                 ");
      $display("_____________________________________________________________________________________________________________________________________________________________");
      $display("                                ");
     end                                     
     
      if(req.enb == req.READ) begin
      $display("                      req.ARID    : %10d  ", req.ARID   );  
      $display("                      req.ARADDR  : %10d  ", req.ARADDR ); 
      $display("                      req.ARLEN   : %10d  ", req.ARLEN  ); 
      $display("                      req.ARSIZE  : %10d  ", req.ARSIZE ); 
      $display("                      req.ARBURST : %10d  ", req.ARBURST); 
      $display("                      req.read_data_array  : %p   ", req.rdata_array); 
      $display("                                ");
      $display("_____________________________________________________________________________________________________________________________________________________________");
      $display("                                ");
      end
      endfunction



endclass
`endif

