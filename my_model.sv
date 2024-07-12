`ifndef MY_MODEL__SV
`define MY_MODEL__SV
class my_model extends uvm_component;
  
  uvm_blocking_get_port #(my_transaction) port;  //定义i_agt接收端口
  uvm_analysis_port #(my_transaction) ap;        //定义发送到scoreboard的接口
  
   extern function new(string name, uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern virtual task main_phase(uvm_phase phase);
  
   `uvm_component_utils(my_model)
endclass
  
   function my_model::new(string name, uvm_component parent);
     super.new(name, parent);
   endfunction
  
   function void my_model::build_phase(uvm_phase phase);
     super.build_phase(phase);
     port = new("port", this);             //实例化接收端口
     ap = new("ap", this);
   endfunction
  
   task my_model::main_phase(uvm_phase phase);
   my_transaction tr;
   my_transaction new_tr;
   super.main_phase(phase);
   while(1) begin
   port.get(tr);                        //通过port.get任务来得到i_agt的monitor中发出的transaction
   new_tr = new("new_tr");
   // new_tr.my_copy(tr);
    new_tr.copy(tr);
   `uvm_info("my_model", "get one transaction, copy and print it:", UVM_LOW)
   // new_tr.my_print();
    new_tr.print();
   ap.write(new_tr);
   end
   endtask
`endif