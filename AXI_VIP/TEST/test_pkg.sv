/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : test_pkg.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 21
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/
//Guard Statement
`ifndef TAXI_PKG_UVM
`define TAXI_PKG_UVM

`include"mas_axi_interface.sv"
`include"slv_axi_interface.sv"


package test_pkg;

`include"uvm_macros.svh"
import uvm_pkg::*;

//`include"axi_env_pkg.sv"
import mas_axi_pkg::*;
import slv_axi_pkg::*;

import env_pkg::*;

`include"axi_base_test.sv"



endpackage
`endif
