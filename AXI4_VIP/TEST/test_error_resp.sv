/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : test_error_resp.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 16
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/
//Gaurd Statement
`ifndef AXI_TEST_ERROR_RESP_UVM
`define AXI_TEST_ERROR_RESP_UVM

 
 class test_error_resp extends axi_base_test;


 
  `uvm_component_utils(test_error_resp)

  error_resp_vseqs#(`ADDR_W, `DATA_W, `ID_W)   er_rsp_seqs;
  err_resp_cb#(`ADDR_W, `DATA_W, `ID_W)        er_rsp_cb;


  function new(string name = "test_error_resp", uvm_component parent =null);

    super.new(name , parent);
    endfunction

  function void build_phase(uvm_phase phase);

    super.build_phase(phase); 
    er_rsp_cb =  err_resp_cb#(`ADDR_W, `DATA_W, `ID_W)::type_id::create("er_rsp_cb");
    endfunction 
  
  task run_phase(uvm_phase phase);

    super.run_phase(phase);
    phase.raise_objection(this);
    

    uvm_callbacks#(slv_axi_sequence#( `ADDR_W, `DATA_W, `ID_W), slv_axi_seq_callback#(`ADDR_W, `DATA_W, `ID_W))::add(slv_seqs_h, er_rsp_cb);
    
    er_rsp_seqs = error_resp_vseqs#(`ADDR_W, `DATA_W, `ID_W)::type_id::create("er_rsp_seqs");
    er_rsp_seqs.start(env_h.vir_seqr);

    phase.phase_done.set_drain_time(this, 100ns); 
    phase.drop_objection(this);

     
    endtask
  
  endclass
 `endif
