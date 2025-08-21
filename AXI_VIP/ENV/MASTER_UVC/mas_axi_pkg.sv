/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : mas_axi_pkg.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 17
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/
//Guard Statement
`ifndef MAXI_PKG_UVM
`define MAXI_PKG_UVM

`include"mas_axi_interface.sv"

package mas_axi_pkg;

`include"uvm_macros.svh"
import uvm_pkg::*;

`include"mas_cnfg_axi.sv"
`include"mas_axi_seq_item.sv"
`include"mas_axi_sequence.sv"
`include"mas_axi_sequencer.sv"
`include"mas_axi_driver.sv"
`include"mas_axi_monitor.sv"
`include"mas_axi_agent.sv"

`include"mas_axi_uvc.sv"

endpackage
`endif
