// `include "head.sv"
 // import uvm_pkg::*;
`ifndef MY_DRIVER__SV
`define MY_DRIVER__SV

  class my_driver extends uvm_driver#(my_transaction);
    `uvm_component_utils(my_driver)             //factory机制将my_driver登记在UVM内部的一张表中 所有派生自uvm_component及其派生类的类都应该使用uvm_component_utils宏注册。
     virtual my_if vif;  //调用interface class和module声明方法不一样  class中声明需要加入virtual


    function new(string name = "my_driver", uvm_component parent = null);
  	  super.new(name, parent);
	  `uvm_info("my_driver", "new is called", UVM_LOW);
    endfunction



    virtual function void build_phase(uvm_phase phase);    //build_phase是在class中的  建立和tb的通信
  		super.build_phase(phase);
  		`uvm_info("my_driver", "build_phase is called", UVM_LOW);

  		if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
  		`uvm_fatal("my_driver", "virtual interface must be set for vif!!!")
  	endfunction

        extern virtual task main_phase(uvm_phase phase);
        extern task drive_one_pkt(my_transaction tr);
  endclass




			 task my_driver::main_phase(uvm_phase phase);
			// phase.raise_objection(this);
			// my_transaction tr;
			// `uvm_info("my_driver", "main_phase is called", UVM_LOW);
			 vif.data <= 8'b0;
			 vif.valid <= 1'b0;
			 while(!vif.rst_n)
			 @(posedge vif.clk);
			 // for(int i = 0; i < 256; i++)begin
			 // @(posedge vif.clk);
			 // // vif.data <= $urandom_range(0, 255); //未加入transactions
			 // // vif.valid <= 1'b1;
			 // // `uvm_info("my_driver", "data is drived", UVM_LOW);
			 // tr = new("tr");
			 // assert(tr.randomize() with {pload.size == 200;});   //产生激励
			 //drive_one_pkt(tr);      //***
			 //end
			 while(1) begin              //加入sequencer 将产生激励的部分去掉
			 seq_item_port.try_next_item(req);    //非阻塞try_next_item
			 //seq_item_port.get_next_item(req);   阻塞get_next_item
			 drive_one_pkt(req);
			 seq_item_port.item_done();
			 end
			 // @(posedge vif.clk);
			 // vif.valid <= 1'b0;
			 // phase.drop_objection(this);    //停止仿真转到env的sequence发送结束之后
			 endtask

task my_driver::drive_one_pkt(my_transaction tr);
//************未使用field机制需要手动的将所有字段填入data_q中
	// bit [47:0] tmp_data;
	// bit [7:0] data_q[$];
    //       //push dmac to data_q
	//  tmp_data = tr.dmac;    //六个字节
	//  for(int i = 0; i < 6; i++) begin
	//  data_q.push_back(tmp_data[7:0]);
	//  tmp_data = (tmp_data >> 8);
	//  end
	//  //push smac to data_q

	//  //push ether_type to data_q

	//  //push payload to data_q

	//  //push crc to data_q
	//  tmp_data = tr.crc;    //四个字节
	//  for(int i = 0; i < 4; i++) begin
	//  data_q.push_back(tmp_data[7:0]);  //可以直接存一个字节进去
	//  tmp_data = (tmp_data >> 8);
	//  end
//**************************使用field机制中的pack_bytes函数  发送数据
   byte unsigned     data_q[];  //动态数组
   int  data_size;

   data_size = tr.pack_bytes(data_q) / 8;   //使用Field机制
   `uvm_info("my_driver", "begin to drive one pkt", UVM_LOW);
   repeat(3) @(posedge vif.clk);           //等待三个时钟周期
   for ( int i = 0; i < data_size; i++ ) begin
      @(posedge vif.clk);
      vif.valid <= 1'b1;
      vif.data <= data_q[i];
   end

   @(posedge vif.clk);
   vif.valid <= 1'b0;
   `uvm_info("my_driver", "end drive one pkt", UVM_LOW);
endtask



`endif








         //未使用interface
		 // task my_driver::main_phase(uvm_phase phase);
		 // phase.raise_objection(this);
		 // `uvm_info("my_driver", "main_phase is called", UVM_LOW);
		 // top_tb.rxd <= 8'b0;
		 // top_tb.rx_dv <= 1'b0;
		 // while(!top_tb.rst_n)
		 // @(posedge top_tb.clk);
		 // for(int i = 0; i < 256; i++)begin
		 // @(posedge top_tb.clk);
		 // top_tb.rxd <= $urandom_range(0, 255);
		 // top_tb.rx_dv <= 1'b1;
		 // `uvm_info("my_driver", "data is drived", UVM_LOW);

		 // end
		 // @(posedge top_tb.clk);
		 // top_tb.rx_dv <= 1'b0;
		 // phase.drop_objection(this);
		 // endtask
