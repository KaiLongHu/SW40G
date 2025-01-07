`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/05 10:25:29
// Design Name: 
// Module Name: Eth10GBaseRPort3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module TenGEthMacPort1_New(
   input  wire              reset,
   //XGMII Ifc 
   input  wire         gtx_clk,
   input  wire         tx_clk0,
   output wire  [63:0] xgmii_txd,
   output wire  [7:0]  xgmii_txc,
   input  wire         rx_clk0,
   input  wire  [63:0] xgmii_rxd,
   input  wire  [7:0]  xgmii_rxc,
   input  wire         tx_dcm_locked,
   input  wire         rx_dcm_locked,
   
   output wire [2:0]       status_vector_Mac1,
   
   //User Data Ifc
   input  wire         tx_axis_fifo_aclk,
   input  wire         tx_axis_aresetn,
   input  wire  [63:0] tx_axis_fifo_tdata,
   input  wire  [7:0]  tx_axis_fifo_tkeep,
   input  wire         tx_axis_fifo_tvalid,
   input  wire         tx_axis_fifo_tlast,
   output wire         tx_axis_fifo_tready,
      
   input  wire         rx_axis_fifo_aclk,
   input  wire         rx_axis_aresetn,
   output wire  [63:0] rx_axis_fifo_tdata,
   output wire  [7:0]  rx_axis_fifo_tkeep,
   output wire         rx_axis_fifo_tvalid,
   output wire         rx_axis_fifo_tlast,
   input  wire         rx_axis_fifo_tready,
   
   input  wire CntClr,
   output wire [31:0] RxPkg_Cnt,
   output wire [31:0] RxPkgErr_Cnt,
   output wire [31:0] BriRxPkg_Cnt,
   output wire [31:0] TxPkg_Cnt,
   output wire [31:0] BriTxPkg_Cnt,
   output wire [7:0] XauiRxFifoStatus

);

//////////////////////////////////////////////////////////////////////// 
//ethernet_Mac1   
 ten_gig_eth_mac_0_example_design ten_gig_eth_mac_0_example_design_Inst0(
   .reset(reset),
   .tx_axis_aresetn(tx_axis_aresetn),
   .rx_axis_aresetn(rx_axis_aresetn),   
   .tx_statistics_vector(),
   .rx_statistics_vector(),
      
   .pause_req(1'b0),

   .gtx_clk(gtx_clk),
   .tx_clk0(tx_clk0),
   .xgmii_txd(xgmii_txd),
   .xgmii_txc(xgmii_txc),
   .rx_clk0(rx_clk0),
   .xgmii_rxd(xgmii_rxd),
   .xgmii_rxc(xgmii_rxc),
   .tx_dcm_locked(tx_dcm_locked),
   .rx_dcm_locked(rx_dcm_locked),
   
   .tx_axis_fifo_aclk(tx_axis_fifo_aclk),
   .tx_axis_fifo_tdata(tx_axis_fifo_tdata),
   .tx_axis_fifo_tkeep(tx_axis_fifo_tkeep),
   .tx_axis_fifo_tvalid(tx_axis_fifo_tvalid),
   .tx_axis_fifo_tlast(tx_axis_fifo_tlast),
   .tx_axis_fifo_tready(tx_axis_fifo_tready),
   
   .rx_axis_fifo_aclk(rx_axis_fifo_aclk),
   .rx_axis_fifo_tdata(rx_axis_fifo_tdata),
   .rx_axis_fifo_tkeep(rx_axis_fifo_tkeep),
   .rx_axis_fifo_tvalid(rx_axis_fifo_tvalid),
   .rx_axis_fifo_tlast(rx_axis_fifo_tlast),
   .rx_axis_fifo_tready(rx_axis_fifo_tready),
   .status_vector(status_vector_Mac1),
   
   .CntClr(CntClr),
   .RxPkg_Cnt(RxPkg_Cnt),
   .RxPkgErr_Cnt(RxPkgErr_Cnt),
   .BriRxPkg_Cnt(BriRxPkg_Cnt),
   .TxPkg_Cnt(TxPkg_Cnt),
   .BriTxPkg_Cnt(BriTxPkg_Cnt),
   .XauiRxFifoStatus(XauiRxFifoStatus)

   );
///////////////////////////////////////////////////////////////  
    
endmodule
