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
module TenGEthMacPort2(
   input  wire              reset,
   //XGMII Ifc 
   input  wire [1:0]        gtx_clk,
   input  wire [1:0]        tx_clk0,
   output wire [1:0] [63:0] xgmii_txd,
   output wire [1:0] [7:0]  xgmii_txc,
   input  wire [1:0]        rx_clk0,
   input  wire [1:0] [63:0] xgmii_rxd,
   input  wire [1:0] [7:0]  xgmii_rxc,
   input  wire [1:0]        tx_dcm_locked,
   input  wire [1:0]        rx_dcm_locked,
   
   output wire [2:0]       status_vector_Mac1,
   output wire [2:0]       status_vector_Mac2,
   
   //User Data Ifc
   input  wire [1:0]        tx_axis_fifo_aclk,
   input  wire [1:0]        tx_axis_aresetn,
   input  wire [1:0] [63:0] tx_axis_fifo_tdata,
   input  wire [1:0] [7:0]  tx_axis_fifo_tkeep,
   input  wire [1:0]        tx_axis_fifo_tvalid,
   input  wire [1:0]        tx_axis_fifo_tlast,
   output wire [1:0]        tx_axis_fifo_tready,
      
   input  wire [1:0]        rx_axis_fifo_aclk,
   input  wire [1:0]        rx_axis_aresetn,
   output wire [1:0] [63:0] rx_axis_fifo_tdata,
   output wire [1:0] [7:0]  rx_axis_fifo_tkeep,
   output wire [1:0]        rx_axis_fifo_tvalid,
   output wire [1:0]        rx_axis_fifo_tlast,
   input  wire [1:0]        rx_axis_fifo_tready,
   
   input  wire CntClr,
   output wire [1:0][31:0] RxPkg_Cnt,
   output wire [1:0][31:0] BriRxPkg_Cnt,
   output wire [1:0][31:0] TxPkg_Cnt,
   output wire [1:0][31:0] BriTxPkg_Cnt

);

//////////////////////////////////////////////////////////////////////// 
//ethernet_Mac1   
 ten_gig_eth_mac_0_example_design ten_gig_eth_mac_0_example_design_Inst0(
   .reset(reset),
   .tx_axis_aresetn(tx_axis_aresetn[0]),
   .rx_axis_aresetn(rx_axis_aresetn[0]),   
   .tx_statistics_vector(),
   .rx_statistics_vector(),
      
   .pause_req(1'b0),

   .gtx_clk(gtx_clk[0]),
   .tx_clk0(tx_clk0[0]),
   .xgmii_txd(xgmii_txd[0]),
   .xgmii_txc(xgmii_txc[0]),
   .rx_clk0(rx_clk0[0]),
   .xgmii_rxd(xgmii_rxd[0]),
   .xgmii_rxc(xgmii_rxc[0]),
   .tx_dcm_locked(tx_dcm_locked[0]),
   .rx_dcm_locked(rx_dcm_locked[0]),
   
   .tx_axis_fifo_aclk(tx_axis_fifo_aclk[0]),
   .tx_axis_fifo_tdata(tx_axis_fifo_tdata[0]),
   .tx_axis_fifo_tkeep(tx_axis_fifo_tkeep[0]),
   .tx_axis_fifo_tvalid(tx_axis_fifo_tvalid[0]),
   .tx_axis_fifo_tlast(tx_axis_fifo_tlast[0]),
   .tx_axis_fifo_tready(tx_axis_fifo_tready[0]),
   
   .rx_axis_fifo_aclk(rx_axis_fifo_aclk[0]),
   .rx_axis_fifo_tdata(rx_axis_fifo_tdata[0]),
   .rx_axis_fifo_tkeep(rx_axis_fifo_tkeep[0]),
   .rx_axis_fifo_tvalid(rx_axis_fifo_tvalid[0]),
   .rx_axis_fifo_tlast(rx_axis_fifo_tlast[0]),
   .rx_axis_fifo_tready(rx_axis_fifo_tready[0]),
   .status_vector(status_vector_Mac1) ,
   
   .CntClr(CntClr),
   .RxPkg_Cnt(RxPkg_Cnt[0]),
   .BriRxPkg_Cnt(BriRxPkg_Cnt[0]),
   .TxPkg_Cnt(TxPkg_Cnt[0]),
   .BriTxPkg_Cnt(BriTxPkg_Cnt[0])

   );
//////////////////////////////////////////////////////////////////////   
//ethernet_Mac2    
 ten_gig_eth_mac_0_example_design  ten_gig_eth_mac_0_example_design_Inst1(
   .reset(reset),
   .tx_axis_aresetn(tx_axis_aresetn[1]),
   .rx_axis_aresetn(rx_axis_aresetn[1]),
   .tx_statistics_vector(),
   .rx_statistics_vector(),
   
   .pause_req(1'b0),

   .gtx_clk(gtx_clk[1]),
   .tx_clk0(tx_clk0[1]),
   .xgmii_txd(xgmii_txd[1]),
   .xgmii_txc(xgmii_txc[1]),
   .rx_clk0(rx_clk0[1]),
   .xgmii_rxd(xgmii_rxd[1]),
   .xgmii_rxc(xgmii_rxc[1]),
   .tx_dcm_locked(tx_dcm_locked[1]),
   .rx_dcm_locked(rx_dcm_locked[1]),   
   
   .tx_axis_fifo_aclk(tx_axis_fifo_aclk[1]),
   .tx_axis_fifo_tdata(tx_axis_fifo_tdata[1]),
   .tx_axis_fifo_tkeep(tx_axis_fifo_tkeep[1]),
   .tx_axis_fifo_tvalid(tx_axis_fifo_tvalid[1]),
   .tx_axis_fifo_tlast(tx_axis_fifo_tlast[1]),
   .tx_axis_fifo_tready(tx_axis_fifo_tready[1]),
   
   .rx_axis_fifo_aclk(rx_axis_fifo_aclk[1]),
   .rx_axis_fifo_tdata(rx_axis_fifo_tdata[1]),
   .rx_axis_fifo_tkeep(rx_axis_fifo_tkeep[1]),
   .rx_axis_fifo_tvalid(rx_axis_fifo_tvalid[1]),
   .rx_axis_fifo_tlast(rx_axis_fifo_tlast[1]),
   .rx_axis_fifo_tready(rx_axis_fifo_tready[1]),
   .status_vector(status_vector_Mac2),

   .CntClr(CntClr),
   .RxPkg_Cnt(RxPkg_Cnt[1]),
   .BriRxPkg_Cnt(BriRxPkg_Cnt[1]),
   .TxPkg_Cnt(TxPkg_Cnt[1]),
   .BriTxPkg_Cnt(BriTxPkg_Cnt[1])

   );
///////////////////////////////////////////////////////////////  
    
endmodule
