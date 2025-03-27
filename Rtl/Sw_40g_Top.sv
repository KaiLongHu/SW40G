/*//////////////////////////////////////////////////////////////////////////////////////////////
+--+--+---+-+---+----+
|  |  |   | /   |    |
|  |--|   --    |    |
|  |  |   | \   ---- |
|--+--+---+-+--------+
Module Name:Sw_40g_Top
Provider:HuKaiLong
Creat Time:2025-01-02 08:38:09
Target Platform:
Function Description: 
//////////////////////////////////////////////////////////////////////////////////////////////*/
`timescale 1ns/1ns

module Sw_40g_Top (
    //
    input  wire Clk100M,
    //XFI
    input  wire BaseX_gtrefclk_p,
    input  wire BaseX_gtrefclk_n,

    output wire [3:0] BaseX_txp,
    output wire [3:0] BaseX_txn,
    input  wire [3:0] BaseX_rxp,
    input  wire [3:0] BaseX_rxn,

    input  wire [1:0]Aurora_Clk_P,
    input  wire [1:0]Aurora_Clk_N,
    output wire [6:0]Aurora_Tx_P,
    output wire [6:0]Aurora_Tx_N,
    input  wire [6:0]Aurora_Rx_P,
    input  wire [6:0]Aurora_Rx_N,

    input  wire [1:0]AuroraLane4_Clk_P,
    input  wire [1:0]AuroraLane4_Clk_N,
    output wire [7:0]AuroraLane4_Tx_P,
    output wire [7:0]AuroraLane4_Tx_N,
    input  wire [7:0]AuroraLane4_Rx_P,
    input  wire [7:0]AuroraLane4_Rx_N

  );

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////            SIGDEF              ////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //test only
  //--------------------------------------------
  wire RstSys_n;
  wire [2:0] User_Clk; //156.25M
  wire dclk;

  wire soft_reset;
  wire PllLock;
  wire RstExtGlb_n;
  wire SysClk;
  wire CpuClk;
  wire RefClk100M;

  wire Clk200M;
  wire ClkPh125M;
  wire Clk125MBfg;
  wire XUpdataSpiClk;
  wire RgmiiRx_Clk_BufR;

  wire clk156_out0;

  //--------------------------------------------
  wire [3:0] [63:0] Xaui_xgmii_txd;
  wire [3:0] [7:0]  Xaui_xgmii_txc;
  wire [3:0] [63:0] Xaui_xgmii_rxd;
  wire [3:0] [7:0]  Xaui_xgmii_rxc;

  wire [3:0] [63:0] TenG_xgmii_txd;
  wire [3:0] [7:0]  TenG_xgmii_txc;
  wire [3:0] [63:0] TenG_xgmii_rxd;
  wire [3:0] [7:0]  TenG_xgmii_rxc;
  //--------------------------------------------
  wire [3:0][2:0]status_vector_Mac;
  wire [3:0]         rx_axis_aresetn;
  wire [3:0]  [63:0] rx_axis_tdata;
  wire [3:0]  [7:0]  rx_axis_tkeep;
  wire [3:0]         rx_axis_tvalid;
  wire [3:0]         rx_axis_tlast;
  wire [3:0]         rx_axis_tready;
  wire [3:0] tx_axis_tready;
  wire [3:0] tx_axis_tvalid;
  wire [3:0] tx_axis_tlast;
  wire [3:0] [63:0] tx_axis_tdata;
  wire [3:0] [7:0] tx_axis_tkeep;

  wire [3:0] [31:0] TenGRxPkg_Cnt;
  wire [3:0] [31:0] RxPkgErr_Cnt;
  wire [3:0] [31:0] TenGBriRxPkg_Cnt;
  wire [3:0] [31:0] TenGTxPkg_Cnt;
  wire [3:0] [31:0] TenGBriTxPkg_Cnt;
  wire [3:0] [7:0] XauiRxFifoStatus;

  //--------------------------------------------
  wire [1:0][255:0] Lane4_s_axi_tx_tdata;
  wire [1:0]        Lane4_s_axi_tx_tlast;
  wire [1:0][31:0]   Lane4_s_axi_tx_tkeep;
  wire [1:0]        Lane4_s_axi_tx_tvalid;
  wire [1:0]        Lane4_s_axi_tx_tready;
  wire [1:0][255:0] Lane4_m_axi_rx_tdata;
  wire [1:0][31:0]  Lane4_m_axi_rx_tkeep;
  wire [1:0]        Lane4_m_axi_rx_tlast;
  wire [1:0]        Lane4_m_axi_rx_tvalid;

  wire [2:0][0:63]s_axi_tx_tdata;
  wire [2:0][0:7] s_axi_tx_tkeep;
  wire [2:0]      s_axi_tx_tlast;
  wire [2:0]      s_axi_tx_tvalid;
  wire [2:0]      s_axi_tx_tready;
  wire [2:0][0:63]m_axi_rx_tdata;
  wire [2:0][0:7] m_axi_rx_tkeep;
  wire [2:0]      m_axi_rx_tlast;
  wire [2:0]      m_axi_rx_tvalid;

  wire [2:0]      Aurora_user_clk;
  wire [4:0]      user_reset;
  wire [4:0]      hard_err_0;
  wire [4:0]      soft_err_0;
  wire [4:0]      channel_up_0;
  wire [4:0]      lane_up_0;
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////            SUPPORT              ///////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Glb_Rst_Gen Glb_Rst_Gen_Inst(
                .Hard_Rst_n(1'b1),
                .Soft_Rst_n(1'b1),
                .RefClk100M(Clk100M),
                .DDR3InitComplete(1'b1),
                .RstExtGlb_n(RstExtGlb_n),
                .RstSys_n(RstSys_n),
                .CpuClk(CpuClk),
                .Clk100MOut(SysClk),
                .Clk125MBfg(),
                .ClkPh125M(),
                .Clk200M(Clk200M),
                .Clk50M(dclk),
                .Clk10M(XUpdataSpiClk),
                .Clk8M(),

                .Watchdog_Control(1'b0),   // 0 --- Watchdog DisAble; 1 ----- Watchdog Enable
                .Feed_Watchdog(),
                .PllLock(PllLock),

                .LS2K_SYS_RST        (LS2K_SYS_RST),
                .ZX5201_RSTN_2V5     (ZX5201_RESET_n),
                .VSC8512_PLL_RESET   (VSC8512_PLL_RESET),
                .VSC8512_RESET       (VSC8512_RESET),
                .CTC5160_RST_POR_B   (F_SW_POR_RST_N),
                .CTC5160_FUSE_DONE   (SW_F_MEM_POR_DONE),
                .CTC5160_RST_PCIE_B  (F_SW_PCIE_RST_N),
                .CTC5160_RST_B       (F_SW_CORE_RST_N)
              );
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////            InterFace              ///////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ten_gig_eth_pcs_pma_example_design_Port4 ten_gig_eth_pcs_pma_example_design_Port4_dut (
                                             .refclk_p (BaseX_gtrefclk_p ),
                                             .refclk_n (BaseX_gtrefclk_n ),
                                             .dclk (dclk ),//In 50M
                                             .coreclk_out (clk156_out0),//O
                                             .reset (~RstSys_n ),
                                             .xgmii_rx_clk(),//Out
                                             .xgmii_txd0 (TenG_xgmii_txd[0] ),
                                             .xgmii_txc0 (TenG_xgmii_txc[0] ),
                                             .xgmii_rxd0 (TenG_xgmii_rxd[0] ),
                                             .xgmii_rxc0 (TenG_xgmii_rxc[0] ),
                                             .xgmii_txd1 (TenG_xgmii_txd[1] ),
                                             .xgmii_txc1 (TenG_xgmii_txc[1] ),
                                             .xgmii_rxd1 (TenG_xgmii_rxd[1] ),
                                             .xgmii_rxc1 (TenG_xgmii_rxc[1] ),
                                             .xgmii_txd2 (TenG_xgmii_txd[2] ),
                                             .xgmii_txc2 (TenG_xgmii_txc[2] ),
                                             .xgmii_rxd2 (TenG_xgmii_rxd[2] ),
                                             .xgmii_rxc2 (TenG_xgmii_rxc[2] ),
                                             .xgmii_txd3 (TenG_xgmii_txd[3] ),
                                             .xgmii_txc3 (TenG_xgmii_txc[3] ),
                                             .xgmii_rxd3 (TenG_xgmii_rxd[3] ),
                                             .xgmii_rxc3 (TenG_xgmii_rxc[3] ),
                                             .txp (BaseX_txp ),
                                             .txn (BaseX_txn ),
                                             .rxp (BaseX_rxp ),
                                             .rxn (BaseX_rxn ),
                                             .pma_loopback (1'b0 ),
                                             .pma_reset (1'b0 ),
                                             .global_tx_disable (1'b0 ),
                                             .pcs_loopback (1'b0 ),
                                             .pcs_reset (1'b0 ),
                                             .test_patt_a_b (58'h0 ),
                                             .data_patt_sel (1'b1 ),
                                             .test_patt_sel (1'b0 ),
                                             .rx_test_patt_en (1'b0 ),
                                             .tx_test_patt_en (1'b0 ),
                                             .prbs31_tx_en (1'b0 ),
                                             .prbs31_rx_en (1'b0 ),
                                             .set_pma_link_status (1'b1 ),
                                             .set_pcs_link_status (1'b1 ),//
                                             .clear_pcs_status2 (1'b0 ),
                                             .clear_test_patt_err_count (1'b0 ),

                                             .Port0_pma_link_status ( ),
                                             .Port0_rx_sig_det ( ),
                                             .Port0_pcs_rx_link_status ( ),
                                             .Port0_pcs_rx_locked ( ),
                                             .Port0_pcs_hiber ( ),
                                             .Port0_teng_pcs_rx_link_status ( ),
                                             .Port0_pcs_err_block_count ( ),
                                             .Port0_pcs_ber_count ( ),
                                             .Port0_pcs_rx_hiber_lh ( ),
                                             .Port0_pcs_rx_locked_ll ( ),
                                             .Port0_pcs_test_patt_err_count ( ),
                                             .Port0_pma_pmd_fault ( ),
                                             .Port0_pma_pmd_rx_fault ( ),
                                             .Port0_pma_pmd_tx_fault ( ),
                                             .Port0_pcs_fault ( ),
                                             .Port0_pcs_rx_fault ( ),
                                             .Port0_pcs_tx_fault ( ),
                                             .Port1_pma_link_status ( ),
                                             .Port1_rx_sig_det ( ),
                                             .Port1_pcs_rx_link_status ( ),
                                             .Port1_pcs_rx_locked ( ),
                                             .Port1_pcs_hiber ( ),
                                             .Port1_teng_pcs_rx_link_status ( ),
                                             .Port1_pcs_err_block_count ( ),
                                             .Port1_pcs_ber_count ( ),
                                             .Port1_pcs_rx_hiber_lh ( ),
                                             .Port1_pcs_rx_locked_ll ( ),
                                             .Port1_pcs_test_patt_err_count ( ),
                                             .Port1_pma_pmd_fault ( ),
                                             .Port1_pma_pmd_rx_fault ( ),
                                             .Port1_pma_pmd_tx_fault ( ),
                                             .Port1_pcs_fault ( ),
                                             .Port1_pcs_rx_fault ( ),
                                             .Port1_pcs_tx_fault ( ),
                                             .Port2_pma_link_status ( ),
                                             .Port2_rx_sig_det ( ),
                                             .Port2_pcs_rx_link_status ( ),
                                             .Port2_pcs_rx_locked ( ),
                                             .Port2_pcs_hiber ( ),
                                             .Port2_teng_pcs_rx_link_status ( ),
                                             .Port2_pcs_err_block_count ( ),
                                             .Port2_pcs_ber_count ( ),
                                             .Port2_pcs_rx_hiber_lh ( ),
                                             .Port2_pcs_rx_locked_ll ( ),
                                             .Port2_pcs_test_patt_err_count ( ),
                                             .Port2_pma_pmd_fault ( ),
                                             .Port2_pma_pmd_rx_fault ( ),
                                             .Port2_pma_pmd_tx_fault ( ),
                                             .Port2_pcs_fault ( ),
                                             .Port2_pcs_rx_fault ( ),
                                             .Port2_pcs_tx_fault ( ),
                                             .core_status0 ( ),
                                             .core_status1 ( ),
                                             .core_status2 ( ),
                                             .resetdone ( ),
                                             .tx_disable  ( )
                                           );


  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  aurora_64b66b_lan4_framing_support aurora_64b66b_lan4_framing_inst0
                                     (
                                       // TX AXI4-S Interface
                                       .s_axi_tx_tdata                     (Lane4_s_axi_tx_tdata[0]   ),
                                       .s_axi_tx_tlast                     (Lane4_s_axi_tx_tlast[0]   ),
                                       .s_axi_tx_tkeep                     (Lane4_s_axi_tx_tkeep[0]   ),
                                       .s_axi_tx_tvalid                    (Lane4_s_axi_tx_tvalid[0]  ),
                                       .s_axi_tx_tready                    (Lane4_s_axi_tx_tready[0]  ),
                                       // RX AXI4-S Interface
                                       .m_axi_rx_tdata                     (Lane4_m_axi_rx_tdata[0]   ),
                                       .m_axi_rx_tlast                     (Lane4_m_axi_rx_tkeep[0]   ),
                                       .m_axi_rx_tkeep                     (Lane4_m_axi_rx_tlast[0]   ),
                                       .m_axi_rx_tvalid                    (Lane4_m_axi_rx_tvalid[0]  ),
                                       // GT Serial I/O
                                       .rxp                                (AuroraLane4_Rx_P[3:0]     ),
                                       .rxn                                (AuroraLane4_Rx_N[3:0]     ),
                                       .txp                                (AuroraLane4_Tx_P[3:0]     ),
                                       .txn                                (AuroraLane4_Tx_N[3:0]     ),
                                       //GT Reference Clock Interface
                                       .gt_refclk1_p                       (AuroraLane4_Clk_P[0]      ),
                                       .gt_refclk1_n                       (AuroraLane4_Clk_N[0]      ),
                                       // Error Detection Interface
                                       .hard_err                           (hard_err_0[0]             ),
                                       .soft_err                           (soft_err_0[0]             ),
                                       // Status
                                       .channel_up                         (channel_up_0[0]           ),
                                       .lane_up                            (lane_up_0[0]              ),
                                       // System Interface
                                       .init_clk_out                       (                          ),
                                       .user_clk_out                       (Aurora_user_clk[0]        ),
                                       .sync_clk_out                       (                          ),
                                       .reset_pb                           (user_reset[0]             ),
                                       .gt_rxcdrovrden_in                  (1'b0                      ),
                                       .power_down                         (1'b0                      ),
                                       .loopback                           (3'b000                    ),
                                       .pma_init                           (1'b1                      ),//gt reset
                                       .gt_pll_lock                        (                          ),
                                       .drp_clk_in                         (SysClk                    ),//
                                       //---------------------- GT DRP Ports ----------------------
                                       .drpaddr_in                         ('0                        ),
                                       .drpdi_in                           ('0                        ),
                                       .drpdo_out                          (                          ),
                                       .drprdy_out                         (                          ),
                                       .drpen_in                           ('0                        ),
                                       .drpwe_in                           ('0                        ),
                                       .drpaddr_in_lane1                   ('0                        ),
                                       .drpdi_in_lane1                     ('0                        ),
                                       .drpdo_out_lane1                    (                          ),
                                       .drprdy_out_lane1                   (                          ),
                                       .drpen_in_lane1                     ('0                        ),
                                       .drpwe_in_lane1                     ('0                        ),
                                       .drpaddr_in_lane2                   ('0                        ),
                                       .drpdi_in_lane2                     ('0                        ),
                                       .drpdo_out_lane2                    (                          ),
                                       .drprdy_out_lane2                   (                          ),
                                       .drpen_in_lane2                     ('0                        ),
                                       .drpwe_in_lane2                     ('0                        ),
                                       .drpaddr_in_lane3                   ('0                        ),
                                       .drpdi_in_lane3                     ('0                        ),
                                       .drpdo_out_lane3                    (                          ),
                                       .drprdy_out_lane3                   (                          ),
                                       .drpen_in_lane3                     ('0                        ),
                                       .drpwe_in_lane3                     ('0                        ),
                                       .init_clk_p                         ('0                        ),
                                       .init_clk_n                         ('0                        ),
                                       .link_reset_out                     (                          ),
                                       .mmcm_not_locked_out                (                          ),
                                       .sys_reset_out                      (                          ),
                                       .tx_out_clk                         (                          )
                                     );

  aurora_64b66b_lan4_framing_support aurora_64b66b_lan4_framing_inst1
                                     (
                                       // TX AXI4-S Interface
                                       .s_axi_tx_tdata                     (Lane4_s_axi_tx_tdata[1]   ),
                                       .s_axi_tx_tlast                     (Lane4_s_axi_tx_tlast[1]   ),
                                       .s_axi_tx_tkeep                     (Lane4_s_axi_tx_tkeep[1]   ),
                                       .s_axi_tx_tvalid                    (Lane4_s_axi_tx_tvalid[1]  ),
                                       .s_axi_tx_tready                    (Lane4_s_axi_tx_tready[1]  ),
                                       // RX AXI4-S Interface
                                       .m_axi_rx_tdata                     (Lane4_m_axi_rx_tdata[1]   ),
                                       .m_axi_rx_tlast                     (Lane4_m_axi_rx_tkeep[1]   ),
                                       .m_axi_rx_tkeep                     (Lane4_m_axi_rx_tlast[1]   ),
                                       .m_axi_rx_tvalid                    (Lane4_m_axi_rx_tvalid[1]  ),
                                       // GT Serial I/O
                                       .rxp                                (AuroraLane4_Rx_P[7:4]     ),
                                       .rxn                                (AuroraLane4_Rx_N[7:4]     ),
                                       .txp                                (AuroraLane4_Tx_P[7:4]     ),
                                       .txn                                (AuroraLane4_Tx_N[7:4]     ),
                                       //GT Reference Clock Interface
                                       .gt_refclk1_p                       (AuroraLane4_Clk_P[1]      ),
                                       .gt_refclk1_n                       (AuroraLane4_Clk_N[1]      ),
                                       // Error Detection Interface
                                       .hard_err                           (hard_err_0[1]             ),
                                       .soft_err                           (soft_err_0[1]             ),
                                       // Status
                                       .channel_up                         (channel_up_0[1]           ),
                                       .lane_up                            (lane_up_0[1]              ),
                                       // System Interface
                                       .init_clk_out                       (                          ),
                                       .user_clk_out                       (Aurora_user_clk[1]        ),
                                       .sync_clk_out                       (                          ),
                                       .reset_pb                           (user_reset[1]             ),
                                       .gt_rxcdrovrden_in                  (1'b0                      ),
                                       .power_down                         (1'b0                      ),
                                       .loopback                           (3'b000                    ),
                                       .pma_init                           (1'b1                      ),//gt reset
                                       .gt_pll_lock                        (                          ),
                                       .drp_clk_in                         (SysClk                    ),//
                                       //---------------------- GT DRP Ports ----------------------
                                       .drpaddr_in                         ('0                        ),
                                       .drpdi_in                           ('0                        ),
                                       .drpdo_out                          (                          ),
                                       .drprdy_out                         (                          ),
                                       .drpen_in                           ('0                        ),
                                       .drpwe_in                           ('0                        ),
                                       .drpaddr_in_lane1                   ('0                        ),
                                       .drpdi_in_lane1                     ('0                        ),
                                       .drpdo_out_lane1                    (                          ),
                                       .drprdy_out_lane1                   (                          ),
                                       .drpen_in_lane1                     ('0                        ),
                                       .drpwe_in_lane1                     ('0                        ),
                                       .drpaddr_in_lane2                   ('0                        ),
                                       .drpdi_in_lane2                     ('0                        ),
                                       .drpdo_out_lane2                    (                          ),
                                       .drprdy_out_lane2                   (                          ),
                                       .drpen_in_lane2                     ('0                        ),
                                       .drpwe_in_lane2                     ('0                        ),
                                       .drpaddr_in_lane3                   ('0                        ),
                                       .drpdi_in_lane3                     ('0                        ),
                                       .drpdo_out_lane3                    (                          ),
                                       .drprdy_out_lane3                   (                          ),
                                       .drpen_in_lane3                     ('0                        ),
                                       .drpwe_in_lane3                     ('0                        ),
                                       .init_clk_p                         ('0                        ),
                                       .init_clk_n                         ('0                        ),
                                       .link_reset_out                     (                          ),
                                       .mmcm_not_locked_out                (                          ),
                                       .sys_reset_out                      (                          ),
                                       .tx_out_clk                         (                          )
                                     );
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Aurora_Top_P3  Aurora_Top_P3_inst (
                   .gt_refclk_p                        (Aurora_Clk_P[1]           ),
                   .gt_refclk_n                        (Aurora_Clk_N[1]           ),
                   .system_rst                         (~RstSys_n                 ),
                   .init_clk                           (SysClk                    ),
                   .drp_clk                            (SysClk                    ),
                   .qpll_drpaddr                       ({1'b0,1'b0,1'b0}          ),
                   .qpll_drpdi                         ({1'b0,1'b0,1'b0}          ),
                   .qpll_drprdy                        (                          ),
                   .qpll_drpen                         ({1'b0,1'b0,1'b0}          ),
                   .qpll_drpwe                         ({1'b0,1'b0,1'b0}          ),
                   .qpll_drpdo                         (                          ),
                   .gt_rx_p                            (Aurora_Rx_P[6:4]          ),
                   .gt_rx_n                            (Aurora_Rx_N[6:4]          ),
                   .user_clk                           (Aurora_user_clk[2]        ),
                   .user_reset                         (user_reset[4:2]           ),
                   .gt_loopback                        ({3'b0,3'b0,3'b0}          ),
                   .gt_tx_p                            (Aurora_Tx_P[6:4]          ),
                   .gt_tx_n                            (Aurora_Tx_N[6:4]          ),
                   .hard_err                           (hard_err_0[4:2]           ),
                   .soft_err                           (soft_err_0[4:2]           ),
                   .channel_up                         (channel_up_0[4:2]         ),
                   .lane_up                            (lane_up_0[4:2]            ),
                   .s_axi_tx_tdata                     (s_axi_tx_tdata[2:0]       ),
                   .s_axi_tx_tkeep                     (s_axi_tx_tkeep[2:0]       ),
                   .s_axi_tx_tlast                     (s_axi_tx_tlast[2:0]       ),
                   .s_axi_tx_tvalid                    (s_axi_tx_tvalid[2:0]      ),
                   .s_axi_tx_tready                    (s_axi_tx_tready[2:0]      ),
                   .m_axi_rx_tdata                     (m_axi_rx_tdata[2:0]       ),
                   .m_axi_rx_tkeep                     (m_axi_rx_tkeep[2:0]       ),
                   .m_axi_rx_tlast                     (m_axi_rx_tlast[2:0]       ),
                   .m_axi_rx_tvalid                    (m_axi_rx_tvalid[2:0]      ),
                   .gt_drpaddr                         (0                         ),
                   .gt_drpdi                           (0                         ),
                   .gt_drprdy                          (                          ),
                   .gt_drpen                           (0                         ),
                   .gt_drpwe                           (0                         ),
                   .gt_drpdo                           (                          )
                 );
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////              Support                   /////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  genvar i;
  generate
    for(i=0; i<4; i=i+1)
    begin:TengMac_Inst_loop
      TenGEthMacPort1_New  TenGEthMacPort1_New_inst (
                             .reset(~RstSys_n),
                             .gtx_clk(clk156_out0),
                             .tx_clk0(clk156_out0),
                             .xgmii_txd(TenG_xgmii_txd[i]),
                             .xgmii_txc(TenG_xgmii_txc[i]),
                             .rx_clk0(clk156_out0),
                             .xgmii_rxd(TenG_xgmii_rxd[i]),
                             .xgmii_rxc(TenG_xgmii_rxc[i]),
                             .tx_dcm_locked(1'b1),
                             .rx_dcm_locked(1'b1),
                             .status_vector_Mac1(status_vector_Mac[i]),
                             .tx_axis_fifo_aclk(clk156_out0),
                             .tx_axis_aresetn(RstSys_n),
                             .tx_axis_fifo_tdata(tx_axis_tdata[i]),
                             .tx_axis_fifo_tkeep(tx_axis_tkeep[i]),
                             .tx_axis_fifo_tvalid(tx_axis_tvalid[i]),
                             .tx_axis_fifo_tlast(tx_axis_tlast[i]),
                             .tx_axis_fifo_tready(tx_axis_tready[i]),
                             .rx_axis_fifo_aclk(clk156_out0),
                             .rx_axis_aresetn(RstSys_n),
                             .rx_axis_fifo_tdata(rx_axis_tdata[i]),
                             .rx_axis_fifo_tkeep(rx_axis_tkeep[i]),
                             .rx_axis_fifo_tvalid(rx_axis_tvalid[i]),
                             .rx_axis_fifo_tlast(rx_axis_tlast[i]),
                             .rx_axis_fifo_tready(rx_axis_tready[i]),
                             .CntClr(CntClr),
                             .RxPkg_Cnt(TenGRxPkg_Cnt[i]),
                             .RxPkgErr_Cnt(RxPkgErr_Cnt[i]),
                             .BriRxPkg_Cnt(TenGBriRxPkg_Cnt[i]),
                             .TxPkg_Cnt(TenGTxPkg_Cnt[i]),
                             .BriTxPkg_Cnt(TenGBriTxPkg_Cnt[i]),
                             .XauiRxFifoStatus(XauiRxFifoStatus[i])
                           );
    end
  endgenerate

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////                                 /////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Sw_40g_Core  Sw_40g_Core_inst (
                 .Rst_n(~RstSys_n),
                 .SysClk(SysClk),
                 .lane1_s_axi_tx_clk(Aurora_user_clk),
                 .lane1_s_axi_tx_tdata(s_axi_tx_tdata),
                 .lane1_s_axi_tx_tkeep(s_axi_tx_tkeep),
                 .lane1_s_axi_tx_tlast(s_axi_tx_tlast),
                 .lane1_s_axi_tx_tvalid(s_axi_tx_tvalid),
                 .lane1_s_axi_tx_tready(s_axi_tx_tready),
                 .lane1_m_axi_rx_clk(Aurora_user_clk),
                 .lane1_m_axi_rx_tdata(m_axi_rx_tdata),
                 .lane1_m_axi_rx_tkeep(m_axi_rx_tkeep),
                 .lane1_m_axi_rx_tlast(m_axi_rx_tlast),
                 .lane1_m_axi_rx_tvalid(m_axi_rx_tvalid),

                 .lane4_s_axi_tx_clk(Aurora_user_clk),
                 .lane4_s_axi_tx_tdata(Lane4_s_axi_tx_tdata),
                 .lane4_s_axi_tx_tkeep(Lane4_s_axi_tx_tkeep),
                 .lane4_s_axi_tx_tlast(Lane4_s_axi_tx_tlast),
                 .lane4_s_axi_tx_tvalid(Lane4_s_axi_tx_tvalid),
                 .lane4_s_axi_tx_tready(Lane4_s_axi_tx_tready),
                 .lane4_m_axi_rx_clk(Aurora_user_clk),
                 .lane4_m_axi_rx_tdata(Lane4_m_axi_rx_tdata),
                 .lane4_m_axi_rx_tkeep(Lane4_m_axi_rx_tkeep),
                 .lane4_m_axi_rx_tlast(Lane4_m_axi_rx_tlast),
                 .lane4_m_axi_rx_tvalid(Lane4_m_axi_rx_tvalid),

                 .Base10G_tx_axis_fifo_aclk(Aurora_user_clk),
                 .Base10G_tx_axis_fifo_tdata(rx_axis_tdata),
                 .Base10G_tx_axis_fifo_tkeep(rx_axis_tkeep),
                 .Base10G_tx_axis_fifo_tvalid(rx_axis_tvalid),
                 .Base10G_tx_axis_fifo_tlast(rx_axis_tlast),
                 .Base10G_tx_axis_fifo_tready(rx_axis_tready),
                 .Base10G_rx_axis_fifo_aclk(Aurora_user_clk),
                 .Base10G_rx_axis_fifo_tdata(tx_axis_tdata),
                 .Base10G_rx_axis_fifo_tkeep(tx_axis_tkeep),
                 .Base10G_rx_axis_fifo_tvalid(tx_axis_tvalid),
                 .Base10G_rx_axis_fifo_tlast(tx_axis_tlast),
                 .Base10G_rx_axis_fifo_tready(tx_axis_tready)
               );

endmodule
