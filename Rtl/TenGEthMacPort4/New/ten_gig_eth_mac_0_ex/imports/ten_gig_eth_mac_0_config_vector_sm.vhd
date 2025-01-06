-- ------------------------------------------------------------------------------
-- (c) Copyright 2014 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES. 
-- ------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Title      : Configuration state machine
-- Project    : 10 Gig Ethernet MAC FIFO Reference Design
--------------------------------------------------------------------------------
-- File       : ten_gig_eth_mac_0_config_vector_sm.v
-- Author     : Xilinx Inc.
-- -----------------------------------------------------------------------------
-- Description:  This module is reponsible for bringing up the XGMAC
--               to enable basic packet transfer in both directions.
--
-----------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ten_gig_eth_mac_0_config_vector_sm is  
port (
   gtx_clk                             : in  std_logic;
   gtx_reset                           : in  std_logic;

   enable_vlan                         : in  std_logic;
   enable_custom_preamble              : in  std_logic;
   
   rx_configuration_vector             : out std_logic_vector(79 downto 0);
   tx_configuration_vector             : out std_logic_vector(79 downto 0)
);
end ten_gig_eth_mac_0_config_vector_sm;
  
architecture rtl of ten_gig_eth_mac_0_config_vector_sm is

   -- main state machine
   type STATES is (STARTUP,RESET_MAC,CHECK_MODE);

   ---------------------------------------------------
   -- Wire/reg declarations
   signal control_status               : STATES;      -- used to keep track of axi transactions

   signal count_shift                  : std_logic_vector(20 downto 0) := (others => '0');

   signal tx_reset                     : std_logic;
   signal tx_enable                    : std_logic;
   signal tx_vlan_enable               : std_logic;
   signal tx_fcs_enable                : std_logic;
   signal tx_jumbo_enable              : std_logic;
   signal tx_fc_enable                 : std_logic;
   signal tx_custom_preamble           : std_logic;
   signal tx_ifg_adjust                : std_logic;
   signal tx_wan_enable                : std_logic;
   signal tx_dic_enable                : std_logic;
   signal tx_max_frame_enable          : std_logic;
   signal tx_max_frame_length          : std_logic_vector(14 downto 0);
   signal tx_pause_addr                : std_logic_vector(47 downto 0);

   signal rx_reset                     : std_logic;
   signal rx_enable                    : std_logic;
   signal rx_vlan_enable               : std_logic;
   signal rx_fcs_enable                : std_logic;
   signal rx_jumbo_enable              : std_logic;
   signal rx_fc_enable                 : std_logic;
   signal rx_custom_preamble           : std_logic;
   signal rx_len_type_chk_disable      : std_logic;
   signal rx_control_len_chk_dis       : std_logic;
   signal rx_rs_inhibit                : std_logic;
   signal rx_max_frame_enable          : std_logic;
   signal rx_max_frame_length          : std_logic_vector(14 downto 0);
   signal rx_pause_addr                : std_logic_vector(47 downto 0);

begin

   rx_configuration_vector             <= rx_pause_addr & 
                                          '0' &  rx_max_frame_length & 
                                          '0' &  rx_max_frame_enable & 
                                          "000" &  rx_rs_inhibit &  
                                          rx_control_len_chk_dis & 
                                          rx_len_type_chk_disable & 
                                          rx_custom_preamble & 
                                          '0' &  rx_fc_enable & 
                                          rx_jumbo_enable & 
                                          rx_fcs_enable & 
                                          rx_vlan_enable & 
                                          rx_enable & 
                                          rx_reset;

   tx_configuration_vector             <= tx_pause_addr & 
                                          '0' &  tx_max_frame_length & 
                                          '0' &  tx_max_frame_enable & 
                                          "000" &  tx_dic_enable & 
                                          tx_wan_enable &  tx_ifg_adjust & 
                                          tx_custom_preamble &  
                                          '0' &  tx_fc_enable & 
                                          tx_jumbo_enable & 
                                          tx_fcs_enable & 
                                          tx_vlan_enable & 
                                          tx_enable & 
                                          tx_reset;

   -- don't reset this  - it will always be updated before it is used..
   -- it does need an init value (zero)
   gen_count : process (gtx_clk)
   begin
      if gtx_clk'event and gtx_clk = '1' then
         count_shift                      <= count_shift(19 downto 0) & (gtx_reset or tx_reset);
      end if;
   end process gen_count;

   ------------------------------------------------------------------------------
   -- Management process. This process sets up the configuration by
   -- turning off flow control and other functionality
   ------------------------------------------------------------------------------

   tx_enable                           <= '1';
   tx_vlan_enable                      <= enable_vlan;
   tx_fcs_enable                       <= '0';
   tx_jumbo_enable                     <= '0';
   tx_fc_enable                        <= '0';
   tx_custom_preamble                  <= enable_custom_preamble;
   tx_ifg_adjust                       <= '0';
   tx_wan_enable                       <= '0';
   tx_dic_enable                       <= '0';
   tx_max_frame_enable                 <= '0';
   tx_max_frame_length                 <= (others => '0');
   tx_pause_addr                       <= X"0605040302DA";

   rx_enable                           <= '1';
   rx_vlan_enable                      <= enable_vlan;
   rx_fcs_enable                       <= '0';
   rx_jumbo_enable                     <= '0';
   rx_fc_enable                        <= '0';
   rx_custom_preamble                  <= enable_custom_preamble;
   rx_len_type_chk_disable             <= '0';
   rx_control_len_chk_dis              <= '0';
   rx_rs_inhibit                       <= '0';
   rx_max_frame_enable                 <= '0';
   rx_max_frame_length                 <= (others => '0');
   rx_pause_addr                       <= X"0605040302DA";

   -- since the main controls are all hard coded, only a reset will restart the state machine
   p_state : process (gtx_clk)
   begin
      if gtx_clk'event and gtx_clk = '1' then
         if gtx_reset = '1' then
            tx_reset                   <= '0';
            rx_reset                   <= '0';
            control_status             <= STARTUP;
         -- main state machine is kicking off multi cycle accesses in each state so has to
         -- stall while they take place
         else
            case control_status is
               when STARTUP =>
                  -- this state will be ran after reset to wait for count_shift
                  if count_shift(20) = '0' then
                     control_status    <= RESET_MAC;
                  end if;
               when RESET_MAC =>
                  assert false
                     report "** Note: Reseting MAC" & cr
                     severity note;
                  tx_reset             <= '1';
                  rx_reset             <= '1';
                  control_status       <= CHECK_MODE;
               when CHECK_MODE =>
                  -- hold the tx/rx resets for a number of clocks to ensure they are caught
                  if count_shift(20) = '1' then
                     tx_reset       <= '0';
                     rx_reset       <= '0';
                  end if;
               when others =>
                  control_status  <= STARTUP;
            end case;
         end if;
      end if;
   end process p_state;

end rtl;

