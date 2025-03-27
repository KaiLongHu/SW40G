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
TODO: 
- Clock domain need to be setup well 
- status need flow depth paramter
- Ready need to be check, cant xx.ready=1'b1
 
//////////////////////////////////////////////////////////////////////////////////////////////*/
`timescale 1ns/1ns
module Sw_40g_Core (
    input  wire Rst_n,
    input  wire SysClk,//100M
    //use 156.25 10Gbase-R Clock for main logic
    //cpu spi

    //rmii 10M


    //aurora lane1*5G*3
    // [0] Payload Sensing(main)  udp_packed_unpacked
    // [1] Payload Sensing(back)  udp_packed_unpacked
    // [2] Data Transmit          interface-convert-only
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
    // [0] route(main)  Switch
    // [1] route(back)  Switch
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
    input   wire                      Base10G_tx_axis_fifo_aclk,
    output  wire  [3:0][63:0]         Base10G_tx_axis_fifo_tdata,
    output  wire  [3:0][7:0]          Base10G_tx_axis_fifo_tkeep,
    output  wire  [3:0]               Base10G_tx_axis_fifo_tvalid,
    output  wire  [3:0]               Base10G_tx_axis_fifo_tlast,
    input   wire  [3:0]               Base10G_tx_axis_fifo_tready,

    input   wire                      Base10G_rx_axis_fifo_aclk,
    input   wire  [3:0][63:0]         Base10G_rx_axis_fifo_tdata,
    input   wire  [3:0][7:0]          Base10G_rx_axis_fifo_tkeep,
    input   wire  [3:0]               Base10G_rx_axis_fifo_tvalid,
    input   wire  [3:0]               Base10G_rx_axis_fifo_tlast,
    output  wire  [3:0]               Base10G_rx_axis_fifo_tready,
    //Ctrl
    input wire [1:0]Route_Ctrl,
    input wire Src_Mac_Cfg,
    input wire Dst_Mac_Cfg,
    input wire Src_Ip_Cfg,
    input wire Dst_Ip_Cfg,
    input wire Src_UdpPort_Cfg,
    input wire Dst_UdpPort_Cfg
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

  localparam CROSS_DEPTH                = 4096;
  localparam CROSS_RAM_PIPELINE         = 1;
  localparam CROSS_OUTPUT_FIFO_EN       = 0;
  localparam CROSS_FRAME_FIFO           = 0;
  localparam CROSS_USER_BAD_FRAME_VALUE = 1;
  localparam CROSS_USER_BAD_FRAME_MASK  = 1;
  localparam CROSS_DROP_OVERSIZE_FRAME  = WIDTH_FRAME_FIFO;
  localparam CROSS_DROP_BAD_FRAME       = 0;
  localparam CROSS_DROP_WHEN_FULL       = 0;
  localparam CROSS_MARK_WHEN_FULL       = 0;
  localparam CROSS_PAUSE_EN             = 0;
  localparam CROSS_FRAME_PAUSE          = WIDTH_FRAME_FIFO;
  //--------------------------------------------
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  wire  [7:0][$clog2(WIDTH_DEPTH):0]   s_status_depth;
  wire  [7:0][$clog2(WIDTH_DEPTH):0]   s_status_depth_commit;
  wire  [7:0]                          s_status_overflow;
  wire  [7:0]                          s_status_bad_frame;
  wire  [7:0]                          s_status_good_frame;
  wire  [7:0][$clog2(WIDTH_DEPTH):0]   m_status_depth;
  wire  [7:0][$clog2(WIDTH_DEPTH):0]   m_status_depth_commit;
  wire  [7:0]                          m_status_overflow;
  wire  [7:0]                          m_status_bad_frame;
  wire  [7:0]                          m_status_good_frame;
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////            SUPPORT              ///////// ///////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // lane1_axi_if--------------------------------------------
  // [0] Payload Sensing(main)  udp_packed_unpacked
  // [1] Payload Sensing(back)  udp_packed_unpacked
  // [2] Data Transmit          interface-convert-only
  taxi_axis_if #(.DATA_W(64), .USER_W(3))  lane1_axi_tx[2:0]();
  taxi_axis_if #(.DATA_W(64), .USER_W(3))  lane1_axi_rx[2:0]();
  taxi_axis_if #(.DATA_W(64), .USER_W(3))  lane1_axi_rx_CDC_BaseR[1:0]();
  genvar i;
  generate
    for(i=0; i<2; i=i+1)
    begin:lane1_axi_Inst_loop

      assign lane1_s_axi_tx_tdata[i]    = lane1_axi_tx[i].tdata;
      assign lane1_s_axi_tx_tkeep[i]    = lane1_axi_tx[i].tkeep;
      assign lane1_s_axi_tx_tlast[i]    = lane1_axi_tx[i].tlast;
      assign lane1_s_axi_tx_tvalid[i]   = lane1_axi_tx[i].tvalid;
      assign lane1_axi_tx[i].tready = lane1_s_axi_tx_tready[i];

      assign lane1_axi_rx[i].tdata   = lane1_m_axi_rx_tdata[i];
      assign lane1_axi_rx[i].tkeep   = lane1_m_axi_rx_tkeep[i];
      assign lane1_axi_rx[i].tlast   = lane1_m_axi_rx_tlast[i];
      assign lane1_axi_rx[i].tvalid  = lane1_m_axi_rx_tvalid[i];
      //
      assign lane1_axi_rx[i].tuser  = i+1;

    end
  endgenerate
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // //lane4_axi_if--------------------------------------------
  // [0] route(main)  Switch
  // [1] route(back)  Switch
  taxi_axis_if #(.DATA_W(256), .USER_W(0))  lane4_axi_tx[1:0]();
  taxi_axis_if #(.DATA_W(256), .USER_W(0))  lane4_axi_rx[1:0]();
  taxi_axis_if #(.DATA_W(256), .USER_W(0))  lane4_axi_rx_W64[1:0]();//width convert

  assign lane4_s_axi_tx_tdata[0]          = (Route_Ctrl==2'd1)?Base10G_axi_rx_W256.tdata  :'0;
  assign lane4_s_axi_tx_tkeep[0]          = (Route_Ctrl==2'd1)?Base10G_axi_rx_W256.tkeep  :'0;
  assign lane4_s_axi_tx_tlast[0]          = (Route_Ctrl==2'd1)?Base10G_axi_rx_W256.tlast  :'0;
  assign lane4_s_axi_tx_tvalid[0]         = (Route_Ctrl==2'd1)?Base10G_axi_rx_W256.tvalid :'0;

  assign lane4_s_axi_tx_tdata[1]          = (Route_Ctrl==2'd2)?Base10G_axi_rx_W256.tdata  :'0;
  assign lane4_s_axi_tx_tkeep[1]          = (Route_Ctrl==2'd2)?Base10G_axi_rx_W256.tkeep  :'0;
  assign lane4_s_axi_tx_tlast[1]          = (Route_Ctrl==2'd2)?Base10G_axi_rx_W256.tlast  :'0;
  assign lane4_s_axi_tx_tvalid[1]         = (Route_Ctrl==2'd2)?Base10G_axi_rx_W256.tvalid :'0;

  assign Base10G_axi_rx_W256.tready       = (Route_Ctrl==2'd1)?lane4_s_axi_tx_tready[0]:lane4_s_axi_tx_tready[1];

  //
  assign lane4_axi_rx[0].tdata   = lane4_m_axi_rx_tdata[0];
  assign lane4_axi_rx[0].tkeep   = lane4_m_axi_rx_tkeep[0];
  assign lane4_axi_rx[0].tlast   = lane4_m_axi_rx_tlast[0];
  assign lane4_axi_rx[0].tvalid  = lane4_m_axi_rx_tvalid[0];

  assign lane4_axi_rx[1].tdata   = lane4_m_axi_rx_tdata[1];
  assign lane4_axi_rx[1].tkeep   = lane4_m_axi_rx_tkeep[1];
  assign lane4_axi_rx[1].tlast   = lane4_m_axi_rx_tlast[1];
  assign lane4_axi_rx[1].tvalid  = lane4_m_axi_rx_tvalid[1];

  // genvar j;
  // generate
  //   for(j=0; j<1; j=j+1)
  //   begin:lane4_axi_Inst_loop

  //     assign lane4_s_axi_tx_tdata[j]  = lane4_axi_tx[j].tdata;
  //     assign lane4_s_axi_tx_tkeep[j]  = lane4_axi_tx[j].tkeep;
  //     assign lane4_s_axi_tx_tlast[j]  = lane4_axi_tx[j].tlast;
  //     assign lane4_s_axi_tx_tvalid[j] = lane4_axi_tx[j].tvalid;
  //     assign lane4_axi_tx[j].tready = lane4_s_axi_tx_tready[j];

  //     assign lane4_axi_rx[j].tdata   = lane4_m_axi_rx_tdata[j];
  //     assign lane4_axi_rx[j].tkeep   = lane4_m_axi_rx_tkeep[j];
  //     assign lane4_axi_rx[j].tlast   = lane4_m_axi_rx_tlast[j];
  //     assign lane4_axi_rx[j].tvalid  = lane4_m_axi_rx_tvalid[j];
  //   end
  // endgenerate
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // //10G_axi_if--------------------------------------------
  //[0]:10G_route0
  //[1]:Payload Sensing
  //[2]:Data Transmit
  taxi_axis_if #(.DATA_W(64),.USER_W(0))  Base10G_axi_tx[3:0]();
  taxi_axis_if #(.DATA_W(64),.USER_W(0))  Base10G_axi_rx[3:0]();
  taxi_axis_if #(.DATA_W(64),.USER_W(0))  Base10G_axi_rx_W256();
  // taxi_axis_if #(.DATA_W(64),.USER_W(0))  Base10G_axi_tx_BaseRClk[3:0]();
  // taxi_axis_if #(.DATA_W(64),.USER_W(0))  Base10G_axi_rx_BaseRClk[3:0]();
  genvar k;
  generate
    for(k=0; k<3; k=k+1)
    begin:Base10G_axi_Inst_loop

      assign Base10G_tx_axis_fifo_tdata[k]  = Base10G_axi_tx[k].tdata;
      assign Base10G_tx_axis_fifo_tkeep[k]  = Base10G_axi_tx[k].tkeep;
      assign Base10G_tx_axis_fifo_tlast[k]  = Base10G_axi_tx[k].tlast;
      assign Base10G_tx_axis_fifo_tvalid[k] = Base10G_axi_tx[k].tvalid;
      assign Base10G_axi_tx[k].tready      = Base10G_tx_axis_fifo_tready[k];

      assign Base10G_axi_rx[k].tdata       = Base10G_rx_axis_fifo_tdata[k];
      assign Base10G_axi_rx[k].tkeep       = Base10G_rx_axis_fifo_tkeep[k];
      assign Base10G_axi_rx[k].tlast       = Base10G_rx_axis_fifo_tlast[k];
      assign Base10G_axi_rx[k].tvalid      = Base10G_rx_axis_fifo_tvalid[k];
      assign Base10G_rx_axis_fifo_tready[k] = Base10G_axi_rx[k].tready;
    end
  endgenerate
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////              Data Transmit             ////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // auror-->10G--------------------------------------------
  taxi_axis_async_fifo_adapter # (
                                 .DEPTH                              (CROSS_DEPTH               ),
                                 .RAM_PIPELINE                       (CROSS_RAM_PIPELINE        ),
                                 .OUTPUT_FIFO_EN                     (CROSS_OUTPUT_FIFO_EN      ),
                                 .FRAME_FIFO                         (CROSS_FRAME_FIFO          ),
                                 .USER_BAD_FRAME_VALUE               (CROSS_USER_BAD_FRAME_VALUE),
                                 .USER_BAD_FRAME_MASK                (CROSS_USER_BAD_FRAME_MASK ),
                                 .DROP_OVERSIZE_FRAME                (CROSS_DROP_OVERSIZE_FRAME ),
                                 .DROP_BAD_FRAME                     (CROSS_DROP_BAD_FRAME      ),
                                 .DROP_WHEN_FULL                     (CROSS_DROP_WHEN_FULL      ),
                                 .MARK_WHEN_FULL                     (CROSS_MARK_WHEN_FULL      ),
                                 .PAUSE_EN                           (CROSS_PAUSE_EN            ),
                                 .FRAME_PAUSE                        (CROSS_FRAME_PAUSE         )
                               )
                               taxi_axis_async_fifo_adapter_DataTransmit0  (
                                 .s_clk                              (lane1_m_axi_rx_clk        ),
                                 .s_rst                              (~Rst_n                    ),
                                 .s_axis                             (lane1_axi_rx[2]           ),
                                 .m_clk                              (lane4_s_axi_tx_clk        ),
                                 .m_rst                              (~Rst_n                    ),
                                 .m_axis                             (Base10G_axi_tx[2]         ),
                                 .s_pause_req                        (1'b0                      ),
                                 .s_pause_ack                        (s_pause_ack               ),
                                 .m_pause_req                        (1'b0                      ),
                                 .m_pause_ack                        (m_pause_ack               ),
                                 .s_status_depth                     (s_status_depth[0]         ),
                                 .s_status_depth_commit              (s_status_depth_commit[0]  ),
                                 .s_status_overflow                  (s_status_overflow[0]      ),
                                 .s_status_bad_frame                 (s_status_bad_frame[0]     ),
                                 .s_status_good_frame                (s_status_good_frame[0]    ),
                                 .m_status_depth                     (m_status_depth[0]         ),
                                 .m_status_depth_commit              (m_status_depth_commit[0]  ),
                                 .m_status_overflow                  (m_status_overflow[0]      ),
                                 .m_status_bad_frame                 (m_status_bad_frame[0]     ),
                                 .m_status_good_frame                (m_status_good_frame[0]    )
                               );
  //10G--->auror--------------------------------------------
  taxi_axis_async_fifo_adapter # (
                                 .DEPTH                              (CROSS_DEPTH               ),
                                 .RAM_PIPELINE                       (CROSS_RAM_PIPELINE        ),
                                 .OUTPUT_FIFO_EN                     (CROSS_OUTPUT_FIFO_EN      ),
                                 .FRAME_FIFO                         (CROSS_FRAME_FIFO          ),
                                 .USER_BAD_FRAME_VALUE               (CROSS_USER_BAD_FRAME_VALUE),
                                 .USER_BAD_FRAME_MASK                (CROSS_USER_BAD_FRAME_MASK ),
                                 .DROP_OVERSIZE_FRAME                (CROSS_DROP_OVERSIZE_FRAME ),
                                 .DROP_BAD_FRAME                     (CROSS_DROP_BAD_FRAME      ),
                                 .DROP_WHEN_FULL                     (CROSS_DROP_WHEN_FULL      ),
                                 .MARK_WHEN_FULL                     (CROSS_MARK_WHEN_FULL      ),
                                 .PAUSE_EN                           (CROSS_PAUSE_EN            ),
                                 .FRAME_PAUSE                        (CROSS_FRAME_PAUSE         )
                               )
                               taxi_axis_async_fifo_adapter_DataTransmit1  (
                                 .s_clk                              (lane1_m_axi_rx_clk        ),
                                 .s_rst                              (~Rst_n                    ),
                                 .s_axis                             (Base10G_axi_rx[2]         ),
                                 .m_clk                              (lane4_s_axi_tx_clk        ),
                                 .m_rst                              (~Rst_n                    ),
                                 .m_axis                             (lane1_axi_tx[0]           ),
                                 .s_pause_req                        (1'b0                      ),
                                 .s_pause_ack                        (s_pause_ack               ),
                                 .m_pause_req                        (1'b0                      ),
                                 .m_pause_ack                        (m_pause_ack               ),
                                 .s_status_depth                     (s_status_depth[1]         ),
                                 .s_status_depth_commit              (s_status_depth_commit[1]  ),
                                 .s_status_overflow                  (s_status_overflow[1]      ),
                                 .s_status_bad_frame                 (s_status_bad_frame[1]     ),
                                 .s_status_good_frame                (s_status_good_frame[1]    ),
                                 .m_status_depth                     (m_status_depth[1]         ),
                                 .m_status_depth_commit              (m_status_depth_commit[1]  ),
                                 .m_status_overflow                  (m_status_overflow[1]      ),
                                 .m_status_bad_frame                 (m_status_bad_frame[1]     ),
                                 .m_status_good_frame                (m_status_good_frame[1]    )
                               );

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////              Route                   //////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Width convert
  //256-->64--------------------------------------------
  //[0] route(main)  Switch
  taxi_axis_async_fifo_adapter # (
                                 .DEPTH                              (WIDTH_DEPTH               ),
                                 .RAM_PIPELINE                       (WIDTH_RAM_PIPELINE        ),
                                 .OUTPUT_FIFO_EN                     (WIDTH_OUTPUT_FIFO_EN      ),
                                 .FRAME_FIFO                         (WIDTH_FRAME_FIFO          ),
                                 .USER_BAD_FRAME_VALUE               (WIDTH_USER_BAD_FRAME_VALUE),
                                 .USER_BAD_FRAME_MASK                (WIDTH_USER_BAD_FRAME_MASK ),
                                 .DROP_OVERSIZE_FRAME                (WIDTH_DROP_OVERSIZE_FRAME ),
                                 .DROP_BAD_FRAME                     (WIDTH_DROP_BAD_FRAME      ),
                                 .DROP_WHEN_FULL                     (WIDTH_DROP_WHEN_FULL      ),
                                 .MARK_WHEN_FULL                     (WIDTH_MARK_WHEN_FULL      ),
                                 .PAUSE_EN                           (WIDTH_PAUSE_EN            ),
                                 .FRAME_PAUSE                        (WIDTH_FRAME_PAUSE         )
                               )
                               taxi_axis_async_fifo_adapter_WidthConvert0 (
                                 .s_clk                              (lane1_m_axi_rx_clk        ),
                                 .s_rst                              (~Rst_n                    ),
                                 .s_axis                             (lane4_axi_rx[0]           ),
                                 .m_clk                              (lane4_s_axi_tx_clk        ),
                                 .m_rst                              (~Rst_n                    ),
                                 .m_axis                             (lane4_axi_rx_W64[0]       ),
                                 .s_pause_req                        (1'b0                      ),
                                 .s_pause_ack                        (s_pause_ack               ),
                                 .m_pause_req                        (1'b0                      ),
                                 .m_pause_ack                        (m_pause_ack               ),
                                 .s_status_depth                     (s_status_depth[2]         ),
                                 .s_status_depth_commit              (s_status_depth_commit[2]  ),
                                 .s_status_overflow                  (s_status_overflow[2]      ),
                                 .s_status_bad_frame                 (s_status_bad_frame[2]     ),
                                 .s_status_good_frame                (s_status_good_frame[2]    ),
                                 .m_status_depth                     (m_status_depth[2]         ),
                                 .m_status_depth_commit              (m_status_depth_commit[2]  ),
                                 .m_status_overflow                  (m_status_overflow[2]      ),
                                 .m_status_bad_frame                 (m_status_bad_frame[2]     ),
                                 .m_status_good_frame                (m_status_good_frame[2]    )
                               );
  //256-->64--------------------------------------------
  //[1] route(main)  Switch
  taxi_axis_async_fifo_adapter # (
                                 .DEPTH                              (WIDTH_DEPTH               ),
                                 .RAM_PIPELINE                       (WIDTH_RAM_PIPELINE        ),
                                 .OUTPUT_FIFO_EN                     (WIDTH_OUTPUT_FIFO_EN      ),
                                 .FRAME_FIFO                         (WIDTH_FRAME_FIFO          ),
                                 .USER_BAD_FRAME_VALUE               (WIDTH_USER_BAD_FRAME_VALUE),
                                 .USER_BAD_FRAME_MASK                (WIDTH_USER_BAD_FRAME_MASK ),
                                 .DROP_OVERSIZE_FRAME                (WIDTH_DROP_OVERSIZE_FRAME ),
                                 .DROP_BAD_FRAME                     (WIDTH_DROP_BAD_FRAME      ),
                                 .DROP_WHEN_FULL                     (WIDTH_DROP_WHEN_FULL      ),
                                 .MARK_WHEN_FULL                     (WIDTH_MARK_WHEN_FULL      ),
                                 .PAUSE_EN                           (WIDTH_PAUSE_EN            ),
                                 .FRAME_PAUSE                        (WIDTH_FRAME_PAUSE         )
                               )
                               taxi_axis_async_fifo_adapter_WidthConvert1 (
                                 .s_clk                              (lane1_m_axi_rx_clk        ),
                                 .s_rst                              (~Rst_n                    ),
                                 .s_axis                             (lane4_axi_rx[1]           ),
                                 .m_clk                              (lane4_s_axi_tx_clk        ),
                                 .m_rst                              (~Rst_n                    ),
                                 .m_axis                             (lane4_axi_rx_W64[1]       ),
                                 .s_pause_req                        (1'b0                      ),
                                 .s_pause_ack                        (s_pause_ack               ),
                                 .m_pause_req                        (1'b0                      ),
                                 .m_pause_ack                        (m_pause_ack               ),
                                 .s_status_depth                     (s_status_depth[3]         ),
                                 .s_status_depth_commit              (s_status_depth_commit[3]  ),
                                 .s_status_overflow                  (s_status_overflow[3]      ),
                                 .s_status_bad_frame                 (s_status_bad_frame[3]     ),
                                 .s_status_good_frame                (s_status_good_frame[3]    ),
                                 .m_status_depth                     (m_status_depth[3]         ),
                                 .m_status_depth_commit              (m_status_depth_commit[3]  ),
                                 .m_status_overflow                  (m_status_overflow[3]      ),
                                 .m_status_bad_frame                 (m_status_bad_frame[3]     ),
                                 .m_status_good_frame                (m_status_good_frame[3]    )
                               );

  // MUX--------------------------------------------
  //lane4[0] & lane4[1] MUX---> Base10G_axi_tx[0]
  taxi_axis_mux_v1 # (
                     .S_COUNT                            (2                         )
                   )
                   taxi_axis_mux_inst (
                     .clk                                (lane1_m_axi_rx_clk        ),
                     .rst                                (~Rst_n                    ),
                     .s_axis                             ({lane4_axi_rx_W64[1],lane4_axi_rx_W64[0]}),
                     .m_axis                             (Base10G_axi_tx[0]         ),
                     .enable                             (1'b1                      ),
                     .select                             (Route_Ctrl[1]             ) //wait set
                   );

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Width convert & CDC
  //64-->256--------------------------------------------
  taxi_axis_async_fifo_adapter # (
                                 .DEPTH                              (WIDTH_DEPTH               ),
                                 .RAM_PIPELINE                       (WIDTH_RAM_PIPELINE        ),
                                 .OUTPUT_FIFO_EN                     (WIDTH_OUTPUT_FIFO_EN      ),
                                 .FRAME_FIFO                         (WIDTH_FRAME_FIFO          ),
                                 .USER_BAD_FRAME_VALUE               (WIDTH_USER_BAD_FRAME_VALUE),
                                 .USER_BAD_FRAME_MASK                (WIDTH_USER_BAD_FRAME_MASK ),
                                 .DROP_OVERSIZE_FRAME                (WIDTH_DROP_OVERSIZE_FRAME ),
                                 .DROP_BAD_FRAME                     (WIDTH_DROP_BAD_FRAME      ),
                                 .DROP_WHEN_FULL                     (WIDTH_DROP_WHEN_FULL      ),
                                 .MARK_WHEN_FULL                     (WIDTH_MARK_WHEN_FULL      ),
                                 .PAUSE_EN                           (WIDTH_PAUSE_EN            ),
                                 .FRAME_PAUSE                        (WIDTH_FRAME_PAUSE         )
                               )
                               taxi_axis_async_fifo_adapter_WidthConvert2 (
                                 .s_clk                              (lane1_m_axi_rx_clk        ),
                                 .s_rst                              (~Rst_n                    ),
                                 .s_axis                             (Base10G_axi_rx[0]         ),
                                 .m_clk                              (lane4_s_axi_tx_clk        ),
                                 .m_rst                              (~Rst_n                    ),
                                 .m_axis                             (Base10G_axi_rx_W256       ),
                                 .s_pause_req                        (1'b0                      ),
                                 .s_pause_ack                        (s_pause_ack               ),
                                 .m_pause_req                        (1'b0                      ),
                                 .m_pause_ack                        (m_pause_ack               ),
                                 .s_status_depth                     (s_status_depth[4]         ),
                                 .s_status_depth_commit              (s_status_depth_commit[4]  ),
                                 .s_status_overflow                  (s_status_overflow[4]      ),
                                 .s_status_bad_frame                 (s_status_bad_frame[4]     ),
                                 .s_status_good_frame                (s_status_good_frame[4]    ),
                                 .m_status_depth                     (m_status_depth[4]         ),
                                 .m_status_depth_commit              (m_status_depth_commit[4]  ),
                                 .m_status_overflow                  (m_status_overflow[4]      ),
                                 .m_status_bad_frame                 (m_status_bad_frame[4]     ),
                                 .m_status_good_frame                (m_status_good_frame[4]    )
                               );

  // //Demux--------------------------------------------
  // //Base10G_axi_tx[0] ---> lane4[0] & lane4[1]
  // taxi_axis_broadcast # (
  //                       .M_COUNT(2)
  //                     )
  //                     taxi_axis_broadcast_inst (
  //                       .clk(lane1_m_axi_rx_clk),
  //                       .rst(~Rst_n),
  //                       .s_axis(Base10G_axi_rx_W256),
  //                       .m_axis(Base10G_axi_rx_W256)
  //                     );


  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////           payload sensing         /////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // CDC--------------------------------------------
  // [0] Payload Sensing(main) --->BASER CD
  taxi_axis_async_fifo_adapter # (
                                 .DEPTH                              (CROSS_DEPTH               ),
                                 .RAM_PIPELINE                       (CROSS_RAM_PIPELINE        ),
                                 .OUTPUT_FIFO_EN                     (CROSS_OUTPUT_FIFO_EN      ),
                                 .FRAME_FIFO                         (CROSS_FRAME_FIFO          ),
                                 .USER_BAD_FRAME_VALUE               (CROSS_USER_BAD_FRAME_VALUE),
                                 .USER_BAD_FRAME_MASK                (CROSS_USER_BAD_FRAME_MASK ),
                                 .DROP_OVERSIZE_FRAME                (CROSS_DROP_OVERSIZE_FRAME ),
                                 .DROP_BAD_FRAME                     (CROSS_DROP_BAD_FRAME      ),
                                 .DROP_WHEN_FULL                     (CROSS_DROP_WHEN_FULL      ),
                                 .MARK_WHEN_FULL                     (CROSS_MARK_WHEN_FULL      ),
                                 .PAUSE_EN                           (CROSS_PAUSE_EN            ),
                                 .FRAME_PAUSE                        (CROSS_FRAME_PAUSE         )
                               )
                               taxi_axis_async_fifo_adapter_CDC0 (
                                 .s_clk                              (lane1_m_axi_rx_clk        ),
                                 .s_rst                              (~Rst_n                    ),
                                 .s_axis                             (lane1_axi_rx[0]           ),
                                 .m_clk                              (lane4_s_axi_tx_clk        ),
                                 .m_rst                              (~Rst_n                    ),
                                 .m_axis                             (lane1_axi_rx_CDC_BaseR[0] ),
                                 .s_pause_req                        (1'b0                      ),
                                 .s_pause_ack                        (s_pause_ack               ),
                                 .m_pause_req                        (1'b0                      ),
                                 .m_pause_ack                        (m_pause_ack               ),
                                 .s_status_depth                     (s_status_depth[5]         ),
                                 .s_status_depth_commit              (s_status_depth_commit[5]  ),
                                 .s_status_overflow                  (s_status_overflow[5]      ),
                                 .s_status_bad_frame                 (s_status_bad_frame[5]     ),
                                 .s_status_good_frame                (s_status_good_frame[5]    ),
                                 .m_status_depth                     (m_status_depth[5]         ),
                                 .m_status_depth_commit              (m_status_depth_commit[5]  ),
                                 .m_status_overflow                  (m_status_overflow[5]      ),
                                 .m_status_bad_frame                 (m_status_bad_frame[5]     ),
                                 .m_status_good_frame                (m_status_good_frame[5]    )
                               );

  //CDC--------------------------------------------
  // [1] Payload Sensing(back)  --->BASER CD
  taxi_axis_async_fifo_adapter # (
                                 .DEPTH                              (CROSS_DEPTH               ),
                                 .RAM_PIPELINE                       (CROSS_RAM_PIPELINE        ),
                                 .OUTPUT_FIFO_EN                     (CROSS_OUTPUT_FIFO_EN      ),
                                 .FRAME_FIFO                         (CROSS_FRAME_FIFO          ),
                                 .USER_BAD_FRAME_VALUE               (CROSS_USER_BAD_FRAME_VALUE),
                                 .USER_BAD_FRAME_MASK                (CROSS_USER_BAD_FRAME_MASK ),
                                 .DROP_OVERSIZE_FRAME                (CROSS_DROP_OVERSIZE_FRAME ),
                                 .DROP_BAD_FRAME                     (CROSS_DROP_BAD_FRAME      ),
                                 .DROP_WHEN_FULL                     (CROSS_DROP_WHEN_FULL      ),
                                 .MARK_WHEN_FULL                     (CROSS_MARK_WHEN_FULL      ),
                                 .PAUSE_EN                           (CROSS_PAUSE_EN            ),
                                 .FRAME_PAUSE                        (CROSS_FRAME_PAUSE         )
                               )
                               taxi_axis_async_fifo_adapter_CDC1 (
                                 .s_clk                              (lane1_m_axi_rx_clk        ),
                                 .s_rst                              (~Rst_n                    ),
                                 .s_axis                             (lane1_axi_rx[1]           ),
                                 .m_clk                              (lane4_s_axi_tx_clk        ),
                                 .m_rst                              (~Rst_n                    ),
                                 .m_axis                             (lane1_axi_rx_CDC_BaseR[1] ),
                                 .s_pause_req                        (1'b0                      ),
                                 .s_pause_ack                        (s_pause_ack               ),
                                 .m_pause_req                        (1'b0                      ),
                                 .m_pause_ack                        (m_pause_ack               ),
                                 .s_status_depth                     (s_status_depth[6]         ),
                                 .s_status_depth_commit              (s_status_depth_commit[6]  ),
                                 .s_status_overflow                  (s_status_overflow[6]      ),
                                 .s_status_bad_frame                 (s_status_bad_frame[6]     ),
                                 .s_status_good_frame                (s_status_good_frame[6]    ),
                                 .m_status_depth                     (m_status_depth[6]         ),
                                 .m_status_depth_commit              (m_status_depth_commit[6]  ),
                                 .m_status_overflow                  (m_status_overflow[6]      ),
                                 .m_status_bad_frame                 (m_status_bad_frame[6]     ),
                                 .m_status_good_frame                (m_status_good_frame[6]    )
                               );


  assign lane1_axi_rx_CDC_BaseR[0].tready=1'b1;//.@
  assign lane1_axi_rx_CDC_BaseR[1].tready=1'b1;//.@



endmodule
