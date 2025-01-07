// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Tue Jan  7 17:10:44 2025
// Host        : hkl running 64-bit Ubuntu 22.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /workspace/HKL_FPGA/TOP63_Aurora/Sw_40G_Prj/Rtl/com/SynBlkfifo41x256/SynBlkfifo41x256_stub.v
// Design      : SynBlkfifo41x256
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_3,Vivado 2018.3" *)
module SynBlkfifo41x256(clk, srst, din, wr_en, rd_en, dout, full, empty, 
  prog_full)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[40:0],wr_en,rd_en,dout[40:0],full,empty,prog_full" */;
  input clk;
  input srst;
  input [40:0]din;
  input wr_en;
  input rd_en;
  output [40:0]dout;
  output full;
  output empty;
  output prog_full;
endmodule
