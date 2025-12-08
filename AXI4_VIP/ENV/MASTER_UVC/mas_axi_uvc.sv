/***************************************************************************************************************************************************************************
 
                FILE_NAME   : mas_axi_uvc.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

********************************************************************************************************************************************************************/

//Gaurd Statement
`ifndef MAXI_UVC_UVM
`define MAXI_UVC_UVM

class mas_axi_uvc#(int ADDR_WIDTH = 32 , DATA_WIDTH= 32, ID_WIDTH =16) extends uvm_agent;

 
  uvm_analysis_export#(mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH))  mas_axi_uvc_export[];
  mas_axi_agent#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)                           magnt_h[];
  int                                                                        no_of_master_agnth ;
 
 
 `uvm_component_param_utils_begin(mas_axi_uvc)
 `uvm_field_int(no_of_master_agnth, UVM_ALL_ON)
 `uvm_component_utils_end


  function new(string name = "mas_axi_uvc", uvm_component parent = null);

    super.new(name, parent);

    endfunction

  function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    
    uvm_config_db#(int)::get(this, "*", "Total_num_of_master_agent",no_of_master_agnth );

    mas_axi_uvc_export = new[no_of_master_agnth];
    foreach(mas_axi_uvc_export[i]) mas_axi_uvc_export[i] = new($sformatf("mas_axi_uvc_export[%0d]",i));
    
    magnt_h = new[no_of_master_agnth];
    foreach(magnt_h[i])
    magnt_h[i] =  mas_axi_agent#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create($sformatf("magnt_h[%0d]",i), this);
    
    endfunction

  function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);
    
    //                        ------- CONNECT AGENT PORT -> UVC EXPROT
    foreach(magnt_h[i])
    magnt_h[i].m_mon_h.axim_mon_anlys_port.connect(mas_axi_uvc_export[i]);

    endfunction  

  endclass
  `endif
