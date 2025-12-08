/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : error_resp_cb.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : SEP 25
                DESCRIPTION : It is user define callback which courrpts the data that is written to address and this lead to failure of test.

****************************************************************************************************************************************************************************************/
//Gaurd Statement
`ifndef AXI_CALLBACK_USER_UVM
`define AXI_CALLBACK_USER_UVM

class err_resp_cb#(int ADDR_WIDTH = 16 , DATA_WIDTH =32 , ID_WIDTH =16) extends slv_axi_seq_callback#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH);
 
  `uvm_object_param_utils(err_resp_cb#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH))

 function new(string name = "err_resp_cb");
     super.new(name);
     endfunction
 
 function void error_wr_resp(slv_axi_seq_item#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) req);

     if(req != null) begin
        foreach(req.wdata_array[i]) req.wdata_array[i] = $urandom_range(0, 3254323);
        end

     endfunction
  
 function void error_rd_resp(slv_axi_seq_item#( ADDR_WIDTH, DATA_WIDTH, ID_WIDTH) req);

     if(req != null) begin
        foreach(req.rdata_array[i]) req.rdata_array[i] = $urandom_range(0, 123325435);
        end

     endfunction

endclass
`endif
