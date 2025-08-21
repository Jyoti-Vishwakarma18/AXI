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
   axi_env#(32,32,16) env_h;
   mas_cnfg_axi    magnt_cnfg_h;
   slv_cnfg_axi    sagnt_cnfg_h;
   env_config      env_cnfg_h;
   mas_axi_sequence#(32, 32, 16)   mseqs_h; 
   slv_axi_sequence#(32, 32, 16)   slv_seqs_h;
  //________________________new function________________________________  
  function new(string name = "axi_base_test", uvm_component parent =null);
  super.new(name , parent);
  magnt_cnfg_h = mas_cnfg_axi::type_id::create("magnt_cnfg_h", this);
  sagnt_cnfg_h = slv_cnfg_axi::type_id::create("sagnt_cnfg_h", this);
  env_cnfg_h   = env_config::type_id::create("env_cnfg_h", this);

  slv_seqs_h = slv_axi_sequence#(32, 32, 16)::type_id::create("slv_seqs_h", this);
  endfunction

  //________________________build_phase_________________________________  
  function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env_cnfg_h.total_master = 10;
  env_cnfg_h.total_slave = 5;

  uvm_config_db#(int)::set(this, "*", "total_master",env_cnfg_h.total_master );
  uvm_config_db#(int)::set(this, "*", "total_slave",env_cnfg_h.total_slave);
  
  //mgnt_cnfg_h.is_active_master = UVM_ACTIVE;
  //sgnt_cnfg_h.is_active_slave = UVM_ACTIVE;
  //uvm_config_db#(mas_cnfg_axi)::set(this,"*","mas_agent_config", magnt_cnfg_h);
  //uvm_config_db#(slv_cnfg_axi)::set(this,"*","slv_agent_config", sagnt_cnfg_h);


  env_h = axi_env#(32,32,16)::type_id::create("env_h", this);
  // uvm_top.print_topology();

 
   endfunction 
 
  //__________________________RUN_PHASE________________________________
  task run_phase(uvm_phase phase);

  phase.raise_objection(this);
  fork
  begin
  
  mas_axi_sequence#(32, 32, 16) mseqs_read_h; 
  mas_axi_sequence#(32, 32, 16) mseqs_write_h; 
  
  mseqs_write_h = mas_axi_sequence#(32, 32, 16)::type_id::create("mseqs_write_h", this);
  mseqs_write_h.start(env_h.mas_axi_uvc_h.magnt_h.m_seqr_h);
/*
  mseqs_write_h = mas_axi_sequence#(32, 32, 16)::type_id::create("mseqs_write_h", this);
  void'(mseqs_write_h.randomize() with { mseqs_write_h.trans_h.AWLEN == 5 ;mseqs_write_h.trans_h.enb == mseqs_write_h.trans_h.WRITE; mseqs_write_h.trans_h.AWBURST == 2; mseqs_write_h.trans_h.AWADDR inside {2, 4, 24, 12};});
  mseqs_write_h.start(env_h.mas_axi_uvc_h.magnt_h.m_seqr_h);
  #150;


  void'(mseqs_read_h.randomize() with {mseqs_read_h.trans_h.AWLEN == 5 ; mseqs_read_h.trans_h.ARLEN ==5; mseqs_read_h.trans_h.enb == mseqs_read_h.trans_h.READ; mseqs_read_h.trans_h.ARSIZE == 2; mseqs_read_h.trans_h.ARBURST == 2; mseqs_read_h.trans_h.ARADDR inside {2, 4, 24, 12};});
  mseqs_read_h.start(env_h.mas_axi_uvc_h.magnt_h.m_seqr_h);
  */
  end

  slv_seqs_h.start(env_h.slv_axi_uvc_h.sagnt_h.s_seqr_h);
  // #80;
  // mseqs_h.start(env_h.mas_axi_uvc_h.magnt_h.m_seqr_h);
  join_any
  #1000;
  phase.drop_objection(this);
   
  endtask
 
  
  endclass
 `endif
