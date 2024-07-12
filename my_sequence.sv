// `include "head.sv" 
 // import uvm_pkg::*;
`ifndef MY_SEQUENCE__SV
`define MY_SEQUENCE__SV
  class my_sequence extends uvm_sequence #(my_transaction);
  my_transaction m_trans;                       //这里调用了规定的数据格式
  
  function new(string name= "my_sequence");
  super.new(name);
  endfunction

  
   virtual task body();
    if(starting_phase != null)      //使用default_sequence
     starting_phase.raise_objection(this);     //为什么在这里挂起objection
   repeat (10) begin
   `uvm_do(m_trans)
   end
   #1000;
    if(starting_phase != null)     //使用default_sequence
     starting_phase.drop_objection(this);
   endtask
  
   `uvm_object_utils(my_sequence)

      endclass
     `endif
