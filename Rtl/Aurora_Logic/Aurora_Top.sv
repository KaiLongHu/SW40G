/*//////////////////////////////////////////////////////////////////////////////////////////////
+--+--+---+-+---+----+
|  |  |   | /   |    |
|  |--|   --    |    |
|  |  |   | \   ---- |
|--+--+---+-+--------+
Module Name:Aurora_Top
Provider:HuKaiLong
Creat Time:2025-01-02 08:55:09
Target Platform:
Function Description: 
//////////////////////////////////////////////////////////////////////////////////////////////*/
`timescale 1ns/1ns

module Aurora_Top (
    input  wire Rst_n,
    input  wire SysClk,

    // GTX Reference Clock Interface
    input              gt_refclk_p,
    input              gt_refclk_n,

    input  wire gt_rx_p_0,
    input  wire gt_rx_n_0,
    output wire gt_tx_p_0,
    output wire gt_tx_n_0
  );




  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////            SIGDEF              ////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  wire [63 : 0] s_axi_tx_tdata_1;    //用户发送数据的AXI_STEAM流接口信号；
  wire [7  : 0] s_axi_tx_tkeep_1;    //用户发送数据的AXI_STEAM流接口信号；
  wire          s_axi_tx_tlast_1;    //用户发送数据的AXI_STEAM流接口信号；
  wire          s_axi_tx_tvalid_1;   //用户发送数据的AXI_STEAM流接口信号；
  wire          s_axi_tx_tready_1;   //用户发送数据的AXI_STEAM流接口信号；
  wire [63 : 0] m_axi_rx_tdata_1;    //用户接收数据的AXI_STEAM流接口信号；
  wire [7 : 0]  m_axi_rx_tkeep_1;    //用户接收数据的AXI_STEAM流接口信号；
  wire          m_axi_rx_tlast_1;    //用户接收数据的AXI_STEAM流接口信号；
  wire          m_axi_rx_tvalid_1;   //用户接收数据的AXI_STEAM流接口信号；

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////            SUPPORT              ///////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  aurora_module u_aurora_module(
    .gt_refclk_p        ( gt_refclk_p       ),//GT差分参考时钟，IP设置为156.25MHZ;
    .gt_refclk_n        ( gt_refclk_n       ),//GT差分参考时钟，IP设置为156.25MHZ;
    .system_rst         ( system_rst        ),//系统复位信号；
    .init_clk           ( clk               ),//初始化时钟，IP设置为100MHz。
    .drp_clk            ( clk               ),//DRP时钟信号,IP设置为100MHz。
    //QPLL的DRP接口；
    .qpll_drpaddr       ( 0                 ),//QPLL的DRP地址信号；
    .qpll_drpdi         ( 0                 ),//QPLL的DRP数据输入信号；
    .qpll_drprdy        (                   ),//QPLL的DRP应答信号；
    .qpll_drpen         ( 0                 ),//QPLL的DRP使能信号；
    .qpll_drpwe         ( 0                 ),//QPLL的DRP读写指示信号；
    .qpll_drpdo         (                   ),//QPLL的DRP数据输出信号；
    //GT收发器0的相关信号；
    .gt_rx_p_0          ( gt_rx_p_0         ),//GT收发器的接收数据差分引脚；
    .gt_rx_n_0          ( gt_rx_n_0         ),//GT收发器的接收数据差分引脚；
    .user_clk_0         ( user_clk_0        ),//用户参考时钟信号；
    .user_reset_0       ( user_reset_0      ),//输出给用户的复位信号；
    .gt_loopback_0      ( 3'b000            ),//GT收发器的回环模式控制信号；
    .gt_tx_p_0          ( gt_tx_p_0         ),//GT收发器的发送数据差分引脚；
    .gt_tx_n_0          ( gt_tx_n_0         ),//GT收发器的发送数据差分引脚；
    .hard_err_0         ( hard_err_0        ),//硬件错误指示信号；
    .soft_err_0         ( soft_err_0        ),//软件错误指示信号；
    .channel_up_0       ( channel_up_0      ),//通道初始化完成且通道准备好数据时拉高；
    .lane_up_0          ( lane_up_0         ),//单通道初始化成功信号；
    .s_axi_tx_tdata_0   ( s_axi_tx_tdata_0  ),//用户发送数据的AXI_STEAM流接口信号；
    .s_axi_tx_tkeep_0   ( s_axi_tx_tkeep_0  ),//用户发送数据的AXI_STEAM流接口信号；
    .s_axi_tx_tlast_0   ( s_axi_tx_tlast_0  ),//用户发送数据的AXI_STEAM流接口信号；
    .s_axi_tx_tvalid_0  ( s_axi_tx_tvalid_0 ),//用户发送数据的AXI_STEAM流接口信号；
    .s_axi_tx_tready_0  ( s_axi_tx_tready_0 ),//用户发送数据的AXI_STEAM流接口信号；
    .m_axi_rx_tdata_0   ( m_axi_rx_tdata_0  ),//用户接收数据的AXI_STEAM流接口信号；
    .m_axi_rx_tkeep_0   ( m_axi_rx_tkeep_0  ),//用户接收数据的AXI_STEAM流接口信号；
    .m_axi_rx_tlast_0   ( m_axi_rx_tlast_0  ),//用户接收数据的AXI_STEAM流接口信号；
    .m_axi_rx_tvalid_0  ( m_axi_rx_tvalid_0 ),//用户接收数据的AXI_STEAM流接口信号；
    .gt_drpaddr_0       ( 0                 ),//GT收发器的DRP地址信号；
    .gt_drpdi_0         ( 0                 ),//GT收发器的DRP数据输入信号；
    .gt_drprdy_0        (                   ),//GT收发器的DRP应答信号；
    .gt_drpen_0         ( 0                 ),//GT收发器的DRP使能信号；
    .gt_drpwe_0         ( 0                 ),//GT收发器的DRP读写指示信号；
    .gt_drpdo_0         (                   ),//GT收发器的DRP数据输出信号；
    //GT收发器1的相关信号；
    .gt_rx_p_1          ( gt_rx_p_1         ),//GT收发器的接收数据差分引脚；
    .gt_rx_n_1          ( gt_rx_n_1         ),//GT收发器的接收数据差分引脚；
    .user_clk_1         ( user_clk_1        ),//用户参考时钟信号；
    .user_reset_1       ( user_reset_1      ),//输出给用户的复位信号；
    .gt_loopback_1      ( 3'b000            ),//GT收发器的回环模式控制信号；
    .gt_tx_p_1          ( gt_tx_p_1         ),//GT收发器的发送数据差分引脚；
    .gt_tx_n_1          ( gt_tx_n_1         ),//GT收发器的发送数据差分引脚；
    .hard_err_1         ( hard_err_1        ),//硬件错误指示信号；
    .soft_err_1         ( soft_err_1        ),//软件错误指示信号；
    .channel_up_1       ( channel_up_1      ),//通道初始化完成且通道准备好数据时拉高；
    .lane_up_1          ( lane_up_1         ),//单通道初始化成功信号；
    .s_axi_tx_tdata_1   ( s_axi_tx_tdata_1  ),//用户发送数据的AXI_STEAM流接口信号；
    .s_axi_tx_tkeep_1   ( s_axi_tx_tkeep_1  ),//用户发送数据的AXI_STEAM流接口信号；
    .s_axi_tx_tlast_1   ( s_axi_tx_tlast_1  ),//用户发送数据的AXI_STEAM流接口信号；
    .s_axi_tx_tvalid_1  ( s_axi_tx_tvalid_1 ),//用户发送数据的AXI_STEAM流接口信号；
    .s_axi_tx_tready_1  ( s_axi_tx_tready_1 ),//用户发送数据的AXI_STEAM流接口信号；
    .m_axi_rx_tdata_1   ( m_axi_rx_tdata_1  ),//用户接收数据的AXI_STEAM流接口信号；
    .m_axi_rx_tkeep_1   ( m_axi_rx_tkeep_1  ),//用户接收数据的AXI_STEAM流接口信号；
    .m_axi_rx_tlast_1   ( m_axi_rx_tlast_1  ),//用户接收数据的AXI_STEAM流接口信号；
    .m_axi_rx_tvalid_1  ( m_axi_rx_tvalid_1 ),//用户接收数据的AXI_STEAM流接口信号；
    .gt_drpaddr_1       ( 0                 ),//GT收发器的DRP地址信号；
    .gt_drpdi_1         ( 0                 ),//GT收发器的DRP数据输入信号；
    .gt_drprdy_1        (                   ),//GT收发器的DRP应答信号；
    .gt_drpen_1         ( 0                 ),//GT收发器的DRP使能信号；
    .gt_drpwe_1         ( 0                 ),//GT收发器的DRP读写指示信号；
    .gt_drpdo_1         (                   ) //GT收发器的DRP数据输出信号；
);

endmodule
