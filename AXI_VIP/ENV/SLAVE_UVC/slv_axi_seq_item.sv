/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : slv_axi_seq_item.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/

//Guard Statement
`ifndef SLAVE_AXI_SEQ_ITEM
`define SLAVE_AXI_SEQ_ITEM

class slv_axi_seq_item#(int ADDR_WIDTH = 32 , DATA_WIDTH = 32, ID_WIDTH = 16) extends uvm_sequence_item;

  typedef enum bit[1:0] {WRITE, READ, WR} Operation;
  typedef enum bit[1:0] {OKAY, EXOKAY, SLVERR, DECERR} response; 
    Operation                 enb;  
  // All signal of Master AXI

  //Write address channel signals
    bit [ADDR_WIDTH - 1 : 0]  AWADDR;
    bit [ID_WIDTH - 1   : 0]  AWID;
    bit [1:0]                 AWBURST;
    bit [7:0]                 AWLEN;
    bit [2:0] 		      AWSIZE;

 //Write data channel signals
   bit [ID_WIDTH - 1   : 0]  WID;
  
   bit 	  	             WLAST;

//arrays for data , strobe
  bit [DATA_WIDTH - 1  : 0]  wdata_array[$];
  bit [DATA_WIDTH - 1  : 0]  rdata_array[$];
  
  bit [DATA_WIDTH/8 -1 :0]   write_strobe[$];

 //Write response channel signals
   bit [ID_WIDTH - 1   : 0]  BID;
   response                  BRESP;
   bit		      	     BREADY;

 //Read address channel signals
   bit [ID_WIDTH - 1   : 0]  ARID;
   bit [ADDR_WIDTH - 1 : 0]  ARADDR;
   bit [2:0] 		     ARSIZE;
   bit [1:0]		     ARBURST;
   bit [7:0]	             ARLEN;

 //Read data channel signals 
   bit [ID_WIDTH - 1   : 0]  RID;
   bit                       RLAST;
   bit 		             RRESP;
   bit                       RDATA;

  
   //Factory registration 
   `uvm_object_param_utils_begin(slv_axi_seq_item)
    `uvm_field_queue_int(wdata_array  ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_queue_int(rdata_array  ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_queue_int(write_strobe ,UVM_ALL_ON | UVM_BIN)

    `uvm_field_int(RID     ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_int(RLAST   ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_int(RRESP   ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_int(RDATA  ,UVM_ALL_ON | UVM_UNSIGNED  )
    
    `uvm_field_int(AWSIZE  ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_int(AWLEN   ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_int(AWBURST ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_int(AWID    ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_int(AWADDR  ,UVM_ALL_ON | UVM_UNSIGNED  )

    `uvm_field_int(WID     ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_int(WLAST   ,UVM_ALL_ON | UVM_UNSIGNED  )

    `uvm_field_int(BID     ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_int(BRESP   ,UVM_ALL_ON | UVM_UNSIGNED  )
    
    `uvm_field_int(ARADDR  ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_int(ARID    ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_int(ARSIZE  ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_int(ARBURST ,UVM_ALL_ON | UVM_UNSIGNED  )
    `uvm_field_int(ARLEN   ,UVM_ALL_ON | UVM_UNSIGNED  )

    `uvm_field_int(enb,     UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_object_utils_end


endclass
`endif
