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
    input               gt_rx_p             ,//GT�շ����Ľ������ݲ�����ţ�
    input               gt_rx_n             ,//GT�շ����Ľ������ݲ�����ţ�
    input               gt_refclk           ,//GT�ο�ʱ�ӣ�IP����Ϊ156.25MHZ;
    // output              user_clk            ,//�û��ο�ʱ���źţ�
    output              user_sys_reset      ,//������û��ĸ�λ�źţ�
    input               system_rst          ,//ϵͳ��λ�źţ�
    input   [2 : 0]     gt_loopback         ,//GT�շ����Ļػ�ģʽ�����źţ�
    output              gt_tx_p             ,//GT�շ����ķ������ݲ�����ţ�
    output              gt_tx_n             ,//GT�շ����ķ������ݲ�����ţ�
    output              hard_err            ,//Ӳ������ָʾ�źţ�
    output              soft_err            ,//�������ָʾ�źţ�
    output              channel_up          ,//ͨ����ʼ�������ͨ��׼��������ʱ���ߣ�
    output              lane_up             ,//��ͨ����ʼ���ɹ��źţ�
    input   [63 : 0]    s_axi_tx_tdata      ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    input   [7  : 0]    s_axi_tx_tkeep      ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    input               s_axi_tx_tlast      ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    input               s_axi_tx_tvalid     ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    output              s_axi_tx_tready     ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    output  [63 : 0]    m_axi_rx_tdata      ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    output  [7 : 0]     m_axi_rx_tkeep      ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    output              m_axi_rx_tlast      ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    output              m_axi_rx_tvalid     ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    input               init_clk            ,//��ʼ��ʱ�ӣ�IP����Ϊ100MHz��
    input               drp_clk             ,//DRPʱ���ź�,IP����Ϊ100MHz��
    input   [8 : 0]     gt_drpaddr          ,//GT�շ�����DRP��ַ�źţ�
    input   [15 : 0]    gt_drpdi            ,//GT�շ�����DRP���������źţ�
    output              gt_drprdy           ,//GT�շ�����DRPӦ���źţ�
    input               gt_drpen            ,//GT�շ�����DRPʹ���źţ�
    input               gt_drpwe            ,//GT�շ�����DRP��дָʾ�źţ�
    output  [15 : 0]    gt_drpdo            ,//GT�շ�����DRP��������źţ�
    input   [7 : 0]     qpll_drpaddr        ,//QPLL��DRP��ַ�źţ�
    input   [15 : 0]    qpll_drpdi          ,//QPLL��DRP���������źţ�
    input               qpll_drpen          ,//QPLL��DRPʹ���źţ�
    input               qpll_drpwe          ,//QPLL��DRP��дָʾ�źţ�
    input               gt_qpllclk          ,//QPLL��ʱ���źţ�
    input               gt_qpllrefclk       ,//QPLL�Ĳο�ʱ���źţ�
    output              gt_qpllreset        ,//QPLL�ĸ�λ�źţ�
    input               gt_qplllock         ,//QPLL�������źţ�
    input               gt_qpllrefclklost   ,//QPLL�Ĳο�ʱ��ʧ���źţ�

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

    //������λͬ��ģ�飻
    Aurora_64B_Framing_SUPPORT_RESET_LOGIC support_reset_logic(
        .RESET          ( system_rst        ),//ϵͳ��λ�źţ�
        .USER_CLK       ( user_clk          ),//�û�ʱ���źţ�
        .INIT_CLK       ( init_clk          ),//��ʼ��ʱ�ӣ�
        .GT_RESET_IN    ( 1'b0              ),//GT�շ�����λ�źţ�
        .SYSTEM_RESET   ( reset_pb          ),//IP��λ�źţ�
        .GT_RESET_OUT   ( gt_rst            ) //GT�շ�����λ�źţ�
    );

    //����MMCMģ�飬ͨ��tx_out_clk�����û�ʱ���źţ�
    // Aurora_64B_Framing_CLOCK_MODULE clock_module(
    //     .CLK                ( tx_out_clk        ),//GT�շ���������û�ʱ���źţ�
    //     .CLK_LOCKED         ( gt_pll_lock       ),//MMCM�����źţ�
    //     .USER_CLK           ( user_clk          ),//�û�ʱ���źţ�
    //     .SYNC_CLK           ( sync_clk          ),//ͬ��ʱ���źţ�
    //     .MMCM_NOT_LOCKED    ( mmcm_not_locked   ) //MMCMû�������źţ�
    // );

    //����aurora_64b66b IP��
    Aurora_64B_Framing_2lane u_Aurora_64B_Framing_lane2 (
        .rxp                        ( gt_rx_p           ),//GT�շ����Ľ������ݲ�����ţ�
        .rxn                        ( gt_rx_n           ),//GT�շ����Ľ������ݲ�����ţ�
        .refclk1_in                 ( gt_refclk         ),//GT�ο�ʱ�ӣ�IP����Ϊ156.25MHZ
        .user_clk                   ( user_clk          ),//�û�ʱ�ӣ���TX_OUT_CLKͨ��MMCM���ɣ�
        .sync_clk                   ( sync_clk          ),//ͬ��ʱ���źţ���TX_OUT_CLKͨ��MMCM���ɣ�
        .reset_pb                   ( reset_pb          ),//ϵͳ��λ�źţ�
        .power_down                 ( 1'b0              ),//����ģʽ��
        .pma_init                   ( gt_rst            ),//GT�շ�����λ����ʼ����
        .loopback                   ( gt_loopback       ),//GT�շ����Ļػ�ģʽ�����źţ�
        .txp                        ( gt_tx_p           ),//GT�շ����ķ������ݲ�����ţ�
        .txn                        ( gt_tx_n           ),//GT�շ����ķ������ݲ�����ţ�
        .hard_err                   ( hard_err          ),//Ӳ������ָʾ�źţ�
        .soft_err                   ( soft_err          ),//�������ָʾ�źţ�
        .channel_up                 ( channel_up        ),//ͨ����ʼ�������ͨ��׼��������ʱ���ߣ�
        .lane_up                    ( lane_up           ),//��ͨ����ʼ���ɹ��źţ�
        .tx_out_clk                 ( tx_out_clk        ),//GT�շ�������ο�ʱ���źţ�ͨ��BUFG���������û�ʱ�ӣ�
        .gt_pll_lock                ( gt_pll_lock       ),//MMCM�����źţ�
        .s_axi_tx_tdata             ( s_axi_tx_tdata    ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
        .s_axi_tx_tkeep             ( s_axi_tx_tkeep    ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
        .s_axi_tx_tlast             ( s_axi_tx_tlast    ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
        .s_axi_tx_tvalid            ( s_axi_tx_tvalid   ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
        .s_axi_tx_tready            ( s_axi_tx_tready   ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
        .m_axi_rx_tdata             ( m_axi_rx_tdata    ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
        .m_axi_rx_tkeep             ( m_axi_rx_tkeep    ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
        .m_axi_rx_tlast             ( m_axi_rx_tlast    ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
        .m_axi_rx_tvalid            ( m_axi_rx_tvalid   ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
        .mmcm_not_locked            ( mmcm_not_locked   ),//MMCMû������ָʾ�źţ�
        .drp_clk_in                 ( drp_clk           ),//DRPʱ���źţ�
        // .drpaddr_in                 ( gt_drpaddr        ),//GT�շ�����DRP��ַ�źţ�
        // .drpdi_in                   ( gt_drpdi          ),//GT�շ�����DRP���������źţ�
        // .drprdy_out                 ( gt_drprdy         ),//GT�շ�����DRPӦ���źţ�
        // .drpen_in                   ( gt_drpen          ),//GT�շ�����DRPʹ���źţ�
        // .drpwe_in                   ( gt_drpwe          ),//GT�շ�����DRP��дָʾ�źţ�
        // .drpdo_out                  ( gt_drpdo          ),//GT�շ�����DRP��������źţ�
        .qpll_drpaddr_in            ( qpll_drpaddr      ),//QPLL��DRP��ַ�źţ�
        .qpll_drpdi_in              ( qpll_drpdi        ),//QPLL��DRP���������źţ�
        .qpll_drprdy_out            (                   ),//QPLL��DRPӦ���źţ�
        .qpll_drpen_in              ( qpll_drpen        ),//QPLL��DRPʹ���źţ�
        .qpll_drpwe_in              ( qpll_drpwe        ),//QPLL��DRP��дָʾ�źţ�
        .qpll_drpdo_out             (                   ),//QPLL��DRP��������źţ�
        .init_clk                   ( init_clk          ),//��ʼ��ʱ�ӣ�IP����Ϊ100MHz��
        .link_reset_out             (                   ),//output wire link_reset_out
        .gt_qpllclk_quad1_in        ( gt_qpllclk        ),//QPLL��ʱ���źţ�
        .gt_qpllrefclk_quad1_in     ( gt_qpllrefclk     ),//QPLL�Ĳο�ʱ���źţ�
        .gt_to_common_qpllreset_out ( gt_qpllreset      ),//QPLL�ĸ�λ�źţ�
        .gt_qplllock_in             ( gt_qplllock       ),//QPLL�������źţ�
        .gt_qpllrefclklost_in       ( gt_qpllrefclklost ),//QPLL�Ĳο�ʱ��ʧ���źţ�
        .gt_rxcdrovrden_in          ( 1'b0              ),//input wire gt_rxcdrovrden_in
        .sys_reset_out              ( user_sys_reset    ) //������û��ĸ�λ�źţ�
    );


endmodule