// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Tue Jan  7 17:10:20 2025
// Host        : hkl running 64-bit Ubuntu 22.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /workspace/HKL_FPGA/TOP63_Aurora/Sw_40G_Prj/Rtl/TenGEthMacPort2/IpCore/ten_gig_eth_mac_0/ten_gig_eth_mac_0_stub.v
// Design      : ten_gig_eth_mac_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ten_gig_eth_mac_v15_1_6,Vivado 2018.3" *)
module ten_gig_eth_mac_0(tx_clk0, reset, tx_axis_aresetn, tx_axis_tdata, 
  tx_axis_tkeep, tx_axis_tvalid, tx_axis_tlast, tx_axis_tuser, tx_ifg_delay, tx_axis_tready, 
  tx_statistics_vector, tx_statistics_valid, pause_val, pause_req, rx_axis_aresetn, 
  rx_axis_tdata, rx_axis_tkeep, rx_axis_tvalid, rx_axis_tuser, rx_axis_tlast, 
  rx_statistics_vector, rx_statistics_valid, tx_configuration_vector, 
  rx_configuration_vector, status_vector, tx_dcm_locked, xgmii_txd, xgmii_txc, rx_clk0, 
  rx_dcm_locked, xgmii_rxd, xgmii_rxc)
/* synthesis syn_black_box black_box_pad_pin="tx_clk0,reset,tx_axis_aresetn,tx_axis_tdata[63:0],tx_axis_tkeep[7:0],tx_axis_tvalid,tx_axis_tlast,tx_axis_tuser,tx_ifg_delay[7:0],tx_axis_tready,tx_statistics_vector[25:0],tx_statistics_valid,pause_val[15:0],pause_req,rx_axis_aresetn,rx_axis_tdata[63:0],rx_axis_tkeep[7:0],rx_axis_tvalid,rx_axis_tuser,rx_axis_tlast,rx_statistics_vector[29:0],rx_statistics_valid,tx_configuration_vector[79:0],rx_configuration_vector[79:0],status_vector[2:0],tx_dcm_locked,xgmii_txd[63:0],xgmii_txc[7:0],rx_clk0,rx_dcm_locked,xgmii_rxd[63:0],xgmii_rxc[7:0]" */;
  input tx_clk0;
  input reset;
  input tx_axis_aresetn;
  input [63:0]tx_axis_tdata;
  input [7:0]tx_axis_tkeep;
  input tx_axis_tvalid;
  input tx_axis_tlast;
  input tx_axis_tuser;
  input [7:0]tx_ifg_delay;
  output tx_axis_tready;
  output [25:0]tx_statistics_vector;
  output tx_statistics_valid;
  input [15:0]pause_val;
  input pause_req;
  input rx_axis_aresetn;
  output [63:0]rx_axis_tdata;
  output [7:0]rx_axis_tkeep;
  output rx_axis_tvalid;
  output rx_axis_tuser;
  output rx_axis_tlast;
  output [29:0]rx_statistics_vector;
  output rx_statistics_valid;
  input [79:0]tx_configuration_vector;
  input [79:0]rx_configuration_vector;
  output [2:0]status_vector;
  input tx_dcm_locked;
  output [63:0]xgmii_txd;
  output [7:0]xgmii_txc;
  input rx_clk0;
  input rx_dcm_locked;
  input [63:0]xgmii_rxd;
  input [7:0]xgmii_rxc;
endmodule
