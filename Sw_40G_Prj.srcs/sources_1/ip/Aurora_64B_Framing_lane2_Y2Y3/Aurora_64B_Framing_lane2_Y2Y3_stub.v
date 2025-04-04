// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Tue Jan  7 17:10:08 2025
// Host        : hkl running 64-bit Ubuntu 22.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /workspace/HKL_FPGA/TOP63_Aurora/Sw_40G_Prj/Sw_40G_Prj.srcs/sources_1/ip/Aurora_64B_Framing_lane2_Y2Y3/Aurora_64B_Framing_lane2_Y2Y3_stub.v
// Design      : Aurora_64B_Framing_lane2_Y2Y3
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "aurora_64b66b_v11_2_6, Coregen v14.3_ip3, Number of lanes = 2, Line rate is double6.25Gbps, Reference Clock is double156.25MHz, Interface is Framing, Flow Control is None and is operating in DUPLEX configuration" *)
module Aurora_64B_Framing_lane2_Y2Y3(s_axi_tx_tdata, s_axi_tx_tlast, 
  s_axi_tx_tkeep, s_axi_tx_tvalid, s_axi_tx_tready, m_axi_rx_tdata, m_axi_rx_tlast, 
  m_axi_rx_tkeep, m_axi_rx_tvalid, rxp, rxn, txp, txn, refclk1_in, hard_err, soft_err, channel_up, 
  lane_up, mmcm_not_locked, user_clk, sync_clk, reset_pb, gt_rxcdrovrden_in, power_down, 
  loopback, pma_init, gt_pll_lock, drp_clk_in, gt_qpllclk_quad1_in, gt_qpllrefclk_quad1_in, 
  drpaddr_in, drpdi_in, drpdo_out, drprdy_out, drpen_in, drpwe_in, drpaddr_in_lane1, 
  drpdi_in_lane1, drpdo_out_lane1, drprdy_out_lane1, drpen_in_lane1, drpwe_in_lane1, 
  init_clk, link_reset_out, sys_reset_out, tx_out_clk)
/* synthesis syn_black_box black_box_pad_pin="s_axi_tx_tdata[0:127],s_axi_tx_tlast,s_axi_tx_tkeep[0:15],s_axi_tx_tvalid,s_axi_tx_tready,m_axi_rx_tdata[0:127],m_axi_rx_tlast,m_axi_rx_tkeep[0:15],m_axi_rx_tvalid,rxp[0:1],rxn[0:1],txp[0:1],txn[0:1],refclk1_in,hard_err,soft_err,channel_up,lane_up[0:1],mmcm_not_locked,user_clk,sync_clk,reset_pb,gt_rxcdrovrden_in,power_down,loopback[2:0],pma_init,gt_pll_lock,drp_clk_in,gt_qpllclk_quad1_in,gt_qpllrefclk_quad1_in,drpaddr_in[8:0],drpdi_in[15:0],drpdo_out[15:0],drprdy_out,drpen_in,drpwe_in,drpaddr_in_lane1[8:0],drpdi_in_lane1[15:0],drpdo_out_lane1[15:0],drprdy_out_lane1,drpen_in_lane1,drpwe_in_lane1,init_clk,link_reset_out,sys_reset_out,tx_out_clk" */;
  input [0:127]s_axi_tx_tdata;
  input s_axi_tx_tlast;
  input [0:15]s_axi_tx_tkeep;
  input s_axi_tx_tvalid;
  output s_axi_tx_tready;
  output [0:127]m_axi_rx_tdata;
  output m_axi_rx_tlast;
  output [0:15]m_axi_rx_tkeep;
  output m_axi_rx_tvalid;
  input [0:1]rxp;
  input [0:1]rxn;
  output [0:1]txp;
  output [0:1]txn;
  input refclk1_in;
  output hard_err;
  output soft_err;
  output channel_up;
  output [0:1]lane_up;
  input mmcm_not_locked;
  input user_clk;
  input sync_clk;
  input reset_pb;
  input gt_rxcdrovrden_in;
  input power_down;
  input [2:0]loopback;
  input pma_init;
  output gt_pll_lock;
  input drp_clk_in;
  input gt_qpllclk_quad1_in;
  input gt_qpllrefclk_quad1_in;
  input [8:0]drpaddr_in;
  input [15:0]drpdi_in;
  output [15:0]drpdo_out;
  output drprdy_out;
  input drpen_in;
  input drpwe_in;
  input [8:0]drpaddr_in_lane1;
  input [15:0]drpdi_in_lane1;
  output [15:0]drpdo_out_lane1;
  output drprdy_out_lane1;
  input drpen_in_lane1;
  input drpwe_in_lane1;
  input init_clk;
  output link_reset_out;
  output sys_reset_out;
  output tx_out_clk;
endmodule
