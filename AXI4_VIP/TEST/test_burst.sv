/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : test_burst.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 16
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/
//Gaurd Statement
`ifndef AXI_TEST_BURST_UVM
`define AXI_TEST_BURST_UVM

 
 class test_burst extends axi_base_test;


  //________________________Factory Registration__________________________________
 
  `uvm_component_utils(test_burst)
  
  //________________________Declaration__________________________________________ 
  
  burst_vseqs#(32, 32, 16) trans_h;

  //________________________new function________________________________  
  function new(string name = "test_burst", uvm_component parent =null);
  super.new(name , parent);
  endfunction

  //________________________build_phase_________________________________  
  function void build_phase(uvm_phase phase);
  super.build_phase(phase); 
  endfunction 
  
  //__________________________RUN_PHASE________________________________
  task run_phase(uvm_phase phase);
  super.run_phase(phase);
  phase.raise_objection(this);
  
  begin
  trans_h = burst_vseqs#(32, 32, 16)::type_id::create("trans_h",this);
  trans_h.start(env_h.vir_seqr);
  end 
  phase.phase_done.set_drain_time(this, 100ns);
  phase.drop_objection(this);

   
  endtask
  
  endclass
 `endif
