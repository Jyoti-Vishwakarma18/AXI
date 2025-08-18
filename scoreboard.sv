/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : scoreboard.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 17
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/
//Guard Statement
`ifndef SCOREBOARD_AXI_UVM
`define SCOREBOARD_AXI_UVM

 `uvm_analysis_imp_decl(_master)
 `uvm_analysis_imp_decl(_slave)

class axi_scoreboard#(ADDR_WIDTH = 32, DATA_WIDTH = 32, ID_WIDTH = 16) extends uvm_scoreboard;

  //________________________Factory Registration__________________________________
  `uvm_component_param_utils(axi_scoreboard)
  
 
  //________________________Declaration__________________________________________ 
  //analysis port connection of scoreboard to two monitor
   uvm_analysis_imp_master #(mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH,ID_WIDTH), axi_scoreboard) mas_an_imp;
   uvm_analysis_imp_slave  #(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH,ID_WIDTH), axi_scoreboard) slv_an_imp;

 

  //________________________new function________________________________  
  function new(string name = "axi_scoreboard", uvm_component parent = null);
  super.new(name, parent);
  mas_an_imp = new("mas_an_imp",this);
  slv_an_imp = new("slv_an_imp", this);
  endfunction

 //___________________________build_phase_____________________________________
 function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 endfunction
 
 function void write_master(mas_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH,ID_WIDTH) mtrans_h);
  endfunction

 function void write_slave(slv_axi_seq_item#(ADDR_WIDTH, DATA_WIDTH,ID_WIDTH) strans_h);
  endfunction
 
 endclass
 `endif
