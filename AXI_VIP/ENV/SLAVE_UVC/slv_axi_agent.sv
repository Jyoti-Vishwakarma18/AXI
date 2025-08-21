/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : slv_axi_agent.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Gaurd Statement
`ifndef SLAVE_AGENT_UVM
`define SLAVE_AGENT_UVM

class slv_axi_agent#(int ADDR_WIDTH = 32 , DATA_WIDTH = 32, ID_WIDTH = 16) extends uvm_agent;

 //_________________________Factory Registration__________________________________
 `uvm_component_param_utils(slv_axi_agent)


//_________________________Declaration__________________________________________

 //slave interface
 //virtual slv_axi_interface#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) slv_inf;
 virtual slv_axi_interface slv_inf;

//configuration
slv_cnfg_axi config_h;

 slv_axi_driver#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)    s_drv_h;
 slv_axi_monitor#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)   s_mon_h;
 slv_axi_sequencer#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) s_seqr_h;
 
//__________________________ new function____________________________________
 function new(string name = "slv_axi_agent", uvm_component parent = null);
 super.new(name , parent);
 config_h = slv_cnfg_axi::type_id::create("config_h", this);
 if(config_h.is_active_slave == UVM_ACTIVE) begin
 s_drv_h  = slv_axi_driver#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("s_drv_h", this);
 s_seqr_h = slv_axi_sequencer#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("s_seqr_h", this);
 end
 else `uvm_error("SLAVE_AGENT", "Master's driver and monitor have not been created");
 s_mon_h  = slv_axi_monitor#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("s_mon_h", this);

 endfunction

//___________________________build_phase_____________________________________
 function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 
 uvm_config_db#(virtual slv_axi_interface)::get(this,"" ,"slv_inf", slv_inf);
 uvm_config_db#(slv_cnfg_axi)::get(this,"","slv_agent_config", config_h);
 
 endfunction

 //______________________________Connect_phase_______________________________
 function void connect_phase(uvm_phase phase);
 s_drv_h.seq_item_port.connect(s_seqr_h.seq_item_export);
 s_drv_h.sinf_drv =  this.slv_inf;
 s_mon_h.sinf_mon =  this.slv_inf; 
 s_mon_h.slave_anaylsis_port.connect(s_seqr_h.store_fifo.analysis_export);
 endfunction

 
 endclass
 `endif
