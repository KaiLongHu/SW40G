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
module aurora_channel_lane2 (
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
    input   [8 : 0]     gt_drpaddr          ,//GT收发器的DRP地址信号；
    input   [15 : 0]    gt_drpdi            ,//GT收发器的DRP数据输入信号；
    output              gt_drprdy           ,//GT收发器的DRP应答信号；
    input               gt_drpen            ,//GT收发器的DRP使能信号；
    input               gt_drpwe            ,//GT收发器的DRP读写指示信号；
    output  [15 : 0]    gt_drpdo            ,//GT收发器的DRP数据输出信号；
    input   [7 : 0]     qpll_drpaddr        ,//QPLL的DRP地址信号；
    input   [15 : 0]    qpll_drpdi          ,//QPLL的DRP数据输入信号；
    input               qpll_drpen          ,//QPLL的DRP使能信号；
    input               qpll_drpwe          ,//QPLL的DRP读写指示信号；
    input               gt_qpllclk          ,//QPLL的时钟信号；
    input               gt_qpllrefclk       ,//QPLL的参考时钟信号；
    output              gt_qpllreset        ,//QPLL的复位信号；
    input               gt_qplllock         ,//QPLL的锁定信号；
    input               gt_qpllrefclklost   ,//QPLL的参考时钟失锁信号；

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
    Aurora_64B_Framing_SUPPORT_RESET_LOGIC support_reset_logic(
        .RESET          ( system_rst        ),//系统复位信号；
        .USER_CLK       ( user_clk          ),//用户时钟信号；
        .INIT_CLK       ( init_clk          ),//初始化时钟；
        .GT_RESET_IN    ( 1'b0              ),//GT收发器复位信号；
        .SYSTEM_RESET   ( reset_pb          ),//IP复位信号；
        .GT_RESET_OUT   ( gt_rst            ) //GT收发器复位信号；
    );

    //例化MMCM模块，通过tx_out_clk生成用户时钟信号；
    // Aurora_64B_Framing_CLOCK_MODULE clock_module(
    //     .CLK                ( tx_out_clk        ),//GT收发器输出的用户时钟信号；
    //     .CLK_LOCKED         ( gt_pll_lock       ),//MMCM锁定信号；
    //     .USER_CLK           ( user_clk          ),//用户时钟信号；
    //     .SYNC_CLK           ( sync_clk          ),//同步时钟信号；
    //     .MMCM_NOT_LOCKED    ( mmcm_not_locked   ) //MMCM没有锁定信号；
    // );

    //例化aurora_64b66b IP；
    Aurora_64B_Framing_2lane u_Aurora_64B_Framing_lane2 (
        .rxp                        ( gt_rx_p           ),//GT收发器的接收数据差分引脚；
        .rxn                        ( gt_rx_n           ),//GT收发器的接收数据差分引脚；
        .refclk1_in                 ( gt_refclk         ),//GT参考时钟，IP设置为156.25MHZ
        .user_clk                   ( user_clk          ),//用户时钟，由TX_OUT_CLK通过MMCM生成；
        .sync_clk                   ( sync_clk          ),//同步时钟信号，由TX_OUT_CLK通过MMCM生成；
        .reset_pb                   ( reset_pb          ),//系统复位信号；
        .power_down                 ( 1'b0              ),//掉电模式；
        .pma_init                   ( gt_rst            ),//GT收发器复位，初始化；
        .loopback                   ( gt_loopback       ),//GT收发器的回环模式控制信号；
        .txp                        ( gt_tx_p           ),//GT收发器的发送数据差分引脚；
        .txn                        ( gt_tx_n           ),//GT收发器的发送数据差分引脚；
        .hard_err                   ( hard_err          ),//硬件错误指示信号；
        .soft_err                   ( soft_err          ),//软件错误指示信号；
        .channel_up                 ( channel_up        ),//通道初始化完成且通道准备好数据时拉高；
        .lane_up                    ( lane_up           ),//单通道初始化成功信号；
        .tx_out_clk                 ( tx_out_clk        ),//GT收发器输出参考时钟信号，通过BUFG可以用作用户时钟；
        .gt_pll_lock                ( gt_pll_lock       ),//MMCM锁定信号；
        .s_axi_tx_tdata             ( s_axi_tx_tdata    ),//用户发送数据的AXI_STEAM流接口信号；
        .s_axi_tx_tkeep             ( s_axi_tx_tkeep    ),//用户发送数据的AXI_STEAM流接口信号；
        .s_axi_tx_tlast             ( s_axi_tx_tlast    ),//用户发送数据的AXI_STEAM流接口信号；
        .s_axi_tx_tvalid            ( s_axi_tx_tvalid   ),//用户发送数据的AXI_STEAM流接口信号；
        .s_axi_tx_tready            ( s_axi_tx_tready   ),//用户发送数据的AXI_STEAM流接口信号；
        .m_axi_rx_tdata             ( m_axi_rx_tdata    ),//用户接收数据的AXI_STEAM流接口信号；
        .m_axi_rx_tkeep             ( m_axi_rx_tkeep    ),//用户接收数据的AXI_STEAM流接口信号；
        .m_axi_rx_tlast             ( m_axi_rx_tlast    ),//用户接收数据的AXI_STEAM流接口信号；
        .m_axi_rx_tvalid            ( m_axi_rx_tvalid   ),//用户接收数据的AXI_STEAM流接口信号；
        .mmcm_not_locked            ( mmcm_not_locked   ),//MMCM没有锁定指示信号；
        .drp_clk_in                 ( drp_clk           ),//DRP时钟信号；
        // .drpaddr_in                 ( gt_drpaddr        ),//GT收发器的DRP地址信号；
        // .drpdi_in                   ( gt_drpdi          ),//GT收发器的DRP数据输入信号；
        // .drprdy_out                 ( gt_drprdy         ),//GT收发器的DRP应答信号；
        // .drpen_in                   ( gt_drpen          ),//GT收发器的DRP使能信号；
        // .drpwe_in                   ( gt_drpwe          ),//GT收发器的DRP读写指示信号；
        // .drpdo_out                  ( gt_drpdo          ),//GT收发器的DRP数据输出信号；
        .qpll_drpaddr_in            ( qpll_drpaddr      ),//QPLL的DRP地址信号；
        .qpll_drpdi_in              ( qpll_drpdi        ),//QPLL的DRP数据输入信号；
        .qpll_drprdy_out            (                   ),//QPLL的DRP应答信号；
        .qpll_drpen_in              ( qpll_drpen        ),//QPLL的DRP使能信号；
        .qpll_drpwe_in              ( qpll_drpwe        ),//QPLL的DRP读写指示信号；
        .qpll_drpdo_out             (                   ),//QPLL的DRP数据输出信号；
        .init_clk                   ( init_clk          ),//初始化时钟，IP设置为100MHz。
        .link_reset_out             (                   ),//output wire link_reset_out
        .gt_qpllclk_quad1_in        ( gt_qpllclk        ),//QPLL的时钟信号；
        .gt_qpllrefclk_quad1_in     ( gt_qpllrefclk     ),//QPLL的参考时钟信号；
        .gt_to_common_qpllreset_out ( gt_qpllreset      ),//QPLL的复位信号；
        .gt_qplllock_in             ( gt_qplllock       ),//QPLL的锁定信号；
        .gt_qpllrefclklost_in       ( gt_qpllrefclklost ),//QPLL的参考时钟失锁信号；
        .gt_rxcdrovrden_in          ( 1'b0              ),//input wire gt_rxcdrovrden_in
        .sys_reset_out              ( user_sys_reset    ) //输出给用户的复位信号；
    );


endmodule