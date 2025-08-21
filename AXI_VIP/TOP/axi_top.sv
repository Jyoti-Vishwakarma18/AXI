/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : axi_top.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 16
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/
`include"test_pkg.sv"

module axi_tb_top;

`include "uvm_macros.svh"
import uvm_pkg::*;
import test_pkg::*;

bit clk;

slv_axi_interface#(32,32,16)  s_inf(clk);
mas_axi_interface#(32,32,16)  m_inf(clk);


//Generate clk
initial  begin
 forever begin
 #10 clk = ~clk;
 end
end

//configuration on interface

assign s_inf.AWADDR   =  m_inf.AWADDR;
assign s_inf.AWID     =  m_inf.AWID;    
assign s_inf.AWBURST  =  m_inf.AWBURST;
assign s_inf.AWLEN    =  m_inf.AWLEN;
assign s_inf.AWSIZE   =  m_inf.AWSIZE;
assign s_inf.AWVALID  =  m_inf.AWVALID;
assign m_inf.AWREADY  =  s_inf.AWREADY;


assign s_inf.WDATA    =  m_inf.WDATA;
assign s_inf.WID      =  m_inf.WID;
assign s_inf.WSTRB    =  m_inf.WSTRB;
assign s_inf.WLAST    =  m_inf.WLAST;
assign s_inf.WVALID   =  m_inf.WVALID;
assign m_inf.WREADY   =  s_inf.WREADY;


assign m_inf.BID      =  s_inf.BID;
assign m_inf.BRESP    =  s_inf.BRESP;
assign m_inf.BVALID   =  s_inf.BVALID;
assign s_inf.BREADY   =  m_inf.BREADY;


assign s_inf.ARID     =  m_inf.ARID;
assign s_inf.ARADDR   =  m_inf.ARADDR;
assign s_inf.ARSIZE   =  m_inf.ARSIZE;
assign s_inf.ARBURST  =  m_inf.ARBURST;
assign s_inf.ARLEN    =  m_inf.ARLEN;
assign s_inf.ARVALID  =  m_inf.ARVALID;
assign m_inf.ARREADY  =  s_inf.ARREADY;

assign m_inf.RID      =  s_inf.RID;
assign m_inf.RLAST    =  s_inf.RLAST;
assign m_inf.RRESP    =  s_inf.RRESP;
assign m_inf.RVALID   =  s_inf.RVALID;
assign s_inf.RREADY   =  m_inf.RREADY;
assign m_inf.RDATA    =  s_inf.RDATA;




initial begin

uvm_config_db #( virtual slv_axi_interface#(32,32,16))::set(null,"*","slv_inf", s_inf);
uvm_config_db #( virtual mas_axi_interface#(32,32,16))::set(null,"*","mas_inf", m_inf);

run_test("axi_base_test");


end
endmodule

