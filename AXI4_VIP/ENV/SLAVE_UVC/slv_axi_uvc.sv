/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : slv_axi_uvc.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Gaurd Statement
`ifndef SAXI_UVC_UVM
`define SAXI_UVC_UVM

class slv_axi_uvc#(int ADDR_WIDTH = 32 , DATA_WIDTH= 32, ID_WIDTH =16) extends uvm_agent;

  uvm_analysis_export#(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH))  slv_axi_uvc_export[];
  slv_axi_agent#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)                           sagnt_h[];
  slv_axi_agent#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)                           sagnt_dum;
  int                                                                        no_of_slv_agnth = 1;

 `uvm_component_param_utils_begin(slv_axi_uvc)
  `uvm_field_int(no_of_slv_agnth, UVM_ALL_ON)
  `uvm_component_utils_end

 function new(string name = "slv_axi_uvc", uvm_component parent = null);

    super.new(name, parent);

    endfunction


 function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    uvm_config_db#(int)::get(this, "*", "Total_num_of_slave_agent",no_of_slv_agnth);

    slv_axi_uvc_export = new[no_of_slv_agnth];
    foreach(slv_axi_uvc_export[i]) slv_axi_uvc_export[i] = new($sformatf("slv_axi_uvc_export[%0d]",i),this);

    sagnt_h = new[no_of_slv_agnth];
    foreach(sagnt_h[i]) sagnt_h[i]  = slv_axi_agent#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create( $sformatf("sagnt_h[%0d]",i), this);

    endfunction


 function void connect_phase(uvm_phase phase);
    
    super.connect_phase(phase);

    foreach(sagnt_h[i]) sagnt_h[i].s_mon_h.slave_anaylsis_port.connect(slv_axi_uvc_export[i]);

    endfunction

 endclass
 `endif
