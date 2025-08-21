/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : slv_axi_monitor.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef SLAVE_MONITOR_AXI_UVM
`define SLAVE_MONITOR_AXI_UVM

class slv_axi_monitor#(int ADDR_WIDTH = 32 , DATA_WIDTH =32 , ID_WIDTH =16)  extends uvm_monitor;

  `uvm_component_param_utils(slv_axi_monitor)
 
 // slave virtual interface 
   virtual slv_axi_interface#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) sinf_mon;
  slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)   trans_h;
   
  uvm_analysis_port#(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)) slave_anaylsis_port;
  slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) packet[int];
  
  function new(string name = "slv_axi_monitor", uvm_component parent = null);
  super.new(name, parent);
  slave_anaylsis_port = new("slave_analysis_port", this);
  trans_h =  slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("trans_h", this); 
  endfunction

  //___________________________________BUILD_PHASE______________________________________________________-
  function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  endfunction
 

  //___________________________________RUN_PHASE_______________________________________________________
  task run_phase(uvm_phase phase);
   forever
   begin 
       monitor();
       //`uvm_info("SLAVE_MONITOR", "SAMPLING IN MONITOR", UVM_LOW)
       packet_collection(trans_h);
       //slave_anaylsis_port.write(trans_h);
       end
   
  endtask

 task monitor();

   fork
        write_addr_channel();
        write_data_channel();
        write_response_channel();
        read_addr_channel();
        read_data_channel();
   join
 
 endtask
 
 task packet_collection(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) trans_h);
  

  
     if(sinf_mon.slv_axi_mon_cb.AWVALID && sinf_mon.slv_axi_mon_cb.AWREADY ) begin
     if(!packet.exists(trans_h.AWID))
     packet[trans_h.AWID] = slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create($sformatf("packet[%0d]",trans_h.AWID), this);
    // $display($time,"packet WRITE ADDReSS foremation is being started");
    // if( packet[trans_h.AWID] == null) `uvm_fatal("SLAVE_MONITOR", "packet called is null" );
     packet[trans_h.AWID].AWID    = trans_h.AWID    ;
     packet[trans_h.AWID].AWADDR  = trans_h.AWADDR  ;
     packet[trans_h.AWID].AWLEN   = trans_h.AWLEN   ;
     packet[trans_h.AWID].AWSIZE  = trans_h.AWSIZE  ;
     packet[trans_h.AWID].AWBURST = trans_h.AWBURST ;
     end
 
     if(sinf_mon.slv_axi_mon_cb.WVALID && sinf_mon.slv_axi_mon_cb.WREADY ) begin
     if(!packet.exists(trans_h.WID))

     packet[trans_h.WID] = slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create($sformatf("packet[%0d]",trans_h.WID), this);
   // $display($time,"packet DATA foremation is being started");
     packet[trans_h.WID].WID          = trans_h.WID  ; 
     packet[trans_h.WID].wdata_array  = trans_h.wdata_array; 
     packet[trans_h.WID].write_strobe = trans_h.write_strobe; 
     packet[trans_h.WID].WLAST        = trans_h.WLAST;
     packet[trans_h.WID].enb          = trans_h.WRITE;
     

     if(trans_h.WLAST)   begin
     slave_anaylsis_port.write(packet[trans_h.WID]);
     //`uvm_info("SLAVE_MONITOR", "PACKET IN MONITOR IS READY TO SEND", UVM_LOW) 
     trans_h.wdata_array.delete();
     trans_h.write_strobe.delete();
     end
     end

     if(sinf_mon.slv_axi_mon_cb.ARVALID && sinf_mon.slv_axi_mon_cb.ARREADY ) begin
     if(!packet.exists(trans_h.ARID))
     packet[trans_h.ARID] = slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create($sformatf("packet[%0d]",trans_h.ARID), this);
    //$display($time,"packet ER__++ foremation is being started");
     packet[trans_h.ARID].ARID     = trans_h.ARID    ;
     packet[trans_h.ARID].ARADDR   = trans_h.ARADDR  ;
     packet[trans_h.ARID].ARLEN    = trans_h.ARLEN   ;
     packet[trans_h.ARID].ARSIZE   = trans_h.ARSIZE  ;
     packet[trans_h.ARID].ARBURST  = trans_h.ARBURST ;
     packet[trans_h.ARID].enb      = trans_h.READ ;
    
     slave_anaylsis_port.write(packet[trans_h.ARID]);
     end
   
 endtask
 
   task write_addr_channel();
   
    //Write address channels ( AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWVALID, AWREADY)
     @(posedge sinf_mon.slv_axi_mon_cb); 
     if(sinf_mon.slv_axi_mon_cb.AWVALID && sinf_mon.slv_axi_mon_cb.AWREADY) begin  
      trans_h.AWID    = sinf_mon.slv_axi_mon_cb.AWID;
      trans_h.AWADDR  = sinf_mon.slv_axi_mon_cb.AWADDR;
      trans_h.AWLEN   = sinf_mon.slv_axi_mon_cb.AWLEN;
      trans_h.AWSIZE  = sinf_mon.slv_axi_mon_cb.AWSIZE;
      trans_h.AWBURST = sinf_mon.slv_axi_mon_cb.AWBURST;
      end
    
   endtask

   task write_data_channel();
     //Write data channels (WID, WDATA, WSTRB, WLAST,  WVALID, WREADY)
     @(posedge sinf_mon.slv_axi_mon_cb);
     if(sinf_mon.slv_axi_mon_cb.WVALID && sinf_mon.slv_axi_mon_cb.WREADY) begin  
       trans_h.WID    = sinf_mon.slv_axi_mon_cb.WID;
       trans_h.wdata_array.push_back(sinf_mon.slv_axi_mon_cb.WDATA);
       trans_h.write_strobe.push_back(sinf_mon.slv_axi_mon_cb.WSTRB);
       trans_h.WLAST  = sinf_mon.slv_axi_mon_cb.WLAST;
       if(trans_h.WLAST) 
	  begin
    //   $display($time, "last data is received");
    //   $display("Slave mointor transcation class");
    //   trans_h.print();
       end
     end
  endtask
 
  task write_response_channel();
   //Write response channels (BID, BRESP, BVALID, BREADY)
     @(posedge sinf_mon.slv_axi_mon_cb);
     if(sinf_mon.slv_axi_mon_cb.BVALID && sinf_mon.slv_axi_mon_cb.BREADY) begin
    //   trans_h.BID    = sinf_mon.slv_axi_mon_cb.BID;
    //   trans_h.BRESP  = sinf_mon.slv_axi_mon_cb.BRESP;
      end 
 endtask

 task read_addr_channel();
   @(posedge sinf_mon.slv_axi_mon_cb); 
     if(sinf_mon.slv_axi_mon_cb.ARVALID && sinf_mon.slv_axi_mon_cb.ARREADY) begin  
      trans_h.ARID    = sinf_mon.slv_axi_mon_cb.ARID;   
      trans_h.ARADDR  = sinf_mon.slv_axi_mon_cb.ARADDR; 
      trans_h.ARLEN   = sinf_mon.slv_axi_mon_cb.ARLEN; 
      trans_h.ARSIZE  = sinf_mon.slv_axi_mon_cb.ARSIZE; 
      trans_h.ARBURST = sinf_mon.slv_axi_mon_cb.ARBURST;
      end
 endtask

 task read_data_channel();
   @(posedge sinf_mon.slv_axi_mon_cb); 
     if(sinf_mon.slv_axi_mon_cb.RVALID && sinf_mon.slv_axi_mon_cb.RREADY) begin  
      trans_h.RID   = sinf_mon.slv_axi_mon_cb.RID; 
      trans_h.RDATA = sinf_mon.slv_axi_mon_cb.RDATA;
      trans_h.RRESP = sinf_mon.slv_axi_mon_cb.RRESP;
      trans_h.RLAST = sinf_mon.slv_axi_mon_cb.RLAST;
      end
   endtask


  endclass
  `endif
