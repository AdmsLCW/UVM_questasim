#set命令设置UVM连接库的目录，与第一个set命令类似，根据自己实际情况实际修改 PC:D:/questasim64_10.6c/uvm-1.2/win64     LAB: D:/questasim64_10.6c/uvm-1.2/win64  
set  UVM_DPI_HOME   D:/questasim64_10.6c/uvm-1.2/win64  


#第一个set命令设置UVM源码的目录，questasim10.6c自带许多版本的UVM库，可根据自己的questasim安装位置和需要的UVM版本修改命令，如果自己下载安装的UVM库，修改目录即可
set  UVM_HOME       D:/questasim64_10.6c/verilog_src/uvm-1.1d

# PC是G:/uvm/uvm_code     LAB是I:/My_program/uvm/uvm_code
set  WORK_HOME      I:/My_program/uvm/uvm_code

transcript on
if [file exists uvm_work] {  
  vdel -lib uvm_work -all  
} 


#set命令设置工作目录
vlib uvm_work  


vmap work uvm_work


vlog  +incdir+$UVM_HOME/src -L mtiAvm -L mtiOvm -L mtiUvm -L mtiUPF   $UVM_HOME/src/uvm_pkg.sv  $WORK_HOME/dut.sv  $WORK_HOME/top_tb.sv

vsim  -novopt  -c -sv_lib $UVM_DPI_HOME/uvm_dpi work.top_tb


radix unsigned

add log -r /*

run 6000ns

