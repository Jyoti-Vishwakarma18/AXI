/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : slv_axi_interface.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef SLAVE_INTERFACE_UVM
`define SLAVE_INTERFACE_UVM

interface slv_axi_interface#(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32, ID_WIDTH = 16)(input clk);

/*  
  parameter ADDR_WIDTH = 32,
  	     DATA_WIDTH = 32, 
  	     ID_WIDTH   = 16;
*/
 //Global signals
 
 
 //Write address channel signals
   logic [ADDR_WIDTH - 1 : 0]  AWADDR;
   logic [ID_WIDTH - 1   : 0]  AWID;
   logic [1:0]                 AWBURST;
   logic [7:0]                 AWLEN;
   logic [2:0] 		       AWSIZE;
   logic                       AWVALID;
   logic                       AWREADY;

 //Write data channel signals
   logic [DATA_WIDTH - 1 : 0]  WDATA;
   logic [ID_WIDTH - 1   : 0]  WID;
   logic [DATA_WIDTH/8 -1 :0]  WSTRB;
   logic 	  	       WLAST;
   logic 		       WVALID;
   logic 		       WREADY;

 //Write response channel signals
   logic [ID_WIDTH - 1   : 0]  BID;
   logic [1:0]                 BRESP;
   logic	       	       BVALID;
   logic		       BREADY;

 //Read address channel signals
   logic [ID_WIDTH - 1   : 0]  ARID;
   logic [ADDR_WIDTH - 1 : 0]  ARADDR;
   logic [2:0] 		       ARSIZE;
   logic [1:0]		       ARBURST;
   logic [7:0]		       ARLEN;
   logic 		       ARVALID;
   logic 		       ARREADY;

 //Read data channel signals 
   logic [ID_WIDTH - 1   : 0]  RID;
   logic                       RLAST;
   logic [1:0]		       RRESP;
   logic 		       RVALID;
   logic 		       RREADY;
   logic [DATA_WIDTH -1 :0]    RDATA;
 //clocking block for master AXI
  clocking slv_axi_drv_cb@(posedge clk);
  default input #1  output #0;
  output  AWREADY, WREADY, BID, BRESP, BVALID, ARREADY, RID, RLAST, RRESP, RVALID, RDATA;
  input AWADDR, AWBURST, AWLEN, AWSIZE, AWID, AWVALID, WDATA , WID, WSTRB, WLAST, WVALID, BREADY, ARID, ARADDR, ARSIZE, ARBURST, ARLEN, ARVALID, RREADY;
  endclocking

  clocking slv_axi_mon_cb@(posedge clk);
  default input #1 output #0;
  input  AWADDR, AWBURST, AWLEN, AWSIZE, AWID, AWVALID, WDATA, WID, WSTRB, WLAST, WVALID, BREADY, ARID, ARADDR, ARSIZE, ARBURST, ARLEN, ARVALID, RREADY, AWREADY, WREADY, BID, BRESP, BVALID, ARREADY, RID, RLAST, RRESP, RVALID, RDATA;
  endclocking


endinterface
`endif
