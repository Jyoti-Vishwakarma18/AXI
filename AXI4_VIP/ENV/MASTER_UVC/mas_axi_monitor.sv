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

  mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)                       trans_h;
  uvm_analysis_port#(mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH))   axim_mon_anlys_port;
  mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)                       packet[int];

  virtual mas_axi_interface#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)              minf_mon;

  `uvm_component_param_utils(mas_axi_monitor)

     
  function new(string name = "mas_axi_monitor", uvm_component parent = null);

      super.new(name, parent);
      axim_mon_anlys_port = new("axim_mon_anlys_port", this);
      trans_h = mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("trans_h", this);
      endfunction
 
  function void build_phase(uvm_phase phase);

      super.build_phase(phase);
      endfunction
  
  task run_phase(uvm_phase phase);

   forever
        begin
        wait_for_reset_release();
	fork : RESET_MAS_MON
            wait_for_reset_assertion();

            forever
            begin 
               monitor();
               packet_collection(trans_h);
               end

        join_any 
        disable RESET_MAS_MON;
        end
 
    endtask

   /*******************************************************************************************************************************************************/ 
    task wait_for_reset_assertion();
    wait(minf_mon.mas_axi_mon_cb.ARESETn == 1'b0);
    endtask
   /*******************************************************************************************************************************************************/  
    task wait_for_reset_release();
    wait(minf_mon.mas_axi_mon_cb.ARESETn == 1'b1);
    endtask
   /*******************************************************************************************************************************************************/  

 task monitor();

        read_data_channel();
        endtask
 
 task packet_collection(mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) trans_h);

     if(minf_mon.mas_axi_mon_cb.RVALID && minf_mon.mas_axi_mon_cb.RREADY ) begin
        if(!packet.exists(trans_h.RID))   //NO need as RID will exist only asuse rdata omes only after read address
           packet[trans_h.RID] = mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create($sformatf("packet[%0d]",trans_h.RID), this);
           packet[trans_h.RID].RID          = trans_h.RID  ; 
           packet[trans_h.RID].rdata_array  = trans_h.rdata_array; 
           packet[trans_h.RID].RLAST        = trans_h.RLAST;
           packet[trans_h.RID].enb          = trans_h.READ;
           
           if(trans_h.RLAST)   begin
              axim_mon_anlys_port.write(packet[trans_h.RID]);
              trans_h.rdata_array.delete();
              end
     end

  endtask

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
