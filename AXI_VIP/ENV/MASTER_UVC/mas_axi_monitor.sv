/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : mas_axi_monitor.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef MASTER_MONITOR_AXI_UVM
`define MASTER_MONITOR_AXI_UVM

class mas_axi_monitor#(int ADDR_WIDTH = 32 , DATA_WIDTH= 32, ID_WIDTH =16) extends uvm_monitor;

  //___________________________Factory Registration________________________________________
  `uvm_component_param_utils(mas_axi_monitor)

  //___________________________Declaration_________________________________________________
  mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  trans_h;
   //anlysis port for boardcast of trancastion to scoreboard and reference model
  uvm_analysis_port#(mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)) master_anaylsis_port;
  mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) packet[int];

  //master interface 
  virtual mas_axi_interface#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) minf_mon;
   
  //___________________________New function ______________________________________________
  function new(string name = "mas_axi_monitor", uvm_component parent = null);
  super.new(name, parent);
  master_anaylsis_port = new("master_anaylsis_port", this);
  trans_h = mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("trans_h", this);
  endfunction
 
  //___________________________BUILD_PHASE_________________________________________________
  function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  endfunction
  
  //___________________________________RUN_PHASE_______________________________________________________
  task run_phase(uvm_phase phase);
   forever
   begin 
       monitor();
       //`uvm_info("MASTER_MONITOR", "SAMPLING IN MONITOR", UVM_LOW)
       packet_collection(trans_h);
       end
   
  endtask

 task monitor();

   fork
    //    write_addr_channel();
    //    write_data_channel();
    //    write_response_channel();
    //    read_addr_channel();
        read_data_channel();
   join
 
 endtask
 
 task packet_collection(mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) trans_h);
  
/*
  
     if(minf_mon.mas_axi_mon_cb.AWVALID && minf_mon.mas_axi_mon_cb.AWREADY ) begin
     if(!packet.exists(trans_h.AWID))
     packet[trans_h.AWID] = mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create($sformatf("packet[%0d]",trans_h.AWID), this);
     //$display($time,"packet WRITE ADDReSS foremation is being started");
     //if( packet[trans_h.AWID] == null) `uvm_fatal("SLAVE_MONITOR", "packet called is null" );
     packet[trans_h.AWID].AWID    = trans_h.AWID    ;
     packet[trans_h.AWID].AWADDR  = trans_h.AWADDR  ;
     packet[trans_h.AWID].AWLEN   = trans_h.AWLEN   ;
     packet[trans_h.AWID].AWSIZE  = trans_h.AWSIZE  ;
     packet[trans_h.AWID].AWBURST = trans_h.AWBURST ;
     end
 
     if(minf_mon.mas_axi_mon_cb.WVALID && minf_mon.mas_axi_mon_cb.WREADY ) begin
     if(!packet.exists(trans_h.WID))

     packet[trans_h.WID] = mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create($sformatf("packet[%0d]",trans_h.WID), this);
     //$display($time,"packet DATA foremation is being started");
     packet[trans_h.WID].WID          = trans_h.WID  ; 
     packet[trans_h.WID].wdata_array  = trans_h.wdata_array; 
     packet[trans_h.WID].write_strobe = trans_h.write_strobe; 
     packet[trans_h.WID].WLAST        = trans_h.WLAST;
     packet[trans_h.WID].enb          = trans_h.WRITE;
     

     if(trans_h.WLAST)   begin
     master_anaylsis_port.write(packet[trans_h.WID]);
    `uvm_info("MASTER_MONITOR", "WRITE PACKET IS READY TO SEND FOR REFERENCE_MODEL", UVM_LOW) 
     //packet[trans_h.WID].print();
     //packet.delete(trans_h.WID);
     trans_h.wdata_array.delete();
     trans_h.write_strobe.delete();
     end
     end

     if(minf_mon.mas_axi_mon_cb.ARVALID && minf_mon.mas_axi_mon_cb.ARREADY ) begin
     if(!packet.exists(trans_h.ARID))
     packet[trans_h.ARID] = mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create($sformatf("packet[%0d]",trans_h.ARID), this);
    //$display($time,"packet ER__++ foremation is being started");
     packet[trans_h.ARID].ARID     = trans_h.ARID    ;
     packet[trans_h.ARID].ARADDR   = trans_h.ARADDR  ;
     packet[trans_h.ARID].ARLEN    = trans_h.ARLEN   ;
     packet[trans_h.ARID].ARSIZE   = trans_h.ARSIZE  ;
     packet[trans_h.ARID].ARBURST  = trans_h.ARBURST ;
     packet[trans_h.ARID].enb      = trans_h.READ ;
    
     end
 */
     if(minf_mon.mas_axi_mon_cb.RVALID && minf_mon.mas_axi_mon_cb.RREADY ) begin
        if(!packet.exists(trans_h.RID))   //NO need as RID will exist only asuse rdata omes only after read address
        packet[trans_h.RID] = mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create($sformatf("packet[%0d]",trans_h.RID), this);
        packet[trans_h.RID].RID          = trans_h.RID  ; 
        packet[trans_h.RID].rdata_array  = trans_h.rdata_array; 
        packet[trans_h.RID].RLAST        = trans_h.RLAST;
        packet[trans_h.RID].enb          = trans_h.READ;
        
        if(trans_h.RLAST)   begin
        master_anaylsis_port.write(packet[trans_h.RID]);
        `uvm_info("MASTER_MONITOR", "READ PACKET IS READY TO SEND FOR SCOREBOARD", UVM_LOW) 
        //packet[trans_h.RID].print();
        trans_h.rdata_array.delete();
        end
     end

  
     


 endtask
 /*
   task write_addr_channel();
   
    //Write address channels ( AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWVALID, AWREADY)
     @(posedge minf_mon.mas_axi_mon_cb); 
     if(minf_mon.mas_axi_mon_cb.AWVALID && minf_mon.mas_axi_mon_cb.AWREADY) begin  
      trans_h.AWID    = minf_mon.mas_axi_mon_cb.AWID;
      trans_h.AWADDR  = minf_mon.mas_axi_mon_cb.AWADDR;
      trans_h.AWLEN   = minf_mon.mas_axi_mon_cb.AWLEN;
      trans_h.AWSIZE  = minf_mon.mas_axi_mon_cb.AWSIZE;
      trans_h.AWBURST = minf_mon.mas_axi_mon_cb.AWBURST;
      end
    
   endtask

   task write_data_channel();
     //Write data channels (WID, WDATA, WSTRB, WLAST,  WVALID, WREADY)
     @(posedge minf_mon.mas_axi_mon_cb);
     if(minf_mon.mas_axi_mon_cb.WVALID && minf_mon.mas_axi_mon_cb.WREADY) begin  
       trans_h.WID    = minf_mon.mas_axi_mon_cb.WID;
       trans_h.wdata_array.push_back(minf_mon.mas_axi_mon_cb.WDATA);
       trans_h.write_strobe.push_back(minf_mon.mas_axi_mon_cb.WSTRB);
       end
  endtask
 
  task write_response_channel();
     //Write response channels (BID, BRESP, BVALID, BREADY)
     @(posedge minf_mon.mas_axi_mon_cb);
     if(minf_mon.mas_axi_mon_cb.BVALID && minf_mon.mas_axi_mon_cb.BREADY) begin
     trans_h.BID    = minf_mon.mas_axi_mon_cb.BID;
     trans_h.BRESP  = minf_mon.mas_axi_mon_cb.BRESP;
     end 
 endtask

 task read_addr_channel();
    @(posedge minf_mon.mas_axi_mon_cb); 
      if(minf_mon.mas_axi_mon_cb.ARVALID && minf_mon.mas_axi_mon_cb.ARREADY) begin  
      trans_h.ARID    = minf_mon.mas_axi_mon_cb.ARID;   
      trans_h.ARADDR  = minf_mon.mas_axi_mon_cb.ARADDR; 
      trans_h.ARLEN   = minf_mon.mas_axi_mon_cb.ARLEN; 
      trans_h.ARSIZE  = minf_mon.mas_axi_mon_cb.ARSIZE; 
      trans_h.ARBURST = minf_mon.mas_axi_mon_cb.ARBURST;
      end
 endtask
*/
 task read_data_channel();
   @(posedge minf_mon.mas_axi_mon_cb); 
     if(minf_mon.mas_axi_mon_cb.RVALID && minf_mon.mas_axi_mon_cb.RREADY) begin  
      trans_h.RID   = minf_mon.mas_axi_mon_cb.RID; 
      trans_h.rdata_array.push_back(minf_mon.mas_axi_mon_cb.RDATA);
      trans_h.RRESP = minf_mon.mas_axi_mon_cb.RRESP;
      trans_h.RLAST = minf_mon.mas_axi_mon_cb.RLAST;
      end
   endtask

   
  endclass
  `endif
