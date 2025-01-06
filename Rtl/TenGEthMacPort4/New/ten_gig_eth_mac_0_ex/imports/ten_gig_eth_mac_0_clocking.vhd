-------------------------------------------------------------------------------
-- File       : ten_gig_eth_mac_0_clocking.vhd  
-- Author     : Xilinx Inc.
-------------------------------------------------------------------------------
-- Description: This is the shareable clocking resources VHDL code for the 
-- Ten Gigabit Ethernet MAC. 
-------------------------------------------------------------------------------
-- (c) Copyright 2001-2014 Xilinx, Inc. All rights reserved.
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
-- 
-- 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ten_gig_eth_mac_0_clocking is
  port (
    -- inputs
    gtx_clk_in     : in  std_logic; -- TX clock input
    tx_mmcm_reset  : in  std_logic; -- reset for MMCM

    -- clock outputs
    tx_clk0        : out std_logic; -- TX system clock

    -- status outputs
    tx_mmcm_locked : out std_logic);
end ten_gig_eth_mac_0_clocking;

library unisim;
use unisim.vcomponents.all;

architecture rtl of ten_gig_eth_mac_0_clocking is
  signal tx_dcm_clk0  : std_logic;
  signal clkfbout     : std_logic;
begin

  -- Clock management
  tx_mmcm : MMCME2_BASE
  generic map
    (DIVCLK_DIVIDE        => 1,
     CLKFBOUT_MULT_F      => 6.000,
     CLKFBOUT_PHASE       => 0.000,
     CLKOUT0_DIVIDE_F     => 6.000,
     CLKOUT0_PHASE        => 0.000,
     CLKOUT0_DUTY_CYCLE   => 0.5,
     CLKIN1_PERIOD        => 6.400,
     REF_JITTER1          => 0.010)
  port map (
     CLKFBOUT    => clkfbout,
     CLKOUT0     => tx_dcm_clk0,
     CLKOUT1     => open,
     CLKIN1      => gtx_clk_in,
     LOCKED      => tx_mmcm_locked,
     CLKFBIN     => clkfbout,
     RST         => tx_mmcm_reset,
     PWRDWN      => '0',
     CLKFBOUTB   => open,
     CLKOUT0B    => open,
     CLKOUT1B    => open,
     CLKOUT2     => open,
     CLKOUT2B    => open,
     CLKOUT3     => open,
     CLKOUT3B    => open,
     CLKOUT4     => open,
     CLKOUT5     => open,
     CLKOUT6     => open);

  tx_bufg0 : BUFG
    port map (
      I => tx_dcm_clk0,
      O => tx_clk0);


   
end rtl;
