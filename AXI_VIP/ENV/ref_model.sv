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

  //________________________Factory Registration__________________________________
  `uvm_component_param_utils(axi_reference)
  
 
  //________________________Declaration__________________________________________ 
  
   event request;
  //analysis port connection of scoreboard to two monitor
   //tlm port for referen- soreboard ommuniation
   uvm_blocking_put_port#(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)) put_port; 
   uvm_analysis_imp_slave_ref  #(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH,ID_WIDTH), axi_reference) slv_an_imp;

   slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  que[$];
   slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  trans_h;
   slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  trans_h2;
  
    static  bit[DATA_WIDTH] memory [int]; 
 
    bit [ADDR_WIDTH]addr_array[];

  //________________________new function________________________________  
  function new(string name = "axi_reference", uvm_component parent = null);
  super.new(name, parent);
  put_port = new("put_port", this);
  slv_an_imp = new("slv_an_imp", this);
  trans_h = slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("trans_h", this);
  endfunction

 //___________________________build_phase_____________________________________
 function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 endfunction
 

 function void write_slave_ref(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH,ID_WIDTH) strans_h);
 trans_h2 = new strans_h;
 que.push_back(trans_h2);
 ->request;
 endfunction
 
 //___________________________RUN_PHASE___________________________________________
 task run_phase(uvm_phase phase);

            repeat(5) begin
            @(request);
            trans_h = que.pop_front(); 
           
	   	if(trans_h.enb == trans_h.WRITE) write_operation();
                if(trans_h.enb == trans_h.READ)  begin
			                         read_operation();
						 put_port.put(trans_h);
                                                 end 
            end
  
 endtask
 
 
 //________________________________________WRITING IN MEMORY______________________________________________________________________________________________________________________

  task write_operation();
   
  
  burst_calc(trans_h.AWADDR, trans_h.AWSIZE, trans_h.AWLEN, trans_h.AWBURST);
  
  $display($time," : WRITE_QUEUE ADDRESS : %p",addr_array);
  $display($time," : WRITE_QUEUE DATA    : %p",trans_h.wdata_array);
  

 //foreach(trans_h.wdata_array[i]) $display($time," : BEFORE STROBE WRITE_QUEUE DATA    : %0h",trans_h.wdata_array[i]);
  
  //strobe application 
                                      //WSTRB[n] --> WDATA[(8n) + 7 :(8n)] 

  foreach(trans_h.write_strobe[i,j]) 
          foreach(trans_h.wdata_array[k,l])
	  begin
	  if(i == k) begin
		    if(trans_h.write_strobe[i][j] == 0)  /* trans_h.wdata_array[k][((8*j) +7) : (8*j)] = ; */
			      if( l <= ((8*j)+7)  && l >= (8 *j))
			      trans_h.wdata_array[k][l] = 'b0;
		    end 
	  end
 
  foreach(trans_h.wdata_array[i]) $display($time," : AFTER STROBE WRITE_QUEUE DATA    : %8h   |  %4b",trans_h.wdata_array[i], trans_h.write_strobe[i]);
  foreach(addr_array[i])
  begin
  
     $display($time, "memory[addr_array[i]] written at address :%8h", memory[addr_array[i]]);
     memory[addr_array[i]] = memory[addr_array[i]] | trans_h.wdata_array[i];
     $display($time, "memory[addr_array[i]] written at address :%8h", memory[addr_array[i]]);
       
  end
    
  endtask
 //____________________________________________READ FORM MEMORY_________________________________________________________________________________________________________
  task read_operation();
  
  
  burst_calc(trans_h.ARADDR, trans_h.ARSIZE, trans_h.ARLEN, trans_h.ARBURST);
  $display($time, " : READ_QUEUE ADDRESS : %p", addr_array);

  foreach(addr_array[i]) trans_h.rdata_array.push_back(memory[addr_array[i]]) ;
  $display($time, " : READ_QUEUE DATA : %p", trans_h.rdata_array);
  trans_h.RID = trans_h.ARID;
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
