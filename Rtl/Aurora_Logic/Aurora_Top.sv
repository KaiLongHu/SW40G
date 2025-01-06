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

  wire [63 : 0] s_axi_tx_tdata_1;    //�û��������ݵ�AXI_STEAM���ӿ��źţ�
  wire [7  : 0] s_axi_tx_tkeep_1;    //�û��������ݵ�AXI_STEAM���ӿ��źţ�
  wire          s_axi_tx_tlast_1;    //�û��������ݵ�AXI_STEAM���ӿ��źţ�
  wire          s_axi_tx_tvalid_1;   //�û��������ݵ�AXI_STEAM���ӿ��źţ�
  wire          s_axi_tx_tready_1;   //�û��������ݵ�AXI_STEAM���ӿ��źţ�
  wire [63 : 0] m_axi_rx_tdata_1;    //�û��������ݵ�AXI_STEAM���ӿ��źţ�
  wire [7 : 0]  m_axi_rx_tkeep_1;    //�û��������ݵ�AXI_STEAM���ӿ��źţ�
  wire          m_axi_rx_tlast_1;    //�û��������ݵ�AXI_STEAM���ӿ��źţ�
  wire          m_axi_rx_tvalid_1;   //�û��������ݵ�AXI_STEAM���ӿ��źţ�

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////            SUPPORT              ///////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  aurora_module u_aurora_module(
    .gt_refclk_p        ( gt_refclk_p       ),//GT��ֲο�ʱ�ӣ�IP����Ϊ156.25MHZ;
    .gt_refclk_n        ( gt_refclk_n       ),//GT��ֲο�ʱ�ӣ�IP����Ϊ156.25MHZ;
    .system_rst         ( system_rst        ),//ϵͳ��λ�źţ�
    .init_clk           ( clk               ),//��ʼ��ʱ�ӣ�IP����Ϊ100MHz��
    .drp_clk            ( clk               ),//DRPʱ���ź�,IP����Ϊ100MHz��
    //QPLL��DRP�ӿڣ�
    .qpll_drpaddr       ( 0                 ),//QPLL��DRP��ַ�źţ�
    .qpll_drpdi         ( 0                 ),//QPLL��DRP���������źţ�
    .qpll_drprdy        (                   ),//QPLL��DRPӦ���źţ�
    .qpll_drpen         ( 0                 ),//QPLL��DRPʹ���źţ�
    .qpll_drpwe         ( 0                 ),//QPLL��DRP��дָʾ�źţ�
    .qpll_drpdo         (                   ),//QPLL��DRP��������źţ�
    //GT�շ���0������źţ�
    .gt_rx_p_0          ( gt_rx_p_0         ),//GT�շ����Ľ������ݲ�����ţ�
    .gt_rx_n_0          ( gt_rx_n_0         ),//GT�շ����Ľ������ݲ�����ţ�
    .user_clk_0         ( user_clk_0        ),//�û��ο�ʱ���źţ�
    .user_reset_0       ( user_reset_0      ),//������û��ĸ�λ�źţ�
    .gt_loopback_0      ( 3'b000            ),//GT�շ����Ļػ�ģʽ�����źţ�
    .gt_tx_p_0          ( gt_tx_p_0         ),//GT�շ����ķ������ݲ�����ţ�
    .gt_tx_n_0          ( gt_tx_n_0         ),//GT�շ����ķ������ݲ�����ţ�
    .hard_err_0         ( hard_err_0        ),//Ӳ������ָʾ�źţ�
    .soft_err_0         ( soft_err_0        ),//�������ָʾ�źţ�
    .channel_up_0       ( channel_up_0      ),//ͨ����ʼ�������ͨ��׼��������ʱ���ߣ�
    .lane_up_0          ( lane_up_0         ),//��ͨ����ʼ���ɹ��źţ�
    .s_axi_tx_tdata_0   ( s_axi_tx_tdata_0  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .s_axi_tx_tkeep_0   ( s_axi_tx_tkeep_0  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .s_axi_tx_tlast_0   ( s_axi_tx_tlast_0  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .s_axi_tx_tvalid_0  ( s_axi_tx_tvalid_0 ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .s_axi_tx_tready_0  ( s_axi_tx_tready_0 ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .m_axi_rx_tdata_0   ( m_axi_rx_tdata_0  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .m_axi_rx_tkeep_0   ( m_axi_rx_tkeep_0  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .m_axi_rx_tlast_0   ( m_axi_rx_tlast_0  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .m_axi_rx_tvalid_0  ( m_axi_rx_tvalid_0 ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .gt_drpaddr_0       ( 0                 ),//GT�շ�����DRP��ַ�źţ�
    .gt_drpdi_0         ( 0                 ),//GT�շ�����DRP���������źţ�
    .gt_drprdy_0        (                   ),//GT�շ�����DRPӦ���źţ�
    .gt_drpen_0         ( 0                 ),//GT�շ�����DRPʹ���źţ�
    .gt_drpwe_0         ( 0                 ),//GT�շ�����DRP��дָʾ�źţ�
    .gt_drpdo_0         (                   ),//GT�շ�����DRP��������źţ�
    //GT�շ���1������źţ�
    .gt_rx_p_1          ( gt_rx_p_1         ),//GT�շ����Ľ������ݲ�����ţ�
    .gt_rx_n_1          ( gt_rx_n_1         ),//GT�շ����Ľ������ݲ�����ţ�
    .user_clk_1         ( user_clk_1        ),//�û��ο�ʱ���źţ�
    .user_reset_1       ( user_reset_1      ),//������û��ĸ�λ�źţ�
    .gt_loopback_1      ( 3'b000            ),//GT�շ����Ļػ�ģʽ�����źţ�
    .gt_tx_p_1          ( gt_tx_p_1         ),//GT�շ����ķ������ݲ�����ţ�
    .gt_tx_n_1          ( gt_tx_n_1         ),//GT�շ����ķ������ݲ�����ţ�
    .hard_err_1         ( hard_err_1        ),//Ӳ������ָʾ�źţ�
    .soft_err_1         ( soft_err_1        ),//�������ָʾ�źţ�
    .channel_up_1       ( channel_up_1      ),//ͨ����ʼ�������ͨ��׼��������ʱ���ߣ�
    .lane_up_1          ( lane_up_1         ),//��ͨ����ʼ���ɹ��źţ�
    .s_axi_tx_tdata_1   ( s_axi_tx_tdata_1  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .s_axi_tx_tkeep_1   ( s_axi_tx_tkeep_1  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .s_axi_tx_tlast_1   ( s_axi_tx_tlast_1  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .s_axi_tx_tvalid_1  ( s_axi_tx_tvalid_1 ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .s_axi_tx_tready_1  ( s_axi_tx_tready_1 ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .m_axi_rx_tdata_1   ( m_axi_rx_tdata_1  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .m_axi_rx_tkeep_1   ( m_axi_rx_tkeep_1  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .m_axi_rx_tlast_1   ( m_axi_rx_tlast_1  ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .m_axi_rx_tvalid_1  ( m_axi_rx_tvalid_1 ),//�û��������ݵ�AXI_STEAM���ӿ��źţ�
    .gt_drpaddr_1       ( 0                 ),//GT�շ�����DRP��ַ�źţ�
    .gt_drpdi_1         ( 0                 ),//GT�շ�����DRP���������źţ�
    .gt_drprdy_1        (                   ),//GT�շ�����DRPӦ���źţ�
    .gt_drpen_1         ( 0                 ),//GT�շ�����DRPʹ���źţ�
    .gt_drpwe_1         ( 0                 ),//GT�շ�����DRP��дָʾ�źţ�
    .gt_drpdo_1         (                   ) //GT�շ�����DRP��������źţ�
);

endmodule
