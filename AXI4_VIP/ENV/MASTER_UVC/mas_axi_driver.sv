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

   `uvm_component_param_utils(mas_axi_driver)
   
     virtual mas_axi_interface#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)     minf_drv;
     mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)              mas_trans_h;
   
     mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)              write_addr_que[$], wrdata_que[$], read_addr_que[$], write_rsp[int], read_rsp[int],
                                                                      wraddr_h,          wrdata_h,      rdaddr_h,         tmp ;

     bit is_pipeline;

   function new(string name = "mas_axi_driver", uvm_component parent = null);

      super.new(name, parent);
      mas_trans_h =mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("mas_trans_h", this);
 
      endfunction

   function void build_phase(uvm_phase phase);

      super.build_phase(phase);
      uvm_config_db#(bit)::get(this, "" , "Is_pipeline", is_pipeline);
      endfunction :build_phase
   
   task run_phase(uvm_phase phase);

        forever
        begin
        wait_for_reset_release();
	fork : RESET_MAS_DRV
            wait_for_reset_assertion();
            fork
 
             drive_response();     

             forever begin

                seq_item_port.get_next_item(req);
                buffer();
                drive_data(is_pipeline); 
                seq_item_port.item_done();

                end
            join
       join_any 
       disable RESET_MAS_DRV;
       end

       endtask
   
    /*******************************************************************************************************************************************************/ 
    task wait_for_reset_assertion();
    wait(minf_drv.mas_axi_drv_cb.ARESETn == 1'b0);
    endtask
   /*******************************************************************************************************************************************************/  
    task wait_for_reset_release();
    wait(minf_drv.mas_axi_drv_cb.ARESETn == 1'b1);
    endtask
   /*******************************************************************************************************************************************************/  
      
    task buffer();

       mas_trans_h = new req;
            //mas_trans_h.print();

            if(mas_trans_h.enb == mas_trans_h.WR)begin     write_addr_que.push_back(mas_trans_h);
                                                           wrdata_que.push_back(mas_trans_h); 
                                                           read_addr_que.push_back(mas_trans_h);
                                                           
                                                           $cast(write_rsp[req.WID], req.clone());
                                                           write_rsp[req.WID].set_id_info(req);

                                                           $cast(read_rsp[req.ARID], req.clone());
                                                           read_rsp[req.ARID].set_id_info(req);
                                                           end

            if(mas_trans_h.enb == mas_trans_h.WRITE)begin  write_addr_que.push_back(mas_trans_h);
                                                           wrdata_que.push_back(mas_trans_h); 
                                      		   
                                                           $cast(write_rsp[req.WID], req.clone());
                                      		           write_rsp[req.WID].set_id_info(req);
                                                           end

            if(mas_trans_h.enb == mas_trans_h.READ)begin   read_addr_que.push_back(mas_trans_h);

                                                           $cast(read_rsp[req.ARID], req.clone());
                                                           read_rsp[req.ARID].set_id_info(req);
                                                           end

    endtask

   task drive_data(bit is_pipeline);

        if(is_pipeline) 

            begin

               fork
                 wait(wraddr_h == null)   write_addr_channel();
                 wait(wrdata_h == null)   write_data_channel();
                 wait(rdaddr_h == null)   read_addr_channel();
               join_none

            end

        else 

	    begin

	      fork
	         wait(wraddr_h == null) nonpipeline_write_addr_and_data_channel();
	         wait(rdaddr_h == null) read_addr_channel();
              join

            end
        endtask
   
   task drive_response();
        //`uvm_info(get_full_name(), "DRIVE_RESPONSE", UVM_LOW)
        fork

          write_response_channel();  
          read_data_channel(); //it consist response also so no need of separate read_response_channel.

        join

        endtask


   task write_addr_channel(); 
    
      if(write_addr_que.size() != 0) begin 
         wraddr_h = new write_addr_que.pop_front();
         minf_drv.mas_axi_drv_cb.AWVALID <= 1'b1; 

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
   
   
   task nonpipeline_write_addr_and_data_channel(); 
    
      fork
        begin
           if(write_addr_que.size() != 0) begin 

              wraddr_h = new write_addr_que.pop_front();

              minf_drv.mas_axi_drv_cb.AWVALID <= 1'b1; 
          
              minf_drv.mas_axi_drv_cb.AWID    <= wraddr_h.AWID;
              minf_drv.mas_axi_drv_cb.AWADDR  <= wraddr_h.AWADDR;
              minf_drv.mas_axi_drv_cb.AWLEN   <= wraddr_h.AWLEN;
              minf_drv.mas_axi_drv_cb.AWSIZE  <= wraddr_h.AWSIZE;
              minf_drv.mas_axi_drv_cb.AWBURST <= wraddr_h.AWBURST;
          
          
              @(minf_drv.mas_axi_drv_cb iff minf_drv.mas_axi_drv_cb.AWREADY);
              if(write_addr_que.size() == 0) minf_drv.mas_axi_drv_cb.AWVALID <= 1'b0; 

              end
           end

        begin
                
           if(wrdata_que.size() != 0) begin

              wrdata_h = new wrdata_que.pop_front(); 
              while(wrdata_h.wdata_array.size() != 0) begin  
                if(wrdata_h == null) `uvm_fatal("WRITE_DATA", "wrdata_h is null");
                minf_drv.mas_axi_drv_cb.WVALID  <= 1'b1;
                minf_drv.mas_axi_drv_cb.WID    <= wrdata_h.WID;
                minf_drv.mas_axi_drv_cb.WDATA  <= wrdata_h.wdata_array.pop_front();
                minf_drv.mas_axi_drv_cb.WSTRB  <= {<<{wrdata_h.write_strobe.pop_front()}};
                if(wrdata_h.wdata_array.size() == 0) minf_drv.mas_axi_drv_cb.WLAST  <= 1'b1; //Array is empty which means this one was last data.

               @(minf_drv.mas_axi_drv_cb iff minf_drv.mas_axi_drv_cb.WREADY);
              
               minf_drv.mas_axi_drv_cb.WLAST   <= 1'b0;
               if(wrdata_que.size() == 0) minf_drv.mas_axi_drv_cb.WVALID  <= 1'b0;
               end
              end
            end
       join

       wraddr_h = null;//Empty the class so that new transfer can take place
       wrdata_h = null;
       endtask
   

   
   task write_data_channel(); 
        
	if(wrdata_que.size() != 0) begin
           wrdata_h = new wrdata_que.pop_front(); 
           while(wrdata_h.wdata_array.size() != 0) begin  
             if(wrdata_h == null) `uvm_fatal("MASTER_DRIVER", "wrdata_h is null");
             minf_drv.mas_axi_drv_cb.WVALID <= 1'b1;
             minf_drv.mas_axi_drv_cb.WID    <= wrdata_h.WID;
             minf_drv.mas_axi_drv_cb.WDATA  <= wrdata_h.wdata_array.pop_front();
             minf_drv.mas_axi_drv_cb.WSTRB  <= {<<{wrdata_h.write_strobe.pop_front()}};
             if(wrdata_h.wdata_array.size() == 0) minf_drv.mas_axi_drv_cb.WLAST  <= 1'b1; //Array is empty which means this one was last data.

             @(minf_drv.mas_axi_drv_cb iff minf_drv.mas_axi_drv_cb.WREADY);
           
	     minf_drv.mas_axi_drv_cb.WLAST   <= 1'b0;
             if(wrdata_que.size() == 0) minf_drv.mas_axi_drv_cb.WVALID  <= 1'b0;
	   end

        wrdata_h = null;
        end
        endtask

   task read_addr_channel();

      if(read_addr_que.size() != 0) begin
         rdaddr_h = new read_addr_que.pop_front();
         minf_drv.mas_axi_drv_cb.ARID    <= rdaddr_h.ARID;
         minf_drv.mas_axi_drv_cb.ARADDR  <= rdaddr_h.ARADDR;
         minf_drv.mas_axi_drv_cb.ARLEN   <= rdaddr_h.ARLEN;
         minf_drv.mas_axi_drv_cb.ARSIZE  <= rdaddr_h.ARSIZE;
         minf_drv.mas_axi_drv_cb.ARBURST <= rdaddr_h.ARBURST;
         minf_drv.mas_axi_drv_cb.ARVALID <= 1'b1;

         @(minf_drv.mas_axi_drv_cb iff minf_drv.mas_axi_drv_cb.ARREADY);
         minf_drv.mas_axi_drv_cb.ARVALID <= 1'b0;
      
         rdaddr_h = null;
         end
     endtask
     
   task write_response_channel;

      forever begin

         @(minf_drv.mas_axi_drv_cb);
         minf_drv.mas_axi_drv_cb.BREADY <= 1'b1;

         if((minf_drv.mas_axi_drv_cb.BRESP == 0) && minf_drv.mas_axi_drv_cb.BVALID && minf_drv.mas_axi_drv_cb.BREADY)begin
             write_rsp[minf_drv.mas_axi_drv_cb.BID].BRESP =  minf_drv.mas_axi_drv_cb.BRESP;
             seq_item_port.put_response(write_rsp[minf_drv.mas_axi_drv_cb.BID]);
             end
         end
   endtask

   task read_data_channel();

      forever begin

         @(minf_drv.mas_axi_drv_cb);
         minf_drv.mas_axi_drv_cb.RREADY <= 1'b1;
              
         if( minf_drv.mas_axi_drv_cb.RLAST &&  minf_drv.mas_axi_drv_cb.RVALID)begin
             read_rsp[minf_drv.mas_axi_drv_cb.RID].RRESP = minf_drv.mas_axi_drv_cb.RRESP;
             seq_item_port.put_response(read_rsp[minf_drv.mas_axi_drv_cb.RID]);
             end
         end
      endtask
  

endclass
`endif


     
    
