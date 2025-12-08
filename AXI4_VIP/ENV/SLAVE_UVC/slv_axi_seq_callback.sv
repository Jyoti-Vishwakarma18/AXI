/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : slv_axi_seq_callback.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : SEP 25
                DESCRIPTION : It is callback class extends form uvm_callback, created it to give error response for driver to scorebord

****************************************************************************************************************************************************************************************/


//Gaurd Statement
`ifndef SLAVE_SEQ_CALLBACK_AXI_UVM
`define SLAVE_sEQ_CALLBACK_AXI_UVM

class slv_axi_seq_callback#(int ADDR_WIDTH = 16 , DATA_WIDTH =32 , ID_WIDTH =16) extends uvm_callback;



  function new(string name = "slv_axi_seq_callback");
  super.new(name);
  endfunction

  virtual function void error_wr_resp(slv_axi_seq_item#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) req);
  $display("Called form main callback class");
  endfunction

  virtual function void error_rd_resp(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) req);
  $display("Called form main callback class");
  endfunction

endclass 
`endif
