/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : env_config.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 23
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Gaurd Statement
`ifndef ENV_AXI_CONFIG
`define ENV_AXI_CONFIG

class env_config extends uvm_object;
 
 int total_master;
 int total_slave; 

 //_______________________Factory Registration__________________________________
 
 `uvm_object_utils_begin(env_config)
  `uvm_field_int(total_master, UVM_ALL_ON);
  `uvm_field_int(total_slave, UVM_ALL_ON);
  `uvm_object_utils_end

//__________________________new function_________________________________________ 
function new(string name= "env_config");
 super.new(name);
 endfunction


endclass
`endif
