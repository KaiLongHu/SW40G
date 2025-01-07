/*//////////////////////////////////////////////////////////////////////////////////////////////
+--+--+---+-+---+----+
|  |  |   | /   |    |
|  |--|   --    |    |
|  |  |   | \   ---- |
|--+--+---+-+--------+
Module Name:aurora_channel_lane2
Provider:HuKaiLong
Creat Time:2025-01-06 09:51:47
Target Platform:
Function Description: 
//////////////////////////////////////////////////////////////////////////////////////////////*/
`timescale 1ns/1ns
module aurora_channel_lane2_Y0Y1 (
    input               gt_rx_p             ,//GT收发器的接收数据差分引脚；
    input               gt_rx_n             ,//GT收发器的接收数据差分引脚；
    input               gt_refclk           ,//GT参考时钟，IP设置为156.25MHZ;
    // output              user_clk            ,//用户参考时钟信号；
    output              user_sys_reset      ,//输出给用户的复位信号；
    input               system_rst          ,//系统复位信号；
    input   [2 : 0]     gt_loopback         ,//GT收发器的回环模式控制信号；
    output              gt_tx_p             ,//GT收发器的发送数据差分引脚；
    output              gt_tx_n             ,//GT收发器的发送数据差分引脚；
    output              hard_err            ,//硬件错误指示信号；
    output              soft_err            ,//软件错误指示信号；
    output              channel_up          ,//通道初始化完成且通道准备好数据时拉高；
    output              lane_up             ,//单通道初始化成功信号；
    input   [63 : 0]    s_axi_tx_tdata      ,//用户发送数据的AXI_STEAM流接口信号；
    input   [7  : 0]    s_axi_tx_tkeep      ,//用户发送数据的AXI_STEAM流接口信号；
    input               s_axi_tx_tlast      ,//用户发送数据的AXI_STEAM流接口信号；
    input               s_axi_tx_tvalid     ,//用户发送数据的AXI_STEAM流接口信号；
    output              s_axi_tx_tready     ,//用户发送数据的AXI_STEAM流接口信号；
    output  [63 : 0]    m_axi_rx_tdata      ,//用户接收数据的AXI_STEAM流接口信号；
    output  [7 : 0]     m_axi_rx_tkeep      ,//用户接收数据的AXI_STEAM流接口信号；
    output              m_axi_rx_tlast      ,//用户接收数据的AXI_STEAM流接口信号；
    output              m_axi_rx_tvalid     ,//用户接收数据的AXI_STEAM流接口信号；
    input               init_clk            ,//初始化时钟，IP设置为100MHz。
    input               drp_clk             ,//DRP时钟信号,IP设置为100MHz。
    // input   [8 : 0]     gt_drpaddr          ,//GT收发器的DRP地址信号；
    // input   [15 : 0]    gt_drpdi            ,//GT收发器的DRP数据输入信号；
    // output              gt_drprdy           ,//GT收发器的DRP应答信号；
    // input               gt_drpen            ,//GT收发器的DRP使能信号；
    // input               gt_drpwe            ,//GT收发器的DRP读写指示信号；
    // output  [15 : 0]    gt_drpdo            ,//GT收发器的DRP数据输出信号；
    // input   [7 : 0]     qpll_drpaddr        ,//QPLL的DRP地址信号；
    // input   [15 : 0]    qpll_drpdi          ,//QPLL的DRP数据输入信号；
    // input               qpll_drpen          ,//QPLL的DRP使能信号；
    // input               qpll_drpwe          ,//QPLL的DRP读写指示信号；
    // input               gt_qpllclk          ,//QPLL的时钟信号；
    // input               gt_qpllrefclk       ,//QPLL的参考时钟信号；
    // output              gt_qpllreset        ,//QPLL的复位信号；
    // input               gt_qplllock         ,//QPLL的锁定信号；
    // input               gt_qpllrefclklost   ,//QPLL的参考时钟失锁信号；

    output wire tx_out_clk,
    output wire gt_pll_lock,
    input  wire user_clk,
    input  wire sync_clk,
    input  wire mmcm_not_locked

  );
  // wire                tx_out_clk          ;
  // wire                mmcm_not_locked     ;
  // wire                gt_pll_lock         ;
  // wire                sync_clk            ;
  wire                reset_pb            ;
  wire                gt_rst              ;

  //例化复位同步模块；
  Aurora_64B_Framing_lane2_Y0Y1_SUPPORT_RESET_LOGIC support_reset_logic(
                                                      .RESET          ( system_rst        ),//系统复位信号；
                                                      .USER_CLK       ( user_clk          ),//用户时钟信号；
                                                      .INIT_CLK       ( init_clk          ),//初始化时钟；
                                                      .GT_RESET_IN    ( 1'b0              ),//GT收发器复位信号；
                                                      .SYSTEM_RESET   ( reset_pb          ),//IP复位信号；
                                                      .GT_RESET_OUT   ( gt_rst            ) //GT收发器复位信号；
                                                    );

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////                                 /////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Aurora_64B_Framing_lane2_Y0Y1 Aurora_64B_Framing_lane2_Y0Y1_i
                                (
                                  // TX AXI4-S Interface
                                  .s_axi_tx_tdata(s_axi_tx_tdata),
                                  .s_axi_tx_tlast(s_axi_tx_tlast),
                                  .s_axi_tx_tkeep(s_axi_tx_tkeep),
                                  .s_axi_tx_tvalid(s_axi_tx_tvalid),
                                  .s_axi_tx_tready(s_axi_tx_tready),

                                  // RX AXI4-S Interface
                                  .m_axi_rx_tdata(m_axi_rx_tdata),
                                  .m_axi_rx_tlast(m_axi_rx_tlast),
                                  .m_axi_rx_tkeep(m_axi_rx_tkeep),
                                  .m_axi_rx_tvalid(m_axi_rx_tvalid),

                                  // GTX Serial I/O
                                  .rxp(gt_rx_p),
                                  .rxn(gt_rx_n),
                                  .txp(gt_tx_p),
                                  .txn(gt_tx_n),

                                  //GTX Reference Clock Interface
                                  .refclk1_in(gt_refclk),
                                  .hard_err(hard_err),
                                  .soft_err(soft_err),

                                  // Status
                                  .channel_up(channel_up),
                                  .lane_up(lane_up),

                                  // System Interface
                                  .mmcm_not_locked(mmcm_not_locked),
                                  .user_clk(user_clk),
                                  .sync_clk(sync_clk),
                                  .reset_pb(reset_pb),
                                  .gt_rxcdrovrden_in(1'b0),//..
                                  .power_down(1'b0),//..
                                  .loopback(gt_loopback),
                                  .pma_init(gt_rst),
                                  .gt_pll_lock(gt_pll_lock),
                                  .drp_clk_in(drp_clk),
                                  //---{
                                  .gt_qpllclk_quad1_in        ( 1'b0),//..
                                  .gt_qpllrefclk_quad1_in     ( 1'b0),//..
                                  //---}
                                  //---------------------- GT DRP Ports ----------------------
                                  .drpaddr_in(8'h0),
                                  .drpdi_in(16'h0),
                                  .drpdo_out(),
                                  .drprdy_out(),
                                  .drpen_in(1'b0),
                                  .drpwe_in(1'b0),
                                  .drpaddr_in_lane1(8'h0),
                                  .drpdi_in_lane1(16'h0),
                                  .drpdo_out_lane1(),
                                  .drprdy_out_lane1(),
                                  .drpen_in_lane1(1'b0),
                                  .drpwe_in_lane1(1'b0),
                                  .init_clk(init_clk),
                                  .link_reset_out(),
                                  .sys_reset_out(user_sys_reset),
                                  .tx_out_clk(tx_out_clk)
                                );
endmodule
