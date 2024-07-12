//*****************************************************************************************
//agent因为 mon和drv功能很接近所以放在一起可以同时例化，sequencer与drv也很接近所以也要放在一起
//
//*****************************************************************************************
`ifndef MY_AGENT__SV
`define MY_AGENT__SV

class my_agent extends uvm_agent ;
    my_sequencer sqr;                   //加入sequencer
    my_driver drv;
    my_monitor mon;
    uvm_analysis_port #(my_transaction) ap;  //定义指向monitor中ap的指针  这是一个类型  

     function new(string name, uvm_component parent);
     super.new(name, parent);
     endfunction

     extern virtual function void build_phase(uvm_phase phase);
     extern virtual function void connect_phase(uvm_phase phase);

     `uvm_component_utils(my_agent)
  endclass


 function void my_agent::build_phase(uvm_phase phase);
     super.build_phase(phase);
     if (is_active == UVM_ACTIVE) begin
     sqr = my_sequencer::type_id::create("sqr", this);  //加入sequencer
     drv = my_driver::type_id::create("drv", this);
     end
     mon = my_monitor::type_id::create("mon", this);
 endfunction

 function void my_agent::connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     ap = mon.ap;    //将monitor中的ap赋予父类的ap ，不需要实例化这个ap
     if (is_active == UVM_ACTIVE) begin
     drv.seq_item_port.connect(sqr.seq_item_export);   //处理driver向sequencer申请transactions
     end
 endfunction
`endif
