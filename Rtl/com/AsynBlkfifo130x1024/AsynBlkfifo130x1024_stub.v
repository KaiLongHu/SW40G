// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Wed Feb  7 18:20:19 2024
// Host        : Admin-PC running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               D:/HKL_FPGA/TOP16_multichnnel/MultiChnnel_KzBoard/RTL/com/FifoIP/AsynBlkfifo130x1024/AsynBlkfifo130x1024_stub.v
// Design      : AsynBlkfifo130x1024
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z045ffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_2,Vivado 2018.2" *)
module AsynBlkfifo130x1024(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  empty, prog_full)
/* synthesis syn_black_box black_box_pad_pin="rst,wr_clk,rd_clk,din[129:0],wr_en,rd_en,dout[129:0],full,empty,prog_full" */;
  input rst;
  input wr_clk;
  input rd_clk;
  input [129:0]din;
  input wr_en;
  input rd_en;
  output [129:0]dout;
  output full;
  output empty;
  output prog_full;
endmodule
