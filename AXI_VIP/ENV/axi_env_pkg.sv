/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : env_pkg.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 17
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

`ifndef ENV_PKG_UVM
`define ENV_PKG_UVM


package env_pkg;

`include"uvm_macros.svh"
import uvm_pkg::*;

import slv_axi_pkg::*;
import mas_axi_pkg::*;


`include"env_config.sv"
`include"scoreboard.sv"
`include"ref_model.sv"
`include"axi_env.sv"


endpackage
`endif
