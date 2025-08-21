/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : slv_axi_uvc.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Gaurd Statement
`ifndef SAXI_UVC_UVM
`define SAXI_UVC_UVM

class slv_axi_uvc#(int ADDR_WIDTH = 32 , DATA_WIDTH= 32, ID_WIDTH =16) extends uvm_component;

  int num;


 //_______________________Factory Registration__________________________________
 `uvm_component_param_utils_begin(slv_axi_uvc)
  `uvm_field_int(num, UVM_ALL_ON)
  `uvm_component_utils_end

 
 //_________________________Declaration__________________________________________
  uvm_analysis_export#(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)) slv_axi_uvc_export;
  slv_axi_agent#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  sagnt_h;


 //__________________________new function_________________________________________ 
 function new(string name = "slv_axi_uvc", uvm_component parent = null);
 super.new(name, parent);
 slv_axi_uvc_export = new("slv_axi_uvc_export", this);
 sagnt_h  = slv_axi_agent#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("sagnt_h", this);

 endfunction


 //___________________________Build_phase__________________________________________
 function void build_phase(uvm_phase phase);
 super.build_phase(phase);

 //Creating required number of master agent
  uvm_config_db#(int)::get(this, "*", "total_slave",num);
  $display("The value of config master %0d", num);
 /*
 slv_axi_agent#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  sagnt_h = new[num];

 foreach(sagnt_h[i]) begin 
  sagnt_h[i] = new();
  sagnt_h[i]  = slv_axi_agent#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("sagnt_h[i]", this);
 end
 */
 endfunction


 //___________________________Connect_phase____________________________________
 function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 sagnt_h.s_mon_h.slave_anaylsis_port.connect(slv_axi_uvc_export);
 endfunction

 endclass
 `endif
