//-----------------------------------------------------------------------------
// Title      : Example Design level wrapper
// Project    : 10GBASE-R
//-----------------------------------------------------------------------------
// File       : ten_gig_eth_pcs_pma_example_design.v
//-----------------------------------------------------------------------------
// Description: This file is a wrapper for the 10GBASE-R core; it contains the
// core support level and a few registers, including a DDR output register
//-----------------------------------------------------------------------------
// (c) Copyright 2009 - 2014 Xilinx, Inc. All rights reserved.
///////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps

module ten_gig_eth_pcs_pma_example_design_Port3
  (
    input           refclk_p,
    input           refclk_n,
    input           dclk,//50M
    output          coreclk_out,
    input           reset,
    //--------------------------------------------
    output wire xgmii_rx_clk,
    //Xgmii Ifc0
    input  [63:0] xgmii_txd0,
    input  [7:0]  xgmii_txc0,
    output reg [63:0] xgmii_rxd0,
    output reg [7:0]  xgmii_rxc0,
    //Xgmii Ifc1
    input  [63:0] xgmii_txd1,
    input  [7:0]  xgmii_txc1,
    output reg [63:0] xgmii_rxd1,
    output reg [7:0]  xgmii_rxc1,
    //Xgmii Ifc2
    input  [63:0] xgmii_txd2,                                                                                                                            
    input  [7:0]  xgmii_txc2,
    output reg [63:0] xgmii_rxd2,
    output reg [7:0]  xgmii_rxc2,
    //GTX Ifc
    output   [2:0]       txp,
    output   [2:0]       txn,
    input    [2:0]       rxp,
    input    [2:0]       rxn,
    //--------------------------------------------
    //configuration_vector set both port0-2
    input pma_loopback,
    input pma_reset,
    input global_tx_disable,
    input pcs_loopback,
    input pcs_reset,
    input [57:0] test_patt_a_b,
    input data_patt_sel,
    input test_patt_sel,
    input rx_test_patt_en,
    input tx_test_patt_en,
    input prbs31_tx_en,
    input prbs31_rx_en,
    input set_pma_link_status,
    input set_pcs_link_status,
    input clear_pcs_status2,
    input clear_test_patt_err_count,
    //Status Port0/1/2--------------------------------------------
    //Port0
    output        Port0_pma_link_status,
    output        Port0_rx_sig_det,
    output        Port0_pcs_rx_link_status,
    output        Port0_pcs_rx_locked,
    output        Port0_pcs_hiber,
    output        Port0_teng_pcs_rx_link_status,
    output [7:0]  Port0_pcs_err_block_count,
    output [5:0]  Port0_pcs_ber_count,
    output        Port0_pcs_rx_hiber_lh,
    output        Port0_pcs_rx_locked_ll,
    output [15:0] Port0_pcs_test_patt_err_count,
    //add
    output        Port0_pma_pmd_fault,   
    output        Port0_pma_pmd_rx_fault,
    output        Port0_pma_pmd_tx_fault,
    output        Port0_pcs_fault,       
    output        Port0_pcs_rx_fault,    
    output        Port0_pcs_tx_fault,    
    //-------
    //Port1
    output        Port1_pma_link_status,
    output        Port1_rx_sig_det,
    output        Port1_pcs_rx_link_status,
    output        Port1_pcs_rx_locked,
    output        Port1_pcs_hiber,
    output        Port1_teng_pcs_rx_link_status,
    output [7:0]  Port1_pcs_err_block_count,
    output [5:0]  Port1_pcs_ber_count,
    output        Port1_pcs_rx_hiber_lh,
    output        Port1_pcs_rx_locked_ll,
    output [15:0] Port1_pcs_test_patt_err_count,
    //add
    output        Port1_pma_pmd_fault,   
    output        Port1_pma_pmd_rx_fault,
    output        Port1_pma_pmd_tx_fault,
    output        Port1_pcs_fault,       
    output        Port1_pcs_rx_fault,    
    output        Port1_pcs_tx_fault,  
    //---
    //Port2
    output        Port2_pma_link_status,
    output        Port2_rx_sig_det,
    output        Port2_pcs_rx_link_status,
    output        Port2_pcs_rx_locked,
    output        Port2_pcs_hiber,
    output        Port2_teng_pcs_rx_link_status,
    output [7:0]  Port2_pcs_err_block_count,
    output [5:0]  Port2_pcs_ber_count,
    output        Port2_pcs_rx_hiber_lh,
    output        Port2_pcs_rx_locked_ll,
    output [15:0] Port2_pcs_test_patt_err_count,
    //add
    output        Port2_pma_pmd_fault,   
    output        Port2_pma_pmd_rx_fault,
    output        Port2_pma_pmd_tx_fault,
    output        Port2_pcs_fault,       
    output        Port2_pcs_rx_fault,    
    output        Port2_pcs_tx_fault,  
    //--------------------------------------------
    output [7:0]  core_status0,
    output [7:0]  core_status1,
    output [7:0]  core_status2,
    output [2:0]  resetdone,//port0-2
    output [2:0]  tx_disable//port0-2
  );

  // Signal declarations
  wire coreclk;
  wire qplloutclk_out;
  wire qplloutrefclk_out;
  wire qplllock_out;
  wire txusrclk_out;
  wire txusrclk2_out;
  wire gttxreset_out;
  wire gtrxreset_out;
  wire txuserrdy_out;
  wire areset_datapathclk_out;
  wire reset_counter_done_out;

  reg [63:0] xgmii_txd_reg0;
  reg [63:0] xgmii_txd_reg1;
  reg [63:0] xgmii_txd_reg2;
  reg [7:0]  xgmii_txc_reg0;
  reg [7:0]  xgmii_txc_reg1;
  reg [7:0]  xgmii_txc_reg2;
  wire [63:0] xgmii_rxd0_int0;
  wire [63:0] xgmii_rxd1_int1;
  wire [63:0] xgmii_rxd2_int2;
  wire [7:0]  xgmii_rxc0_int0;
  wire [7:0]  xgmii_rxc1_int1;
  wire [7:0]  xgmii_rxc2_int2;
  wire dclk_buf;
  wire [535:0] configuration_vector;
  wire [447:0] status_vector0;
  wire [447:0] status_vector1;
  wire [447:0] status_vector2;

  reg [63:0] xgmii_txd0_pipe1;
  reg [7:0]  xgmii_txc0_pipe1;
  reg [63:0] xgmii_txd1_pipe1;
  reg [7:0]  xgmii_txc1_pipe1;
  reg [63:0] xgmii_txd2_pipe1;
  reg [7:0]  xgmii_txc2_pipe1;

  reg [63:0] xgmii_txd0_pipe2;
  reg [7:0]  xgmii_txc0_pipe2;
  reg [63:0] xgmii_txd1_pipe2;
  reg [7:0]  xgmii_txc1_pipe2;
  reg [63:0] xgmii_txd2_pipe2;
  reg [7:0]  xgmii_txc2_pipe2;

  reg [63:0] xgmii_txd0_pipe3;
  reg [7:0]  xgmii_txc0_pipe3;
  reg [63:0] xgmii_txd1_pipe3;
  reg [7:0]  xgmii_txc1_pipe3;
  reg [63:0] xgmii_txd2_pipe3;
  reg [7:0]  xgmii_txc2_pipe3;


  reg [63:0] xgmii_rxd0_pipe1;
  reg [7:0]  xgmii_rxc0_pipe1;
  reg [63:0] xgmii_rxd1_pipe1;
  reg [7:0]  xgmii_rxc1_pipe1;
  reg [63:0] xgmii_rxd2_pipe1;
  reg [7:0]  xgmii_rxc2_pipe1;

  reg [63:0] xgmii_rxd0_pipe2;
  reg [7:0]  xgmii_rxc0_pipe2;
  reg [63:0] xgmii_rxd1_pipe2;
  reg [7:0]  xgmii_rxc1_pipe2;
  reg [63:0] xgmii_rxd2_pipe2;
  reg [7:0]  xgmii_rxc2_pipe2;

  reg [63:0] xgmii_rxd0_pipe3;
  reg [7:0]  xgmii_rxc0_pipe3;
  reg [63:0] xgmii_rxd1_pipe3;
  reg [7:0]  xgmii_rxc1_pipe3;
  reg [63:0] xgmii_rxd2_pipe3;
  reg [7:0]  xgmii_rxc2_pipe3;



  assign configuration_vector[0]   = pma_loopback;
  assign configuration_vector[14:1] = 0;
  assign configuration_vector[15]  = pma_reset;
  assign configuration_vector[16]  = global_tx_disable;
  assign configuration_vector[79:17] = 0;
  assign configuration_vector[83:80] = 0;
  assign configuration_vector[109:84] = 0;
  assign configuration_vector[110] = pcs_loopback;
  assign configuration_vector[111] = pcs_reset;
  assign configuration_vector[169:112] = test_patt_a_b;
  assign configuration_vector[175:170] = 0;
  assign configuration_vector[233:176] = test_patt_a_b;
  assign configuration_vector[239:234] = 0;
  assign configuration_vector[240] = data_patt_sel;
  assign configuration_vector[241] = test_patt_sel;
  assign configuration_vector[242] = rx_test_patt_en;
  assign configuration_vector[243] = tx_test_patt_en;
  assign configuration_vector[244] = prbs31_tx_en;
  assign configuration_vector[245] = prbs31_rx_en;
  assign configuration_vector[269:246] = 0;
  assign configuration_vector[271:270] = 0;
  assign configuration_vector[383:272] = 0;
  assign configuration_vector[399:384] = 16'h4C4B;
  assign configuration_vector[511:400] = 0;
  assign configuration_vector[512] = set_pma_link_status;
  assign configuration_vector[515:513] = 0;
  assign configuration_vector[516] = set_pcs_link_status;
  assign configuration_vector[517] = 0;
  assign configuration_vector[518] = clear_pcs_status2;
  assign configuration_vector[519] = clear_test_patt_err_count;
  assign configuration_vector[535:520] = 0;

  //Port0 Status--------------------------------------------
  assign Port0_pma_link_status          = status_vector0[18];
  assign Port0_rx_sig_det               = status_vector0[48];
  assign Port0_pcs_rx_link_status       = status_vector0[226];
  assign Port0_pcs_rx_locked            = status_vector0[256];
  assign Port0_pcs_hiber                = status_vector0[257];
  assign Port0_teng_pcs_rx_link_status  = status_vector0[268];
  assign Port0_pcs_err_block_count      = status_vector0[279:272];
  assign Port0_pcs_ber_count            = status_vector0[285:280];
  assign Port0_pcs_rx_hiber_lh          = status_vector0[286];
  assign Port0_pcs_rx_locked_ll         = status_vector0[287];
  assign Port0_pcs_test_patt_err_count  = status_vector0[303:288];
  //Port0 User add Status--------------------------------------------
  assign Port0_pma_pmd_fault            = status_vector0[23];
  assign Port0_pma_pmd_rx_fault         = status_vector0[42];
  assign Port0_pma_pmd_tx_fault         = status_vector0[43];
  assign Port0_pcs_fault                = status_vector0[231];
  assign Port0_pcs_rx_fault             = status_vector0[250];
  assign Port0_pcs_tx_fault             = status_vector0[251];
  //--------------------------------------------

  //Port1 Status--------------------------------------------
  assign Port1_pma_link_status          = status_vector1[18];
  assign Port1_rx_sig_det               = status_vector1[48];
  assign Port1_pcs_rx_link_status       = status_vector1[226];
  assign Port1_pcs_rx_locked            = status_vector1[256];
  assign Port1_pcs_hiber                = status_vector1[257];
  assign Port1_teng_pcs_rx_link_status  = status_vector1[268];
  assign Port1_pcs_err_block_count      = status_vector1[279:272];
  assign Port1_pcs_ber_count            = status_vector1[285:280];
  assign Port1_pcs_rx_hiber_lh          = status_vector1[286];
  assign Port1_pcs_rx_locked_ll         = status_vector1[287];
  assign Port1_pcs_test_patt_err_count  = status_vector1[303:288];
  //Port1 User add Status--------------------------------------------
  assign Port1_pma_pmd_fault            = status_vector1[23];
  assign Port1_pma_pmd_rx_fault         = status_vector1[42];
  assign Port1_pma_pmd_tx_fault         = status_vector1[43];
  assign Port1_pcs_fault                = status_vector1[231];
  assign Port1_pcs_rx_fault             = status_vector1[250];
  assign Port1_pcs_tx_fault             = status_vector1[251];
  //--------------------------------------------

  //Port2 Status--------------------------------------------
  assign Port2_pma_link_status          = status_vector2[18];
  assign Port2_rx_sig_det               = status_vector2[48];
  assign Port2_pcs_rx_link_status       = status_vector2[226];
  assign Port2_pcs_rx_locked            = status_vector2[256];
  assign Port2_pcs_hiber                = status_vector2[257];
  assign Port2_teng_pcs_rx_link_status  = status_vector2[268];
  assign Port2_pcs_err_block_count      = status_vector2[279:272];
  assign Port2_pcs_ber_count            = status_vector2[285:280];
  assign Port2_pcs_rx_hiber_lh          = status_vector2[286];
  assign Port2_pcs_rx_locked_ll         = status_vector2[287];
  assign Port2_pcs_test_patt_err_count  = status_vector2[303:288];
  //Port2 User add Status--------------------------------------------
  assign Port2_pma_pmd_fault            = status_vector2[23];
  assign Port2_pma_pmd_rx_fault         = status_vector2[42];
  assign Port2_pma_pmd_tx_fault         = status_vector2[43];
  assign Port2_pcs_fault                = status_vector2[231];
  assign Port2_pcs_rx_fault             = status_vector2[250];
  assign Port2_pcs_tx_fault             = status_vector2[251];
  //--------------------------------------------


  // Add a pipeline to the xmgii_tx inputs, to aid timing closure
  always @(posedge coreclk)
  begin
    xgmii_txd0_pipe1 <= xgmii_txd0;
    xgmii_txc0_pipe1 <= xgmii_txc0;
    xgmii_txd0_pipe2 <= xgmii_txd0_pipe1;
    xgmii_txc0_pipe2 <= xgmii_txc0_pipe1;
    xgmii_txd0_pipe3 <= xgmii_txd0_pipe2;
    xgmii_txc0_pipe3 <= xgmii_txc0_pipe2;
    xgmii_txd_reg0   <= xgmii_txd0_pipe3;
    xgmii_txc_reg0   <= xgmii_txc0_pipe3;

    xgmii_txd1_pipe1 <= xgmii_txd1;
    xgmii_txc1_pipe1 <= xgmii_txc1;
    xgmii_txd1_pipe2 <= xgmii_txd1_pipe1;
    xgmii_txc1_pipe2 <= xgmii_txc1_pipe1;
    xgmii_txd1_pipe3 <= xgmii_txd1_pipe2;
    xgmii_txc1_pipe3 <= xgmii_txc1_pipe2;
    xgmii_txd_reg1   <= xgmii_txd1_pipe3;
    xgmii_txc_reg1   <= xgmii_txc1_pipe3;

    xgmii_txd2_pipe1 <= xgmii_txd2;
    xgmii_txc2_pipe1 <= xgmii_txc2;
    xgmii_txd2_pipe2 <= xgmii_txd2_pipe1;
    xgmii_txc2_pipe2 <= xgmii_txc2_pipe1;
    xgmii_txd2_pipe3 <= xgmii_txd2_pipe2;
    xgmii_txc2_pipe3 <= xgmii_txc2_pipe2;
    xgmii_txd_reg2   <= xgmii_txd2_pipe3;
    xgmii_txc_reg2   <= xgmii_txc2_pipe3;

  end

  // Add a pipeline to the xmgii_rx outputs, to aid timing closure
  always @(posedge coreclk)
  begin
    xgmii_rxd0_pipe1 <= xgmii_rxd0_int0;
    xgmii_rxc0_pipe1 <= xgmii_rxc0_int0;
    xgmii_rxd0_pipe2 <= xgmii_rxd0_pipe1;
    xgmii_rxc0_pipe2 <= xgmii_rxc0_pipe1;
    xgmii_rxd0_pipe3 <= xgmii_rxd0_pipe2;
    xgmii_rxc0_pipe3 <= xgmii_rxc0_pipe2;
    xgmii_rxd0       <= xgmii_rxd0_pipe3;
    xgmii_rxc0       <= xgmii_rxc0_pipe3;

    xgmii_rxd1_pipe1 <= xgmii_rxd1_int1;
    xgmii_rxc1_pipe1 <= xgmii_rxc1_int1;
    xgmii_rxd1_pipe2 <= xgmii_rxd1_pipe1;
    xgmii_rxc1_pipe2 <= xgmii_rxc1_pipe1;
    xgmii_rxd1_pipe3 <= xgmii_rxd1_pipe2;
    xgmii_rxc1_pipe3 <= xgmii_rxc1_pipe2;
    xgmii_rxd1       <= xgmii_rxd1_pipe3;
    xgmii_rxc1       <= xgmii_rxc1_pipe3;

    xgmii_rxd2_pipe1 <= xgmii_rxd2_int2;
    xgmii_rxc2_pipe1 <= xgmii_rxc2_int2;
    xgmii_rxd2_pipe2 <= xgmii_rxd2_pipe1;
    xgmii_rxc2_pipe2 <= xgmii_rxc2_pipe1;
    xgmii_rxd2_pipe3 <= xgmii_rxd2_pipe2;
    xgmii_rxc2_pipe3 <= xgmii_rxc2_pipe2;
    xgmii_rxd2       <= xgmii_rxd2_pipe3;
    xgmii_rxc2       <= xgmii_rxc2_pipe3;
  end



  BUFG dclk_bufg_i
       (
         .I (dclk),
         .O (dclk_buf)
       );

  // Instantiate the 10GBASE-R Block Level

       ten_gig_eth_pcs_pma_support_Port3 ten_gig_eth_pcs_pma_support_Port3_dut
                              (
                                .refclk_p(refclk_p),
                                .refclk_n(refclk_n),
                                .dclk(dclk_buf),
                                .coreclk_out(coreclk),
                                .reset(reset),
                                //unuse--------------------------------------------
                                .sim_speedup_control(1'b0),
                                .qplloutclk_out(qplloutclk_out),
                                .qplloutrefclk_out(qplloutrefclk_out),
                                .qplllock_out(qplllock_out),
                                .rxrecclk_out(),
                                .txusrclk_out(txusrclk_out),
                                .txusrclk2_out(txusrclk2_out),
                                .gttxreset_out(gttxreset_out),
                                .gtrxreset_out(gtrxreset_out),
                                .txuserrdy_out(txuserrdy_out),
                                .areset_datapathclk_out(areset_datapathclk_out),
                                .reset_counter_done_out(reset_counter_done_out),
                                //Xgmii Inf--------------------------------------------
                                .xgmii_txd0 (xgmii_txd_reg0 ),
                                .xgmii_txc0 (xgmii_txc_reg0 ),
                                .xgmii_rxd0 (xgmii_rxd0_int0 ),
                                .xgmii_rxc0 (xgmii_rxc0_int0 ),
                                .xgmii_txd1 (xgmii_txd_reg1 ),
                                .xgmii_txc1 (xgmii_txc_reg1 ),
                                .xgmii_rxd1 (xgmii_rxd1_int1 ),
                                .xgmii_rxc1 (xgmii_rxc1_int1 ),
                                .xgmii_txd2 (xgmii_txd_reg2 ),
                                .xgmii_txc2 (xgmii_txc_reg2 ),
                                .xgmii_rxd2 (xgmii_rxd2_int2 ),
                                .xgmii_rxc2 (xgmii_rxc2_int2 ),
                                //GTX Inf
                                .txp (txp ),//[2:0]
                                .txn (txn ),//[2:0]
                                .rxp (rxp ),//[2:0]
                                .rxn (rxn ),//[2:0]
                                //--------------------------------------------
                                .resetdone_out(resetdone),
                                .signal_detect(1'b1),
                                .tx_fault(1'b0),
                                .tx_disable(tx_disable),//unuse
                                .configuration_vector(configuration_vector),//In
                                .status_vector0 (status_vector0 ),//O
                                .status_vector1 (status_vector1 ),//O
                                .status_vector2 (status_vector2 ),//O
                                .pma_pmd_type(3'b101),
                                .core_status0 (core_status0 ),//O
                                .core_status1 (core_status1 ),//O
                                .core_status2 (core_status2 )//O
                              );

  assign coreclk_out = coreclk;

  ODDR #(
         .SRTYPE("ASYNC"),
         .DDR_CLK_EDGE("SAME_EDGE")) rx_clk_ddr(
         .Q(xgmii_rx_clk),
         .D1(1'b0),
         .D2(1'b1),
         .C(coreclk),
         .CE(1'b1),
         .R(1'b0),
         .S(1'b0));



endmodule
