/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : test_random.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 16
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/
//Gaurd Statement
`ifndef AXI_TEST_RANDOM_UVM
`define AXI_TEST_RANDOM_UVM

 
 class test_random extends axi_base_test;


  random_vseqs#(32, 32, 16) trans_h;
 
  `uvm_component_utils(test_random)



  function new(string name = "test_random", uvm_component parent =null);

      super.new(name , parent);

      endfunction

  function void build_phase(uvm_phase phase);

      super.build_phase(phase); 
      endfunction 
  
  task run_phase(uvm_phase phase);

      super.run_phase(phase);
      phase.raise_objection(this);
      

      trans_h = random_vseqs#(32, 32, 16)::type_id::create("trans_h");
      trans_h.start(env_h.vir_seqr);

      phase.phase_done.set_drain_time(this, 100ns); 
      phase.drop_objection(this);

       
      endtask
  
  endclass
 `endif
