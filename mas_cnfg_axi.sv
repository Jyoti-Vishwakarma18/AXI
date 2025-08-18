/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : mas_cnfg_axi.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 17
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef AXI_MASTER_CONFIG_UVM
`define AXI_MASTER_CONFIG_UVM


class mas_cnfg_axi extends uvm_object;

 uvm_active_passive_enum  is_active_master = UVM_ACTIVE;

 //_______________________Factory Registration__________________________________
 
 `uvm_object_utils_begin(mas_cnfg_axi)
  `uvm_field_enum( uvm_active_passive_enum,is_active_master, UVM_ALL_ON)
  `uvm_object_utils_end

//__________________________new function_________________________________________   
 function new (string name = "mas_cnfg_axi");
  super.new(name);
  endfunction


 
 endclass
 `endif 
