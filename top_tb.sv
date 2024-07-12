`timescale 1ns/1ps
`include "uvm_macros.svh"

import uvm_pkg::*;
`include "my_if.sv"
`include "my_transaction.sv"
`include "my_sequencer.sv"
`include "my_driver.sv"
`include "my_monitor.sv"
`include "my_agent.sv"
`include "my_model.sv"
`include "my_scoreboard.sv"
`include "my_env.sv"
`include "base_test.sv"
`include "my_case0.sv"
`include "my_case1.sv"


   
  module top_tb;


 
 
 
   reg clk;
   reg rst_n;
  // reg[7:0] rxd;
  // reg rx_dv;
  // wire[7:0] txd;
  // wire tx_en;

//  使用接口信息去除绝对路径
//  例化两个作为不同方向

	my_if input_if(clk, rst_n);
	my_if output_if(clk, rst_n);

 
  // dut my_dut(.clk(clk),
  // .rst_n(rst_n),
  // .rxd(rxd),
  // .rx_dv(rx_dv),
  // .txd(txd),
  // .tx_en(tx_en));
	 dut my_dut(.clk(clk),
	 	.rst_n(rst_n),
	 	.rxd(input_if.data),
	 	.rx_dv(input_if.valid),
	 	.txd(output_if.data),
	 	.tx_en(output_if.valid));
 
  initial begin
	// run_test("my_env");
     // run_test("base_test");
      run_test("my_case1");
     // run_test();  //树根的类型从base_test变成了my_casen。  使用命令启动测试激励 +UVM_TEST_NAME=my_case0
  end
 

 initial begin
      // uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.i_agt.drv", "vif", input_if);  树根是env
      // uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.i_agt.mon", "vif", input_if);
      // uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.o_agt.mon", "vif", output_if);
      //树根变成base_test   
      uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.drv", "vif",input_if);
      uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.mon","vif", input_if);
      uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.o_agt.mon","vif", output_if);   
 end

  initial begin
  clk = 0;
  forever begin
  #100 clk = ~clk;
  end
  end
 
  initial begin
  rst_n = 1'b0;

  #1000;
  rst_n = 1'b1;
  end
 
  endmodule