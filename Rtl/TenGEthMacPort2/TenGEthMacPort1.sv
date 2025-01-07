`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/05 10:25:29
// Design Name: 
// Module Name: TenGEthMacPort2New
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
module TenGEthMacPort1(
   input  wire              reset,
   //XGMII Ifc 
   input  wire         gtx_clk,
   output wire  [63:0] xgmii_txd,
   output wire  [7:0]  xgmii_txc,
   
   input  wire         rx_clk0,
   input  wire  [63:0] xgmii_rxd,
   input  wire  [7:0]  xgmii_rxc,
   
   output wire [2:0]       status_vector_Mac1,
   //User Data Ifc
   input  wire         tx_axis_aresetn,
   input  wire  [63:0] tx_axis_fifo_tdata,
   input  wire  [7:0]  tx_axis_fifo_tkeep,
   input  wire         tx_axis_fifo_tvalid,
   input  wire         tx_axis_fifo_tlast,
   output wire         tx_axis_fifo_tready,   

   input  wire         rx_axis_aresetn,
   output wire  [63:0] rx_axis_fifo_tdata,
   output wire  [7:0]  rx_axis_fifo_tkeep,
   output wire         rx_axis_fifo_tvalid,
   output wire         rx_axis_fifo_tlast,
   input  wire         rx_axis_fifo_tready,
   output wire         user_clk,
   
   output wire        tx_fifo_full,
   output wire  [3:0] tx_fifo_status,
   output wire        tx_axis_mac_tready

);
//////////////////////////////////////////////////////////////////////// 
   wire        tx_fifo_full1;
   wire [3:0]  tx_fifo_status1;
   wire        tx_axis_mac_tready1;

   
   assign tx_fifo_full   = tx_fifo_full1;
   assign tx_fifo_status = tx_fifo_status1;
   assign tx_axis_mac_tready = tx_axis_mac_tready1;
//////////////////////////////////////////////////////////////////////// 
//ethernet_Mac1   
 ten_gig_eth_mac_0_example_design  ten_gig_eth_mac_0_example_design_Inst0(
   .reset(reset),
   .tx_axis_aresetn(tx_axis_aresetn),
   .rx_axis_aresetn(rx_axis_aresetn),
   .tx_statistics_vector(),
   .rx_statistics_vector(),
   .gen_active_flash(),
   .check_active_flash(),
   .frame_error(),
   
   .user_clk(user_clk),
   .rx_axis_fifo_tdata(rx_axis_fifo_tdata),
   .rx_axis_fifo_tkeep(rx_axis_fifo_tkeep),
   .rx_axis_fifo_tvalid(rx_axis_fifo_tvalid),
   .rx_axis_fifo_tlast(rx_axis_fifo_tlast),
   .rx_axis_fifo_tready(rx_axis_fifo_tready),
   
   .tx_axis_fifo_tdata(tx_axis_fifo_tdata),
   .tx_axis_fifo_tkeep(tx_axis_fifo_tkeep),
   .tx_axis_fifo_tvalid(tx_axis_fifo_tvalid),
   .tx_axis_fifo_tlast(tx_axis_fifo_tlast),
   .tx_axis_fifo_ready(tx_axis_fifo_tready),
   
   .pause_req(1'b0),
   .pause_val(16'habcd),

   .gtx_clk(gtx_clk),
   .xgmii_tx_clk(),
   .xgmii_txd(xgmii_txd),
   .xgmii_txc(xgmii_txc),
   .xgmii_rx_clk(rx_clk0),
   .xgmii_rxd(xgmii_rxd),
   .xgmii_rxc(xgmii_rxc),
   
   .status_vector(status_vector_Mac1),
   .tx_fifo_full(tx_fifo_full1),
   .tx_fifo_status(tx_fifo_status1),
   .tx_axis_mac_tready(tx_axis_mac_tready1)
   );
//////////////////////////////////////////////////////////////////////   

    
endmodule
