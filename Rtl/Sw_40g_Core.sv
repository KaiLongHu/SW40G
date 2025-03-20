/*//////////////////////////////////////////////////////////////////////////////////////////////
+--+--+---+-+---+----+
|  |  |   | /   |    |
|  |--|   --    |    |
|  |  |   | \   ---- |
|--+--+---+-+--------+
Module Name:Sw_40g_Core
Provider:HuKaiLong
Creat Time:2025-03-13 10:47:11
Target Platform:
Function Description: 
//////////////////////////////////////////////////////////////////////////////////////////////*/
`timescale 1ns/1ns
module Sw_40g_Core (
    input  wire Rst_n,
    input  wire SysClk,
    //cpu spi

    //rmii 10M





    // //aurora lane1*5G*3--------------------------------------------
    // //  * AXI4-Stream input (sink)
    // input  wire                          Aurora_lane1_s_clk,
    // input  wire                          Aurora_lane1_s_rst,
    // taxi_axis_if.snk                     Aurora_lane1_0_s_axis,
    // taxi_axis_if.snk                     Aurora_lane1_1_s_axis,
    // taxi_axis_if.snk                     Aurora_lane1_2_s_axis,

    // // * AXI4-Stream output (source)
    // input  wire                          Aurora_lane1_m_clk,
    // input  wire                          Aurora_lane1_m_rst,
    // taxi_axis_if.src                     Aurora_lane1_0_m_axis,
    // taxi_axis_if.src                     Aurora_lane1_1_m_axis,
    // taxi_axis_if.src                     Aurora_lane1_2_m_axis,

    // //aurora lane4*25G*2--------------------------------------------
    // //  * AXI4-Stream input (sink)
    // input  wire                          Aurora_lane4_s_clk,
    // input  wire                          Aurora_lane4_s_rst,
    // taxi_axis_if.snk                     Aurora_lane4_0_s_axis,
    // taxi_axis_if.snk                     Aurora_lane4_1_s_axis,
    // taxi_axis_if.snk                     Aurora_lane4_2_s_axis,

    // // * AXI4-Stream output (source)
    // input  wire                          Aurora_lane4_m_clk,
    // input  wire                          Aurora_lane4_m_rst,
    // taxi_axis_if.src                     Aurora_lane4_0_m_axis,
    // taxi_axis_if.src                     Aurora_lane4_1_m_axis,
    // taxi_axis_if.src                     Aurora_lane4_2_m_axis,









         //aurora lane1*5G*3
        input   wire                      lane1_s_axi_tx_clk,
        output  wire    [2:0] [63 : 0]    lane1_s_axi_tx_tdata,
        output  wire    [2:0] [7  : 0]    lane1_s_axi_tx_tkeep,
        output  wire    [2:0]             lane1_s_axi_tx_tlast,
        output  wire    [2:0]             lane1_s_axi_tx_tvalid,
        input   wire    [2:0]             lane1_s_axi_tx_tready,
     
        input   wire                      lane1_m_axi_rx_clk,
        input   wire    [2:0] [63 : 0]    lane1_m_axi_rx_tdata,
        input   wire    [2:0] [7 : 0]     lane1_m_axi_rx_tkeep,
        input   wire    [2:0]             lane1_m_axi_rx_tlast,
        input   wire    [2:0]             lane1_m_axi_rx_tvalid,
        //aurora lane4*25G*2
        input   wire                      lane4_s_axi_tx_clk,
        output  wire    [1:0] [255: 0]    lane4_s_axi_tx_tdata,
        output  wire    [1:0] [31 : 0]    lane4_s_axi_tx_tkeep,
        output  wire    [1:0]             lane4_s_axi_tx_tlast,
        output  wire    [1:0]             lane4_s_axi_tx_tvalid,
        input   wire    [1:0]             lane4_s_axi_tx_tready,
     
        input   wire                      lane4_m_axi_rx_clk,
        input   wire    [1:0] [63 : 0]    lane4_m_axi_rx_tdata,
        input   wire    [1:0] [31: 0]     lane4_m_axi_rx_tkeep,
        input   wire    [1:0]             lane4_m_axi_rx_tlast,
        input   wire    [1:0]             lane4_m_axi_rx_tvalid,
        //10G-Base-R *4
        input   wire  [3:0]               Base10G_tx_axis_fifo_aclk,
        output  wire  [3:0][63:0]         Base10G_tx_axis_fifo_tdata,
        output  wire  [3:0][7:0]          Base10G_tx_axis_fifo_tkeep,
        output  wire  [3:0]               Base10G_tx_axis_fifo_tvalid,
        output  wire  [3:0]               Base10G_tx_axis_fifo_tlast,
        input   wire  [3:0]               Base10G_tx_axis_fifo_tready,
     
        input   wire  [3:0]               Base10G_rx_axis_fifo_aclk,
        input   wire  [3:0][63:0]         Base10G_rx_axis_fifo_tdata,
        input   wire  [3:0][7:0]          Base10G_rx_axis_fifo_tkeep,
        input   wire  [3:0]               Base10G_rx_axis_fifo_tvalid,
        input   wire  [3:0]               Base10G_rx_axis_fifo_tlast,
        output  wire  [3:0]               Base10G_rx_axis_fifo_tready 
    //CAN

    //422


  );

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////              SIGDEF                   /////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //--------------------------------------------
  localparam WIDTH_DEPTH                = 4096;
  localparam WIDTH_RAM_PIPELINE         = 1;
  localparam WIDTH_OUTPUT_FIFO_EN       = 0;
  localparam WIDTH_FRAME_FIFO           = 0;
  localparam WIDTH_USER_BAD_FRAME_VALUE = 1;
  localparam WIDTH_USER_BAD_FRAME_MASK  = 1;
  localparam WIDTH_DROP_OVERSIZE_FRAME  = WIDTH_FRAME_FIFO;
  localparam WIDTH_DROP_BAD_FRAME       = 0;
  localparam WIDTH_DROP_WHEN_FULL       = 0;
  localparam WIDTH_MARK_WHEN_FULL       = 0;
  localparam WIDTH_PAUSE_EN             = 0;
  localparam WIDTH_FRAME_PAUSE          = WIDTH_FRAME_FIFO;

  // localparam CROSS_DEPTH                = 4096;
  // localparam CROSS_RAM_PIPELINE         = 1;
  // localparam CROSS_OUTPUT_FIFO_EN       = 0;
  // localparam CROSS_FRAME_FIFO           = 1;
  // localparam CROSS_USER_BAD_FRAME_VALUE = 1;
  // localparam CROSS_USER_BAD_FRAME_MASK  = 1;
  // localparam CROSS_DROP_OVERSIZE_FRAME  = 1;
  // localparam CROSS_DROP_BAD_FRAME       = 1;
  // localparam CROSS_DROP_WHEN_FULL       = 1;
  // localparam CROSS_MARK_WHEN_FULL       = 1;
  // localparam CROSS_PAUSE_EN             = 1;
  // localparam CROSS_FRAME_PAUSE          = 1;
  //--------------------------------------------

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////            SUPPORT              ////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // lane1_axi_if--------------------------------------------
/*   taxi_axis_if #(.DATA_W(64),  .ID_W(1), .DEST_W(1), .USER_W(1))  lane1_axi[2:0]();//.@
  genvar i;
  generate
    for(i=0; i<2; i=i+1)
    begin:lane1_axi_Inst_loop

      assign lane1_s_axi_tx_tdata[i]  = lane1_axi[i].src.tdata;
      assign lane1_s_axi_tx_tkeep[i]  = lane1_axi[i].src.tkeep;
      assign lane1_s_axi_tx_tlast[i]  = lane1_axi[i].src.tlast;
      assign lane1_s_axi_tx_tvalid[i] = lane1_axi[i].src.tvalid;
      assign lane1_axi[i].src.tready = lane1_s_axi_tx_tready[i];

      assign lane1_axi[i].snk.tdata   = lane1_m_axi_rx_tdata[i];
      assign lane1_axi[i].snk.tkeep   = lane1_m_axi_rx_tkeep[i];
      assign lane1_axi[i].snk.tlast   = lane1_m_axi_rx_tlast[i];
      assign lane1_axi[i].snk.tvalid  = lane1_m_axi_rx_tvalid[i];
    end
  endgenerate

  //lane4_axi_if--------------------------------------------
  taxi_axis_if #(.DATA_W(64),  .ID_W(0), .DEST_W(0), .USER_W(0))  lane4_axi[1:0]();
  genvar j;
  generate
    for(j=0; j<1; j=j+1)
    begin:lane4_axi_Inst_loop

      assign lane4_s_axi_tx_tdata[j]  = lane4_axi[j].src.tdata;
      assign lane4_s_axi_tx_tkeep[j]  = lane4_axi[j].src.tkeep;
      assign lane4_s_axi_tx_tlast[j]  = lane4_axi[j].src.tlast;
      assign lane4_s_axi_tx_tvalid[j] = lane4_axi[j].src.tvalid;
      assign lane4_axi[j].src.tready = lane4_s_axi_tx_tready[j];

      assign lane4_axi[j].snk.tdata   = lane4_m_axi_rx_tdata[j];
      assign lane4_axi[j].snk.tkeep   = lane4_m_axi_rx_tkeep[j];
      assign lane4_axi[j].snk.tlast   = lane4_m_axi_rx_tlast[j];
      assign lane4_axi[j].snk.tvalid  = lane4_m_axi_rx_tvalid[j];
    end
  endgenerate

  //10G_axi_if--------------------------------------------
  taxi_axis_if #(.DATA_W(64),  .ID_W(0), .DEST_W(0), .USER_W(0))  Base10G_axi[3:0]();
  genvar k;
  generate
    for(k=0; k<3; k=k+1)
    begin:Base10G_axi_Inst_loop

      assign Base10G_tx_axis_fifo_tdata[k]  = Base10G_axi[k].src.tdata;
      assign Base10G_tx_axis_fifo_tkeep[k]  = Base10G_axi[k].src.tkeep;
      assign Base10G_tx_axis_fifo_tlast[k]  = Base10G_axi[k].src.tlast;
      assign Base10G_tx_axis_fifo_tvalid[k] = Base10G_axi[k].src.tvalid;
      assign Base10G_axi[k].src.tready      = Base10G_tx_axis_fifo_tready[k];

      assign Base10G_axi[k].snk.tdata       = Base10G_rx_axis_fifo_tdata[k];
      assign Base10G_axi[k].snk.tkeep       = Base10G_rx_axis_fifo_tkeep[k];
      assign Base10G_axi[k].snk.tlast       = Base10G_rx_axis_fifo_tlast[k];
      assign Base10G_axi[k].snk.tvalid      = Base10G_rx_axis_fifo_tvalid[k];
      assign Base10G_rx_axis_fifo_tready[k] = Base10G_axi[k].snk.tready;
    end
  endgenerate  */

  taxi_axis_if #(.DATA_W(64),  .ID_W(1), .DEST_W(1), .USER_W(1))  lane1_axi[2:0]();
  taxi_axis_if #(.DATA_W(64),  .ID_W(0), .DEST_W(0), .USER_W(0))  lane4_axi[1:0]();
  taxi_axis_if #(.DATA_W(64),  .ID_W(0), .DEST_W(0), .USER_W(0))  Base10G_axi[3:0]();

  assign lane4_s_axi_tx_tdata[0]  = lane4_axi[0].src.tdata;
  assign lane4_s_axi_tx_tkeep[0]  = lane4_axi[0].src.tkeep;
  assign lane4_s_axi_tx_tlast[0]  = lane4_axi[0].src.tlast;
  assign lane4_s_axi_tx_tvalid[0] = lane4_axi[0].src.tvalid;
  assign lane4_axi[0].src.tready = lane4_s_axi_tx_tready[0];

  assign lane4_axi[0].snk.tdata   = lane4_m_axi_rx_tdata[0];
  assign lane4_axi[0].snk.tkeep   = lane4_m_axi_rx_tkeep[0];
  assign lane4_axi[0].snk.tlast   = lane4_m_axi_rx_tlast[0];
  assign lane4_axi[0].snk.tvalid  = lane4_m_axi_rx_tvalid[0];

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////              SUPPORT                   /////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////            Width   convert  ///////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  taxi_axis_async_fifo_adapter # (
                                 .DEPTH(WIDTH_DEPTH),
                                 .RAM_PIPELINE(WIDTH_RAM_PIPELINE),
                                 .OUTPUT_FIFO_EN(WIDTH_OUTPUT_FIFO_EN),
                                 .FRAME_FIFO(WIDTH_FRAME_FIFO),
                                 .USER_BAD_FRAME_VALUE(WIDTH_USER_BAD_FRAME_VALUE),
                                 .USER_BAD_FRAME_MASK(WIDTH_USER_BAD_FRAME_MASK),
                                 .DROP_OVERSIZE_FRAME(WIDTH_DROP_OVERSIZE_FRAME),
                                 .DROP_BAD_FRAME(WIDTH_DROP_BAD_FRAME),
                                 .DROP_WHEN_FULL(WIDTH_DROP_WHEN_FULL),
                                 .MARK_WHEN_FULL(WIDTH_MARK_WHEN_FULL),
                                 .PAUSE_EN(WIDTH_PAUSE_EN),
                                 .FRAME_PAUSE(WIDTH_FRAME_PAUSE)
                               )
taxi_axis_async_fifo_adapter_inst0 (
                                 .s_clk(lane1_m_axi_rx_clk),
                                 .s_rst(Rst_n),
                                 .s_axis(lane4_axi[0].snk),
                                 .m_clk(lane4_s_axi_tx_clk),
                                 .m_rst(Rst_n),
                                 .m_axis(lane4_axi[0].src),
                                 .s_pause_req(1'b0),
                                 .s_pause_ack(s_pause_ack),
                                 .m_pause_req(1'b0),
                                 .m_pause_ack(m_pause_ack),
                                 .s_status_depth(s_status_depth),
                                 .s_status_depth_commit(s_status_depth_commit),
                                 .s_status_overflow(s_status_overflow),
                                 .s_status_bad_frame(s_status_bad_frame),
                                 .s_status_good_frame(s_status_good_frame),
                                 .m_status_depth(m_status_depth),
                                 .m_status_depth_commit(m_status_depth_commit),
                                 .m_status_overflow(m_status_overflow),
                                 .m_status_bad_frame(m_status_bad_frame),
                                 .m_status_good_frame(m_status_good_frame)
                               );






  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////           async adapter         /////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  // taxi_axis_async_fifo_adapter # (
  //                                .DEPTH(CROSS_DEPTH),
  //                                .RAM_PIPELINE(CROSS_RAM_PIPELINE),
  //                                .OUTPUT_FIFO_EN(CROSS_OUTPUT_FIFO_EN),
  //                                .FRAME_FIFO(CROSS_FRAME_FIFO),
  //                                .USER_BAD_FRAME_VALUE(CROSS_USER_BAD_FRAME_VALUE),
  //                                .USER_BAD_FRAME_MASK(CROSS_USER_BAD_FRAME_MASK),
  //                                .DROP_OVERSIZE_FRAME(CROSS_DROP_OVERSIZE_FRAME),
  //                                .DROP_BAD_FRAME(CROSS_DROP_BAD_FRAME),
  //                                .DROP_WHEN_FULL(CROSS_DROP_WHEN_FULL),
  //                                .MARK_WHEN_FULL(CROSS_MARK_WHEN_FULL),
  //                                .PAUSE_EN(CROSS_PAUSE_EN),
  //                                .FRAME_PAUSE(CROSS_FRAME_PAUSE)
  //                              )
  //                              taxi_axis_async_fifo_adapter_inst0 (
  //                                .s_clk(s_clk),
  //                                .s_rst(s_rst),
  //                                .s_axis(s_axis),
  //                                .m_clk(m_clk),
  //                                .m_rst(m_rst),
  //                                .m_axis(m_axis),
  //                                .s_pause_req(s_pause_req),
  //                                .s_pause_ack(s_pause_ack),
  //                                .m_pause_req(m_pause_req),
  //                                .m_pause_ack(m_pause_ack),
  //                                .s_status_depth(s_status_depth),
  //                                .s_status_depth_commit(s_status_depth_commit),
  //                                .s_status_overflow(s_status_overflow),
  //                                .s_status_bad_frame(s_status_bad_frame),
  //                                .s_status_good_frame(s_status_good_frame),
  //                                .m_status_depth(m_status_depth),
  //                                .m_status_depth_commit(m_status_depth_commit),
  //                                .m_status_overflow(m_status_overflow),
  //                                .m_status_bad_frame(m_status_bad_frame),
  //                                .m_status_good_frame(m_status_good_frame)
  //                              );





endmodule
