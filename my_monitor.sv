`ifndef MY_MONITOR__SV
`define MY_MONITOR__SV
class my_monitor extends uvm_monitor;

    virtual my_if vif;

    uvm_analysis_port #(my_transaction) ap;   //定义ap变量与rml通信  与scoreboard通信


    `uvm_component_utils(my_monitor)
    function new(string name = "my_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))             //连接与top_tb的参数
          `uvm_fatal("my_monitor", "virtual interface must be set for vif!!!")
          ap = new("ap", this);   //实例化ap与rml通信
    endfunction

    extern task main_phase(uvm_phase phase);
    extern task collect_one_pkt(my_transaction tr);
 endclass

 task my_monitor::main_phase(uvm_phase phase);
 my_transaction tr;
 while(1) begin
 tr = new("tr");
 collect_one_pkt(tr);
 ap.write(tr);                //收集完一个transaction后将他写入ap中
 end
 endtask

 // task my_monitor::collect_one_pkt(my_transaction tr);
 // bit[7:0] data_q[$];
 // int psize;

 // //等待数据过来
 // while(1) begin
 // @(posedge vif.clk);
 // if(vif.valid) break;
 // end

 // `uvm_info("my_monitor", "begin to collect one pkt", UVM_LOW);
 // while(vif.valid) begin
 // data_q.push_back(vif.data);    //将数据都压入队列中
 // @(posedge vif.clk);
 // end
 // //分解
 // //pop dmac
 // for(int i = 0; i < 6; i++) begin
 // tr.dmac = {tr.dmac[39:0], data_q.pop_front()};
 // end
 // //pop smac


 // //pop ether_type

 // //pop payload

 // //pop crc
 // for(int i = 0; i < 4; i++) begin
 // tr.crc = {tr.crc[23:0], data_q.pop_front()};    //32bit   data.q一次出一个字节
 // end
 // `uvm_info("my_monitor", "end collect one pkt, print it:", UVM_LOW);
 // tr.print();
 // endtask

  //使用field机制
  task my_monitor::collect_one_pkt(my_transaction tr);
  byte unsigned data_q[$];
  byte unsigned data_array[];
  logic [7:0] data;
  logic valid = 0;
  int data_size;

   //等待数据过来
   while(1) begin
   @(posedge vif.clk);
   if(vif.valid) break;
   end
 
  `uvm_info("my_monitor", "begin to collect one pkt", UVM_LOW);
  while(vif.valid) begin
  data_q.push_back(vif.data);
  @(posedge vif.clk);
  end
  data_size = data_q.size();
  data_array = new[data_size];
  for ( int i = 0; i < data_size; i++ ) begin
  data_array[i] = data_q[i];
  end
  tr.pload = new[data_size - 18]; //da sa, e_type, crc
  data_size = tr.unpack_bytes(data_array) / 8;
  `uvm_info("my_monitor", "end collect one pkt", UVM_LOW);
  endtask



`endif

