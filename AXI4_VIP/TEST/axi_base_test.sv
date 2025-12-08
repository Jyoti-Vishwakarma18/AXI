/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : axi_base_test.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 16
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/
//Gaurd Statement
`ifndef AXI_BASE_TEST_UVM
`define AXI_BASE_TEST_UVM

 
 class axi_base_test extends uvm_test;


  //________________________Factory Registration__________________________________
 
  `uvm_component_utils(axi_base_test)
  
  //________________________Declaration__________________________________________ 
   axi_env#(`ADDR_W, `DATA_W, `ID_W) env_h;

   mas_axi_sequence#(`ADDR_W, `DATA_W, `ID_W)   mseqs_h; 
   slv_axi_sequence#(`ADDR_W, `DATA_W, `ID_W)   slv_seqs_h;
  
  //________________________new function________________________________  
  function new(string name = "axi_base_test", uvm_component parent =null);
  super.new(name , parent);


  slv_seqs_h = slv_axi_sequence#(`ADDR_W, `DATA_W, `ID_W)::type_id::create("slv_seqs_h", this);
  endfunction

  //________________________build_phase_________________________________  
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    env_h = axi_env#(`ADDR_W, `DATA_W, `ID_W)::type_id::create("env_h", this);
    endfunction 
   
   function void end_of_elaboration_phase(uvm_phase phase);
   uvm_top.print_topology();
   endfunction

  //__________________________RUN_PHASE________________________________
  task run_phase(uvm_phase phase);
  if(env_h.slv_axi_uvc_h.sagnt_h[0] == null)`uvm_fatal(get_full_name(), "slv_agent is not create")
  fork
  slv_seqs_h.start(env_h.slv_axi_uvc_h.sagnt_h[0].s_seqr_h);
  join_none


  endtask


  endclass
 `endif
