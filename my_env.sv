`ifndef MY_ENV__SV
`define MY_ENV__SV

 class my_env extends uvm_env;

 //my_driver drv;
 //my_monitor i_mon;
 //my_monitor o_mon;    这些都放入i_agt中
  my_agent i_agt;
  my_agent o_agt;
  my_model mdl;
  my_scoreboard scb;

  uvm_tlm_analysis_fifo #(my_transaction) agt_mdl_fifo;   //定义连接mdl与i_agt中的monitor的fifo  数据类型和my_transaction一样
  uvm_tlm_analysis_fifo #(my_transaction) scb_mdl_fifo;   //定义连接mdl与scb中的exp_port的fifo
  uvm_tlm_analysis_fifo #(my_transaction) scb_agt_fifo;   //定义连接agt与scb中的act_port的fifo

 function new(string name = "my_env", uvm_component parent);
 super.new(name, parent);
 endfunction


 virtual function void build_phase(uvm_phase phase);
 	super.build_phase(phase);
 	// drv = my_driver::type_id::create("drv", this);
 	// i_mon = my_monitor::type_id::create("i_mon", this);
 	// o_mon = my_monitor::type_id::create("o_mon", this);
    //*******************************************************************************************
    // 在my_env的定义中没有直接调用my_driver的new函数，而是使用了一种古怪的方式。
    // 这种方式就是factory机制带来的独特的实例化方式。只有使用factory机制注册过的类才能使用这种方式实例化；
    // 只有使用这种方式实例化的实例，才能使用后文要讲述的factory机制中最为强大的重载功能。
    // 验证平台中的组件在实例化时都应该使用type_name：：type_id：：create的方式。
    // 在drv实例化时，传递了两个参数，一个是名字drv，另外一个是this指针，表示my_env。
    //********************************************************************************************

	 i_agt = my_agent::type_id::create("i_agt", this);
	 o_agt = my_agent::type_id::create("o_agt", this);
	 i_agt.is_active = UVM_ACTIVE;                   //需要产生激励的标志
	 o_agt.is_active = UVM_PASSIVE;                  //不需要产生激励的标志
     mdl = my_model::type_id::create("mdl", this);
     scb = my_scoreboard::type_id::create("scb", this);

     agt_mdl_fifo = new("agt_mdl_fifo", this);               //实例化连接mdl和i_agtFIFO 
     scb_mdl_fifo = new("scb_mdl_fifo", this);               //实例化连接scb和mdl的FIFO
     scb_agt_fifo = new("scb_agt_fifo", this);               //实例化连接scb和agt的FIFO

     //使用default_sequence启动sequence    改为在base_test中启动
     // uvm_config_db#(uvm_object_wrapper)::set(this,
     //                                        "i_agt.sqr.main_phase",
     //                                         "default_sequence",
     //                                         my_sequence::type_id::get());    

     endfunction

    extern virtual function void connect_phase(uvm_phase phase);
    `uvm_component_utils(my_env)
  endclass

//将fifo分别与my_monitor中的analysis_port和my_model中的blocking_get_port相连：
 function void my_env::connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 // 连接i_agt和mdl
 i_agt.ap.connect(agt_mdl_fifo.analysis_export);
 mdl.port.connect(agt_mdl_fifo.blocking_get_export);

// 连接o_agt和scb
 o_agt.ap.connect(scb_agt_fifo.analysis_export);                      
 scb.act_port.connect(scb_agt_fifo.blocking_get_export);

// 连接mdl和scb
 mdl.ap.connect(scb_mdl_fifo.analysis_export);                      
 scb.exp_port.connect(scb_mdl_fifo.blocking_get_export);




 endfunction

  // 启动my_sequence   未启用default_sequence
  // task my_env::main_phase(uvm_phase phase);
  // my_sequence seq;
  // phase.raise_objection(this);
  // seq = my_sequence::type_id::create("seq");
  // seq.start(i_agt.sqr);
  // phase.drop_objection(this);
  // endtask


`endif