// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Tue Jan  7 17:10:22 2025
// Host        : hkl running 64-bit Ubuntu 22.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /workspace/HKL_FPGA/TOP63_Aurora/Sw_40G_Prj/Rtl/ten_gig_eth_pcs_pma/ten_gig_eth_pcs_pma_stub.v
// Design      : ten_gig_eth_pcs_pma
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ten_gig_eth_pcs_pma_v6_0_14,Vivado 2018.3" *)
module ten_gig_eth_pcs_pma(dclk, rxrecclk_out, coreclk, txusrclk, txusrclk2, 
  txoutclk, areset, areset_coreclk, gttxreset, gtrxreset, sim_speedup_control, txuserrdy, 
  qplllock, qplloutclk, qplloutrefclk, reset_counter_done, xgmii_txd, xgmii_txc, xgmii_rxd, 
  xgmii_rxc, txp, txn, rxp, rxn, configuration_vector, status_vector, core_status, tx_resetdone, 
  rx_resetdone, signal_detect, tx_fault, drp_req, drp_gnt, drp_den_o, drp_dwe_o, drp_daddr_o, 
  drp_di_o, drp_drdy_o, drp_drpdo_o, drp_den_i, drp_dwe_i, drp_daddr_i, drp_di_i, drp_drdy_i, 
  drp_drpdo_i, pma_pmd_type, tx_disable)
/* synthesis syn_black_box black_box_pad_pin="dclk,rxrecclk_out,coreclk,txusrclk,txusrclk2,txoutclk,areset,areset_coreclk,gttxreset,gtrxreset,sim_speedup_control,txuserrdy,qplllock,qplloutclk,qplloutrefclk,reset_counter_done,xgmii_txd[63:0],xgmii_txc[7:0],xgmii_rxd[63:0],xgmii_rxc[7:0],txp,txn,rxp,rxn,configuration_vector[535:0],status_vector[447:0],core_status[7:0],tx_resetdone,rx_resetdone,signal_detect,tx_fault,drp_req,drp_gnt,drp_den_o,drp_dwe_o,drp_daddr_o[15:0],drp_di_o[15:0],drp_drdy_o,drp_drpdo_o[15:0],drp_den_i,drp_dwe_i,drp_daddr_i[15:0],drp_di_i[15:0],drp_drdy_i,drp_drpdo_i[15:0],pma_pmd_type[2:0],tx_disable" */;
  input dclk;
  output rxrecclk_out;
  input coreclk;
  input txusrclk;
  input txusrclk2;
  output txoutclk;
  input areset;
  input areset_coreclk;
  input gttxreset;
  input gtrxreset;
  input sim_speedup_control;
  input txuserrdy;
  input qplllock;
  input qplloutclk;
  input qplloutrefclk;
  input reset_counter_done;
  input [63:0]xgmii_txd;
  input [7:0]xgmii_txc;
  output [63:0]xgmii_rxd;
  output [7:0]xgmii_rxc;
  output txp;
  output txn;
  input rxp;
  input rxn;
  input [535:0]configuration_vector;
  output [447:0]status_vector;
  output [7:0]core_status;
  output tx_resetdone;
  output rx_resetdone;
  input signal_detect;
  input tx_fault;
  output drp_req;
  input drp_gnt;
  output drp_den_o;
  output drp_dwe_o;
  output [15:0]drp_daddr_o;
  output [15:0]drp_di_o;
  output drp_drdy_o;
  output [15:0]drp_drpdo_o;
  input drp_den_i;
  input drp_dwe_i;
  input [15:0]drp_daddr_i;
  input [15:0]drp_di_i;
  input drp_drdy_i;
  input [15:0]drp_drpdo_i;
  input [2:0]pma_pmd_type;
  output tx_disable;
endmodule
