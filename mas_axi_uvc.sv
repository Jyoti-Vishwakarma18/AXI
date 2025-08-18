/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : mas_axi_uvc.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Gaurd Statement
`ifndef MAXI_UVC_UVM
`define MAXI_UVC_UVM

class mas_axi_uvc#(int ADDR_WIDTH = 32 , DATA_WIDTH= 32, ID_WIDTH =16) extends uvm_component;

 //__________________________Declaration_________________________________________
 uvm_analysis_export#(mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)) mas_axi_uvc_export;
 mas_axi_agent#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  magnt_h;
 int num;
 
 //_______________________Factory Registration__________________________________
 
 `uvm_component_param_utils_begin(mas_axi_uvc)
  `uvm_field_int(num, UVM_ALL_ON)
 `uvm_component_utils_end


//__________________________new function________________________________________  
 function new(string name = "mas_axi_uvc", uvm_component parent = null);
 super.new(name, parent);
 mas_axi_uvc_export = new("mas_axi_uvc_exprot");

 magnt_h =  mas_axi_agent#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("magnt_h", this);
 endfunction

//___________________________build_phase________________________________________
 function void build_phase(uvm_phase phase);
 super.build_phase(phase);

  uvm_config_db#(int)::get(this, "*", "total_master",num );
  $display("The value of config slave  %0d", num);


 endfunction

//___________________________Connect_phase______________________________________
 function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);

 magnt_h.m_mon_h.master_anaylsis_port.connect(mas_axi_uvc_export);
 endfunction  

 endclass
 `endif
