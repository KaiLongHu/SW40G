//-----------------------------------------------------------------------------
// Title      : Core Support level wrapper
// Project    : 10GBASE-R
//-----------------------------------------------------------------------------
// File       : ten_gig_eth_pcs_pma_support.v
//-----------------------------------------------------------------------------
// Description: This file is a wrapper for the 10GBASE-R/KR Core Support level
// It contains the block level for the core which a user would instance in
// their own design, along with various modules which can be shared between
// several block levels.
//-----------------------------------------------------------------------------
// (c) Copyright 2009 - 2014 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.

`timescale 1ps / 1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module ten_gig_eth_pcs_pma_support_Port3
  (
    input           refclk_p,
    input           refclk_n,
    input           dclk,    //50M share
    output          coreclk_out,
    input           reset,
    input           sim_speedup_control,//Only for Sim
    output          qplloutclk_out,//unuse
    output          qplloutrefclk_out,//unuse
    output          qplllock_out,//unuse
    output          areset_datapathclk_out,//unuse
    output          txusrclk_out,//unuse
    output          txusrclk2_out,//unuse
    output          gttxreset_out,//unuse
    output          gtrxreset_out,//unuse
    output          txuserrdy_out,//unuse
    output          rxrecclk_out,//unuse
    output          reset_counter_done_out,//unuse
    //--------------------------------------------
    //Xgmii Ifc0
    input  [63 : 0] xgmii_txd0,
    input  [7 : 0]  xgmii_txc0,
    output [63 : 0] xgmii_rxd0,
    output [7 : 0]  xgmii_rxc0,
    //Xgmii Ifc1
    input  [63 : 0] xgmii_txd1,
    input  [7 : 0]  xgmii_txc1,
    output [63 : 0] xgmii_rxd1,
    output [7 : 0]  xgmii_rxc1,
    //Xgmii Ifc2
    input  [63 : 0] xgmii_txd2,
    input  [7 : 0]  xgmii_txc2,
    output [63 : 0] xgmii_rxd2,
    output [7 : 0]  xgmii_rxc2,
    //GTX Ifc
    output   [2:0]       txp,
    output   [2:0]       txn,
    input    [2:0]       rxp,
    input    [2:0]       rxn,
    //--------------------------------------------
    input [535:0]   configuration_vector,
    output [447:0]  status_vector0,
    output [447:0]  status_vector1,
    output [447:0]  status_vector2,
    output [7:0]    core_status0,
    output [7:0]    core_status1,
    output [7:0]    core_status2,
    output [2:0]    resetdone_out,//unuse
    input           signal_detect,//1'b1
    input           tx_fault,//1'b0
    input  [2:0]    pma_pmd_type,//3'b101
    output [2:0]    tx_disable//unuse
  );

  // Signal declarations
  wire coreclk;
  wire [2:0] txoutclk;
  wire rxrecclk_out_int;
  wire qplloutclk;
  wire qplloutrefclk;
  wire qplllock;


  wire          Port0_drp_gnt;
  wire          Port0_drp_req;
  wire          Port0_drp_den_o;
  wire          Port0_drp_dwe_o;
  wire [15 : 0] Port0_drp_daddr_o;
  wire [15 : 0] Port0_drp_di_o;
  wire          Port0_drp_drdy_o;
  wire [15 : 0] Port0_drp_drpdo_o;
  wire          Port0_drp_den_i;
  wire          Port0_drp_dwe_i;
  wire [15 : 0] Port0_drp_daddr_i;
  wire [15 : 0] Port0_drp_di_i;
  wire          Port0_drp_drdy_i;
  wire [15 : 0] Port0_drp_drpdo_i;

  wire          Port1_drp_gnt;
  wire          Port1_drp_req;
  wire          Port1_drp_den_o;
  wire          Port1_drp_dwe_o;
  wire [15 : 0] Port1_drp_daddr_o;
  wire [15 : 0] Port1_drp_di_o;
  wire          Port1_drp_drdy_o;
  wire [15 : 0] Port1_drp_drpdo_o;
  wire          Port1_drp_den_i;
  wire          Port1_drp_dwe_i;
  wire [15 : 0] Port1_drp_daddr_i;
  wire [15 : 0] Port1_drp_di_i;
  wire          Port1_drp_drdy_i;
  wire [15 : 0] Port1_drp_drpdo_i;

  wire          Port2_drp_gnt;
  wire          Port2_drp_req;
  wire          Port2_drp_den_o;
  wire          Port2_drp_dwe_o;
  wire [15 : 0] Port2_drp_daddr_o;
  wire [15 : 0] Port2_drp_di_o;
  wire          Port2_drp_drdy_o;
  wire [15 : 0] Port2_drp_drpdo_o;
  wire          Port2_drp_den_i;
  wire          Port2_drp_dwe_i;
  wire [15 : 0] Port2_drp_daddr_i;
  wire [15 : 0] Port2_drp_di_i;
  wire          Port2_drp_drdy_i;
  wire [15 : 0] Port2_drp_drpdo_i;

  wire [2:0]tx_resetdone_int;
  wire [2:0]rx_resetdone_int;

  wire areset_coreclk;
  wire gttxreset;
  wire gtrxreset;
  wire qpllreset;
  wire txuserrdy;
  wire reset_counter_done;

  wire txusrclk;
  wire txusrclk2;
  wire areset_txusrclk2;
  wire refclk;

  assign coreclk_out = coreclk;
  assign resetdone_out[0] = tx_resetdone_int[0] && rx_resetdone_int[0];
  assign resetdone_out[1] = tx_resetdone_int[1] && rx_resetdone_int[1];
  assign resetdone_out[2] = tx_resetdone_int[2] && rx_resetdone_int[2];

  // If no arbitration is required on the GT DRP ports then connect REQ to GNT
  // and connect other signals i <= o;
  assign Port0_drp_gnt                = Port0_drp_req;
  assign Port0_drp_den_i              = Port0_drp_den_o;
  assign Port0_drp_dwe_i              = Port0_drp_dwe_o;
  assign Port0_drp_daddr_i            = Port0_drp_daddr_o;
  assign Port0_drp_di_i               = Port0_drp_di_o;
  assign Port0_drp_drdy_i             = Port0_drp_drdy_o;
  assign Port0_drp_drpdo_i            = Port0_drp_drpdo_o;

  assign Port1_drp_gnt                = Port1_drp_req;
  assign Port1_drp_den_i              = Port1_drp_den_o;
  assign Port1_drp_dwe_i              = Port1_drp_dwe_o;
  assign Port1_drp_daddr_i            = Port1_drp_daddr_o;
  assign Port1_drp_di_i               = Port1_drp_di_o;
  assign Port1_drp_drdy_i             = Port1_drp_drdy_o;
  assign Port1_drp_drpdo_i            = Port1_drp_drpdo_o;

  assign Port2_drp_gnt                = Port2_drp_req;
  assign Port2_drp_den_i              = Port2_drp_den_o;
  assign Port2_drp_dwe_i              = Port2_drp_dwe_o;
  assign Port2_drp_daddr_i            = Port2_drp_daddr_o;
  assign Port2_drp_di_i               = Port2_drp_di_o;
  assign Port2_drp_drdy_i             = Port2_drp_drdy_o;
  assign Port2_drp_drpdo_i            = Port2_drp_drpdo_o;
  //unsue-------------
  assign qplloutclk_out         = qplloutclk;
  assign qplloutrefclk_out      = qplloutrefclk;
  assign qplllock_out           = qplllock;
  assign txusrclk_out           = txusrclk;
  assign txusrclk2_out          = txusrclk2;
  assign areset_datapathclk_out = areset_coreclk;
  assign gttxreset_out          = gttxreset;
  assign gtrxreset_out          = gtrxreset;
  assign txuserrdy_out          = txuserrdy;
  assign reset_counter_done_out = reset_counter_done;

  // Instantiate the 10GBASER/KR GT Common block
  ten_gig_eth_pcs_pma_gt_common # (
                                  .WRAPPER_SIM_GTRESET_SPEEDUP("TRUE") ) //Does not affect hardware
                                ten_gig_eth_pcs_pma_gt_common_block
                                (
                                  .refclk(refclk),
                                  .qpllreset(qpllreset),
                                  .qplllock(qplllock),
                                  .qplloutclk(qplloutclk),
                                  .qplloutrefclk(qplloutrefclk)
                                );


  // Instantiate the 10GBASER/KR shared clock/reset block
  ten_gig_eth_pcs_pma_shared_clock_and_reset ten_gig_eth_pcs_pma_shared_clock_reset_block
                                             (
                                               .areset(reset),
                                               .refclk_p(refclk_p),
                                               .refclk_n(refclk_n),
                                               .refclk(refclk),
                                               .coreclk(coreclk),
                                               .txoutclk(txoutclk[0]),//In
                                               .qplllock(qplllock),//In
                                               .areset_coreclk(areset_coreclk),
                                               .gttxreset(gttxreset),
                                               .gtrxreset(gtrxreset),
                                               .txuserrdy(txuserrdy),
                                               .txusrclk(txusrclk),
                                               .txusrclk2(txusrclk2),
                                               .qpllreset(qpllreset),
                                               .reset_counter_done(reset_counter_done)
                                             );

  // Instantiate the 10GBASER/KR Block Level

  //10GBASER/KR Block0
  ten_gig_eth_pcs_pma ten_gig_eth_pcs_pma_i0
                      (
                        .coreclk(coreclk),//I
                        .dclk(dclk),//I
                        .txusrclk(txusrclk),//I
                        .txusrclk2(txusrclk2),//I
                        .txoutclk(txoutclk[0]),
                        .areset_coreclk(areset_coreclk),//I
                        .txuserrdy(txuserrdy),//I
                        .rxrecclk_out(rxrecclk_out),//O
                        .areset(reset),
                        .gttxreset(gttxreset),//I
                        .gtrxreset(gtrxreset),//I
                        .sim_speedup_control(sim_speedup_control),//I
                        .qplllock(qplllock),//i
                        .qplloutclk(qplloutclk),//i
                        .qplloutrefclk(qplloutrefclk),//i
                        .reset_counter_done(reset_counter_done), //i
                        .xgmii_txd(xgmii_txd0),                  
                        .xgmii_txc(xgmii_txc0),
                        .xgmii_rxd(xgmii_rxd0),
                        .xgmii_rxc(xgmii_rxc0),
                        .txp(txp[0]),
                        .txn(txn[0]),
                        .rxp(rxp[0]),
                        .rxn(rxn[0]),
                        .configuration_vector(configuration_vector),
                        .status_vector(status_vector0),
                        .core_status(core_status0),
                        .tx_resetdone(tx_resetdone_int[0]),
                        .rx_resetdone(rx_resetdone_int[0]),
                        .signal_detect(signal_detect),//Static Value
                        .tx_fault(tx_fault),//Static Value

                        //Cycle
                        .drp_req(Port0_drp_req),
                        .drp_gnt(Port0_drp_gnt),
                        .drp_den_o(Port0_drp_den_o),
                        .drp_dwe_o(Port0_drp_dwe_o),
                        .drp_daddr_o(Port0_drp_daddr_o),
                        .drp_di_o(Port0_drp_di_o),
                        .drp_drdy_o(Port0_drp_drdy_o),
                        .drp_drpdo_o(Port0_drp_drpdo_o),
                        .drp_den_i(Port0_drp_den_i),
                        .drp_dwe_i(Port0_drp_dwe_i),
                        .drp_daddr_i(Port0_drp_daddr_i),
                        .drp_di_i(Port0_drp_di_i),
                        .drp_drdy_i(Port0_drp_drdy_i),
                        .drp_drpdo_i(Port0_drp_drpdo_i),

                        .pma_pmd_type(pma_pmd_type),//Static Value
                        .tx_disable(tx_disable[0])
                      );
  ////////////////////////////////////////////////////////////////////////////////////////
  //10GBASER/KR Block1
  ten_gig_eth_pcs_pma ten_gig_eth_pcs_pma_i1
                      (
                        .coreclk(coreclk),
                        .dclk(dclk),
                        .txusrclk(txusrclk),
                        .txusrclk2(txusrclk2),
                        .txoutclk(txoutclk[1]),
                        .areset_coreclk(areset_coreclk),
                        .txuserrdy(txuserrdy),
                        .rxrecclk_out(),
                        .areset(reset),
                        .gttxreset(gttxreset),
                        .gtrxreset(gtrxreset),
                        .sim_speedup_control(sim_speedup_control),//
                        .qplllock(qplllock),
                        .qplloutclk(qplloutclk),
                        .qplloutrefclk(qplloutrefclk),
                        .reset_counter_done(reset_counter_done),
                        .xgmii_txd(xgmii_txd1),
                        .xgmii_txc(xgmii_txc1),
                        .xgmii_rxd(xgmii_rxd1),
                        .xgmii_rxc(xgmii_rxc1),
                        .txp(txp[1]),
                        .txn(txn[1]),
                        .rxp(rxp[1]),
                        .rxn(rxn[1]),
                        .configuration_vector(configuration_vector),
                        .status_vector(status_vector1),
                        .core_status(core_status1),
                        .tx_resetdone(tx_resetdone_int[1]),
                        .rx_resetdone(rx_resetdone_int[1]),
                        .signal_detect(signal_detect),
                        .tx_fault(tx_fault),
                        .drp_req(Port1_drp_req),
                        .drp_gnt(Port1_drp_gnt),
                        .drp_den_o(Port1_drp_den_o),
                        .drp_dwe_o(Port1_drp_dwe_o),
                        .drp_daddr_o(Port1_drp_daddr_o),
                        .drp_di_o(Port1_drp_di_o),
                        .drp_drdy_o(Port1_drp_drdy_o),
                        .drp_drpdo_o(Port1_drp_drpdo_o),
                        .drp_den_i(Port1_drp_den_i),
                        .drp_dwe_i(Port1_drp_dwe_i),
                        .drp_daddr_i(Port1_drp_daddr_i),
                        .drp_di_i(Port1_drp_di_i),
                        .drp_drdy_i(Port1_drp_drdy_i),
                        .drp_drpdo_i(Port1_drp_drpdo_i),
                        .pma_pmd_type(pma_pmd_type),
                        .tx_disable(tx_disable[1])
                      );
  ////////////////////////////////////////////////////////////////////////////////////////
  //10GBASER/KR Block1
  ten_gig_eth_pcs_pma ten_gig_eth_pcs_pma_i2
                      (
                        .coreclk(coreclk),
                        .dclk(dclk),
                        .txusrclk(txusrclk),
                        .txusrclk2(txusrclk2),
                        .txoutclk(txoutclk[2]),
                        .areset_coreclk(areset_coreclk),
                        .txuserrdy(txuserrdy),
                        .rxrecclk_out(),
                        .areset(reset),
                        .gttxreset(gttxreset),
                        .gtrxreset(gtrxreset),
                        .sim_speedup_control(sim_speedup_control),
                        .qplllock(qplllock),
                        .qplloutclk(qplloutclk),
                        .qplloutrefclk(qplloutrefclk),
                        .reset_counter_done(reset_counter_done),
                        .xgmii_txd(xgmii_txd2),
                        .xgmii_txc(xgmii_txc2),
                        .xgmii_rxd(xgmii_rxd2),
                        .xgmii_rxc(xgmii_rxc2),
                        .txp(txp[2]),
                        .txn(txn[2]),
                        .rxp(rxp[2]),
                        .rxn(rxn[2]),
                        .configuration_vector(configuration_vector),
                        .status_vector(status_vector2),
                        .core_status(core_status2),
                        .tx_resetdone(tx_resetdone_int[2]),
                        .rx_resetdone(rx_resetdone_int[2]),
                        .signal_detect(signal_detect),
                        .tx_fault(tx_fault),

                        .drp_req(Port2_drp_req),
                        .drp_gnt(Port2_drp_gnt),
                        .drp_den_o(Port2_drp_den_o),
                        .drp_dwe_o(Port2_drp_dwe_o),
                        .drp_daddr_o(Port2_drp_daddr_o),
                        .drp_di_o(Port2_drp_di_o),
                        .drp_drdy_o(Port2_drp_drdy_o),
                        .drp_drpdo_o(Port2_drp_drpdo_o),
                        .drp_den_i(Port2_drp_den_i),
                        .drp_dwe_i(Port2_drp_dwe_i),
                        .drp_daddr_i(Port2_drp_daddr_i),
                        .drp_di_i(Port2_drp_di_i),
                        .drp_drdy_i(Port2_drp_drdy_i),
                        .drp_drpdo_i(Port2_drp_drpdo_i),

                        .pma_pmd_type(pma_pmd_type),
                        .tx_disable(tx_disable[2])
                      );

endmodule
