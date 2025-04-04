 ///////////////////////////////////////////////////////////////////////////////
 //
 // Project:  Aurora 64B/66B
 // Company:  Xilinx
 //
 //
 //
 // (c) Copyright 2008 - 2009 Xilinx, Inc. All rights reserved.
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
 
 //
 //
 ////////////////////////////////////////////////////////////////////////////////
 // Design Name: aurora_64b66b_lan4_framing_MULTI_GT
 //
 
 `timescale 1ns / 1ps

   (* core_generation_info = "aurora_64b66b_lan4_framing,aurora_64b66b_v11_2_6,{c_aurora_lanes=4,c_column_used=left,c_gt_clock_1=GTXQ0,c_gt_clock_2=None,c_gt_loc_1=1,c_gt_loc_10=X,c_gt_loc_11=X,c_gt_loc_12=X,c_gt_loc_13=X,c_gt_loc_14=X,c_gt_loc_15=X,c_gt_loc_16=X,c_gt_loc_17=X,c_gt_loc_18=X,c_gt_loc_19=X,c_gt_loc_2=2,c_gt_loc_20=X,c_gt_loc_21=X,c_gt_loc_22=X,c_gt_loc_23=X,c_gt_loc_24=X,c_gt_loc_25=X,c_gt_loc_26=X,c_gt_loc_27=X,c_gt_loc_28=X,c_gt_loc_29=X,c_gt_loc_3=3,c_gt_loc_30=X,c_gt_loc_31=X,c_gt_loc_32=X,c_gt_loc_33=X,c_gt_loc_34=X,c_gt_loc_35=X,c_gt_loc_36=X,c_gt_loc_37=X,c_gt_loc_38=X,c_gt_loc_39=X,c_gt_loc_4=4,c_gt_loc_40=X,c_gt_loc_41=X,c_gt_loc_42=X,c_gt_loc_43=X,c_gt_loc_44=X,c_gt_loc_45=X,c_gt_loc_46=X,c_gt_loc_47=X,c_gt_loc_48=X,c_gt_loc_5=X,c_gt_loc_6=X,c_gt_loc_7=X,c_gt_loc_8=X,c_gt_loc_9=X,c_lane_width=4,c_line_rate=6.25,c_gt_type=gtx,c_qpll=false,c_nfc=false,c_nfc_mode=IMM,c_refclk_frequency=156.25,c_simplex=false,c_simplex_mode=TX,c_stream=false,c_ufc=false,c_user_k=false,flow_mode=None,interface_mode=Framing,dataflow_config=Duplex}" *) 
(* DowngradeIPIdentifiedWarnings="yes" *) 
 module aurora_64b66b_lan4_framing_MULTI_GT #
 (
    // Simulation attributes
    parameter   WRAPPER_SIM_GTRESET_SPEEDUP    =   "true",     // Set to "true" to speed up sim reset
    parameter   RX_DFE_KL_CFG2_IN              =   32'h301148AC,
    parameter   PMA_RSV_IN                     =   32'h00018480,
    parameter   SIM_VERSION                    =   "4.0"
 )
 `define DLY #1
 (
//---{
    input                     gt_qpllclk_quad1_in,
    input                     gt_qpllrefclk_quad1_in,
//---}
    //____________________________CHANNEL PORTS________________________________
    //------------------------------- CPLL Ports -------------------------------
    output          GT0_CPLLFBCLKLOST_OUT,
    output          GT0_CPLLLOCK_OUT,
    input           GT0_CPLLLOCKDETCLK_IN,
    output          GT0_CPLLREFCLKLOST_OUT,
    input           GT0_CPLLRESET_IN,
    //------------------------ Channel - Clocking Ports ------------------------
    input           GT0_GTREFCLK0_IN,
    //-------------------------- Channel - DRP Ports  --------------------------
    input  [8:0]    gt0_drpaddr_in,
    input           gt0_drp_clk_in,
    input  [15:0]   gt0_drpdi_in,
    output [15:0]   gt0_drpdo_out,
    input           gt0_drpen_in,
    output          gt0_drprdy_out,
    input           gt0_drpwe_in,
    //----------------------------- Loopback Ports -----------------------------
    input  [2:0]    GT0_LOOPBACK_IN,
    //------------------- RX Initialization and Reset Ports --------------------
    input           GT0_eyescanreset_in,
    input           GT0_RXUSERRDY_IN,
    input           GT0_RX_POLARITY_IN,
    //------------------------ RX Margin Analysis Ports ------------------------
    output          GT0_eyescandataerror_out,
    input           GT0_eyescantrigger_in,
    //----------------------- Receive Ports - CDR Ports ------------------------
    input          GT0_RXCDROVRDEN_IN,
    input          GT0_rxcdrhold_in,
    //---------------- Receive Ports - FPGA RX Interface Ports -----------------
    input           GT0_RXUSRCLK_IN,
    input           GT0_RXUSRCLK2_IN,
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    output  [31:0]  GT0_RXDATA_OUT,
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    input           GT0_GTXRXN_IN,
    input           GT0_GTXRXP_IN,
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    output  [2:0]   GT0_RXBUFSTATUS_OUT,
    //------------------ Receive Ports - RX Equailizer Ports -------------------
    input           GT0_rxlpmhfovrden_in,
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    input           GT0_rxdfeagchold_in,
    input           GT0_rxdfeagcovrden_in,
    input           GT0_rxdfelfhold_in,
    input           GT0_rxdfelpmreset_in,
    input           GT0_rxlpmlfklovrden_in,
    output  [6:0]   GT0_rxmonitorout_out,
    input   [1:0]   GT0_rxmonitorsel_in,
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    output          GT0_RXOUTCLK_OUT,
    //-------------------- Receive Ports - RX Gearbox Ports --------------------
    output          GT0_RXDATAVALID_OUT,
    output [1:0]    GT0_RXHEADER_OUT,
    output          GT0_RXHEADERVALID_OUT,
    //------------------- Receive Ports - RX Gearbox Ports  --------------------
    input           GT0_RXGEARBOXSLIP_IN,
    //---------------- Receive Ports - RX Margin Analysis ports ----------------
    input           GT0_rxlpmen_in,
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    input           GT0_GTRXRESET_IN,
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    output          GT0_RXRESETDONE_OUT,
    //---------------------- TX Configurable Driver Ports ----------------------
    input   [4:0]   GT0_txpostcursor_in,
    //------------------- TX Initialization and Reset Ports --------------------
    input           GT0_GTTXRESET_IN,
    input           GT0_TXUSERRDY_IN,
    //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
    input           GT0_TXUSRCLK_IN, 
    input           GT0_TXUSRCLK2_IN,
    //------------- Transmit Ports - TX Configurable Driver Ports --------------
    input   [3:0]   GT0_txdiffctrl_in,
    input   [6:0]   GT0_txmaincursor_in,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input  [63:0]   GT0_TXDATA_IN,
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    output          GT0_GTXTXN_OUT,
    output          GT0_GTXTXP_OUT,
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    output          GT0_TXOUTCLK_OUT,
    output          GT0_TXOUTCLKFABRIC_OUT,
    output          GT0_TXOUTCLKPCS_OUT,
    //---------------  ---- Transmit Ports - TX Gearbox Ports --------------------
    input  [1:0]    GT0_TXHEADER_IN,
    input  [6:0]    GT0_TXSEQUENCE_IN,
    //--------------- Transmit Ports - TX Polarity Control Ports ---------------
    input           GT0_txpolarity_in,
    input           gt0_txinhibit_in,
    input           gt0_txpmareset_in,
    input           gt0_txpcsreset_in,
    input           gt0_rxpcsreset_in,
    input           gt0_rxbufreset_in,
    input   [4:0]   gt0_txprecursor_in,
    input   [2:0]   gt0_txprbssel_in,
    input   [2:0]   gt0_rxprbssel_in,
    input           gt0_txprbsforceerr_in,
    output          gt0_rxprbserr_out,
    input           gt0_rxprbscntreset_in,
    output  [ 7:0]  gt0_dmonitorout_out,
    output  [1:0]   gt0_txbufstatus_out,
    input           gt0_RXPMARESET_IN,
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    output          GT0_TXRESETDONE_OUT,

    output          GT1_CPLLFBCLKLOST_OUT,
    output          GT1_CPLLLOCK_OUT,
    input           GT1_CPLLLOCKDETCLK_IN,
    output          GT1_CPLLREFCLKLOST_OUT,
    input           GT1_CPLLRESET_IN,
    //------------------------ Channel - Clocking Ports ------------------------
    input           GT1_GTREFCLK0_IN,
    //-------------------------- Channel - DRP Ports  --------------------------
    input  [8:0]    gt1_drpaddr_in,
    input           gt1_drp_clk_in,
    input  [15:0]   gt1_drpdi_in,
    output [15:0]   gt1_drpdo_out,
    input           gt1_drpen_in,
    output          gt1_drprdy_out,
    input           gt1_drpwe_in,
    //----------------------------- Loopback Ports -----------------------------
    input  [2:0]    GT1_LOOPBACK_IN,
    //------------------- RX Initialization and Reset Ports --------------------
    input           GT1_eyescanreset_in,
    input           GT1_RXUSERRDY_IN,
    input           GT1_RX_POLARITY_IN,
    //------------------------ RX Margin Analysis Ports ------------------------
    output          GT1_eyescandataerror_out,
    input           GT1_eyescantrigger_in,
    //----------------------- Receive Ports - CDR Ports ------------------------
    input          GT1_RXCDROVRDEN_IN,
    input          GT1_rxcdrhold_in,
    //---------------- Receive Ports - FPGA RX Interface Ports -----------------
    input           GT1_RXUSRCLK_IN,
    input           GT1_RXUSRCLK2_IN,
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    output  [31:0]  GT1_RXDATA_OUT,
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    input           GT1_GTXRXN_IN,
    input           GT1_GTXRXP_IN,
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    output  [2:0]   GT1_RXBUFSTATUS_OUT,
    //------------------ Receive Ports - RX Equailizer Ports -------------------
    input           GT1_rxlpmhfovrden_in,
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    input           GT1_rxdfeagchold_in,
    input           GT1_rxdfeagcovrden_in,
    input           GT1_rxdfelfhold_in,
    input           GT1_rxdfelpmreset_in,
    input           GT1_rxlpmlfklovrden_in,
    output  [6:0]   GT1_rxmonitorout_out,
    input   [1:0]   GT1_rxmonitorsel_in,
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    output          GT1_RXOUTCLK_OUT,
    //-------------------- Receive Ports - RX Gearbox Ports --------------------
    output          GT1_RXDATAVALID_OUT,
    output [1:0]    GT1_RXHEADER_OUT,
    output          GT1_RXHEADERVALID_OUT,
    //------------------- Receive Ports - RX Gearbox Ports  --------------------
    input           GT1_RXGEARBOXSLIP_IN,
    //---------------- Receive Ports - RX Margin Analysis ports ----------------
    input           GT1_rxlpmen_in,
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    input           GT1_GTRXRESET_IN,
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    output          GT1_RXRESETDONE_OUT,
    //---------------------- TX Configurable Driver Ports ----------------------
    input   [4:0]   GT1_txpostcursor_in,
    //------------------- TX Initialization and Reset Ports --------------------
    input           GT1_GTTXRESET_IN,
    input           GT1_TXUSERRDY_IN,
    //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
    input           GT1_TXUSRCLK_IN, 
    input           GT1_TXUSRCLK2_IN,
    //------------- Transmit Ports - TX Configurable Driver Ports --------------
    input   [3:0]   GT1_txdiffctrl_in,
    input   [6:0]   GT1_txmaincursor_in,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input  [63:0]   GT1_TXDATA_IN,
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    output          GT1_GTXTXN_OUT,
    output          GT1_GTXTXP_OUT,
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    output          GT1_TXOUTCLK_OUT,
    output          GT1_TXOUTCLKFABRIC_OUT,
    output          GT1_TXOUTCLKPCS_OUT,
    //---------------  ---- Transmit Ports - TX Gearbox Ports --------------------
    input  [1:0]    GT1_TXHEADER_IN,
    input  [6:0]    GT1_TXSEQUENCE_IN,
    //--------------- Transmit Ports - TX Polarity Control Ports ---------------
    input           GT1_txpolarity_in,
    input           gt1_txinhibit_in,
    input           gt1_txpmareset_in,
    input           gt1_txpcsreset_in,
    input           gt1_rxpcsreset_in,
    input           gt1_rxbufreset_in,
    input   [4:0]   gt1_txprecursor_in,
    input   [2:0]   gt1_txprbssel_in,
    input   [2:0]   gt1_rxprbssel_in,
    input           gt1_txprbsforceerr_in,
    output          gt1_rxprbserr_out,
    input           gt1_rxprbscntreset_in,
    output  [ 7:0]  gt1_dmonitorout_out,
    output  [1:0]   gt1_txbufstatus_out,
    input           gt1_RXPMARESET_IN,
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    output          GT1_TXRESETDONE_OUT,

    output          GT2_CPLLFBCLKLOST_OUT,
    output          GT2_CPLLLOCK_OUT,
    input           GT2_CPLLLOCKDETCLK_IN,
    output          GT2_CPLLREFCLKLOST_OUT,
    input           GT2_CPLLRESET_IN,
    //------------------------ Channel - Clocking Ports ------------------------
    input           GT2_GTREFCLK0_IN,
    //-------------------------- Channel - DRP Ports  --------------------------
    input  [8:0]    gt2_drpaddr_in,
    input           gt2_drp_clk_in,
    input  [15:0]   gt2_drpdi_in,
    output [15:0]   gt2_drpdo_out,
    input           gt2_drpen_in,
    output          gt2_drprdy_out,
    input           gt2_drpwe_in,
    //----------------------------- Loopback Ports -----------------------------
    input  [2:0]    GT2_LOOPBACK_IN,
    //------------------- RX Initialization and Reset Ports --------------------
    input           GT2_eyescanreset_in,
    input           GT2_RXUSERRDY_IN,
    input           GT2_RX_POLARITY_IN,
    //------------------------ RX Margin Analysis Ports ------------------------
    output          GT2_eyescandataerror_out,
    input           GT2_eyescantrigger_in,
    //----------------------- Receive Ports - CDR Ports ------------------------
    input          GT2_RXCDROVRDEN_IN,
    input          GT2_rxcdrhold_in,
    //---------------- Receive Ports - FPGA RX Interface Ports -----------------
    input           GT2_RXUSRCLK_IN,
    input           GT2_RXUSRCLK2_IN,
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    output  [31:0]  GT2_RXDATA_OUT,
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    input           GT2_GTXRXN_IN,
    input           GT2_GTXRXP_IN,
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    output  [2:0]   GT2_RXBUFSTATUS_OUT,
    //------------------ Receive Ports - RX Equailizer Ports -------------------
    input           GT2_rxlpmhfovrden_in,
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    input           GT2_rxdfeagchold_in,
    input           GT2_rxdfeagcovrden_in,
    input           GT2_rxdfelfhold_in,
    input           GT2_rxdfelpmreset_in,
    input           GT2_rxlpmlfklovrden_in,
    output  [6:0]   GT2_rxmonitorout_out,
    input   [1:0]   GT2_rxmonitorsel_in,
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    output          GT2_RXOUTCLK_OUT,
    //-------------------- Receive Ports - RX Gearbox Ports --------------------
    output          GT2_RXDATAVALID_OUT,
    output [1:0]    GT2_RXHEADER_OUT,
    output          GT2_RXHEADERVALID_OUT,
    //------------------- Receive Ports - RX Gearbox Ports  --------------------
    input           GT2_RXGEARBOXSLIP_IN,
    //---------------- Receive Ports - RX Margin Analysis ports ----------------
    input           GT2_rxlpmen_in,
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    input           GT2_GTRXRESET_IN,
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    output          GT2_RXRESETDONE_OUT,
    //---------------------- TX Configurable Driver Ports ----------------------
    input   [4:0]   GT2_txpostcursor_in,
    //------------------- TX Initialization and Reset Ports --------------------
    input           GT2_GTTXRESET_IN,
    input           GT2_TXUSERRDY_IN,
    //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
    input           GT2_TXUSRCLK_IN, 
    input           GT2_TXUSRCLK2_IN,
    //------------- Transmit Ports - TX Configurable Driver Ports --------------
    input   [3:0]   GT2_txdiffctrl_in,
    input   [6:0]   GT2_txmaincursor_in,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input  [63:0]   GT2_TXDATA_IN,
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    output          GT2_GTXTXN_OUT,
    output          GT2_GTXTXP_OUT,
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    output          GT2_TXOUTCLK_OUT,
    output          GT2_TXOUTCLKFABRIC_OUT,
    output          GT2_TXOUTCLKPCS_OUT,
    //---------------  ---- Transmit Ports - TX Gearbox Ports --------------------
    input  [1:0]    GT2_TXHEADER_IN,
    input  [6:0]    GT2_TXSEQUENCE_IN,
    //--------------- Transmit Ports - TX Polarity Control Ports ---------------
    input           GT2_txpolarity_in,
    input           gt2_txinhibit_in,
    input           gt2_txpmareset_in,
    input           gt2_txpcsreset_in,
    input           gt2_rxpcsreset_in,
    input           gt2_rxbufreset_in,
    input   [4:0]   gt2_txprecursor_in,
    input   [2:0]   gt2_txprbssel_in,
    input   [2:0]   gt2_rxprbssel_in,
    input           gt2_txprbsforceerr_in,
    output          gt2_rxprbserr_out,
    input           gt2_rxprbscntreset_in,
    output  [ 7:0]  gt2_dmonitorout_out,
    output  [1:0]   gt2_txbufstatus_out,
    input           gt2_RXPMARESET_IN,
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    output          GT2_TXRESETDONE_OUT,

    output          GT3_CPLLFBCLKLOST_OUT,
    output          GT3_CPLLLOCK_OUT,
    input           GT3_CPLLLOCKDETCLK_IN,
    output          GT3_CPLLREFCLKLOST_OUT,
    input           GT3_CPLLRESET_IN,
    //------------------------ Channel - Clocking Ports ------------------------
    input           GT3_GTREFCLK0_IN,
    //-------------------------- Channel - DRP Ports  --------------------------
    input  [8:0]    gt3_drpaddr_in,
    input           gt3_drp_clk_in,
    input  [15:0]   gt3_drpdi_in,
    output [15:0]   gt3_drpdo_out,
    input           gt3_drpen_in,
    output          gt3_drprdy_out,
    input           gt3_drpwe_in,
    //----------------------------- Loopback Ports -----------------------------
    input  [2:0]    GT3_LOOPBACK_IN,
    //------------------- RX Initialization and Reset Ports --------------------
    input           GT3_eyescanreset_in,
    input           GT3_RXUSERRDY_IN,
    input           GT3_RX_POLARITY_IN,
    //------------------------ RX Margin Analysis Ports ------------------------
    output          GT3_eyescandataerror_out,
    input           GT3_eyescantrigger_in,
    //----------------------- Receive Ports - CDR Ports ------------------------
    input          GT3_RXCDROVRDEN_IN,
    input          GT3_rxcdrhold_in,
    //---------------- Receive Ports - FPGA RX Interface Ports -----------------
    input           GT3_RXUSRCLK_IN,
    input           GT3_RXUSRCLK2_IN,
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    output  [31:0]  GT3_RXDATA_OUT,
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    input           GT3_GTXRXN_IN,
    input           GT3_GTXRXP_IN,
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    output  [2:0]   GT3_RXBUFSTATUS_OUT,
    //------------------ Receive Ports - RX Equailizer Ports -------------------
    input           GT3_rxlpmhfovrden_in,
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    input           GT3_rxdfeagchold_in,
    input           GT3_rxdfeagcovrden_in,
    input           GT3_rxdfelfhold_in,
    input           GT3_rxdfelpmreset_in,
    input           GT3_rxlpmlfklovrden_in,
    output  [6:0]   GT3_rxmonitorout_out,
    input   [1:0]   GT3_rxmonitorsel_in,
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    output          GT3_RXOUTCLK_OUT,
    //-------------------- Receive Ports - RX Gearbox Ports --------------------
    output          GT3_RXDATAVALID_OUT,
    output [1:0]    GT3_RXHEADER_OUT,
    output          GT3_RXHEADERVALID_OUT,
    //------------------- Receive Ports - RX Gearbox Ports  --------------------
    input           GT3_RXGEARBOXSLIP_IN,
    //---------------- Receive Ports - RX Margin Analysis ports ----------------
    input           GT3_rxlpmen_in,
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    input           GT3_GTRXRESET_IN,
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    output          GT3_RXRESETDONE_OUT,
    //---------------------- TX Configurable Driver Ports ----------------------
    input   [4:0]   GT3_txpostcursor_in,
    //------------------- TX Initialization and Reset Ports --------------------
    input           GT3_GTTXRESET_IN,
    input           GT3_TXUSERRDY_IN,
    //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
    input           GT3_TXUSRCLK_IN, 
    input           GT3_TXUSRCLK2_IN,
    //------------- Transmit Ports - TX Configurable Driver Ports --------------
    input   [3:0]   GT3_txdiffctrl_in,
    input   [6:0]   GT3_txmaincursor_in,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input  [63:0]   GT3_TXDATA_IN,
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    output          GT3_GTXTXN_OUT,
    output          GT3_GTXTXP_OUT,
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    output          GT3_TXOUTCLK_OUT,
    output          GT3_TXOUTCLKFABRIC_OUT,
    output          GT3_TXOUTCLKPCS_OUT,
    //---------------  ---- Transmit Ports - TX Gearbox Ports --------------------
    input  [1:0]    GT3_TXHEADER_IN,
    input  [6:0]    GT3_TXSEQUENCE_IN,
    //--------------- Transmit Ports - TX Polarity Control Ports ---------------
    input           GT3_txpolarity_in,
    input           gt3_txinhibit_in,
    input           gt3_txpmareset_in,
    input           gt3_txpcsreset_in,
    input           gt3_rxpcsreset_in,
    input           gt3_rxbufreset_in,
    input   [4:0]   gt3_txprecursor_in,
    input   [2:0]   gt3_txprbssel_in,
    input   [2:0]   gt3_rxprbssel_in,
    input           gt3_txprbsforceerr_in,
    output          gt3_rxprbserr_out,
    input           gt3_rxprbscntreset_in,
    output  [ 7:0]  gt3_dmonitorout_out,
    output  [1:0]   gt3_txbufstatus_out,
    input           gt3_RXPMARESET_IN,
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    output          GT3_TXRESETDONE_OUT

 );

 //***************************** Wire Declarations *****************************
     // Ground and VCC signals
     wire                    tied_to_ground_i;
     wire    [63:0]          tied_to_ground_vec_i;
     wire                    tied_to_vcc_i;
 //********************************* Main Body of Code**************************
     //-------------------------  Static signal Assigments ---------------------   
     assign tied_to_ground_i             = 1'b0;
     assign tied_to_ground_vec_i         = 64'h0000000000000000;
     assign tied_to_vcc_i             = 1'b1;
 
 
 
     //*************************************************************************************************
     //-----------------------------------GT INSTANCE-----------------------------------------------
     //*************************************************************************************************
aurora_64b66b_lan4_framing_GTX # 
     (
        // Simulation attributes
        .GT_SIM_GTRESET_SPEEDUP   (WRAPPER_SIM_GTRESET_SPEEDUP),
        .SIM_VERSION              (SIM_VERSION),
        .RX_DFE_KL_CFG2_IN        (RX_DFE_KL_CFG2_IN),
        .PCS_RSVD_ATTR_IN         (48'h000000000000),
        .PMA_RSV_IN               (PMA_RSV_IN)
     ) 
aurora_64b66b_lan4_framing_gtx_inst
     (
        //------------------------------- CPLL Ports -------------------------------
        .CPLLFBCLKLOST_OUT          (GT0_CPLLFBCLKLOST_OUT),
        .CPLLLOCK_OUT               (GT0_CPLLLOCK_OUT),
        .CPLLLOCKDETCLK_IN          (GT0_CPLLLOCKDETCLK_IN),
        .CPLLREFCLKLOST_OUT         (GT0_CPLLREFCLKLOST_OUT),
        .CPLLRESET_IN               (GT0_CPLLRESET_IN),
        //------------------------ Channel - Clocking Ports ------------------------
        .GTREFCLK0_IN               (GT0_GTREFCLK0_IN),
        .drpaddr_in                 (gt0_drpaddr_in),
        .drpclk_in                  (gt0_drp_clk_in),
        .drpdi_in                   (gt0_drpdi_in),
        .drpdo_out                  (gt0_drpdo_out),
        .drpen_in                   (gt0_drpen_in),
        .drprdy_out                 (gt0_drprdy_out),
        .drpwe_in                   (gt0_drpwe_in),
        //----------------------------- Clocking Ports -----------------------------
 
        .QPLLCLK_IN                     (gt_qpllclk_quad1_in),
        .QPLLREFCLK_IN                  (gt_qpllrefclk_quad1_in),

        //----------------------------- Loopback Ports -----------------------------
        .LOOPBACK_IN                (GT0_LOOPBACK_IN),
        //------------------- RX Initialization and Reset Ports --------------------
        .eyescanreset_in            (GT0_eyescanreset_in),
        .RXUSERRDY_IN               (GT0_RXUSERRDY_IN),
        .RX_POLARITY_IN             (GT0_RX_POLARITY_IN),
        //------------------------ RX Margin Analysis Ports ------------------------
        .eyescandataerror_out       (GT0_eyescandataerror_out),
        .eyescantrigger_in          (GT0_eyescantrigger_in),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .RXCDRLOCK_OUT              (),
        .RXCDROVRDEN_IN             (GT0_RXCDROVRDEN_IN),
        .rxcdrhold_in               (GT0_rxcdrhold_in),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .RXUSRCLK_IN                (GT0_RXUSRCLK_IN),
        .RXUSRCLK2_IN               (GT0_RXUSRCLK2_IN),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .RXDATA_OUT                 (GT0_RXDATA_OUT),
        //------------------------- Receive Ports - RX AFE -------------------------
        .GTXRXN_IN                  (GT0_GTXRXN_IN),
        .GTXRXP_IN                  (GT0_GTXRXP_IN),
        //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .RXBUFSTATUS_OUT            (GT0_RXBUFSTATUS_OUT),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .rxlpmhfovrden_in           (GT0_rxlpmhfovrden_in),
        .rxdfeagchold_in            (GT0_rxdfeagchold_in),
        .rxdfeagcovrden_in          (GT0_rxdfeagcovrden_in),
        .rxdfelfhold_in             (GT0_rxdfelfhold_in),
        .rxdfelpmreset_in           (GT0_rxdfelpmreset_in),
        .rxlpmlfklovrden_in         (GT0_rxlpmlfklovrden_in),
        .rxmonitorout_out           (GT0_rxmonitorout_out),
        .rxmonitorsel_in            (GT0_rxmonitorsel_in),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .RXOUTCLK_OUT               (GT0_RXOUTCLK_OUT),
        //-------------------- Receive Ports - RX Gearbox Ports --------------------
        .RXDATAVALID_OUT            (GT0_RXDATAVALID_OUT),
        .RXHEADER_OUT               (GT0_RXHEADER_OUT),
        .RXHEADERVALID_OUT          (GT0_RXHEADERVALID_OUT),
        //------------------- Receive Ports - RX Gearbox Ports  --------------------
        .RXGEARBOXSLIP_IN           (GT0_RXGEARBOXSLIP_IN),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .GTRXRESET_IN               (GT0_GTRXRESET_IN),
        .RXPMARESET_IN              (gt0_RXPMARESET_IN),
        .rxlpmen_in                 (GT0_rxlpmen_in),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .RXRESETDONE_OUT            (GT0_RXRESETDONE_OUT),
        //---------------------- TX Configurable Driver Ports ----------------------
        .txpostcursor_in            (GT0_txpostcursor_in),
        .txdiffctrl_in              (GT0_txdiffctrl_in),
        .txmaincursor_in            (GT0_txmaincursor_in),
        //------------------- TX Initialization and Reset Ports --------------------
        .GTTXRESET_IN               (GT0_GTTXRESET_IN),
        .TXUSERRDY_IN               (GT0_TXUSERRDY_IN),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .TXUSRCLK_IN                (GT0_TXUSRCLK_IN),
        .TXUSRCLK2_IN               (GT0_TXUSRCLK2_IN),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA_IN                  (GT0_TXDATA_IN),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTXTXN_OUT                 (GT0_GTXTXN_OUT),
        .GTXTXP_OUT                 (GT0_GTXTXP_OUT),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .TXOUTCLK_OUT               (GT0_TXOUTCLK_OUT),
        .TXOUTCLKFABRIC_OUT         (GT0_TXOUTCLKFABRIC_OUT),
        .TXOUTCLKPCS_OUT            (GT0_TXOUTCLKPCS_OUT),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .TXHEADER_IN                (GT0_TXHEADER_IN),
        .TXSEQUENCE_IN              (GT0_TXSEQUENCE_IN),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .TXRESETDONE_OUT            (GT0_TXRESETDONE_OUT),
        .gt_txpmareset_in           (gt0_txpmareset_in ),
        .gt_txpcsreset_in           (gt0_txpcsreset_in ),
        .gt_rxpcsreset_in           (gt0_rxpcsreset_in ),
        .gt_rxbufreset_in           (gt0_rxbufreset_in ),
        .txprecursor_in             (gt0_txprecursor_in      ),
        .gt_txprbssel_in            (gt0_txprbssel_in     ),
        .gt_rxprbssel_in            (gt0_rxprbssel_in     ),
        .gt_txprbsforceerr_in       (gt0_txprbsforceerr_in),
        .gt_rxprbserr_out           (gt0_rxprbserr_out    ),
        .gt_rxprbscntreset_in       (gt0_rxprbscntreset_in),
        .gt_dmonitorout_out         (gt0_dmonitorout_out    ),
        .gt_txbufstatus_out         (gt0_txbufstatus_out    ),
        .txinhibit_in               (gt0_txinhibit_in),
        //--------------- Transmit Ports - TX Polarity Control Ports ---------------
        .txpolarity_in              (GT0_txpolarity_in)

     );
 
 
     //*************************************************************************************************
     //-----------------------------------GT INSTANCE-----------------------------------------------
     //*************************************************************************************************
aurora_64b66b_lan4_framing_GTX # 
     (
        // Simulation attributes
        .GT_SIM_GTRESET_SPEEDUP   (WRAPPER_SIM_GTRESET_SPEEDUP),
        .SIM_VERSION              (SIM_VERSION),
        .RX_DFE_KL_CFG2_IN        (RX_DFE_KL_CFG2_IN),
        .PCS_RSVD_ATTR_IN         (48'h000000000000),
        .PMA_RSV_IN               (PMA_RSV_IN)
     ) 
aurora_64b66b_lan4_framing_gtx_inst_lane1
     (
        //------------------------------- CPLL Ports -------------------------------
        .CPLLFBCLKLOST_OUT          (GT1_CPLLFBCLKLOST_OUT),
        .CPLLLOCK_OUT               (GT1_CPLLLOCK_OUT),
        .CPLLLOCKDETCLK_IN          (GT1_CPLLLOCKDETCLK_IN),
        .CPLLREFCLKLOST_OUT         (GT1_CPLLREFCLKLOST_OUT),
        .CPLLRESET_IN               (GT1_CPLLRESET_IN),
        //------------------------ Channel - Clocking Ports ------------------------
        .GTREFCLK0_IN               (GT1_GTREFCLK0_IN),
        .drpaddr_in                 (gt1_drpaddr_in),
        .drpclk_in                  (gt1_drp_clk_in),
        .drpdi_in                   (gt1_drpdi_in),
        .drpdo_out                  (gt1_drpdo_out),
        .drpen_in                   (gt1_drpen_in),
        .drprdy_out                 (gt1_drprdy_out),
        .drpwe_in                   (gt1_drpwe_in),
        //----------------------------- Clocking Ports -----------------------------
 
        .QPLLCLK_IN                     (gt_qpllclk_quad1_in),
        .QPLLREFCLK_IN                  (gt_qpllrefclk_quad1_in),

        //----------------------------- Loopback Ports -----------------------------
        .LOOPBACK_IN                (GT1_LOOPBACK_IN),
        //------------------- RX Initialization and Reset Ports --------------------
        .eyescanreset_in            (GT1_eyescanreset_in),
        .RXUSERRDY_IN               (GT1_RXUSERRDY_IN),
        .RX_POLARITY_IN             (GT1_RX_POLARITY_IN),
        //------------------------ RX Margin Analysis Ports ------------------------
        .eyescandataerror_out       (GT1_eyescandataerror_out),
        .eyescantrigger_in          (GT1_eyescantrigger_in),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .RXCDRLOCK_OUT              (),
        .RXCDROVRDEN_IN             (GT1_RXCDROVRDEN_IN),
        .rxcdrhold_in               (GT1_rxcdrhold_in),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .RXUSRCLK_IN                (GT1_RXUSRCLK_IN),
        .RXUSRCLK2_IN               (GT1_RXUSRCLK2_IN),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .RXDATA_OUT                 (GT1_RXDATA_OUT),
        //------------------------- Receive Ports - RX AFE -------------------------
        .GTXRXN_IN                  (GT1_GTXRXN_IN),
        .GTXRXP_IN                  (GT1_GTXRXP_IN),
        //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .RXBUFSTATUS_OUT            (GT1_RXBUFSTATUS_OUT),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .rxlpmhfovrden_in           (GT1_rxlpmhfovrden_in),
        .rxdfeagchold_in            (GT1_rxdfeagchold_in),
        .rxdfeagcovrden_in          (GT1_rxdfeagcovrden_in),
        .rxdfelfhold_in             (GT1_rxdfelfhold_in),
        .rxdfelpmreset_in           (GT1_rxdfelpmreset_in),
        .rxlpmlfklovrden_in         (GT1_rxlpmlfklovrden_in),
        .rxmonitorout_out           (GT1_rxmonitorout_out),
        .rxmonitorsel_in            (GT1_rxmonitorsel_in),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .RXOUTCLK_OUT               (GT1_RXOUTCLK_OUT),
        //-------------------- Receive Ports - RX Gearbox Ports --------------------
        .RXDATAVALID_OUT            (GT1_RXDATAVALID_OUT),
        .RXHEADER_OUT               (GT1_RXHEADER_OUT),
        .RXHEADERVALID_OUT          (GT1_RXHEADERVALID_OUT),
        //------------------- Receive Ports - RX Gearbox Ports  --------------------
        .RXGEARBOXSLIP_IN           (GT1_RXGEARBOXSLIP_IN),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .GTRXRESET_IN               (GT1_GTRXRESET_IN),
        .RXPMARESET_IN              (gt1_RXPMARESET_IN),
        .rxlpmen_in                 (GT1_rxlpmen_in),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .RXRESETDONE_OUT            (GT1_RXRESETDONE_OUT),
        //---------------------- TX Configurable Driver Ports ----------------------
        .txpostcursor_in            (GT1_txpostcursor_in),
        .txdiffctrl_in              (GT1_txdiffctrl_in),
        .txmaincursor_in            (GT1_txmaincursor_in),
        //------------------- TX Initialization and Reset Ports --------------------
        .GTTXRESET_IN               (GT1_GTTXRESET_IN),
        .TXUSERRDY_IN               (GT1_TXUSERRDY_IN),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .TXUSRCLK_IN                (GT1_TXUSRCLK_IN),
        .TXUSRCLK2_IN               (GT1_TXUSRCLK2_IN),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA_IN                  (GT1_TXDATA_IN),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTXTXN_OUT                 (GT1_GTXTXN_OUT),
        .GTXTXP_OUT                 (GT1_GTXTXP_OUT),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .TXOUTCLK_OUT               (GT1_TXOUTCLK_OUT),
        .TXOUTCLKFABRIC_OUT         (GT1_TXOUTCLKFABRIC_OUT),
        .TXOUTCLKPCS_OUT            (GT1_TXOUTCLKPCS_OUT),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .TXHEADER_IN                (GT1_TXHEADER_IN),
        .TXSEQUENCE_IN              (GT1_TXSEQUENCE_IN),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .TXRESETDONE_OUT            (GT1_TXRESETDONE_OUT),
        .gt_txpmareset_in           (gt1_txpmareset_in ),
        .gt_txpcsreset_in           (gt1_txpcsreset_in ),
        .gt_rxpcsreset_in           (gt1_rxpcsreset_in ),
        .gt_rxbufreset_in           (gt1_rxbufreset_in ),
        .txprecursor_in             (gt1_txprecursor_in      ),
        .gt_txprbssel_in            (gt1_txprbssel_in     ),
        .gt_rxprbssel_in            (gt1_rxprbssel_in     ),
        .gt_txprbsforceerr_in       (gt1_txprbsforceerr_in),
        .gt_rxprbserr_out           (gt1_rxprbserr_out    ),
        .gt_rxprbscntreset_in       (gt1_rxprbscntreset_in),
        .gt_dmonitorout_out         (gt1_dmonitorout_out    ),
        .gt_txbufstatus_out         (gt1_txbufstatus_out    ),
        .txinhibit_in               (gt1_txinhibit_in),
        //--------------- Transmit Ports - TX Polarity Control Ports ---------------
        .txpolarity_in              (GT1_txpolarity_in)

     );
 
 
     //*************************************************************************************************
     //-----------------------------------GT INSTANCE-----------------------------------------------
     //*************************************************************************************************
aurora_64b66b_lan4_framing_GTX # 
     (
        // Simulation attributes
        .GT_SIM_GTRESET_SPEEDUP   (WRAPPER_SIM_GTRESET_SPEEDUP),
        .SIM_VERSION              (SIM_VERSION),
        .RX_DFE_KL_CFG2_IN        (RX_DFE_KL_CFG2_IN),
        .PCS_RSVD_ATTR_IN         (48'h000000000000),
        .PMA_RSV_IN               (PMA_RSV_IN)
     ) 
aurora_64b66b_lan4_framing_gtx_inst_lane2
     (
        //------------------------------- CPLL Ports -------------------------------
        .CPLLFBCLKLOST_OUT          (GT2_CPLLFBCLKLOST_OUT),
        .CPLLLOCK_OUT               (GT2_CPLLLOCK_OUT),
        .CPLLLOCKDETCLK_IN          (GT2_CPLLLOCKDETCLK_IN),
        .CPLLREFCLKLOST_OUT         (GT2_CPLLREFCLKLOST_OUT),
        .CPLLRESET_IN               (GT2_CPLLRESET_IN),
        //------------------------ Channel - Clocking Ports ------------------------
        .GTREFCLK0_IN               (GT2_GTREFCLK0_IN),
        .drpaddr_in                 (gt2_drpaddr_in),
        .drpclk_in                  (gt2_drp_clk_in),
        .drpdi_in                   (gt2_drpdi_in),
        .drpdo_out                  (gt2_drpdo_out),
        .drpen_in                   (gt2_drpen_in),
        .drprdy_out                 (gt2_drprdy_out),
        .drpwe_in                   (gt2_drpwe_in),
        //----------------------------- Clocking Ports -----------------------------
 
        .QPLLCLK_IN                     (gt_qpllclk_quad1_in),
        .QPLLREFCLK_IN                  (gt_qpllrefclk_quad1_in),

        //----------------------------- Loopback Ports -----------------------------
        .LOOPBACK_IN                (GT2_LOOPBACK_IN),
        //------------------- RX Initialization and Reset Ports --------------------
        .eyescanreset_in            (GT2_eyescanreset_in),
        .RXUSERRDY_IN               (GT2_RXUSERRDY_IN),
        .RX_POLARITY_IN             (GT2_RX_POLARITY_IN),
        //------------------------ RX Margin Analysis Ports ------------------------
        .eyescandataerror_out       (GT2_eyescandataerror_out),
        .eyescantrigger_in          (GT2_eyescantrigger_in),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .RXCDRLOCK_OUT              (),
        .RXCDROVRDEN_IN             (GT2_RXCDROVRDEN_IN),
        .rxcdrhold_in               (GT2_rxcdrhold_in),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .RXUSRCLK_IN                (GT2_RXUSRCLK_IN),
        .RXUSRCLK2_IN               (GT2_RXUSRCLK2_IN),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .RXDATA_OUT                 (GT2_RXDATA_OUT),
        //------------------------- Receive Ports - RX AFE -------------------------
        .GTXRXN_IN                  (GT2_GTXRXN_IN),
        .GTXRXP_IN                  (GT2_GTXRXP_IN),
        //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .RXBUFSTATUS_OUT            (GT2_RXBUFSTATUS_OUT),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .rxlpmhfovrden_in           (GT2_rxlpmhfovrden_in),
        .rxdfeagchold_in            (GT2_rxdfeagchold_in),
        .rxdfeagcovrden_in          (GT2_rxdfeagcovrden_in),
        .rxdfelfhold_in             (GT2_rxdfelfhold_in),
        .rxdfelpmreset_in           (GT2_rxdfelpmreset_in),
        .rxlpmlfklovrden_in         (GT2_rxlpmlfklovrden_in),
        .rxmonitorout_out           (GT2_rxmonitorout_out),
        .rxmonitorsel_in            (GT2_rxmonitorsel_in),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .RXOUTCLK_OUT               (GT2_RXOUTCLK_OUT),
        //-------------------- Receive Ports - RX Gearbox Ports --------------------
        .RXDATAVALID_OUT            (GT2_RXDATAVALID_OUT),
        .RXHEADER_OUT               (GT2_RXHEADER_OUT),
        .RXHEADERVALID_OUT          (GT2_RXHEADERVALID_OUT),
        //------------------- Receive Ports - RX Gearbox Ports  --------------------
        .RXGEARBOXSLIP_IN           (GT2_RXGEARBOXSLIP_IN),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .GTRXRESET_IN               (GT2_GTRXRESET_IN),
        .RXPMARESET_IN              (gt2_RXPMARESET_IN),
        .rxlpmen_in                 (GT2_rxlpmen_in),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .RXRESETDONE_OUT            (GT2_RXRESETDONE_OUT),
        //---------------------- TX Configurable Driver Ports ----------------------
        .txpostcursor_in            (GT2_txpostcursor_in),
        .txdiffctrl_in              (GT2_txdiffctrl_in),
        .txmaincursor_in            (GT2_txmaincursor_in),
        //------------------- TX Initialization and Reset Ports --------------------
        .GTTXRESET_IN               (GT2_GTTXRESET_IN),
        .TXUSERRDY_IN               (GT2_TXUSERRDY_IN),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .TXUSRCLK_IN                (GT2_TXUSRCLK_IN),
        .TXUSRCLK2_IN               (GT2_TXUSRCLK2_IN),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA_IN                  (GT2_TXDATA_IN),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTXTXN_OUT                 (GT2_GTXTXN_OUT),
        .GTXTXP_OUT                 (GT2_GTXTXP_OUT),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .TXOUTCLK_OUT               (GT2_TXOUTCLK_OUT),
        .TXOUTCLKFABRIC_OUT         (GT2_TXOUTCLKFABRIC_OUT),
        .TXOUTCLKPCS_OUT            (GT2_TXOUTCLKPCS_OUT),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .TXHEADER_IN                (GT2_TXHEADER_IN),
        .TXSEQUENCE_IN              (GT2_TXSEQUENCE_IN),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .TXRESETDONE_OUT            (GT2_TXRESETDONE_OUT),
        .gt_txpmareset_in           (gt2_txpmareset_in ),
        .gt_txpcsreset_in           (gt2_txpcsreset_in ),
        .gt_rxpcsreset_in           (gt2_rxpcsreset_in ),
        .gt_rxbufreset_in           (gt2_rxbufreset_in ),
        .txprecursor_in             (gt2_txprecursor_in      ),
        .gt_txprbssel_in            (gt2_txprbssel_in     ),
        .gt_rxprbssel_in            (gt2_rxprbssel_in     ),
        .gt_txprbsforceerr_in       (gt2_txprbsforceerr_in),
        .gt_rxprbserr_out           (gt2_rxprbserr_out    ),
        .gt_rxprbscntreset_in       (gt2_rxprbscntreset_in),
        .gt_dmonitorout_out         (gt2_dmonitorout_out    ),
        .gt_txbufstatus_out         (gt2_txbufstatus_out    ),
        .txinhibit_in               (gt2_txinhibit_in),
        //--------------- Transmit Ports - TX Polarity Control Ports ---------------
        .txpolarity_in              (GT2_txpolarity_in)

     );
 
 
     //*************************************************************************************************
     //-----------------------------------GT INSTANCE-----------------------------------------------
     //*************************************************************************************************
aurora_64b66b_lan4_framing_GTX # 
     (
        // Simulation attributes
        .GT_SIM_GTRESET_SPEEDUP   (WRAPPER_SIM_GTRESET_SPEEDUP),
        .SIM_VERSION              (SIM_VERSION),
        .RX_DFE_KL_CFG2_IN        (RX_DFE_KL_CFG2_IN),
        .PCS_RSVD_ATTR_IN         (48'h000000000000),
        .PMA_RSV_IN               (PMA_RSV_IN)
     ) 
aurora_64b66b_lan4_framing_gtx_inst_lane3
     (
        //------------------------------- CPLL Ports -------------------------------
        .CPLLFBCLKLOST_OUT          (GT3_CPLLFBCLKLOST_OUT),
        .CPLLLOCK_OUT               (GT3_CPLLLOCK_OUT),
        .CPLLLOCKDETCLK_IN          (GT3_CPLLLOCKDETCLK_IN),
        .CPLLREFCLKLOST_OUT         (GT3_CPLLREFCLKLOST_OUT),
        .CPLLRESET_IN               (GT3_CPLLRESET_IN),
        //------------------------ Channel - Clocking Ports ------------------------
        .GTREFCLK0_IN               (GT3_GTREFCLK0_IN),
        .drpaddr_in                 (gt3_drpaddr_in),
        .drpclk_in                  (gt3_drp_clk_in),
        .drpdi_in                   (gt3_drpdi_in),
        .drpdo_out                  (gt3_drpdo_out),
        .drpen_in                   (gt3_drpen_in),
        .drprdy_out                 (gt3_drprdy_out),
        .drpwe_in                   (gt3_drpwe_in),
        //----------------------------- Clocking Ports -----------------------------
 
        .QPLLCLK_IN                     (gt_qpllclk_quad1_in),
        .QPLLREFCLK_IN                  (gt_qpllrefclk_quad1_in),

        //----------------------------- Loopback Ports -----------------------------
        .LOOPBACK_IN                (GT3_LOOPBACK_IN),
        //------------------- RX Initialization and Reset Ports --------------------
        .eyescanreset_in            (GT3_eyescanreset_in),
        .RXUSERRDY_IN               (GT3_RXUSERRDY_IN),
        .RX_POLARITY_IN             (GT3_RX_POLARITY_IN),
        //------------------------ RX Margin Analysis Ports ------------------------
        .eyescandataerror_out       (GT3_eyescandataerror_out),
        .eyescantrigger_in          (GT3_eyescantrigger_in),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .RXCDRLOCK_OUT              (),
        .RXCDROVRDEN_IN             (GT3_RXCDROVRDEN_IN),
        .rxcdrhold_in               (GT3_rxcdrhold_in),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .RXUSRCLK_IN                (GT3_RXUSRCLK_IN),
        .RXUSRCLK2_IN               (GT3_RXUSRCLK2_IN),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .RXDATA_OUT                 (GT3_RXDATA_OUT),
        //------------------------- Receive Ports - RX AFE -------------------------
        .GTXRXN_IN                  (GT3_GTXRXN_IN),
        .GTXRXP_IN                  (GT3_GTXRXP_IN),
        //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .RXBUFSTATUS_OUT            (GT3_RXBUFSTATUS_OUT),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .rxlpmhfovrden_in           (GT3_rxlpmhfovrden_in),
        .rxdfeagchold_in            (GT3_rxdfeagchold_in),
        .rxdfeagcovrden_in          (GT3_rxdfeagcovrden_in),
        .rxdfelfhold_in             (GT3_rxdfelfhold_in),
        .rxdfelpmreset_in           (GT3_rxdfelpmreset_in),
        .rxlpmlfklovrden_in         (GT3_rxlpmlfklovrden_in),
        .rxmonitorout_out           (GT3_rxmonitorout_out),
        .rxmonitorsel_in            (GT3_rxmonitorsel_in),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .RXOUTCLK_OUT               (GT3_RXOUTCLK_OUT),
        //-------------------- Receive Ports - RX Gearbox Ports --------------------
        .RXDATAVALID_OUT            (GT3_RXDATAVALID_OUT),
        .RXHEADER_OUT               (GT3_RXHEADER_OUT),
        .RXHEADERVALID_OUT          (GT3_RXHEADERVALID_OUT),
        //------------------- Receive Ports - RX Gearbox Ports  --------------------
        .RXGEARBOXSLIP_IN           (GT3_RXGEARBOXSLIP_IN),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .GTRXRESET_IN               (GT3_GTRXRESET_IN),
        .RXPMARESET_IN              (gt3_RXPMARESET_IN),
        .rxlpmen_in                 (GT3_rxlpmen_in),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .RXRESETDONE_OUT            (GT3_RXRESETDONE_OUT),
        //---------------------- TX Configurable Driver Ports ----------------------
        .txpostcursor_in            (GT3_txpostcursor_in),
        .txdiffctrl_in              (GT3_txdiffctrl_in),
        .txmaincursor_in            (GT3_txmaincursor_in),
        //------------------- TX Initialization and Reset Ports --------------------
        .GTTXRESET_IN               (GT3_GTTXRESET_IN),
        .TXUSERRDY_IN               (GT3_TXUSERRDY_IN),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .TXUSRCLK_IN                (GT3_TXUSRCLK_IN),
        .TXUSRCLK2_IN               (GT3_TXUSRCLK2_IN),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA_IN                  (GT3_TXDATA_IN),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTXTXN_OUT                 (GT3_GTXTXN_OUT),
        .GTXTXP_OUT                 (GT3_GTXTXP_OUT),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .TXOUTCLK_OUT               (GT3_TXOUTCLK_OUT),
        .TXOUTCLKFABRIC_OUT         (GT3_TXOUTCLKFABRIC_OUT),
        .TXOUTCLKPCS_OUT            (GT3_TXOUTCLKPCS_OUT),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .TXHEADER_IN                (GT3_TXHEADER_IN),
        .TXSEQUENCE_IN              (GT3_TXSEQUENCE_IN),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .TXRESETDONE_OUT            (GT3_TXRESETDONE_OUT),
        .gt_txpmareset_in           (gt3_txpmareset_in ),
        .gt_txpcsreset_in           (gt3_txpcsreset_in ),
        .gt_rxpcsreset_in           (gt3_rxpcsreset_in ),
        .gt_rxbufreset_in           (gt3_rxbufreset_in ),
        .txprecursor_in             (gt3_txprecursor_in      ),
        .gt_txprbssel_in            (gt3_txprbssel_in     ),
        .gt_rxprbssel_in            (gt3_rxprbssel_in     ),
        .gt_txprbsforceerr_in       (gt3_txprbsforceerr_in),
        .gt_rxprbserr_out           (gt3_rxprbserr_out    ),
        .gt_rxprbscntreset_in       (gt3_rxprbscntreset_in),
        .gt_dmonitorout_out         (gt3_dmonitorout_out    ),
        .gt_txbufstatus_out         (gt3_txbufstatus_out    ),
        .txinhibit_in               (gt3_txinhibit_in),
        //--------------- Transmit Ports - TX Polarity Control Ports ---------------
        .txpolarity_in              (GT3_txpolarity_in)

     );
 
 
endmodule
 
