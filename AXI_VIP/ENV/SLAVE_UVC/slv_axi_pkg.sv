/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : slv_axi_pkg.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 17
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/
//Guard Statement
`ifndef SAXI_PKG_UVM
`define SAXI_PKG_UVM

`include"slv_axi_interface.sv"

package slv_axi_pkg;

`include"uvm_macros.svh"
import uvm_pkg::*;

`include"slv_axi_seq_item.sv"

`include"slv_axi_sequencer.sv"
`include"slv_axi_sequence.sv"
`include"slv_axi_driver.sv"
`include"slv_axi_monitor.sv"
`include"slv_cnfg_axi.sv"
`include"slv_axi_agent.sv"

`include"slv_axi_uvc.sv"

endpackage
`endif

