 ///////////////////////////////////////////////////////////////////////////////
 //
 // Project:  Aurora 64B/66B
 // Company:  Xilinx
 //
 //
 //
 // (c) Copyright 2009-2010 Xilinx, Inc. All rights reserved.
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
 
 //////////////////////////////////////////////////////////////////////////////
 //

// 7 series GTX //

 // Design Name: aurora_64b66b_lan4_framing_GTX
 //
 // Module aurora_64b66b_lan4_framing_GTX
 
  
 
 
 `timescale 1ns / 1ps
   (* core_generation_info = "aurora_64b66b_lan4_framing,aurora_64b66b_v11_2_6,{c_aurora_lanes=4,c_column_used=left,c_gt_clock_1=GTXQ0,c_gt_clock_2=None,c_gt_loc_1=1,c_gt_loc_10=X,c_gt_loc_11=X,c_gt_loc_12=X,c_gt_loc_13=X,c_gt_loc_14=X,c_gt_loc_15=X,c_gt_loc_16=X,c_gt_loc_17=X,c_gt_loc_18=X,c_gt_loc_19=X,c_gt_loc_2=2,c_gt_loc_20=X,c_gt_loc_21=X,c_gt_loc_22=X,c_gt_loc_23=X,c_gt_loc_24=X,c_gt_loc_25=X,c_gt_loc_26=X,c_gt_loc_27=X,c_gt_loc_28=X,c_gt_loc_29=X,c_gt_loc_3=3,c_gt_loc_30=X,c_gt_loc_31=X,c_gt_loc_32=X,c_gt_loc_33=X,c_gt_loc_34=X,c_gt_loc_35=X,c_gt_loc_36=X,c_gt_loc_37=X,c_gt_loc_38=X,c_gt_loc_39=X,c_gt_loc_4=4,c_gt_loc_40=X,c_gt_loc_41=X,c_gt_loc_42=X,c_gt_loc_43=X,c_gt_loc_44=X,c_gt_loc_45=X,c_gt_loc_46=X,c_gt_loc_47=X,c_gt_loc_48=X,c_gt_loc_5=X,c_gt_loc_6=X,c_gt_loc_7=X,c_gt_loc_8=X,c_gt_loc_9=X,c_lane_width=4,c_line_rate=6.25,c_gt_type=gtx,c_qpll=false,c_nfc=false,c_nfc_mode=IMM,c_refclk_frequency=156.25,c_simplex=false,c_simplex_mode=TX,c_stream=false,c_ufc=false,c_user_k=false,flow_mode=None,interface_mode=Framing,dataflow_config=Duplex}" *) 
(* DowngradeIPIdentifiedWarnings="yes" *) 
 //***************************** Entity Declaration ****************************
 
 module aurora_64b66b_lan4_framing_GTX #
 (
     // Simulation attributes
     parameter   GT_SIM_GTRESET_SPEEDUP   =   "true",      // Set to 1 to speed up sim reset
     parameter   RX_DFE_KL_CFG2_IN             =   32'h301148AC,
     parameter   PMA_RSV_IN                     =   32'h00018480,
     parameter   PCS_RSVD_ATTR_IN              =   48'h000000000000,
     parameter   SIM_VERSION                   =  ("4.0")
 )
 `define DLY #0.005
 (
     //------------------------------ CPLL Ports -------------------------------
     output          CPLLFBCLKLOST_OUT,
     output          CPLLLOCK_OUT,
     input           CPLLLOCKDETCLK_IN,
     output          CPLLREFCLKLOST_OUT,
     input           CPLLRESET_IN,
    //----------------------- Channel - Clocking Ports ------------------------
    input           GTREFCLK0_IN,
    //-------------------------- Channel - DRP Ports  --------------------------
    input   [8:0]   drpaddr_in,
    input           drpclk_in,
    input   [15:0]  drpdi_in,
    output  [15:0]  drpdo_out,
    input           drpen_in,
    output          drprdy_out,
    input           drpwe_in,
    //----------------------------- Clocking Ports -----------------------------
    input           QPLLCLK_IN,
    input           QPLLREFCLK_IN,
    //----------------------------- Loopback Ports -----------------------------
    input   [2:0]   LOOPBACK_IN,
    //------------------- RX Initialization and Reset Ports --------------------
    input           eyescanreset_in,
    input           RXUSERRDY_IN,
    input           RX_POLARITY_IN,
    //------------------------ RX Margin Analysis Ports ------------------------
    output          eyescandataerror_out,
    input           eyescantrigger_in,
    //----------------------- Receive Ports - CDR Ports ------------------------
    output          RXCDRLOCK_OUT,
    input          RXCDROVRDEN_IN,
    input           rxcdrhold_in,
    //---------------- Receive Ports - FPGA RX Interface Ports -----------------
    input           RXUSRCLK_IN,
    input           RXUSRCLK2_IN,
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    output  [31:0]  RXDATA_OUT,
    //------------------------- Receive Ports - RX AFE -------------------------
    input           GTXRXN_IN,
    input           GTXRXP_IN,
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    output  [2:0]   RXBUFSTATUS_OUT,
    //------------------ Receive Ports - RX Equailizer Ports -------------------
    input           rxlpmhfovrden_in,
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    input           rxdfeagchold_in,
    input           rxdfeagcovrden_in,
    input           rxdfelfhold_in,
    input           rxdfelpmreset_in,
    input           rxlpmlfklovrden_in,
    output  [6:0]   rxmonitorout_out,
    input   [1:0]   rxmonitorsel_in,
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    output          RXOUTCLK_OUT,
    //-------------------- Receive Ports - RX Gearbox Ports --------------------
    output          RXDATAVALID_OUT,
    output  [1:0]   RXHEADER_OUT,
    output          RXHEADERVALID_OUT,
    //------------------- Receive Ports - RX Gearbox Ports  --------------------
    input           RXGEARBOXSLIP_IN,
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    input           GTRXRESET_IN,
    input           RXPMARESET_IN,
    //---------------- Receive Ports - RX Margin Analysis ports ----------------
    input           rxlpmen_in,
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    output          RXRESETDONE_OUT,
    //---------------------- TX Configurable Driver Ports ----------------------
    input   [4:0]   txpostcursor_in,
    //------------------- TX Initialization and Reset Ports --------------------
    input           GTTXRESET_IN,
    input           TXUSERRDY_IN,
    //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
    input           TXUSRCLK_IN,
    input           TXUSRCLK2_IN,
    //------------- Transmit Ports - TX Configurable Driver Ports --------------
    input   [3:0]   txdiffctrl_in,
    input   [6:0]   txmaincursor_in,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input   [63:0]  TXDATA_IN,
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    output          GTXTXN_OUT,
    output          GTXTXP_OUT,
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    output          TXOUTCLK_OUT,
    output          TXOUTCLKFABRIC_OUT,
    output          TXOUTCLKPCS_OUT,
    //------------------- Transmit Ports - TX Gearbox Ports --------------------
    input   [1:0]   TXHEADER_IN,
    input   [6:0]   TXSEQUENCE_IN,
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    output          TXRESETDONE_OUT,
    input           gt_txpmareset_in,
    input           gt_txpcsreset_in,
    input           gt_rxpcsreset_in,
    input           gt_rxbufreset_in,
    input   [4:0]   txprecursor_in,
    input   [2:0]   gt_txprbssel_in,
    input   [2:0]   gt_rxprbssel_in,
    input           gt_txprbsforceerr_in,
    output          gt_rxprbserr_out,
    input           gt_rxprbscntreset_in,
    output  [ 7:0]  gt_dmonitorout_out,
    output  [1:0]   gt_txbufstatus_out,
    input           txinhibit_in,
    //--------------- Transmit Ports - TX Polarity Control Ports ---------------
    input           txpolarity_in

 );
 
 
 //***************************** Wire Declarations *****************************
 
     // ground and vcc signals
     wire            tied_to_ground_i;
     wire    [63:0]  tied_to_ground_vec_i;
     wire            tied_to_vcc_i;
     wire    [63:0]  tied_to_vcc_vec_i;
 
 
     //RX Datapath signals
     wire    [63:0]  rxdata_i;
 
     //TX Datapath signals
     wire    [63:0]  txdata_i;           

(* equivalent_register_removal="no" *) reg [95:0]   cpllpd_wait    =  96'hFFFFFFFFFFFFFFFFFFFFFFFF;
(* equivalent_register_removal="no" *) reg [127:0]  cpllreset_wait = 128'h000000000000000000000000000000FF;
wire    cpllpd_ovrd_i ;
wire    cpllreset_ovrd_i ;
wire    cpll_reset_i;
wire    cpllreset_sync;
wire    cpll_pd_i;
wire    cpllpd_sync;
wire    ack_i;
reg     flag = 1'b0;
reg     flag2 = 1'b0;
reg     ack_flag = 1'b0;
  // Internal Signals
  wire data_sync1;
  wire data_sync2;
  wire data_sync3;
  wire data_sync4;
  wire data_sync5;
  wire data_sync6;
  wire ack_sync1;
  wire ack_sync2;
  wire ack_sync3;
  wire ack_sync4;
  wire ack_sync5;
  wire ack_sync6;

 // 
 //********************************* Main Body of Code**************************
                        
     //-------------------------  Static signal Assigments ---------------------   
 
     assign tied_to_ground_i             = 1'b0;
     assign tied_to_ground_vec_i         = 64'h0000000000000000;
     assign tied_to_vcc_i                = 1'b1;
     assign tied_to_vcc_vec_i            = 64'hffffffffffffffff;
     
     //-------------------  GT Datapath byte mapping  -----------------
 
     //The GT deserializes the rightmost parallel bit (LSb) first
     assign  RXDATA_OUT    =   rxdata_i[31:0];
 
     //The GT serializes the rightmost parallel bit (LSb) first
             assign txdata_i =   TXDATA_IN;
 
 
     //------------------------- GT Instantiations  --------------------------
         GTXE2_CHANNEL #
         (
             //_______________________ Simulation-Only Attributes __________________
     
             .SIM_RECEIVER_DETECT_PASS   ("TRUE"),
             .SIM_TX_EIDLE_DRIVE_LEVEL   ("X"),
            .SIM_RESET_SPEEDUP          (GT_SIM_GTRESET_SPEEDUP),
            .SIM_CPLLREFCLK_SEL         (3'b001),
            .SIM_VERSION                (SIM_VERSION),
             
 
           //----------------RX Byte and Word Alignment Attributes---------------
            .ALIGN_COMMA_DOUBLE                     ("FALSE"),
            .ALIGN_COMMA_ENABLE                     (10'b1111111111),
            .ALIGN_COMMA_WORD                       (1),
            .ALIGN_MCOMMA_DET                       ("FALSE"),
            .ALIGN_MCOMMA_VALUE                     (10'b1010000011),
            .ALIGN_PCOMMA_DET                       ("FALSE"),
            .ALIGN_PCOMMA_VALUE                     (10'b0101111100),
            .SHOW_REALIGN_COMMA                     ("FALSE"),
            .RXSLIDE_AUTO_WAIT                      (7),
            .RXSLIDE_MODE                           ("OFF"),
            .RX_SIG_VALID_DLY                       (10),
 
           //----------------RX 8B/10B Decoder Attributes---------------
            .RX_DISPERR_SEQ_MATCH                   ("FALSE"),
            .DEC_MCOMMA_DETECT                      ("FALSE"),
            .DEC_PCOMMA_DETECT                      ("FALSE"),
            .DEC_VALID_COMMA_ONLY                   ("FALSE"),
 
           //----------------------RX Clock Correction Attributes----------------------
            .CBCC_DATA_SOURCE_SEL                   ("ENCODED"),
            .CLK_COR_SEQ_2_USE                      ("FALSE"),
            .CLK_COR_KEEP_IDLE                      ("FALSE"),
            .CLK_COR_MAX_LAT                        (19),
            .CLK_COR_MIN_LAT                        (15),
            .CLK_COR_PRECEDENCE                     ("TRUE"),
            .CLK_COR_REPEAT_WAIT                    (0),
            .CLK_COR_SEQ_LEN                        (1),
            .CLK_COR_SEQ_1_ENABLE                   (4'b1111),
            .CLK_COR_SEQ_1_1                        (10'b0100000000),
            .CLK_COR_SEQ_1_2                        (10'b0000000000),
            .CLK_COR_SEQ_1_3                        (10'b0000000000),
            .CLK_COR_SEQ_1_4                        (10'b0000000000),
            .CLK_CORRECT_USE                        ("FALSE"),
            .CLK_COR_SEQ_2_ENABLE                   (4'b1111),
            .CLK_COR_SEQ_2_1                        (10'b0100000000),
            .CLK_COR_SEQ_2_2                        (10'b0000000000),
            .CLK_COR_SEQ_2_3                        (10'b0000000000),
            .CLK_COR_SEQ_2_4                        (10'b0000000000),
 
           //----------------------RX Channel Bonding Attributes----------------------
            .CHAN_BOND_KEEP_ALIGN                   ("FALSE"),
            .CHAN_BOND_MAX_SKEW                     (1),
            .CHAN_BOND_SEQ_LEN                      (1),
            .CHAN_BOND_SEQ_1_1                      (10'b0000000000),
            .CHAN_BOND_SEQ_1_2                      (10'b0000000000),
            .CHAN_BOND_SEQ_1_3                      (10'b0000000000),
            .CHAN_BOND_SEQ_1_4                      (10'b0000000000),
            .CHAN_BOND_SEQ_1_ENABLE                 (4'b1111),
            .CHAN_BOND_SEQ_2_1                      (10'b0000000000),
            .CHAN_BOND_SEQ_2_2                      (10'b0000000000),
            .CHAN_BOND_SEQ_2_3                      (10'b0000000000),
            .CHAN_BOND_SEQ_2_4                      (10'b0000000000),
            .CHAN_BOND_SEQ_2_ENABLE                 (4'b1111),
            .CHAN_BOND_SEQ_2_USE                    ("FALSE"),
            .FTS_DESKEW_SEQ_ENABLE                  (4'b1111),
            .FTS_LANE_DESKEW_CFG                    (4'b1111),
            .FTS_LANE_DESKEW_EN                     ("FALSE"),
 
           //-------------------------RX Margin Analysis Attributes----------------------------
            .ES_CONTROL                             (6'b000000),
            .ES_ERRDET_EN                           ("FALSE"),
            .ES_EYE_SCAN_EN                         ("TRUE"),
            .ES_HORZ_OFFSET                         (12'h000),
            .ES_PMA_CFG                             (10'b0000000000),
            .ES_PRESCALE                            (5'b00000),
            .ES_QUALIFIER                           (80'h00000000000000000000),
            .ES_QUAL_MASK                           (80'h00000000000000000000),
            .ES_SDATA_MASK                          (80'h00000000000000000000),
            .ES_VERT_OFFSET                         (9'b000000000),
 
           //-----------------------FPGA RX Interface Attributes-------------------------
            .RX_DATA_WIDTH                          (32),
 
           //-------------------------PMA Attributes----------------------------
            .OUTREFCLK_SEL_INV                      (2'b11),
            .PMA_RSV                                (PMA_RSV_IN),
            .PMA_RSV2                               (16'h2050),
            .PMA_RSV3                               (2'b00),
            .PMA_RSV4                               (32'h00000000),
            .RX_BIAS_CFG                            (12'b000000000100),
            .DMONITOR_CFG                           (24'h000A00),
            .RX_CM_SEL                              (2'b11),
            .RX_CM_TRIM                             (3'b010),
            .RX_DEBUG_CFG                           (12'b000000000000),
            .RX_OS_CFG                              (13'b0000010000000),
            .TERM_RCAL_CFG                          (5'b10000),
            .TERM_RCAL_OVRD                         (1'b0),
            .TST_RSV                                (32'h00000000),
            .RX_CLK25_DIV                           (7), 
            .TX_CLK25_DIV                           (7), 
            .UCODEER_CLR                            (1'b0),
 
           //-------------------------PCI Express Attributes----------------------------
            .PCS_PCIE_EN                            ("FALSE"),
 
           //-------------------------PCS Attributes----------------------------
            .PCS_RSVD_ATTR                          (PCS_RSVD_ATTR_IN),
 
           //-----------RX Buffer Attributes------------
            .RXBUF_ADDR_MODE                        ("FAST"),
            .RXBUF_EIDLE_HI_CNT                     (4'b1000),
            .RXBUF_EIDLE_LO_CNT                     (4'b0000),
            .RXBUF_EN                               ("TRUE"),
            .RX_BUFFER_CFG                          (6'b000000),
            .RXBUF_RESET_ON_CB_CHANGE               ("TRUE"),
            .RXBUF_RESET_ON_COMMAALIGN              ("FALSE"),
            .RXBUF_RESET_ON_EIDLE                   ("FALSE"),
            .RXBUF_RESET_ON_RATE_CHANGE             ("TRUE"),
            .RXBUFRESET_TIME                        (5'b00001),
            .RXBUF_THRESH_OVFLW                     (61),
            .RXBUF_THRESH_OVRD                      ("FALSE"),
            .RXBUF_THRESH_UNDFLW                    (4),
            .RXDLY_CFG                              (16'h001F),
            .RXDLY_LCFG                             (9'h030),
            .RXDLY_TAP_CFG                          (16'h0000),
            .RXPH_CFG                               (24'h000000),
            .RXPHDLY_CFG                            (24'h084020),
            .RXPH_MONITOR_SEL                       (5'b00000),
            .RX_XCLK_SEL                            ("RXREC"),
            .RX_DDI_SEL                             (6'b000000),
            .RX_DEFER_RESET_BUF_EN                  ("TRUE"),
 
           //---------------------CDR Attributes-------------------------
           .RXCDR_CFG                              (72'h03000023ff20400020),
           .RXCDR_FR_RESET_ON_EIDLE                (1'b0),
           .RXCDR_HOLD_DURING_EIDLE                (1'b0),
           .RXCDR_PH_RESET_ON_EIDLE                (1'b0),
           .RXCDR_LOCK_CFG                         (6'b010101),
 
           //-----------------RX Initialization and Reset Attributes-------------------
            .RXCDRFREQRESET_TIME                    (5'b00001),
            .RXCDRPHRESET_TIME                      (5'b00001),
            .RXISCANRESET_TIME                      (5'b00001),
            .RXPCSRESET_TIME                        (5'b00001),
            .RXPMARESET_TIME                        (5'b00011),
 
           //-----------------RX OOB Signaling Attributes-------------------
            .RXOOB_CFG                              (7'b0000110),
 
           //-----------------------RX Gearbox Attributes---------------------------
            .RXGEARBOX_EN                           ("TRUE"),
            .GEARBOX_MODE                           (3'b001),
 
           //-----------------------PRBS Detection Attribute-----------------------
            .RXPRBS_ERR_LOOPBACK                    (1'b0),
 
           //-----------Power-Down Attributes----------
            .PD_TRANS_TIME_FROM_P2                  (12'h03c),
            .PD_TRANS_TIME_NONE_P2                  (8'h19),
            .PD_TRANS_TIME_TO_P2                    (8'h64),
 
           //-----------RX OOB Signaling Attributes----------
            .SAS_MAX_COM                            (64),
            .SAS_MIN_COM                            (36),
            .SATA_BURST_SEQ_LEN                     (4'b0101),
            .SATA_BURST_VAL                         (3'b100),
            .SATA_EIDLE_VAL                         (3'b100),
            .SATA_MAX_BURST                         (8),
            .SATA_MAX_INIT                          (21),
            .SATA_MAX_WAKE                          (7),
            .SATA_MIN_BURST                         (4),
            .SATA_MIN_INIT                          (12),
            .SATA_MIN_WAKE                          (4),
 
           //-----------RX Fabric Clock Output Control Attributes----------
            .TRANS_TIME_RATE                        (8'h0E),
 
           //------------TX Buffer Attributes----------------
            .TXBUF_EN                               ("TRUE"),
            .TXBUF_RESET_ON_RATE_CHANGE             ("TRUE"),
            .TXDLY_CFG                              (16'h001F),
            .TXDLY_LCFG                             (9'h030),
            .TXDLY_TAP_CFG                          (16'h0000),
            .TXPH_CFG                               (16'h0780),
            .TXPHDLY_CFG                            (24'h084020),
            .TXPH_MONITOR_SEL                       (5'b00000),
            .TX_XCLK_SEL                            ("TXOUT"),
 
            //-----------------------FPGA TX Interface Attributes-------------------------
            .TX_DATA_WIDTH                          (64),
 
           //-----------------------TX Configurable Driver Attributes-------------------------
            .TX_DEEMPH0                             (5'b00000),
            .TX_DEEMPH1                             (5'b00000),
            .TX_EIDLE_ASSERT_DELAY                  (3'b110),
            .TX_EIDLE_DEASSERT_DELAY                (3'b100),
            .TX_LOOPBACK_DRIVE_HIZ                  ("FALSE"),
            .TX_MAINCURSOR_SEL                      (1'b0),
            .TX_DRIVE_MODE                          ("DIRECT"),
            .TX_MARGIN_FULL_0                       (7'b1001110),
            .TX_MARGIN_FULL_1                       (7'b1001001),
            .TX_MARGIN_FULL_2                       (7'b1000101),
            .TX_MARGIN_FULL_3                       (7'b1000010),
            .TX_MARGIN_FULL_4                       (7'b1000000),
            .TX_MARGIN_LOW_0                        (7'b1000110),
            .TX_MARGIN_LOW_1                        (7'b1000100),
            .TX_MARGIN_LOW_2                        (7'b1000010),
            .TX_MARGIN_LOW_3                        (7'b1000000),
            .TX_MARGIN_LOW_4                        (7'b1000000),
 
           //-----------------------TX Gearbox Attributes--------------------------
            .TXGEARBOX_EN                           ("TRUE"),
 
           //-----------------------TX Initialization and Reset Attributes--------------------------
            .TXPCSRESET_TIME                        (5'b00001),
            .TXPMARESET_TIME                        (5'b00001),
 
           //-----------------------TX Receiver Detection Attributes--------------------------
            .TX_RXDETECT_CFG                        (14'h1832),
            .TX_RXDETECT_REF                        (3'b100),
 
           //--------------------------CPLL Attributes----------------------------
            .CPLL_CFG                               (24'hBC07DC),
            .CPLL_FBDIV                             (4),
            .CPLL_FBDIV_45                          (5),
            .CPLL_INIT_CFG                          (24'h00001E),
            .CPLL_LOCK_CFG                          (16'h01E8),
            .CPLL_REFCLK_DIV                        (1),
            .RXOUT_DIV                              (1),
            .TXOUT_DIV                              (1),
            .SATA_CPLL_CFG                          ("VCO_3000MHZ"),
 
           //------------RX Initialization and Reset Attributes-------------
            .RXDFELPMRESET_TIME                     (7'b0001111),
 
           //------------RX Equalizer Attributes-------------
            .RXLPM_HF_CFG                           (14'b00000011110000),
            .RXLPM_LF_CFG                           (14'b00000011110000),
            .RX_DFE_GAIN_CFG                        (23'h020FEA),
            .RX_DFE_H2_CFG                          (12'b000000000000),
            .RX_DFE_H3_CFG                          (12'b000001000000),
            .RX_DFE_H4_CFG                          (11'b00011110000),
            .RX_DFE_H5_CFG                          (11'b00011100000),
            .RX_DFE_KL_CFG                          (13'b0000011111110),
            .RX_DFE_LPM_CFG                         (16'h0954),
            .RX_DFE_LPM_HOLD_DURING_EIDLE           (1'b0),
            .RX_DFE_UT_CFG                          (17'b10001111000000000),
            .RX_DFE_VP_CFG                          (17'b00011111100000011),
 
           //-----------------------Power-Down Attributes-------------------------
            .RX_CLKMUX_PD                           (1'b1),
            .TX_CLKMUX_PD                           (1'b1),
 
           //-----------------------FPGA RX Interface Attribute-------------------------
            .RX_INT_DATAWIDTH                       (1),
 
           //-----------------------FPGA TX Interface Attribute-------------------------
            .TX_INT_DATAWIDTH                       (1),
 
           //----------------TX Configurable Driver Attributes---------------
            .TX_QPI_STATUS_EN                       (1'b0),
 
           //-----------------------RX Equalizer Attributes--------------------------
            .RX_DFE_KL_CFG2                         (RX_DFE_KL_CFG2_IN),
            .RX_DFE_XYD_CFG                         (13'b0000000000000),
 
           //-----------------------TX Configurable Driver Attributes--------------------------
            .TX_PREDRIVER_MODE                      (1'b0)
           )
 
         gtxe2_i 
         (
        //------------------------------- CPLL Ports -------------------------------
        .CPLLFBCLKLOST                  (CPLLFBCLKLOST_OUT),
        .CPLLLOCK                       (CPLLLOCK_OUT),
        .CPLLLOCKDETCLK                 (CPLLLOCKDETCLK_IN),
        .CPLLLOCKEN                     (tied_to_vcc_i),
        .CPLLPD                         (cpll_pd_i),
        .CPLLREFCLKLOST                 (CPLLREFCLKLOST_OUT),
        .CPLLREFCLKSEL                  (3'b001),
        .CPLLRESET                      (cpll_reset_i),
        .GTRSVD                         (16'b0000000000000000),
        .PCSRSVDIN                      (16'b0000000000000000),
        .PCSRSVDIN2                     (5'b00000),
        .PMARSVDIN                      (5'b00000),
        .PMARSVDIN2                     (5'b00000),
        .TSTIN                          (20'b11111111111111111111),
        .TSTOUT                         (),
        //-------------------------------- Channel ---------------------------------
        .CLKRSVD                        (4'b0000),
       //------------------------ Channel - Clocking Ports ------------------------
        .GTGREFCLK                      (tied_to_ground_i),
        .GTNORTHREFCLK0                 (tied_to_ground_i),
        .GTNORTHREFCLK1                 (tied_to_ground_i),
        .GTREFCLK0                      (GTREFCLK0_IN),
        .GTREFCLK1                      (tied_to_ground_i),
        .GTSOUTHREFCLK0                 (tied_to_ground_i),
        .GTSOUTHREFCLK1                 (tied_to_ground_i),
        //-------------------------- Channel - DRP Ports  --------------------------
        .DRPADDR                        (drpaddr_in),
        .DRPCLK                         (drpclk_in),
        .DRPDI                          (drpdi_in),
        .DRPDO                          (drpdo_out),
        .DRPEN                          (drpen_in),
        .DRPRDY                         (drprdy_out),
        .DRPWE                          (drpwe_in),
        //----------------------------- Clocking Ports -----------------------------
        .GTREFCLKMONITOR                (),
        .QPLLCLK                        (QPLLCLK_IN),
        .QPLLREFCLK                     (QPLLREFCLK_IN),
        .RXSYSCLKSEL                    (2'b00),
        .TXSYSCLKSEL                    (2'b00),
        //------------------------- Digital Monitor Ports --------------------------
        .DMONITOROUT                    (gt_dmonitorout_out),
        //--------------- FPGA TX Interface Datapath Configuration  ----------------
        .TX8B10BEN                      (tied_to_ground_i),
        //----------------------------- Loopback Ports -----------------------------
        .LOOPBACK                       (LOOPBACK_IN),
        //--------------------------- PCI Express Ports ----------------------------
        .PHYSTATUS                      (),
        .RXRATE                         (tied_to_ground_vec_i[2:0]),
        .RXVALID                        (),
        //---------------------------- Power-Down Ports ----------------------------
        .RXPD                           (2'b00),
        .TXPD                           (2'b00),
        //------------------------ RX 8B/10B Decoder Ports -------------------------
        .SETERRSTATUS                   (tied_to_ground_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .EYESCANRESET                   (tied_to_ground_i),
        .RXUSERRDY                      (RXUSERRDY_IN),
        //------------------------ RX Margin Analysis Ports ------------------------
        .EYESCANDATAERROR               (eyescandataerror_out),
        .EYESCANMODE                    (tied_to_ground_i),
        .EYESCANTRIGGER                 (tied_to_ground_i),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .RXCDRFREQRESET                 (tied_to_ground_i),
        .RXCDRHOLD                      (rxcdrhold_in),
        .RXCDRLOCK                      (RXCDRLOCK_OUT),
        .RXCDROVRDEN                    (RXCDROVRDEN_IN),
        .RXCDRRESET                     (tied_to_ground_i),
        .RXCDRRESETRSV                  (tied_to_ground_i),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .RXCLKCORCNT                    (),
        //-------- Receive Ports - FPGA RX Interface Datapath Configuration --------
        .RX8B10BEN                      (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .RXUSRCLK                       (RXUSRCLK_IN),
        .RXUSRCLK2                      (RXUSRCLK2_IN),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .RXDATA                         (rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .RXPRBSERR                      (gt_rxprbserr_out),
        .RXPRBSSEL                      (gt_rxprbssel_in),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .RXPRBSCNTRESET                 (gt_rxprbscntreset_in),
        //------------------ Receive Ports - RX  Equalizer Ports -------------------
        .RXDFEXYDEN                     (tied_to_vcc_i),
        .RXDFEXYDHOLD                   (tied_to_ground_i),
        .RXDFEXYDOVRDEN                 (tied_to_ground_i),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .RXDISPERR                      (),
        .RXNOTINTABLE                   (),
        //------------------------- Receive Ports - RX AFE -------------------------
        .GTXRXN                         (GTXRXN_IN),
        .GTXRXP                         (GTXRXP_IN),
        .RXBUFRESET                     (gt_rxbufreset_in),
        .RXBUFSTATUS                    (RXBUFSTATUS_OUT),
        .RXDDIEN                        (tied_to_ground_i),
        .RXDLYBYPASS                    (tied_to_vcc_i),
        .RXDLYEN                        (tied_to_ground_i),
        .RXDLYOVRDEN                    (tied_to_ground_i),
        .RXDLYSRESET                    (tied_to_ground_i),
        .RXDLYSRESETDONE                (),
        .RXPHALIGN                      (tied_to_ground_i),
        .RXPHALIGNDONE                  (),
        .RXPHALIGNEN                    (tied_to_ground_i),
        .RXPHDLYPD                      (tied_to_ground_i),
        .RXPHDLYRESET                   (tied_to_ground_i),
        .RXPHMONITOR                    (),
        .RXPHOVRDEN                     (tied_to_ground_i),
        .RXPHSLIPMONITOR                (),
        .RXSTATUS                       (),
        //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
        .RXBYTEISALIGNED                (),
        .RXBYTEREALIGN                  (),
        .RXCOMMADET                     (),
        .RXCOMMADETEN                   (tied_to_ground_i),
        .RXMCOMMAALIGNEN                (tied_to_ground_i),
        .RXPCOMMAALIGNEN                (tied_to_ground_i),
        //---------------- Receive Ports - RX Channel Bonding Ports ----------------
        .RXCHANBONDSEQ                  (),
        .RXCHBONDEN                     (tied_to_ground_i),
        .RXCHBONDLEVEL                  (tied_to_ground_vec_i[2:0]),
        .RXCHBONDMASTER                 (tied_to_ground_i),
        .RXCHBONDO                      (),
        .RXCHBONDSLAVE                  (tied_to_ground_i),
        //--------------- Receive Ports - RX Channel Bonding Ports  ----------------
        .RXCHANISALIGNED                (),
        .RXCHANREALIGN                  (),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .RXDFEAGCHOLD                   (rxdfeagchold_in),
        .RXDFEAGCOVRDEN                 (rxdfeagcovrden_in),
        .RXDFECM1EN                     (tied_to_ground_i),
        .RXDFELFHOLD                    (rxdfelfhold_in),
        .RXDFELFOVRDEN                  (tied_to_vcc_i),
        .RXDFELPMRESET                  (rxdfelpmreset_in),
        .RXDFETAP2HOLD                  (tied_to_ground_i),
        .RXDFETAP2OVRDEN                (tied_to_ground_i),
        .RXDFETAP3HOLD                  (tied_to_ground_i),
        .RXDFETAP3OVRDEN                (tied_to_ground_i),
        .RXDFETAP4HOLD                  (tied_to_ground_i),
        .RXDFETAP4OVRDEN                (tied_to_ground_i),
        .RXDFETAP5HOLD                  (tied_to_ground_i),
        .RXDFETAP5OVRDEN                (tied_to_ground_i),
        .RXDFEUTHOLD                    (tied_to_ground_i),
        .RXDFEUTOVRDEN                  (tied_to_ground_i),
        .RXDFEVPHOLD                    (tied_to_ground_i),
        .RXDFEVPOVRDEN                  (tied_to_ground_i),
        .RXDFEVSEN                      (tied_to_ground_i),
        .RXLPMLFKLOVRDEN                (rxlpmlfklovrden_in),
        .RXMONITOROUT                   (rxmonitorout_out),
        .RXMONITORSEL                   (rxmonitorsel_in),
        .RXOSHOLD                       (tied_to_ground_i),
        .RXOSOVRDEN                     (tied_to_ground_i),
        //------------------- Receive Ports - RX Equilizer Ports -------------------
        .RXLPMHFHOLD                    (tied_to_ground_i),
        .RXLPMHFOVRDEN                  (rxlpmhfovrden_in),
        .RXLPMLFHOLD                    (tied_to_ground_i),
        //---------- Receive Ports - RX Fabric ClocK Output Control Ports ----------
        .RXRATEDONE                     (),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .RXOUTCLK                       (RXOUTCLK_OUT),
        .RXOUTCLKFABRIC                 (),
        .RXOUTCLKPCS                    (),
        .RXOUTCLKSEL                    (3'b010),
        .RXDATAVALID                    (RXDATAVALID_OUT),
        .RXHEADER                       ({rxheader_float_i,RXHEADER_OUT}),
        .RXHEADERVALID                  (RXHEADERVALID_OUT),
        .RXSTARTOFSEQ                   (),
        //------------------- Receive Ports - RX Gearbox Ports  --------------------
        .RXGEARBOXSLIP                  (RXGEARBOXSLIP_IN),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .GTRXRESET                      (GTRXRESET_IN),
        .RXOOBRESET                     (tied_to_ground_i),
        .RXPCSRESET                     (gt_rxpcsreset_in),
        .RXPMARESET                     (RXPMARESET_IN),
        //---------------- Receive Ports - RX Margin Analysis ports ----------------
        .RXLPMEN                        (rxlpmen_in),
        //----------------- Receive Ports - RX OOB Signaling ports -----------------
        .RXCOMSASDET                    (),
        .RXCOMWAKEDET                   (),
        //---------------- Receive Ports - RX OOB Signaling ports  -----------------
        .RXCOMINITDET                   (),
        //---------------- Receive Ports - RX OOB signalling Ports -----------------
        .RXELECIDLE                     (),
        .RXELECIDLEMODE                 (2'b11),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .RXPOLARITY                     (RX_POLARITY_IN),
        //-------------------- Receive Ports - RX gearbox ports --------------------
        .RXSLIDE                        (tied_to_ground_i),
        //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        .RXCHARISCOMMA                  (),
        .RXCHARISK                      (),
        //---------------- Receive Ports - Rx Channel Bonding Ports ----------------
        .RXCHBONDI                      (5'b00000),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .RXRESETDONE                    (RXRESETDONE_OUT),
        //------------------------------ Rx AFE Ports ------------------------------
        .RXQPIEN                        (tied_to_ground_i),
        .RXQPISENN                      (),
        .RXQPISENP                      (),
        //------------------------- TX Buffer Bypass Ports -------------------------
        .TXPHDLYTSTCLK                  (tied_to_ground_i),
        .TXPOSTCURSOR                   (txpostcursor_in),
        .TXPOSTCURSORINV                (tied_to_ground_i),
        .TXPRECURSOR                    (txprecursor_in  ),
        .TXPRECURSORINV                 (tied_to_ground_i),
        .TXQPIBIASEN                    (tied_to_ground_i),
        .TXQPISTRONGPDOWN               (tied_to_ground_i),
        .TXQPIWEAKPUP                   (tied_to_ground_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .CFGRESET                       (tied_to_ground_i),
        .GTTXRESET                      (GTTXRESET_IN),
        .PCSRSVDOUT                     (),
        .TXUSERRDY                      (TXUSERRDY_IN),
        //-------------------- Transceiver Reset Mode Operation --------------------
        .GTRESETSEL                     (tied_to_ground_i),
        .RESETOVRD                      (tied_to_ground_i),
        //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        .TXCHARDISPMODE                 (tied_to_ground_vec_i[7:0]),
        .TXCHARDISPVAL                  (tied_to_ground_vec_i[7:0]),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .TXUSRCLK                       (TXUSRCLK_IN),
        .TXUSRCLK2                      (TXUSRCLK2_IN),
        //------------------- Transmit Ports - PCI Express Ports -------------------
        .TXELECIDLE                     (tied_to_ground_i),
        .TXMARGIN                       (tied_to_ground_vec_i[2:0]),
        .TXRATE                         (tied_to_ground_vec_i[2:0]),
        .TXSWING                        (tied_to_ground_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .TXPRBSFORCEERR                 (gt_txprbsforceerr_in),
        //---------------- Transmit Ports - TX Buffer Bypass Ports -----------------
        .TXDLYBYPASS                    (tied_to_vcc_i),
        .TXDLYEN                        (tied_to_ground_i),
        .TXDLYHOLD                      (tied_to_ground_i),
        .TXDLYOVRDEN                    (tied_to_ground_i),
        .TXDLYSRESET                    (tied_to_ground_i),
        .TXDLYSRESETDONE                (),
        .TXDLYUPDOWN                    (tied_to_ground_i),
        .TXPHALIGN                      (tied_to_ground_i),
        .TXPHALIGNDONE                  (),
        .TXPHALIGNEN                    (tied_to_ground_i),
        .TXPHDLYPD                      (tied_to_ground_i),
        .TXPHDLYRESET                   (tied_to_ground_i),
        .TXPHINIT                       (tied_to_ground_i),
        .TXPHINITDONE                   (),
        .TXPHOVRDEN                     (tied_to_ground_i),
        //-------------------- Transmit Ports - TX Buffer Ports --------------------
        .TXBUFSTATUS                    (gt_txbufstatus_out),
        //------------- Transmit Ports - TX Configurable Driver Ports --------------
        .TXBUFDIFFCTRL                  (3'b100),
        .TXDEEMPH                       (tied_to_ground_i),
        .TXDIFFCTRL                     (txdiffctrl_in),
        .TXDIFFPD                       (tied_to_ground_i),
        .TXINHIBIT                     (txinhibit_in),
        .TXMAINCURSOR                   (txmaincursor_in),
        .TXPISOPD                       (tied_to_ground_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA                         (txdata_i),
        .GTXTXN                         (GTXTXN_OUT),
        .GTXTXP                         (GTXTXP_OUT),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .TXOUTCLK                       (TXOUTCLK_OUT),
        .TXOUTCLKFABRIC                 (TXOUTCLKFABRIC_OUT),
        .TXOUTCLKPCS                    (TXOUTCLKPCS_OUT),
        .TXOUTCLKSEL                    (3'b010),
        .TXRATEDONE                     (),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .TXCHARISK                      (tied_to_ground_vec_i[7:0]),
        .TXGEARBOXREADY                 (),
        .TXHEADER                       ({tied_to_ground_i,TXHEADER_IN}),
        .TXSEQUENCE                     (TXSEQUENCE_IN),
        .TXSTARTSEQ                     (tied_to_ground_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .TXPCSRESET                     (gt_txpcsreset_in),
        .TXPMARESET                     (gt_txpmareset_in),
        .TXRESETDONE                    (TXRESETDONE_OUT),
        //---------------- Transmit Ports - TX OOB signalling Ports ----------------
        .TXCOMFINISH                    (),
        .TXCOMINIT                      (tied_to_ground_i),
        .TXCOMSAS                       (tied_to_ground_i),
        .TXCOMWAKE                      (tied_to_ground_i),
        .TXPDELECIDLEMODE               (tied_to_ground_i),
        //--------------- Transmit Ports - TX Polarity Control Ports ---------------
        .TXPOLARITY                     (txpolarity_in),
        //------------- Transmit Ports - TX Receiver Detection Ports  --------------
        .TXDETECTRX                     (tied_to_ground_i),
        //---------------- Transmit Ports - TX8b/10b Encoder Ports -----------------
        .TX8B10BBYPASS                  (tied_to_ground_vec_i[7:0]),
        .TXPRBSSEL                      (gt_txprbssel_in),
        .TXQPISENN                      (),
        .TXQPISENP                      ()
      );
      
always @(posedge GTREFCLK0_IN)
begin
  cpllpd_wait <= {cpllpd_wait[94:0], 1'b0};
  cpllreset_wait <= {cpllreset_wait[126:0], 1'b0};
end

assign cpllpd_ovrd_i = cpllpd_wait[95];
assign cpllreset_ovrd_i = cpllreset_wait[127];

assign cpll_pd_i = cpllpd_ovrd_i;
always @(posedge CPLLLOCKDETCLK_IN)
begin
if(CPLLRESET_IN == 1'b1 && ack_flag == 1'b0)
begin
    flag <= !flag;
    flag2 <= 1'b1;
end
else
begin
    flag <= flag; 
    flag2 <= 1'b0;
end
end


always @(posedge CPLLLOCKDETCLK_IN)
begin
if(flag2 == 1'b1)
 ack_flag <= 1'b1;
else if(ack_i == 1'b1)
 ack_flag <= 1'b0;
end



  (* shreg_extract = "no", ASYNC_REG = "TRUE" *)
  FD #(
    .INIT (1'b0)
  ) data_sync_reg1 (
    .C  (GTREFCLK0_IN),
    .D  (flag),
    .Q  (data_sync1)
  );


  (* shreg_extract = "no", ASYNC_REG = "TRUE" *)
  FD #(
   .INIT (1'b0)
  ) data_sync_reg2 (
  .C  (GTREFCLK0_IN),
  .D  (data_sync1),
  .Q  (data_sync2)
  );


  (* shreg_extract = "no", ASYNC_REG = "TRUE" *)
  FD #(
   .INIT (1'b0)
  ) data_sync_reg3 (
  .C  (GTREFCLK0_IN),
  .D  (data_sync2),
  .Q  (data_sync3)
  );

  (* shreg_extract = "no", ASYNC_REG = "TRUE" *)
  FD #(
   .INIT (1'b0)
  ) data_sync_reg4 (
  .C  (GTREFCLK0_IN),
  .D  (data_sync3),
  .Q  (data_sync4)
  );

  (* shreg_extract = "no", ASYNC_REG = "TRUE" *)
  FD #(
   .INIT (1'b0)
  ) data_sync_reg5 (
  .C  (GTREFCLK0_IN),
  .D  (data_sync4),
  .Q  (data_sync5)
  );

  (* shreg_extract = "no", ASYNC_REG = "TRUE" *)
  FD #(
   .INIT (1'b0)
  ) data_sync_reg6 (
  .C  (GTREFCLK0_IN),
  .D  (data_sync5),
  .Q  (data_sync6)
  );

assign cpllreset_sync = data_sync5 ^ data_sync6;

  (* shreg_extract = "no", ASYNC_REG = "TRUE" *)
  FD #(
   .INIT (1'b0)
  ) ack_sync_reg1 (
  .C  (CPLLLOCKDETCLK_IN),
  .D  (data_sync6),
  .Q  (ack_sync1)
  );

  (* shreg_extract = "no", ASYNC_REG = "TRUE" *)
  FD #(
   .INIT (1'b0)
  ) ack_sync_reg2 (
  .C  (CPLLLOCKDETCLK_IN),
  .D  (ack_sync1),
  .Q  (ack_sync2)
  );

  (* shreg_extract = "no", ASYNC_REG = "TRUE" *)
  FD #(
   .INIT (1'b0)
  ) ack_sync_reg3 (
  .C  (CPLLLOCKDETCLK_IN),
  .D  (ack_sync2),
  .Q  (ack_sync3)
  );

  (* shreg_extract = "no", ASYNC_REG = "TRUE" *)
  FD #(
   .INIT (1'b0)
  ) ack_sync_reg4 (
  .C  (CPLLLOCKDETCLK_IN),
  .D  (ack_sync3),
  .Q  (ack_sync4)
  );

  (* shreg_extract = "no", ASYNC_REG = "TRUE" *)
  FD #(
   .INIT (1'b0)
  ) ack_sync_reg5 (
  .C  (CPLLLOCKDETCLK_IN),
  .D  (ack_sync4),
  .Q  (ack_sync5)
  );

  (* shreg_extract = "no", ASYNC_REG = "TRUE" *)
  FD #(
   .INIT (1'b0)
  ) ack_sync_reg6 (
  .C  (CPLLLOCKDETCLK_IN),
  .D  (ack_sync5),
  .Q  (ack_sync6)
  );

assign ack_i = ack_sync5 ^ ack_sync6;

assign cpll_reset_i = cpllreset_sync || cpllreset_ovrd_i;

 endmodule     
 
 
