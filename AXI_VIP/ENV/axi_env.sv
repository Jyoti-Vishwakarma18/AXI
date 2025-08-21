/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : axi_env.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/


//Gaurd Statement
`ifndef MAXI_UVC_UVM
`define MAXI_UVC_UVM

class axi_env#(int ADDR_WIDTH = 32 , DATA_WIDTH= 32, ID_WIDTH =16)  extends uvm_env;

 //_______________________Factory Registration__________________________________
    `uvm_component_param_utils(axi_env)
 
  //Declaration
  mas_axi_uvc#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)       mas_axi_uvc_h;
  slv_axi_uvc#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)       slv_axi_uvc_h;
  axi_scoreboard#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)    axi_scrbd_h;
  axi_reference#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)     axi_ref_h;
 //__________________________new function_________________________________________ 
 function new(string name = "axi_env", uvm_component parent = null);
 super.new(name, parent);
  mas_axi_uvc_h = mas_axi_uvc#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("mas_axi_uvc_h",this);
  slv_axi_uvc_h = slv_axi_uvc#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("slv_axi_uvc_h",this);
  axi_scrbd_h   = axi_scoreboard#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("axi_scrbd_h", this);
  axi_ref_h     = axi_reference#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("axi_ref_h", this);
  endfunction

//___________________________build_phase_____________________________________
 function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  mas_axi_uvc_h.mas_axi_uvc_export.connect(axi_scrbd_h.mas_an_imp);
  slv_axi_uvc_h.slv_axi_uvc_export.connect(axi_ref_h.slv_an_imp);
  axi_ref_h.put_port.connect(axi_scrbd_h.act_imp);
  endfunction

 endclass
 `endif
