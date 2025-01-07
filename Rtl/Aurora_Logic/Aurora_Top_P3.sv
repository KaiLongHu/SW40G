/*//////////////////////////////////////////////////////////////////////////////////////////////
+--+--+---+-+---+----+
|  |  |   | /   |    |
|  |--|   --    |    |
|  |  |   | \   ---- |
|--+--+---+-+--------+
Module Name:Aurora_Top_P4
Provider:HuKaiLong
Creat Time:2025-01-02 16:36:34
Target Platform:
Function Description: 
//////////////////////////////////////////////////////////////////////////////////////////////*/
`timescale 1ns/1ns
module Aurora_Top_P3 (
    input               gt_refclk_p         ,//GT差分参考时钟，IP设置为156.25MHZ;
    input               gt_refclk_n         ,//GT差分参考时钟，IP设置为156.25MHZ;
    input               system_rst          ,//系统复位信号；
    input               init_clk            ,//初始化时钟，IP设置为100MHz。
    input               drp_clk             ,//DRP时钟信号,IP设置为100MHz。
    //QPLL的DRP接口；
    input   [7 : 0]     qpll_drpaddr        ,//QPLL的DRP地址信号；
    input   [15 : 0]    qpll_drpdi          ,//QPLL的DRP数据输入信号；
    output              qpll_drprdy         ,//QPLL的DRP应答信号；
    input               qpll_drpen          ,//QPLL的DRP使能信号；
    input               qpll_drpwe          ,//QPLL的DRP读写指示信号；
    output  [15 : 0]    qpll_drpdo          ,//QPLL的DRP数据输出信号；
    //GT收发器0的相关信号；
    input   [2:0]             gt_rx_p           ,//GT收发器的接收数据差分引脚；
    input   [2:0]             gt_rx_n           ,//GT收发器的接收数据差分引脚；
    output               user_clk          ,//用户参考时钟信号；
    output  [2:0]             user_reset        ,//输出给用户的复位信号；
    input   [2:0] [2 : 0]     gt_loopback       ,//GT收发器的回环模式控制信号；
    output  [2:0]             gt_tx_p           ,//GT收发器的发送数据差分引脚；
    output  [2:0]             gt_tx_n           ,//GT收发器的发送数据差分引脚；
    output  [2:0]             hard_err          ,//硬件错误指示信号；
    output  [2:0]             soft_err          ,//软件错误指示信号；
    output  [2:0]             channel_up        ,//通道初始化完成且通道准备好数据时拉高；
    output  [2:0]             lane_up           ,//单通道初始化成功信号；
    input   [2:0] [63 : 0]    s_axi_tx_tdata    ,//用户发送数据的AXI_STEAM流接口信号；
    input   [2:0] [7  : 0]    s_axi_tx_tkeep    ,//用户发送数据的AXI_STEAM流接口信号；
    input   [2:0]             s_axi_tx_tlast    ,//用户发送数据的AXI_STEAM流接口信号；
    input   [2:0]             s_axi_tx_tvalid   ,//用户发送数据的AXI_STEAM流接口信号；
    output  [2:0]             s_axi_tx_tready   ,//用户发送数据的AXI_STEAM流接口信号；
    output  [2:0] [63 : 0]    m_axi_rx_tdata    ,//用户接收数据的AXI_STEAM流接口信号；
    output  [2:0] [7 : 0]     m_axi_rx_tkeep    ,//用户接收数据的AXI_STEAM流接口信号；
    output  [2:0]             m_axi_rx_tlast    ,//用户接收数据的AXI_STEAM流接口信号；
    output  [2:0]             m_axi_rx_tvalid   ,//用户接收数据的AXI_STEAM流接口信号；
    input   [2:0] [8 : 0]     gt_drpaddr        ,//GT收发器的DRP地址信号；
    input   [2:0] [15 : 0]    gt_drpdi          ,//GT收发器的DRP数据输入信号；
    output  [2:0]             gt_drprdy         ,//GT收发器的DRP应答信号；
    input   [2:0]             gt_drpen          ,//GT收发器的DRP使能信号；
    input   [2:0]             gt_drpwe          ,//GT收发器的DRP读写指示信号；
    output  [2:0] [15 : 0]    gt_drpdo          //GT收发器的DRP数据输出信号；
  );

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////              Sig Def              /////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  wire                gt_refclk           ;//GT收发器的单端时钟信号，频率为156.25MHz。
  wire                gt_qpllclk          ;//QPLL的时钟信号；
  wire                gt_qpllrefclk       ;//QPLL的参考时钟信号；
  wire                gt_qpllreset        ;//QPLL的复位信号；
  wire                gt_qplllock         ;//QPLL的锁定信号；
  wire                gt_qpllrefclklost   ;//QPLL的参考时钟失锁信号；


  wire tx_out_clk;
  wire gt_pll_lock;
  wire sync_clk;
  wire mmcm_not_locked;

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////              Logic                /////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Aurora_64B_Framing_CLOCK_MODULE  clock_module (
    .INIT_CLK_P(0),
    .INIT_CLK_N(0),
    .INIT_CLK_O(),
    .CLK(tx_out_clk),//In
    .CLK_LOCKED(gt_pll_lock),//In
    .USER_CLK(user_clk),//o
    .SYNC_CLK(sync_clk),//o
    .MMCM_NOT_LOCKED(mmcm_not_locked)//o
  );

  // //例化IBUFGDS_GTE2，将差分时钟转换为单端时钟；
  IBUFDS_GTE2 IBUFDS_GTXE2_CLK1 (
                .O      ( gt_refclk     ),//单端时钟输出信号；
                .ODIV2  (               ),//单端时钟二分频输出信号；
                .CEB    ( 1'b0          ),//IBUFDS_GTE2使能信号；
                .I      ( gt_refclk_p   ),//差分时钟输入信号；
                .IB     ( gt_refclk_n   ) //差分时钟输入信号；
              );

  //例化QPLL模块；
  Aurora_64B_Framing_gt_common_wrapper gt_common_support (
                                         .gt_qpllclk_quad1_out       ( gt_qpllclk        ),//QPLL的时钟信号；
                                         .gt_qpllrefclk_quad1_out    ( gt_qpllrefclk     ),//QPLL的参考时钟信号；
                                         .GT0_GTREFCLK0_COMMON_IN    ( gt_refclk         ),//单端时钟输出信号；
                                         .GT0_QPLLLOCK_OUT           ( gt_qplllock       ),//QPLL的锁定信号；
                                        //  .GT0_QPLLRESET_IN           ( gt_qpllreset      ),//QPLL的复位信号；
                                         .GT0_QPLLLOCKDETCLK_IN      ( init_clk          ),//初始化时钟，IP设置为100MHz。
                                         .GT0_QPLLREFCLKLOST_OUT     ( gt_qpllrefclklost ),//QPLL的参考时钟失锁信号；
                                         .qpll_drpaddr_in            ( qpll_drpaddr      ),//QPLL的DRP地址信号；
                                         .qpll_drpdi_in              ( qpll_drpdi        ),//QPLL的DRP数据输入信号；
                                         .qpll_drpclk_in             ( drp_clk           ),//DRP时钟信号,IP设置为100MHz。
                                         .qpll_drpdo_out             ( qpll_drpdo        ),//QPLL的DRP数据输出信号；
                                         .qpll_drprdy_out            ( qpll_drprdy       ),//QPLL的DRP应答信号；
                                         .qpll_drpen_in              ( qpll_drpen        ),//QPLL的DRP使能信号；
                                         .qpll_drpwe_in              ( qpll_drpwe        ) //QPLL的DRP读写指示信号；
                                       );



  //例化高速收发器0；
  aurora_channel u_aurora_channel_0(
                   .gt_rx_p            ( gt_rx_p[0]         ),//GT收发器的接收数据差分引脚；
                   .gt_rx_n            ( gt_rx_n[0]         ),//GT收发器的接收数据差分引脚；
                   .gt_refclk          ( gt_refclk         ),//GT参考时钟，IP设置为156.25MHZ;
                   .user_clk           ( user_clk        ),//用户参考时钟信号；
                   .user_sys_reset     ( user_reset[0]      ),//输出给用户的复位信号；
                   .system_rst         ( system_rst        ),//系统复位信号；
                   .gt_loopback        ( gt_loopback[0]     ),//GT收发器的回环模式控制信号；
                   .gt_tx_p            ( gt_tx_p[0]         ),//GT收发器的发送数据差分引脚；
                   .gt_tx_n            ( gt_tx_n[0]         ),//GT收发器的发送数据差分引脚；
                   .hard_err           ( hard_err[0]        ),//硬件错误指示信号；
                   .soft_err           ( soft_err[0]        ),//软件错误指示信号；
                   .channel_up         ( channel_up[0]      ),//通道初始化完成且通道准备好数据时拉高；
                   .lane_up            ( lane_up[0]         ),//单通道初始化成功信号；
                   .s_axi_tx_tdata     ( s_axi_tx_tdata[0]  ),//用户发送数据的AXI_STEAM流接口信号；
                   .s_axi_tx_tkeep     ( s_axi_tx_tkeep[0]  ),//用户发送数据的AXI_STEAM流接口信号；
                   .s_axi_tx_tlast     ( s_axi_tx_tlast[0]  ),//用户发送数据的AXI_STEAM流接口信号；
                   .s_axi_tx_tvalid    ( s_axi_tx_tvalid[0] ),//用户发送数据的AXI_STEAM流接口信号；
                   .s_axi_tx_tready    ( s_axi_tx_tready[0] ),//用户发送数据的AXI_STEAM流接口信号；
                   .m_axi_rx_tdata     ( m_axi_rx_tdata[0]  ),//用户接收数据的AXI_STEAM流接口信号；
                   .m_axi_rx_tkeep     ( m_axi_rx_tkeep[0]  ),//用户接收数据的AXI_STEAM流接口信号；
                   .m_axi_rx_tlast     ( m_axi_rx_tlast[0]  ),//用户接收数据的AXI_STEAM流接口信号；
                   .m_axi_rx_tvalid    ( m_axi_rx_tvalid[0] ),//用户接收数据的AXI_STEAM流接口信号；
                   .init_clk           ( init_clk          ),//初始化时钟，IP设置为100MHz。
                   .drp_clk            ( drp_clk           ),//DRP时钟信号,IP设置为100MHz。
                   .gt_drpaddr         ( gt_drpaddr[0]      ),//GT收发器的DRP地址信号；
                   .gt_drpdi           ( gt_drpdi[0]        ),//GT收发器的DRP数据输入信号；
                   .gt_drprdy          ( gt_drprdy[0]       ),//GT收发器的DRP应答信号；
                   .gt_drpen           ( gt_drpen[0]        ),//GT收发器的DRP使能信号；
                   .gt_drpwe           ( gt_drpwe[0]        ),//GT收发器的DRP读写指示信号；
                   .gt_drpdo           ( gt_drpdo[0]        ),//GT收发器的DRP数据输出信号；
                   .qpll_drpaddr       ( qpll_drpaddr      ),//QPLL的DRP地址信号；
                   .qpll_drpdi         ( qpll_drpdi        ),//QPLL的DRP数据输入信号；
                   .qpll_drpen         ( qpll_drpen        ),//QPLL的DRP使能信号；
                   .qpll_drpwe         ( qpll_drpwe        ),//QPLL的DRP读写指示信号；
                   .gt_qpllclk         ( gt_qpllclk        ),//QPLL的时钟信号；
                   .gt_qpllrefclk      ( gt_qpllrefclk     ),//QPLL的参考时钟信号；
                   .gt_qpllreset       ( gt_qpllreset      ),//QPLL的复位信号；
                   .gt_qplllock        ( gt_qplllock       ),//QPLL的锁定信号；
                   .gt_qpllrefclklost  ( gt_qpllrefclklost ), //QPLL的参考时钟失锁信号；
                   .tx_out_clk(tx_out_clk),
                   .gt_pll_lock(gt_pll_lock),
                   .sync_clk(sync_clk),
                   .mmcm_not_locked(mmcm_not_locked)               
                 );

  //例化高速收发器1；
  aurora_channel u_aurora_channel_1(
                   .gt_rx_p            ( gt_rx_p[1]         ),//GT收发器的接收数据差分引脚；
                   .gt_rx_n            ( gt_rx_n[1]         ),//GT收发器的接收数据差分引脚；
                   .gt_refclk          ( gt_refclk         ),//GT参考时钟，IP设置为156.25MHZ;
                   .user_clk           ( user_clk        ),//用户参考时钟信号；
                   .user_sys_reset     ( user_reset[1]      ),//输出给用户的复位信号；
                   .system_rst         ( system_rst        ),//系统复位信号；
                   .gt_loopback        ( gt_loopback[1]     ),//GT收发器的回环模式控制信号；
                   .gt_tx_p            ( gt_tx_p[1]         ),//GT收发器的发送数据差分引脚；
                   .gt_tx_n            ( gt_tx_n[1]         ),//GT收发器的发送数据差分引脚；
                   .hard_err           ( hard_err[1]        ),//硬件错误指示信号；
                   .soft_err           ( soft_err[1]        ),//软件错误指示信号；
                   .channel_up         ( channel_up[1]      ),//通道初始化完成且通道准备好数据时拉高；
                   .lane_up            ( lane_up[1]         ),//单通道初始化成功信号；
                   .s_axi_tx_tdata     ( s_axi_tx_tdata[1]  ),//用户发送数据的AXI_STEAM流接口信号；
                   .s_axi_tx_tkeep     ( s_axi_tx_tkeep[1]  ),//用户发送数据的AXI_STEAM流接口信号；
                   .s_axi_tx_tlast     ( s_axi_tx_tlast[1]  ),//用户发送数据的AXI_STEAM流接口信号；
                   .s_axi_tx_tvalid    ( s_axi_tx_tvalid[1] ),//用户发送数据的AXI_STEAM流接口信号；
                   .s_axi_tx_tready    ( s_axi_tx_tready[1] ),//用户发送数据的AXI_STEAM流接口信号；
                   .m_axi_rx_tdata     ( m_axi_rx_tdata[1]  ),//用户接收数据的AXI_STEAM流接口信号；
                   .m_axi_rx_tkeep     ( m_axi_rx_tkeep[1]  ),//用户接收数据的AXI_STEAM流接口信号；
                   .m_axi_rx_tlast     ( m_axi_rx_tlast[1]  ),//用户接收数据的AXI_STEAM流接口信号；
                   .m_axi_rx_tvalid    ( m_axi_rx_tvalid[1] ),//用户接收数据的AXI_STEAM流接口信号；
                   .init_clk           ( init_clk          ),//初始化时钟，IP设置为100MHz。
                   .drp_clk            ( drp_clk           ),//DRP时钟信号,IP设置为100MHz。
                   .gt_drpaddr         ( gt_drpaddr[1]      ),//GT收发器的DRP地址信号；
                   .gt_drpdi           ( gt_drpdi[1]        ),//GT收发器的DRP数据输入信号；
                   .gt_drprdy          ( gt_drprdy[1]       ),//GT收发器的DRP应答信号；
                   .gt_drpen           ( gt_drpen[1]        ),//GT收发器的DRP使能信号；
                   .gt_drpwe           ( gt_drpwe[1]        ),//GT收发器的DRP读写指示信号；
                   .gt_drpdo           ( gt_drpdo[1]        ),//GT收发器的DRP数据输出信号；
                   .qpll_drpaddr       ( qpll_drpaddr      ),//QPLL的DRP地址信号；
                   .qpll_drpdi         ( qpll_drpdi        ),//QPLL的DRP数据输入信号；
                   .qpll_drpen         ( qpll_drpen        ),//QPLL的DRP使能信号；
                   .qpll_drpwe         ( qpll_drpwe        ),//QPLL的DRP读写指示信号；
                   .gt_qpllclk         ( gt_qpllclk        ),//QPLL的时钟信号；
                   .gt_qpllrefclk      ( gt_qpllrefclk     ),//QPLL的参考时钟信号；
                   .gt_qpllreset       (                   ),//QPLL的复位信号；
                   .gt_qplllock        ( gt_qplllock       ),//QPLL的锁定信号；
                   .gt_qpllrefclklost  ( gt_qpllrefclklost ), //QPLL的参考时钟失锁信号；
                   .tx_out_clk(),
                   .gt_pll_lock(),
                   .sync_clk(sync_clk),
                   .mmcm_not_locked(mmcm_not_locked)        
                 );

  //例化高速收发器1；
  aurora_channel u_aurora_channel_2(
                   .gt_rx_p            ( gt_rx_p[2]         ),//GT收发器的接收数据差分引脚；
                   .gt_rx_n            ( gt_rx_n[2]         ),//GT收发器的接收数据差分引脚；
                   .gt_refclk          ( gt_refclk         ),//GT参考时钟，IP设置为156.25MHZ;
                   .user_clk           ( user_clk       ),//用户参考时钟信号；
                   .user_sys_reset     ( user_reset[2]      ),//输出给用户的复位信号；
                   .system_rst         ( system_rst        ),//系统复位信号；
                   .gt_loopback        ( gt_loopback[2]     ),//GT收发器的回环模式控制信号；
                   .gt_tx_p            ( gt_tx_p[2]         ),//GT收发器的发送数据差分引脚；
                   .gt_tx_n            ( gt_tx_n[2]         ),//GT收发器的发送数据差分引脚；
                   .hard_err           ( hard_err[2]        ),//硬件错误指示信号；
                   .soft_err           ( soft_err[2]        ),//软件错误指示信号；
                   .channel_up         ( channel_up[2]      ),//通道初始化完成且通道准备好数据时拉高；
                   .lane_up            ( lane_up[2]         ),//单通道初始化成功信号；
                   .s_axi_tx_tdata     ( s_axi_tx_tdata[2]  ),//用户发送数据的AXI_STEAM流接口信号；
                   .s_axi_tx_tkeep     ( s_axi_tx_tkeep[2]  ),//用户发送数据的AXI_STEAM流接口信号；
                   .s_axi_tx_tlast     ( s_axi_tx_tlast[2]  ),//用户发送数据的AXI_STEAM流接口信号；
                   .s_axi_tx_tvalid    ( s_axi_tx_tvalid[2] ),//用户发送数据的AXI_STEAM流接口信号；
                   .s_axi_tx_tready    ( s_axi_tx_tready[2] ),//用户发送数据的AXI_STEAM流接口信号；
                   .m_axi_rx_tdata     ( m_axi_rx_tdata[2]  ),//用户接收数据的AXI_STEAM流接口信号；
                   .m_axi_rx_tkeep     ( m_axi_rx_tkeep[2]  ),//用户接收数据的AXI_STEAM流接口信号；
                   .m_axi_rx_tlast     ( m_axi_rx_tlast[2]  ),//用户接收数据的AXI_STEAM流接口信号；
                   .m_axi_rx_tvalid    ( m_axi_rx_tvalid[2] ),//用户接收数据的AXI_STEAM流接口信号；
                   .init_clk           ( init_clk          ),//初始化时钟，IP设置为100MHz。
                   .drp_clk            ( drp_clk           ),//DRP时钟信号,IP设置为100MHz。
                   .gt_drpaddr         ( gt_drpaddr[2]      ),//GT收发器的DRP地址信号；
                   .gt_drpdi           ( gt_drpdi[2]        ),//GT收发器的DRP数据输入信号；
                   .gt_drprdy          ( gt_drprdy[2]       ),//GT收发器的DRP应答信号；
                   .gt_drpen           ( gt_drpen[2]        ),//GT收发器的DRP使能信号；
                   .gt_drpwe           ( gt_drpwe[2]        ),//GT收发器的DRP读写指示信号；
                   .gt_drpdo           ( gt_drpdo[2]        ),//GT收发器的DRP数据输出信号；
                   .qpll_drpaddr       ( qpll_drpaddr      ),//QPLL的DRP地址信号；
                   .qpll_drpdi         ( qpll_drpdi        ),//QPLL的DRP数据输入信号；
                   .qpll_drpen         ( qpll_drpen        ),//QPLL的DRP使能信号；
                   .qpll_drpwe         ( qpll_drpwe        ),//QPLL的DRP读写指示信号；
                   .gt_qpllclk         ( gt_qpllclk        ),//QPLL的时钟信号；
                   .gt_qpllrefclk      ( gt_qpllrefclk     ),//QPLL的参考时钟信号；
                   .gt_qpllreset       (                   ),//QPLL的复位信号；
                   .gt_qplllock        ( gt_qplllock       ),//QPLL的锁定信号；
                   .gt_qpllrefclklost  ( gt_qpllrefclklost ), //QPLL的参考时钟失锁信号；
                   .tx_out_clk(),
                   .gt_pll_lock(),
                   .sync_clk(sync_clk),
                   .mmcm_not_locked(mmcm_not_locked)        
                 );
endmodule
