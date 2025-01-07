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
    input               gt_refclk_p         ,//GT��ֲο�ʱ�ӣ�IP����Ϊ156.25MHZ;
    input               gt_refclk_n         ,//GT��ֲο�ʱ�ӣ�IP����Ϊ156.25MHZ;
    input               system_rst          ,//ϵͳ��λ�źţ�
    input               init_clk            ,//��ʼ��ʱ�ӣ�IP����Ϊ100MHz��
    input               drp_clk             ,//DRPʱ���ź�,IP����Ϊ100MHz��
    //QPLL��DRP�ӿڣ�
    input   [7 : 0]     qpll_drpaddr        ,//QPLL��DRP��ַ�źţ�
    input   [15 : 0]    qpll_drpdi          ,//QPLL��DRP���������źţ�
    output              qpll_drprdy         ,//QPLL��DRPӦ���źţ�
    input               qpll_drpen          ,//QPLL��DRPʹ���źţ�
    input               qpll_drpwe          ,//QPLL��DRP��дָʾ�źţ�
    output  [15 : 0]    qpll_drpdo          ,//QPLL��DRP��������źţ�
    //GT�շ���0������źţ�
    input   [2:0]             gt_rx_p           ,//GT�շ����Ľ������ݲ�����ţ�
    input   [2:0]             gt_rx_n           ,//GT�շ����Ľ������ݲ�����ţ�
    output               user_clk          ,//�û��ο�ʱ���źţ�
    output  [2:0]             user_reset        ,//������û��ĸ�λ�źţ�
    input   [2:0] [2 : 0]     gt_loopback       ,//GT�շ����Ļػ�ģʽ�����źţ�
    output  [2:0]             gt_tx_p           ,//GT�շ����ķ������ݲ�����ţ�
    output  [2:0]             gt_tx_n           ,//GT�շ����ķ������ݲ�����ţ�
    output  [2:0]             hard_err          ,//Ӳ������ָʾ�źţ�
    output  [2:0]             soft_err          ,//�������ָʾ�źţ�
    output  [2:0]             channel_up        ,//ͨ����ʼ�������ͨ��׼��������ʱ���ߣ�
    output  [2:0]             lane_up           ,//��ͨ����ʼ���ɹ��źţ�
    input   [2:0] [63 : 0]    s_axi_tx_tdata    ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    input   [2:0] [7  : 0]    s_axi_tx_tkeep    ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    input   [2:0]             s_axi_tx_tlast    ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    input   [2:0]             s_axi_tx_tvalid   ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    output  [2:0]             s_axi_tx_tready   ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    output  [2:0] [63 : 0]    m_axi_rx_tdata    ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    output  [2:0] [7 : 0]     m_axi_rx_tkeep    ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    output  [2:0]             m_axi_rx_tlast    ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    output  [2:0]             m_axi_rx_tvalid   ,//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    input   [2:0] [8 : 0]     gt_drpaddr        ,//GT�շ�����DRP��ַ�źţ�
    input   [2:0] [15 : 0]    gt_drpdi          ,//GT�շ�����DRP���������źţ�
    output  [2:0]             gt_drprdy         ,//GT�շ�����DRPӦ���źţ�
    input   [2:0]             gt_drpen          ,//GT�շ�����DRPʹ���źţ�
    input   [2:0]             gt_drpwe          ,//GT�շ�����DRP��дָʾ�źţ�
    output  [2:0] [15 : 0]    gt_drpdo          //GT�շ�����DRP��������źţ�
  );

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////              Sig Def              /////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  wire                gt_refclk           ;//GT�շ����ĵ���ʱ���źţ�Ƶ��Ϊ156.25MHz��
  wire                gt_qpllclk          ;//QPLL��ʱ���źţ�
  wire                gt_qpllrefclk       ;//QPLL�Ĳο�ʱ���źţ�
  wire                gt_qpllreset        ;//QPLL�ĸ�λ�źţ�
  wire                gt_qplllock         ;//QPLL�������źţ�
  wire                gt_qpllrefclklost   ;//QPLL�Ĳο�ʱ��ʧ���źţ�


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

  // //����IBUFGDS_GTE2�������ʱ��ת��Ϊ����ʱ�ӣ�
  IBUFDS_GTE2 IBUFDS_GTXE2_CLK1 (
                .O      ( gt_refclk     ),//����ʱ������źţ�
                .ODIV2  (               ),//����ʱ�Ӷ���Ƶ����źţ�
                .CEB    ( 1'b0          ),//IBUFDS_GTE2ʹ���źţ�
                .I      ( gt_refclk_p   ),//���ʱ�������źţ�
                .IB     ( gt_refclk_n   ) //���ʱ�������źţ�
              );

  //����QPLLģ�飻
  Aurora_64B_Framing_gt_common_wrapper gt_common_support (
                                         .gt_qpllclk_quad1_out       ( gt_qpllclk        ),//QPLL��ʱ���źţ�
                                         .gt_qpllrefclk_quad1_out    ( gt_qpllrefclk     ),//QPLL�Ĳο�ʱ���źţ�
                                         .GT0_GTREFCLK0_COMMON_IN    ( gt_refclk         ),//����ʱ������źţ�
                                         .GT0_QPLLLOCK_OUT           ( gt_qplllock       ),//QPLL�������źţ�
                                        //  .GT0_QPLLRESET_IN           ( gt_qpllreset      ),//QPLL�ĸ�λ�źţ�
                                         .GT0_QPLLLOCKDETCLK_IN      ( init_clk          ),//��ʼ��ʱ�ӣ�IP����Ϊ100MHz��
                                         .GT0_QPLLREFCLKLOST_OUT     ( gt_qpllrefclklost ),//QPLL�Ĳο�ʱ��ʧ���źţ�
                                         .qpll_drpaddr_in            ( qpll_drpaddr      ),//QPLL��DRP��ַ�źţ�
                                         .qpll_drpdi_in              ( qpll_drpdi        ),//QPLL��DRP���������źţ�
                                         .qpll_drpclk_in             ( drp_clk           ),//DRPʱ���ź�,IP����Ϊ100MHz��
                                         .qpll_drpdo_out             ( qpll_drpdo        ),//QPLL��DRP��������źţ�
                                         .qpll_drprdy_out            ( qpll_drprdy       ),//QPLL��DRPӦ���źţ�
                                         .qpll_drpen_in              ( qpll_drpen        ),//QPLL��DRPʹ���źţ�
                                         .qpll_drpwe_in              ( qpll_drpwe        ) //QPLL��DRP��дָʾ�źţ�
                                       );



  //���������շ���0��
  aurora_channel u_aurora_channel_0(
                   .gt_rx_p            ( gt_rx_p[0]         ),//GT�շ����Ľ������ݲ�����ţ�
                   .gt_rx_n            ( gt_rx_n[0]         ),//GT�շ����Ľ������ݲ�����ţ�
                   .gt_refclk          ( gt_refclk         ),//GT�ο�ʱ�ӣ�IP����Ϊ156.25MHZ;
                   .user_clk           ( user_clk        ),//�û��ο�ʱ���źţ�
                   .user_sys_reset     ( user_reset[0]      ),//������û��ĸ�λ�źţ�
                   .system_rst         ( system_rst        ),//ϵͳ��λ�źţ�
                   .gt_loopback        ( gt_loopback[0]     ),//GT�շ����Ļػ�ģʽ�����źţ�
                   .gt_tx_p            ( gt_tx_p[0]         ),//GT�շ����ķ������ݲ�����ţ�
                   .gt_tx_n            ( gt_tx_n[0]         ),//GT�շ����ķ������ݲ�����ţ�
                   .hard_err           ( hard_err[0]        ),//Ӳ������ָʾ�źţ�
                   .soft_err           ( soft_err[0]        ),//�������ָʾ�źţ�
                   .channel_up         ( channel_up[0]      ),//ͨ����ʼ�������ͨ��׼��������ʱ���ߣ�
                   .lane_up            ( lane_up[0]         ),//��ͨ����ʼ���ɹ��źţ�
                   .s_axi_tx_tdata     ( s_axi_tx_tdata[0]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .s_axi_tx_tkeep     ( s_axi_tx_tkeep[0]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .s_axi_tx_tlast     ( s_axi_tx_tlast[0]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .s_axi_tx_tvalid    ( s_axi_tx_tvalid[0] ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .s_axi_tx_tready    ( s_axi_tx_tready[0] ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .m_axi_rx_tdata     ( m_axi_rx_tdata[0]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .m_axi_rx_tkeep     ( m_axi_rx_tkeep[0]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .m_axi_rx_tlast     ( m_axi_rx_tlast[0]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .m_axi_rx_tvalid    ( m_axi_rx_tvalid[0] ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .init_clk           ( init_clk          ),//��ʼ��ʱ�ӣ�IP����Ϊ100MHz��
                   .drp_clk            ( drp_clk           ),//DRPʱ���ź�,IP����Ϊ100MHz��
                   .gt_drpaddr         ( gt_drpaddr[0]      ),//GT�շ�����DRP��ַ�źţ�
                   .gt_drpdi           ( gt_drpdi[0]        ),//GT�շ�����DRP���������źţ�
                   .gt_drprdy          ( gt_drprdy[0]       ),//GT�շ�����DRPӦ���źţ�
                   .gt_drpen           ( gt_drpen[0]        ),//GT�շ�����DRPʹ���źţ�
                   .gt_drpwe           ( gt_drpwe[0]        ),//GT�շ�����DRP��дָʾ�źţ�
                   .gt_drpdo           ( gt_drpdo[0]        ),//GT�շ�����DRP��������źţ�
                   .qpll_drpaddr       ( qpll_drpaddr      ),//QPLL��DRP��ַ�źţ�
                   .qpll_drpdi         ( qpll_drpdi        ),//QPLL��DRP���������źţ�
                   .qpll_drpen         ( qpll_drpen        ),//QPLL��DRPʹ���źţ�
                   .qpll_drpwe         ( qpll_drpwe        ),//QPLL��DRP��дָʾ�źţ�
                   .gt_qpllclk         ( gt_qpllclk        ),//QPLL��ʱ���źţ�
                   .gt_qpllrefclk      ( gt_qpllrefclk     ),//QPLL�Ĳο�ʱ���źţ�
                   .gt_qpllreset       ( gt_qpllreset      ),//QPLL�ĸ�λ�źţ�
                   .gt_qplllock        ( gt_qplllock       ),//QPLL�������źţ�
                   .gt_qpllrefclklost  ( gt_qpllrefclklost ), //QPLL�Ĳο�ʱ��ʧ���źţ�
                   .tx_out_clk(tx_out_clk),
                   .gt_pll_lock(gt_pll_lock),
                   .sync_clk(sync_clk),
                   .mmcm_not_locked(mmcm_not_locked)               
                 );

  //���������շ���1��
  aurora_channel u_aurora_channel_1(
                   .gt_rx_p            ( gt_rx_p[1]         ),//GT�շ����Ľ������ݲ�����ţ�
                   .gt_rx_n            ( gt_rx_n[1]         ),//GT�շ����Ľ������ݲ�����ţ�
                   .gt_refclk          ( gt_refclk         ),//GT�ο�ʱ�ӣ�IP����Ϊ156.25MHZ;
                   .user_clk           ( user_clk        ),//�û��ο�ʱ���źţ�
                   .user_sys_reset     ( user_reset[1]      ),//������û��ĸ�λ�źţ�
                   .system_rst         ( system_rst        ),//ϵͳ��λ�źţ�
                   .gt_loopback        ( gt_loopback[1]     ),//GT�շ����Ļػ�ģʽ�����źţ�
                   .gt_tx_p            ( gt_tx_p[1]         ),//GT�շ����ķ������ݲ�����ţ�
                   .gt_tx_n            ( gt_tx_n[1]         ),//GT�շ����ķ������ݲ�����ţ�
                   .hard_err           ( hard_err[1]        ),//Ӳ������ָʾ�źţ�
                   .soft_err           ( soft_err[1]        ),//�������ָʾ�źţ�
                   .channel_up         ( channel_up[1]      ),//ͨ����ʼ�������ͨ��׼��������ʱ���ߣ�
                   .lane_up            ( lane_up[1]         ),//��ͨ����ʼ���ɹ��źţ�
                   .s_axi_tx_tdata     ( s_axi_tx_tdata[1]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .s_axi_tx_tkeep     ( s_axi_tx_tkeep[1]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .s_axi_tx_tlast     ( s_axi_tx_tlast[1]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .s_axi_tx_tvalid    ( s_axi_tx_tvalid[1] ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .s_axi_tx_tready    ( s_axi_tx_tready[1] ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .m_axi_rx_tdata     ( m_axi_rx_tdata[1]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .m_axi_rx_tkeep     ( m_axi_rx_tkeep[1]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .m_axi_rx_tlast     ( m_axi_rx_tlast[1]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .m_axi_rx_tvalid    ( m_axi_rx_tvalid[1] ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .init_clk           ( init_clk          ),//��ʼ��ʱ�ӣ�IP����Ϊ100MHz��
                   .drp_clk            ( drp_clk           ),//DRPʱ���ź�,IP����Ϊ100MHz��
                   .gt_drpaddr         ( gt_drpaddr[1]      ),//GT�շ�����DRP��ַ�źţ�
                   .gt_drpdi           ( gt_drpdi[1]        ),//GT�շ�����DRP���������źţ�
                   .gt_drprdy          ( gt_drprdy[1]       ),//GT�շ�����DRPӦ���źţ�
                   .gt_drpen           ( gt_drpen[1]        ),//GT�շ�����DRPʹ���źţ�
                   .gt_drpwe           ( gt_drpwe[1]        ),//GT�շ�����DRP��дָʾ�źţ�
                   .gt_drpdo           ( gt_drpdo[1]        ),//GT�շ�����DRP��������źţ�
                   .qpll_drpaddr       ( qpll_drpaddr      ),//QPLL��DRP��ַ�źţ�
                   .qpll_drpdi         ( qpll_drpdi        ),//QPLL��DRP���������źţ�
                   .qpll_drpen         ( qpll_drpen        ),//QPLL��DRPʹ���źţ�
                   .qpll_drpwe         ( qpll_drpwe        ),//QPLL��DRP��дָʾ�źţ�
                   .gt_qpllclk         ( gt_qpllclk        ),//QPLL��ʱ���źţ�
                   .gt_qpllrefclk      ( gt_qpllrefclk     ),//QPLL�Ĳο�ʱ���źţ�
                   .gt_qpllreset       (                   ),//QPLL�ĸ�λ�źţ�
                   .gt_qplllock        ( gt_qplllock       ),//QPLL�������źţ�
                   .gt_qpllrefclklost  ( gt_qpllrefclklost ), //QPLL�Ĳο�ʱ��ʧ���źţ�
                   .tx_out_clk(),
                   .gt_pll_lock(),
                   .sync_clk(sync_clk),
                   .mmcm_not_locked(mmcm_not_locked)        
                 );

  //���������շ���1��
  aurora_channel u_aurora_channel_2(
                   .gt_rx_p            ( gt_rx_p[2]         ),//GT�շ����Ľ������ݲ�����ţ�
                   .gt_rx_n            ( gt_rx_n[2]         ),//GT�շ����Ľ������ݲ�����ţ�
                   .gt_refclk          ( gt_refclk         ),//GT�ο�ʱ�ӣ�IP����Ϊ156.25MHZ;
                   .user_clk           ( user_clk       ),//�û��ο�ʱ���źţ�
                   .user_sys_reset     ( user_reset[2]      ),//������û��ĸ�λ�źţ�
                   .system_rst         ( system_rst        ),//ϵͳ��λ�źţ�
                   .gt_loopback        ( gt_loopback[2]     ),//GT�շ����Ļػ�ģʽ�����źţ�
                   .gt_tx_p            ( gt_tx_p[2]         ),//GT�շ����ķ������ݲ�����ţ�
                   .gt_tx_n            ( gt_tx_n[2]         ),//GT�շ����ķ������ݲ�����ţ�
                   .hard_err           ( hard_err[2]        ),//Ӳ������ָʾ�źţ�
                   .soft_err           ( soft_err[2]        ),//�������ָʾ�źţ�
                   .channel_up         ( channel_up[2]      ),//ͨ����ʼ�������ͨ��׼��������ʱ���ߣ�
                   .lane_up            ( lane_up[2]         ),//��ͨ����ʼ���ɹ��źţ�
                   .s_axi_tx_tdata     ( s_axi_tx_tdata[2]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .s_axi_tx_tkeep     ( s_axi_tx_tkeep[2]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .s_axi_tx_tlast     ( s_axi_tx_tlast[2]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .s_axi_tx_tvalid    ( s_axi_tx_tvalid[2] ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .s_axi_tx_tready    ( s_axi_tx_tready[2] ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .m_axi_rx_tdata     ( m_axi_rx_tdata[2]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .m_axi_rx_tkeep     ( m_axi_rx_tkeep[2]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .m_axi_rx_tlast     ( m_axi_rx_tlast[2]  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .m_axi_rx_tvalid    ( m_axi_rx_tvalid[2] ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
                   .init_clk           ( init_clk          ),//��ʼ��ʱ�ӣ�IP����Ϊ100MHz��
                   .drp_clk            ( drp_clk           ),//DRPʱ���ź�,IP����Ϊ100MHz��
                   .gt_drpaddr         ( gt_drpaddr[2]      ),//GT�շ�����DRP��ַ�źţ�
                   .gt_drpdi           ( gt_drpdi[2]        ),//GT�շ�����DRP���������źţ�
                   .gt_drprdy          ( gt_drprdy[2]       ),//GT�շ�����DRPӦ���źţ�
                   .gt_drpen           ( gt_drpen[2]        ),//GT�շ�����DRPʹ���źţ�
                   .gt_drpwe           ( gt_drpwe[2]        ),//GT�շ�����DRP��дָʾ�źţ�
                   .gt_drpdo           ( gt_drpdo[2]        ),//GT�շ�����DRP��������źţ�
                   .qpll_drpaddr       ( qpll_drpaddr      ),//QPLL��DRP��ַ�źţ�
                   .qpll_drpdi         ( qpll_drpdi        ),//QPLL��DRP���������źţ�
                   .qpll_drpen         ( qpll_drpen        ),//QPLL��DRPʹ���źţ�
                   .qpll_drpwe         ( qpll_drpwe        ),//QPLL��DRP��дָʾ�źţ�
                   .gt_qpllclk         ( gt_qpllclk        ),//QPLL��ʱ���źţ�
                   .gt_qpllrefclk      ( gt_qpllrefclk     ),//QPLL�Ĳο�ʱ���źţ�
                   .gt_qpllreset       (                   ),//QPLL�ĸ�λ�źţ�
                   .gt_qplllock        ( gt_qplllock       ),//QPLL�������źţ�
                   .gt_qpllrefclklost  ( gt_qpllrefclklost ), //QPLL�Ĳο�ʱ��ʧ���źţ�
                   .tx_out_clk(),
                   .gt_pll_lock(),
                   .sync_clk(sync_clk),
                   .mmcm_not_locked(mmcm_not_locked)        
                 );
endmodule
