/****************************************************************************************************************************************************************************************
 
                FILE_NAME   : axi_env.sv
		AUTHOR_NAME : JYOTI VISHWAKARMA
		DATE        : JULY 14
                DESCRIPTION : 

****************************************************************************************************************************************************************************************/


//Gaurd Statement
`ifndef MAXI_UVC_UVM
`define MAXI_UVC_UVM

class axi_env#(int ADDR_WIDTH = 32 , DATA_WIDTH= 32, ID_WIDTH =16)  extends uvm_env;

  `uvm_component_param_utils(axi_env)
 
  env_config                                                 env_cnfg_h;

  mas_axi_uvc#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)             mas_axi_uvc_h;
  slv_axi_uvc#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)             slv_axi_uvc_h;

  axi_scoreboard#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)          axi_scrbd_h;
  axi_reference#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)           axi_ref_h;

  axi_vir_base_sequencer#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)  vir_seqr; 




 function new(string name = "axi_env", uvm_component parent = null);
    super.new(name, parent);

    env_cnfg_h    = env_config::type_id::create("env_cnfg_h", this);

    mas_axi_uvc_h = mas_axi_uvc#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("mas_axi_uvc_h",this);
    slv_axi_uvc_h = slv_axi_uvc#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("slv_axi_uvc_h",this);

    axi_scrbd_h   = axi_scoreboard#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("axi_scrbd_h", this);
    axi_ref_h     = axi_reference#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("axi_ref_h", this);

    vir_seqr      = axi_vir_base_sequencer#(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)::type_id::create("vir_seqr", this); 

    uvm_config_db#(int)::set(null,"*", "Total_num_of_master_agent", `NO_OF_MASTER );     //No of Master
    uvm_config_db#(int)::set(null,"*", "Total_num_of_slave_agent", `NO_OF_SLAVE );       //No of slave
 
    uvm_config_db#(bit)::set(null,"*", "Is_pipeline", `IS_PIPELINE);                      //Pipeline or nonpiple mode

    endfunction

 function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    endfunction

 function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    foreach(mas_axi_uvc_h.magnt_h[i])   vir_seqr.mas_seqr_h[i] =  mas_axi_uvc_h.magnt_h[i].m_seqr_h;
    foreach(slv_axi_uvc_h.sagnt_h[i])   vir_seqr.slv_seqr_h[i] =  slv_axi_uvc_h.sagnt_h[i].s_seqr_h;

    foreach(mas_axi_uvc_h.mas_axi_uvc_export[i]) mas_axi_uvc_h.mas_axi_uvc_export[i].connect(axi_scrbd_h.mas_an_imp[i]);
    foreach(slv_axi_uvc_h.slv_axi_uvc_export[i]) slv_axi_uvc_h.slv_axi_uvc_export[i].connect(axi_ref_h.slv_an_imp[i]);

    axi_ref_h.exp_put_port.connect(axi_scrbd_h.exp_tlm_imp);
  endfunction

 endclass
 `endif
