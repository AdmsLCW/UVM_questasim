`ifndef BASE_TEST__SV
`define BASE_TEST__SV



class base_test extends uvm_test;

	my_env env;

	function new(string name = "base_test", uvm_component parent = null);
	super.new(name,parent);
	 endfunction

	 extern virtual function void build_phase(uvm_phase phase);
	 extern virtual function void report_phase(uvm_phase phase);
	 `uvm_component_utils(base_test)
 endclass

	 //设置default_sequence  并且例化env 发芽
	 function void base_test::build_phase(uvm_phase phase);
		 super.build_phase(phase);
		 env = my_env::type_id::create("env", this);
		    // uvm_config_db#(uvm_object_wrapper)::set(this,
			// 									 "env.i_agt.sqr.main_phase",
			// 									 "default_sequence",
			// 									 my_sequence::type_id::get());    移到case1 或者case0中去
	 endfunction
    

	 // 在report_phase中根据UVM_ERROR的数量来打印不同的信息。
	 // 一些日志分析工具可以根据打印的信息来判断DUT是否通过了某个测试用例的检查。
	 // report_phase也是UVM内建的一个phase，它在main_phase结束之后执行。

	 function void base_test::report_phase(uvm_phase phase);
	 uvm_report_server server;
	 int err_num;
	 super.report_phase(phase);

	 server = get_report_server();
	 err_num = server.get_severity_count(UVM_ERROR);

	 if (err_num != 0) begin
		 $display("TEST CASE FAILED");
	 end
	 else begin
		 $display("TEST CASE PASSED");
	 end
	 endfunction


`endif