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

`include"axi_define.sv"
`include"uvm_macros.svh"
import uvm_pkg::*;

//`include"axi_env_pkg.sv"
import mas_axi_pkg::*;
import slv_axi_pkg::*;

import env_pkg::*;

//Sequence files
`include"error_resp_cb.sv"
`include"seqs_read.sv"
`include"seqs_write.sv"
`include"seqs_random.sv"
`include"seqs_burst.sv"
`include"seqs_len.sv"

//virtual_sequence_files
`include"sanity_vseqs.sv"
`include"random_vseqs.sv"
`include"error_resp_vseqs.sv"
`include"burst_vseqs.sv"
`include"slave_vseqs.sv"


//base_test_file
`include"axi_base_test.sv"

//test_case_files
`include"test_sanity.sv"
`include"test_random.sv"
`include"test_burst.sv"
`include"test_length.sv"
`include"test_error_resp.sv"

endpackage
`endif
