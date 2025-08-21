/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : slv_cnfg_axi.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 17
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef AXI_SLV_CONFIG_UVM
`define AXI_SLV_CONFIG_UVM


class slv_cnfg_axi extends uvm_object;

 uvm_active_passive_enum  is_active_slave = UVM_ACTIVE;

 //_______________________Factory Registration__________________________________
 
  `uvm_object_utils_begin(slv_cnfg_axi)
  `uvm_field_enum( uvm_active_passive_enum,is_active_slave, UVM_ALL_ON)
  `uvm_object_utils_end

  //__________________________new function_________________________________________ 
  function new (string name = "slv_cnfg_axi");
  super.new(name);
  endfunction



 
 endclass
 `endif 
