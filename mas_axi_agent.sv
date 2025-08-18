/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : mas_axi_agent.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Gaurd Statement
`ifndef MASTER_AGENT_UVM
`define MASTER_AGENT_UVM

class mas_axi_agent#(int ADDR_WIDTH = 32, DATA_WIDTH = 32,  ID_WIDTH= 16) extends uvm_agent;

 //__________________________Factory Registration__________________________________
  
 `uvm_component_param_utils(mas_axi_agent)

 //__________________________Declaration__________________________________________
 //master interface 
 virtual mas_axi_interface#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) mas_inf;

//configuration
 mas_cnfg_axi config_h;

 //component handle 
 mas_axi_driver#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)    m_drv_h;
 mas_axi_monitor#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)   m_mon_h;
 mas_axi_sequencer#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) m_seqr_h;

//___________________________new function_________________________________________
 function new(string name = "mas_axi_agent", uvm_component parent = null);
  super.new(name , parent);
  config_h = mas_cnfg_axi::type_id::create("config_h", this);
//component configuration
  if(config_h.is_active_master == UVM_ACTIVE) begin 
   m_drv_h  = mas_axi_driver#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("m_drv_h", this);
   m_seqr_h = mas_axi_sequencer#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("m_seqr_h", this);
   end
  m_mon_h  = mas_axi_monitor#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("m_mon_h", this);

 endfunction

//___________________________build_phase_____________________________________
 function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  uvm_config_db#(virtual mas_axi_interface#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH))::get(this," ","mas_inf", mas_inf);
  uvm_config_db #(mas_cnfg_axi)::get(this,"","mas_agent_config", config_h);

   endfunction

 //__________________________Connect_phase_______________________________
 function void connect_phase(uvm_phase phase);
  m_drv_h.seq_item_port.connect(m_seqr_h.seq_item_export);
  m_drv_h.minf_drv = this.mas_inf;
  m_mon_h.minf_mon = this.mas_inf;
 endfunction
   
 endclass
 `endif
