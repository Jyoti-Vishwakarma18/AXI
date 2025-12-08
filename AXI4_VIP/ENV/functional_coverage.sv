/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : functional_coverage.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : Sep 4
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/
//Guard Statement
`ifndef FUNCTIONAL_CVG_AXI_UVM
`define FUNCTIONAL_CVG_AXI_UVM

class func_cvg#(ADDR_WIDTH = 32, DATA_WIDTH = 32, ID_WIDTH = 16) extends uvm_component;


  slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  trans_h;

 `uvm_component_param_utils(func_cvg);


  covergroup cvg_master ;

   awburst_cvg  :  coverpoint trans_h.AWBURST {
	           bins cb_awburst[] = {[0:2]};
		   }
   arburst_cvg  :  coverpoint trans_h.ARBURST {
	           bins cb_arburst[] = {0,1,2};
		   }
   awsize_cvg   :  coverpoint trans_h.AWSIZE  {
	           bins cb_awsize[]  = {[0:1]};
		   }
   arsize_cvg   :  coverpoint trans_h.ARSIZE  {
	           bins cb_arsize[]  = {[0:1]};
		   }
		   
   awlen_cvg    :  coverpoint trans_h.AWLEN   {
	           bins cb_awlen_low   = {[0:99]};
	           bins cb_awlen_mid   = {[100:199]};
		   bins cb_awlen_hgh   = {[200:255]};
                   }
   arlen_cvg    :  coverpoint trans_h.ARLEN   {
	           bins cb_arlen_low   = {[0:99]};
	           bins cb_arlen_mid   = {[100:199]};
		   bins cb_arlen_hgh   = {[200:255]};
                   }
 
   wr_addr_cvg  :  coverpoint trans_h.AWADDR {
	           bins cb_wraddr_low  = {[16'h0000:16'h3FFF]};
                   bins cb_wraddr_mid  = {[16'h4000:16'h7FFF]};
                   bins cb_wraddr_mid2 = {[16'h8000:16'hBFFF]};
                   bins cb_wraddr_high = {[16'hC000:16'hFFFF]};
                   bins cb_wraddr_start_end = {16'h0000, 16'hFFFF}; 
		   }
   rd_addr_cvg  :  coverpoint trans_h.ARADDR {
 	           bins cb_rdaddr_low  = {[16'h0000:16'h3FFF]};
	           bins cb_rdaddr_mid  = {[16'h4000:16'h7FFF]};
	           bins cb_rdaddr_mid2 = {[16'h8000:16'hBFFF]};
	           bins cb_rdaddr_high = {[16'hC000:16'hFFFF]};
		   bins cb_rdaddr_start_end = {16'h0000, 16'hFFFF}; 
		   }

   wr_cross_cvg : cross awburst_cvg, awsize_cvg, awlen_cvg;
   rd_cross_cvg : cross arburst_cvg, arsize_cvg, arlen_cvg;

   endgroup
 
  function new(string name = "func_cvg", uvm_component parent = null);

     super.new(name, parent);
     trans_h = slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("trans_h", this); 
     cvg_master = new();
     endfunction


  function sample_cvg( slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  trans_h);

     cvg_master.sample();
     endfunction

endclass
`endif   
