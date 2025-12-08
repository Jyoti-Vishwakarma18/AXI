/************************************************************************************************************************************************************************
 
                FILE_NAME   : test_sanity.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 16
                DESCRIPTION : 

*************************************************************************************************************************************************************************/

//Gaurd Statement
`ifndef AXI_TEST_SANITY_UVM
`define AXI_TEST_SANITY_UVM

 
 class test_sanity extends axi_base_test;


  sanity_vseqs#(`ADDR_W, `DATA_W, `ID_W) sanity_vseqs_h;
 
  `uvm_component_utils(test_sanity)
  
  
  function new(string name = "test_sanity", uvm_component parent =null);

      super.new(name , parent);
      endfunction

  function void build_phase(uvm_phase phase);

      super.build_phase(phase); 
      endfunction 
  
  task run_phase(uvm_phase phase);

      super.run_phase(phase);
      phase.raise_objection(this);
      
      sanity_vseqs_h = sanity_vseqs#(`ADDR_W, `DATA_W, `ID_W)::type_id::create("sanity_vseqs_h", this);
      sanity_vseqs_h.randomize() with {no_of_read_pkt == 4; no_of_write_pkt == 5 ;};
      sanity_vseqs_h.start(env_h.vir_seqr);
      phase.phase_done.set_drain_time(this, 100ns); 
      phase.drop_objection(this);

       
      endtask

  function void report_phase(uvm_phase phase);
     if(`IS_PIPELINE) $display(" AXI is currently supporting for %s version ",$sformatf("pipeline")); 
     else $display(" AXI is currently supporting for %s version ",$sformatf("non - pipeline")); 
     $display("Total num of_read  packet driven : 'd%0d", sanity_vseqs_h.no_of_read_pkt);
     $display("Total num of write packet driven : 'd%0d", sanity_vseqs_h.no_of_write_pkt);

     endfunction 
  endclass
 `endif
