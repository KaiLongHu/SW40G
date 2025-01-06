-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
-- Date        : Mon Jan  6 12:01:15 2025
-- Host        : hkl running 64-bit Ubuntu 22.04.4 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /workspace/HKL_FPGA/TOP63_Aurora/Sw_40G_Prj/Sw_40G_Prj.srcs/sources_1/ip/Aurora_64B_Framing_lane2_Y0Y1/Aurora_64B_Framing_lane2_Y0Y1_stub.vhdl
-- Design      : Aurora_64B_Framing_lane2_Y0Y1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffv900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Aurora_64B_Framing_lane2_Y0Y1 is
  Port ( 
    s_axi_tx_tdata : in STD_LOGIC_VECTOR ( 0 to 127 );
    s_axi_tx_tlast : in STD_LOGIC;
    s_axi_tx_tkeep : in STD_LOGIC_VECTOR ( 0 to 15 );
    s_axi_tx_tvalid : in STD_LOGIC;
    s_axi_tx_tready : out STD_LOGIC;
    m_axi_rx_tdata : out STD_LOGIC_VECTOR ( 0 to 127 );
    m_axi_rx_tlast : out STD_LOGIC;
    m_axi_rx_tkeep : out STD_LOGIC_VECTOR ( 0 to 15 );
    m_axi_rx_tvalid : out STD_LOGIC;
    rxp : in STD_LOGIC_VECTOR ( 0 to 1 );
    rxn : in STD_LOGIC_VECTOR ( 0 to 1 );
    txp : out STD_LOGIC_VECTOR ( 0 to 1 );
    txn : out STD_LOGIC_VECTOR ( 0 to 1 );
    refclk1_in : in STD_LOGIC;
    hard_err : out STD_LOGIC;
    soft_err : out STD_LOGIC;
    channel_up : out STD_LOGIC;
    lane_up : out STD_LOGIC_VECTOR ( 0 to 1 );
    mmcm_not_locked : in STD_LOGIC;
    user_clk : in STD_LOGIC;
    sync_clk : in STD_LOGIC;
    reset_pb : in STD_LOGIC;
    gt_rxcdrovrden_in : in STD_LOGIC;
    power_down : in STD_LOGIC;
    loopback : in STD_LOGIC_VECTOR ( 2 downto 0 );
    pma_init : in STD_LOGIC;
    gt_pll_lock : out STD_LOGIC;
    drp_clk_in : in STD_LOGIC;
    gt_qpllclk_quad1_in : in STD_LOGIC;
    gt_qpllrefclk_quad1_in : in STD_LOGIC;
    drpaddr_in : in STD_LOGIC_VECTOR ( 8 downto 0 );
    drpdi_in : in STD_LOGIC_VECTOR ( 15 downto 0 );
    drpdo_out : out STD_LOGIC_VECTOR ( 15 downto 0 );
    drprdy_out : out STD_LOGIC;
    drpen_in : in STD_LOGIC;
    drpwe_in : in STD_LOGIC;
    drpaddr_in_lane1 : in STD_LOGIC_VECTOR ( 8 downto 0 );
    drpdi_in_lane1 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    drpdo_out_lane1 : out STD_LOGIC_VECTOR ( 15 downto 0 );
    drprdy_out_lane1 : out STD_LOGIC;
    drpen_in_lane1 : in STD_LOGIC;
    drpwe_in_lane1 : in STD_LOGIC;
    init_clk : in STD_LOGIC;
    link_reset_out : out STD_LOGIC;
    sys_reset_out : out STD_LOGIC;
    tx_out_clk : out STD_LOGIC
  );

end Aurora_64B_Framing_lane2_Y0Y1;

architecture stub of Aurora_64B_Framing_lane2_Y0Y1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "s_axi_tx_tdata[0:127],s_axi_tx_tlast,s_axi_tx_tkeep[0:15],s_axi_tx_tvalid,s_axi_tx_tready,m_axi_rx_tdata[0:127],m_axi_rx_tlast,m_axi_rx_tkeep[0:15],m_axi_rx_tvalid,rxp[0:1],rxn[0:1],txp[0:1],txn[0:1],refclk1_in,hard_err,soft_err,channel_up,lane_up[0:1],mmcm_not_locked,user_clk,sync_clk,reset_pb,gt_rxcdrovrden_in,power_down,loopback[2:0],pma_init,gt_pll_lock,drp_clk_in,gt_qpllclk_quad1_in,gt_qpllrefclk_quad1_in,drpaddr_in[8:0],drpdi_in[15:0],drpdo_out[15:0],drprdy_out,drpen_in,drpwe_in,drpaddr_in_lane1[8:0],drpdi_in_lane1[15:0],drpdo_out_lane1[15:0],drprdy_out_lane1,drpen_in_lane1,drpwe_in_lane1,init_clk,link_reset_out,sys_reset_out,tx_out_clk";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "aurora_64b66b_v11_2_6, Coregen v14.3_ip3, Number of lanes = 2, Line rate is double6.25Gbps, Reference Clock is double156.25MHz, Interface is Framing, Flow Control is None and is operating in DUPLEX configuration";
begin
end;
