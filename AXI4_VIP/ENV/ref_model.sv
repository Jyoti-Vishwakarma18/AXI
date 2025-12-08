/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : ref_model.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : AUGUST 18
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/
//Guard Statement
`ifndef REF_AXI_UVM
`define REF_AXI_UVM

 `uvm_analysis_imp_decl(_master_ref)
 `uvm_analysis_imp_decl(_slave_ref)

class axi_reference#(ADDR_WIDTH = 32, DATA_WIDTH = 32, ID_WIDTH = 16) extends uvm_component;

   event                                                                                            request;
   uvm_blocking_put_port#(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH))                      exp_put_port;      //to send expected data 
   uvm_analysis_imp_slave_ref  #(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH,ID_WIDTH), axi_reference) slv_an_imp[];  //to get actual data

   slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)                                              que[$];
   slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)                                              trans_h;
   slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)                                              trans_h2;
  
   bit [ADDR_WIDTH - 1 :0]addr_array[];

   static  bit[DATA_WIDTH-1 : 0] memory [int]; 


  `uvm_component_param_utils(axi_reference)
  
  
   function new(string name = "axi_reference", uvm_component parent = null);

    super.new(name, parent);
    exp_put_port = new("exp_put_port", this);

    trans_h = slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("trans_h", this);
    endfunction

 function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    slv_an_imp = new[`NO_OF_SLAVE];
    foreach(slv_an_imp[i]) slv_an_imp[i] = new($sformatf("slv_an_imp[%0d]",i), this);

    endfunction
 

 function void write_slave_ref(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH,ID_WIDTH) act_trans);

    trans_h2 = new act_trans;
    que.push_back(trans_h2);
    ->request;
    endfunction
 
 task run_phase(uvm_phase phase);

            forever begin
            @(request);
            trans_h = que.pop_front(); 
           
	   	if(trans_h.enb == trans_h.WRITE) write_operation();
                if(trans_h.enb == trans_h.READ)  read_operation();
		exp_put_port.put(trans_h);
            end
  
 endtask
 
 
 //              -----         WRITING IN MEMORY
              
  task write_operation();
   
  
    burst_calc(trans_h.AWADDR, trans_h.AWSIZE, trans_h.AWLEN, trans_h.AWBURST);

    //strobe application --  WSTRB[n] --> WDATA[(8n) + 7 :(8n)] 
    foreach(addr_array[i]) 
            begin
            if(!memory.exists(addr_array[i])) memory[addr_array[i]] = 'b0;
            end

    foreach(trans_h.write_strobe[k,j])
            begin 
            if(trans_h.write_strobe[k][j] == 1'b1) begin	  
            memory[addr_array[k]][(8*j) +: 8] = memory[addr_array[k]][(8*j) +: 8] | trans_h.wdata_array[k][(8*j) +: 8]; 
            end
            end

    
    endtask
    

 //              -----         READ FORM MEMORY
  task read_operation();
  
  
    burst_calc(trans_h.ARADDR, trans_h.ARSIZE, trans_h.ARLEN, trans_h.ARBURST);

    foreach(addr_array[i]) 
    begin
    if(!memory.exists(addr_array[i])) memory[addr_array[i]] = 'b0; 
    trans_h.rdata_array.push_back(memory[addr_array[i]]) ;
    end
    trans_h.RID = trans_h.ARID;
    endtask

 //              -----         BURST CALCULATION

  function void burst_calc(input bit [ADDR_WIDTH -1 : 0]  addr,input  bit [2:0] AxSIZE,input bit [7:0] AxLEN,input bit[1:0] burst_type );

      bit[ADDR_WIDTH - 1: 0]  Start_Address = addr;
      int  Number_Bytes = 2 ** AxSIZE;
      int  Burst_Length = AxLEN + 1;
      
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
