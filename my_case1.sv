`ifndef MY_CASE1__SV
`define MY_CASE1__SV	
class case1_sequence extends uvm_sequence #(my_transaction);
	my_transaction m_trans;                  //这里调用了规定的数据格式
	
  	 function  new(string name= "case1_sequence");
     	 super.new(name);
  	 endfunction 

	//开始和结束仿真
	 virtual task body();
	 	if(starting_phase != null)
	 		starting_phase.raise_objection(this);
		 repeat (10) begin
			 `uvm_do_with(m_trans, { m_trans.pload.size() == 60;})  //uvm_do_with宏，它是uvm_do系列宏中的一个，用于在随机化时提供对某些字段的约束
		 end
		 #100;
	 	if(starting_phase != null)
			 starting_phase.drop_objection(this);
	 endtask
	   `uvm_object_utils(case1_sequence)
endclass
	
	 

class my_case1 extends base_test;   //继承base_test
	
	 function new(string name = "my_case1", uvm_component parent = null);
	 super.new(name,parent);
	 endfunction
	
	 extern virtual function void build_phase(uvm_phase phase);
	 `uvm_component_utils(my_case1)
endclass
	
	
function void my_case1::build_phase(uvm_phase phase);
	 super.build_phase(phase);
	
	 uvm_config_db#(uvm_object_wrapper)::set(this,
	 										"env.i_agt.sqr.main_phase",
	 										"default_sequence",
	 										case1_sequence::type_id::get());  
//********************************************
// this 代表这是树根
// main_phase则是为了让sqr知道在那个phase启动这个sq  可是sqr没有main_phase啊
//********************************************
	
endfunction


`endif