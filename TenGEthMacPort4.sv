`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/05 10:25:29
// Design Name: 
// Module Name: TenGEthMacPort4
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
module TenGEthMacPort4(
   input  wire              reset,
   //XGMII Ifc 
   input  wire [3:0]        gtx_clk,
   output wire [3:0] [63:0] xgmii_txd,
   output wire [3:0] [7:0]  xgmii_txc,
   
   input  wire [3:0]        rx_clk0,
   input  wire [3:0] [63:0] xgmii_rxd,
   input  wire [3:0] [7:0]  xgmii_rxc,
   
   output wire [3:0]       status_vector_Mac1,
   output wire [3:0]       status_vector_Mac2,
   output wire [3:0]       status_vector_Mac3,   
   output wire [3:0]       status_vector_Mac4,   
   //User Data Ifc
   input  wire [3:0]        tx_axis_aresetn,
   input  wire [3:0] [63:0] tx_axis_fifo_tdata,
   input  wire [3:0] [7:0]  tx_axis_fifo_tkeep,
   input  wire [3:0]        tx_axis_fifo_tvalid,
   input  wire [3:0]        tx_axis_fifo_tlast,
   output wire [3:0]        tx_axis_fifo_tready,
      
   input  wire [3:0]        rx_axis_aresetn,
   output wire [3:0] [63:0] rx_axis_fifo_tdata,
   output wire [3:0] [7:0]  rx_axis_fifo_tkeep,
   output wire [3:0]        rx_axis_fifo_tvalid,
   output wire [3:0]        rx_axis_fifo_tlast,
   input  wire [3:0]        rx_axis_fifo_tready,
   output wire [3:0]        user_clk,
   
   output [3:0]       tx_fifo_full,
   output [3:0] [3:0] tx_fifo_status,
   output [3:0]       tx_axis_mac_tready
);

//////////////////////////////////////////////////////////////////////// 
   wire        tx_fifo_full1;
   wire [3:0]  tx_fifo_status1;
   wire        tx_axis_mac_tready1;
   wire        tx_fifo_full2;
   wire [3:0]  tx_fifo_status2;
   wire        tx_axis_mac_tready2;
   wire        tx_fifo_full3;
   wire [3:0]  tx_fifo_status3;
   wire        tx_axis_mac_tready3;
   wire        tx_fifo_full4;
   wire [3:0]  tx_fifo_status4;
   wire        tx_axis_mac_tready4;
   
   assign tx_fifo_full        = {tx_fifo_full4,tx_fifo_full3,tx_fifo_full2,tx_fifo_full1};
   assign tx_fifo_status      = {tx_fifo_status4,tx_fifo_status3,tx_fifo_status2,tx_fifo_status1};
   assign tx_axis_mac_tready  = {tx_axis_mac_tready4,tx_axis_mac_tready3,tx_axis_mac_tready2,tx_axis_mac_tready1};

///////////////////////////////////////////////////////////////////////
//ethernet_Mac1   
 ten_gig_eth_mac_0_example_design  ten_gig_eth_mac_0_example_design_Inst0(
   .reset(reset),
   .tx_axis_aresetn(tx_axis_aresetn[0]),
   .rx_axis_aresetn(rx_axis_aresetn[0]),
   .tx_statistics_vector(),
   .rx_statistics_vector(),
   .gen_active_flash(),
   .check_active_flash(),
   .frame_error(),
   
   .user_clk(user_clk[0]),
   .rx_axis_fifo_tdata(rx_axis_fifo_tdata[0]),
   .rx_axis_fifo_tkeep(rx_axis_fifo_tkeep[0]),
   .rx_axis_fifo_tvalid(rx_axis_fifo_tvalid[0]),
   .rx_axis_fifo_tlast(rx_axis_fifo_tlast[0]),
   .rx_axis_fifo_tready(rx_axis_fifo_tready[0]),
   
   .tx_axis_fifo_tdata(tx_axis_fifo_tdata[0]),
   .tx_axis_fifo_tkeep(tx_axis_fifo_tkeep[0]),
   .tx_axis_fifo_tvalid(tx_axis_fifo_tvalid[0]),
   .tx_axis_fifo_tlast(tx_axis_fifo_tlast[0]),
   .tx_axis_fifo_ready(tx_axis_fifo_tready[0]),
   
   .pause_req(1'b0),
   .pause_val(16'habcd),

   .gtx_clk(gtx_clk[0]),
   .xgmii_tx_clk(),
   .xgmii_txd(xgmii_txd[0]),
   .xgmii_txc(xgmii_txc[0]),
   .xgmii_rx_clk(rx_clk0[0]),
   .xgmii_rxd(xgmii_rxd[0]),
   .xgmii_rxc(xgmii_rxc[0]),
   
   .status_vector(status_vector_Mac1),
   .tx_fifo_full(tx_fifo_full1),
   .tx_fifo_status(tx_fifo_status1),
   .tx_axis_mac_tready(tx_axis_mac_tready1)
   );
//////////////////////////////////////////////////////////////////////   
//ethernet_Mac2    
 ten_gig_eth_mac_0_example_design  ten_gig_eth_mac_0_example_design_Inst1(
   .reset(reset),
   .tx_axis_aresetn(tx_axis_aresetn[1]),
   .rx_axis_aresetn(rx_axis_aresetn[1]),
   .tx_statistics_vector(),
   .rx_statistics_vector(),
   .gen_active_flash(),
   .check_active_flash(),
   .frame_error(),
   
   .user_clk(user_clk[1]),
   .rx_axis_fifo_tdata(rx_axis_fifo_tdata[1]),
   .rx_axis_fifo_tkeep(rx_axis_fifo_tkeep[1]),
   .rx_axis_fifo_tvalid(rx_axis_fifo_tvalid[1]),
   .rx_axis_fifo_tlast(rx_axis_fifo_tlast[1]),
   .rx_axis_fifo_tready(rx_axis_fifo_tready[1]),
   
   .tx_axis_fifo_tdata(tx_axis_fifo_tdata[1]),
   .tx_axis_fifo_tkeep(tx_axis_fifo_tkeep[1]),
   .tx_axis_fifo_tvalid(tx_axis_fifo_tvalid[1]),
   .tx_axis_fifo_tlast(tx_axis_fifo_tlast[1]),
   .tx_axis_fifo_ready(tx_axis_fifo_tready[1]),
   
   .pause_req(1'b0),
   .pause_val(16'habcd),

   .gtx_clk(gtx_clk[1]),
   .xgmii_tx_clk(),
   .xgmii_txd(xgmii_txd[1]),
   .xgmii_txc(xgmii_txc[1]),
   .xgmii_rx_clk(rx_clk0[1]),
   .xgmii_rxd(xgmii_rxd[1]),
   .xgmii_rxc(xgmii_rxc[1]),
   
   .status_vector(status_vector_Mac2),
   .tx_fifo_full(tx_fifo_full2),
   .tx_fifo_status(tx_fifo_status2),
   .tx_axis_mac_tready(tx_axis_mac_tready2)
   );
////////////////////////////////////////////////////////////////////////
//ethernet_Mac3    
 ten_gig_eth_mac_0_example_design  ten_gig_eth_mac_0_example_design_Inst2(
   .reset(reset),
   .tx_axis_aresetn(tx_axis_aresetn[2]),
   .rx_axis_aresetn(rx_axis_aresetn[2]),
   .tx_statistics_vector(),
   .rx_statistics_vector(),
   .gen_active_flash(),
   .check_active_flash(),
   .frame_error(),
   
   .user_clk(user_clk[2]),
   .rx_axis_fifo_tdata(rx_axis_fifo_tdata[2]),
   .rx_axis_fifo_tkeep(rx_axis_fifo_tkeep[2]),
   .rx_axis_fifo_tvalid(rx_axis_fifo_tvalid[2]),
   .rx_axis_fifo_tlast(rx_axis_fifo_tlast[2]),
   .rx_axis_fifo_tready(rx_axis_fifo_tready[2]),
   
   .tx_axis_fifo_tdata(tx_axis_fifo_tdata[2]),
   .tx_axis_fifo_tkeep(tx_axis_fifo_tkeep[2]),
   .tx_axis_fifo_tvalid(tx_axis_fifo_tvalid[2]),
   .tx_axis_fifo_tlast(tx_axis_fifo_tlast[2]),
   .tx_axis_fifo_ready(tx_axis_fifo_tready[2]),
   
   .pause_req(1'b0),
   .pause_val(16'habcd),

   .gtx_clk(gtx_clk[2]),
   .xgmii_tx_clk(),
   .xgmii_txd(xgmii_txd[2]),
   .xgmii_txc(xgmii_txc[2]),
   .xgmii_rx_clk(rx_clk0[2]),
   .xgmii_rxd(xgmii_rxd[2]),
   .xgmii_rxc(xgmii_rxc[2]),
   
   .status_vector(status_vector_Mac3),
   .tx_fifo_full(tx_fifo_full3),
   .tx_fifo_status(tx_fifo_status3),
   .tx_axis_mac_tready(tx_axis_mac_tready3)
   );
////////////////////////////////////////////////////////////////////////                
   ten_gig_eth_mac_0_example_design  ten_gig_eth_mac_0_example_design_Inst3(
      .reset(reset),
      .tx_axis_aresetn(tx_axis_aresetn[3]),
      .rx_axis_aresetn(rx_axis_aresetn[3]),
      .tx_statistics_vector(),
      .rx_statistics_vector(),
      .gen_active_flash(),
      .check_active_flash(),
      .frame_error(),
      
      .user_clk(user_clk[3]),
      .rx_axis_fifo_tdata(rx_axis_fifo_tdata[3]),
      .rx_axis_fifo_tkeep(rx_axis_fifo_tkeep[3]),
      .rx_axis_fifo_tvalid(rx_axis_fifo_tvalid[3]),
      .rx_axis_fifo_tlast(rx_axis_fifo_tlast[3]),
      .rx_axis_fifo_tready(rx_axis_fifo_tready[3]),
      
      .tx_axis_fifo_tdata(tx_axis_fifo_tdata[3]),
      .tx_axis_fifo_tkeep(tx_axis_fifo_tkeep[3]),
      .tx_axis_fifo_tvalid(tx_axis_fifo_tvalid[3]),
      .tx_axis_fifo_tlast(tx_axis_fifo_tlast[3]),
      .tx_axis_fifo_ready(tx_axis_fifo_tready[3]),
      
      .pause_req(1'b0),
      .pause_val(16'habcd),
   
      .gtx_clk(gtx_clk[3]),
      .xgmii_tx_clk(),
      .xgmii_txd(xgmii_txd[3]),
      .xgmii_txc(xgmii_txc[3]),
      .xgmii_rx_clk(rx_clk0[3]),
      .xgmii_rxd(xgmii_rxd[3]),
      .xgmii_rxc(xgmii_rxc[3]),
      
      .status_vector(status_vector_Mac4),
      .tx_fifo_full(tx_fifo_full4),
      .tx_fifo_status(tx_fifo_status4),
      .tx_axis_mac_tready(tx_axis_mac_tready4)
      );
////////////////////////////////////////////////////////////////////////                

    
endmodule
