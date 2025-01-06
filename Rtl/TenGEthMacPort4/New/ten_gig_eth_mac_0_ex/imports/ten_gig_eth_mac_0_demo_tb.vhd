-------------------------------------------------------------------------------
-- Title      : Demo testbench
-- Project    : 10 Gigabit Ethernet MAC
-------------------------------------------------------------------------------
-- File       : demo_tb.vhd
-------------------------------------------------------------------------------
-- Description: This testbench will exercise the ports of the MAC core to
--              demonstrate the functionality.
-------------------------------------------------------------------------------
-- (c) Copyright 2004-2014 Xilinx, Inc. All rights reserved.
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
-- This testbench performs the following operations on the MAC core:
--  - The clock divide register is set for MDIO operation.
--  - The XGMII/XAUI port is wired as a loopback, so that transmitted frames
--    are then injected into the receiver.
--  - Four frames are pushed into the transmitter. The first is a minimum
--    length frame, the second is slightly longer, the third has an error
--    asserted and the fourth is less than minimum length and is hence padded
--    by the transmitter up to the minimum.
--  - These frames are then parsed by the receiver, which supplies the data out
--    on it's client interface. The testbench verifies that this data matches
--    that injected into the transmitter.

entity ten_gig_eth_mac_0_demo_tb is
   generic (
      func_sim : boolean := false);
end ten_gig_eth_mac_0_demo_tb;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture behav of ten_gig_eth_mac_0_demo_tb is
  
   -----------------------------------------------------------------------------
   -- Component Declaration for Example Design (the top level wrapper example).
   -----------------------------------------------------------------------------
   component ten_gig_eth_mac_0_example_design
   port(
      ---------------------------------------------------------------------------
      -- Interface to the host.
      ---------------------------------------------------------------------------
      reset                            : in  std_logic;                     -- Resets the MAC.
      tx_axis_aresetn                  : in  std_logic;
      rx_axis_aresetn                  : in  std_logic;
      address_swap_disable             : in  std_logic;
      tx_statistics_vector             : out std_logic;                     -- Statistics information on the last frame.
      rx_statistics_vector             : out std_logic;                     -- Statistics info on the last received frame.
      reset_error                      : in  std_logic;
      insert_error                     : in  std_logic;
      enable_pat_gen                   : in  std_logic;
      enable_pat_check                 : in  std_logic;
   
      gen_active_flash                 : out std_logic; 
      check_active_flash               : out std_logic;
      frame_error                      : out std_logic;
      
      pause_req                        : in  std_logic;
   
      gtx_clk                          : in  std_logic;                     -- The global transmit clock from the outside world.
      xgmii_tx_clk                     : out std_logic;                     -- the TX clock from the reconcilliation sublayer.
      xgmii_txd                        : out std_logic_vector(63 downto 0); -- Transmitted data
      xgmii_txc                        : out std_logic_vector(7 downto 0);  -- Transmitted control
      xgmii_rx_clk                     : in  std_logic;                     -- The rx clock from the PHY layer.
      xgmii_rxd                        : in  std_logic_vector(63 downto 0); -- Received data
      xgmii_rxc                        : in  std_logic_vector(7 downto 0)   -- received control
   );
   end component;

   --constant TB_MODE                  : string := "BIST";
   constant TB_MODE                    : string := "DEMO";

   constant MIN_FRAME_DATA_BYTES       : integer := 60;
   constant OVERHEAD                   : integer := 18;   -- DA/SA (12) + L/T (2) + CRC (4)
  
   constant RX_CLK_PERIOD              : time := 6400 ps;
  
   -- FRAME_GEN_MULTIPLIER constant determines the number of word blocks after DA/SA to be sent
   -- For instance if index of last complete ctrl column ( eg. column[14] == X"F" hence LAST_QUAD_DATA_COLUMN_INDEX = 14) 
   -- then the block size is (14 + 1) - 3 = 12. 
   -- That means that 12 * 4 = 48 bytes are contained in one block
   -- If FRAME_GEN_MULTIPLIER is set to 2 then 2*12*4 = 96 bytes are sent after DA/SA
   -- and the same 48 byte will be sent 2 times.
   -- In order to get correct frames through the TYPE/LENGTH field is to be set to 2*48 - 2 = 94 (0h5E) 
   -- in this case the general formula for LENGTH/TYPE field is as follows:
   -- [[(index of last complete ctrl column + 1) - 3] * 4 * FRAME_GEN_MULTIPLIER ]- 2 + 
   -- (0,1,2 or 3 depending from the value of the ctrl column after the last complete ctrl column)
   -- Note that this multiplier constant is applied to every frame inserted into RX therefore the L/T field 
   -- is to be set appropriately for every frame unless the frame is a control frame.
   constant FRAME_GEN_MULTIPLIER       : integer := 1;
  
   -- The IN_BAND_FCS_PASSING global parameter controls whether this feature is disabled or enabled 
   -- in the core
   constant IN_BAND_FCS_PASSING        : boolean := false;
  
   -----------------------------------------------------------------------------
   -- types to support frame data
   -----------------------------------------------------------------------------
   -- COLUMN_TYP is a type declaration for an object to hold an single
   -- XGMII column's information on the client interface i.e. 32 bit
   -- data/4 bit control. It holds both the data bytes and the valid signals
   -- for each byte lane.
   type COLUMN_TYP is record             -- Single column on client I/F
                       D : bit_vector(31 downto 0);  -- Data
                       C : bit_vector(3 downto 0);   -- Control
                     end record;
   type COLUMN_ARY_TYP is array (natural range <>) of COLUMN_TYP;
   -- FRAME_TYPE is a type declaration for an object to hold an entire frame of
   -- information. The columns which make up the frame are held in here, along
   -- with a flag to say whether the error flag should be asserted to the
   -- core on this frame. If TRUE, this error occurs on the clock cycle
   -- *after* the last column of data defined in the frame record.
   type FRAME_TYP is record
                      COLUMNS  : COLUMN_ARY_TYP(0 to 31);
                      LAST_QUAD_DATA_COLUMN_INDEX : integer;
                      ERROR : boolean;            -- should this frame cause
                                                     -- error/error?
                    end record;
   type FRAME_TYP_ARY is array (natural range <>) of FRAME_TYP;

  -----------------------------------------------------------------------------
  -- Stimulus - Frame data
  -----------------------------------------------------------------------------
  -- The following constant holds the stimulus for the testbench. It is an
  -- ordered array of frames, with frame 0 the first to be injected into the
  -- core transmit interface by the testbench. See the datasheet for the
  -- position of the Ethernet fields within each frame.
  constant FRAME_DATA : FRAME_TYP_ARY := (
  
  -- In order to get correct frames through the TYPE/LENGTH  
  -- field is to be set according to the following formula:
  -- TYPE/LENGTH = [[(index of last complete ctrl column + 1) - 3] * 4 * FRAME_GEN_MULTIPLIER ]- 2 + 
  -- (0,1,2 or 3 depending from the value of the ctrl column after the last complete ctrl column)    
  -- TYPE/LENGTH field is the 16LSBs of column 3
        
    0          => (                     -- Frame 0
      COLUMNS  => (
        0      => (D => X"04030201", C => X"F"),
        1      => (D => X"02020605", C => X"F"),
        2      => (D => X"06050403", C => X"F"),
        3      => (D => X"55AA2E00", C => X"F"),  -- <---
        4      => (D => X"AA55AA55", C => X"F"),  --    |
        5      => (D => X"55AA55AA", C => X"F"),  --    |  This part of the frame is looped
        6      => (D => X"AA55AA55", C => X"F"),  --    |  if FRAME_GEN_MULTIPLIER is set to 
        7      => (D => X"55AA55AA", C => X"F"),  --    |  more than 1
        8      => (D => X"AA55AA55", C => X"F"),  --    |  
        9      => (D => X"55AA55AA", C => X"F"),  --    |
        10     => (D => X"AA55AA55", C => X"F"),  --    |
        11     => (D => X"55AA55AA", C => X"F"),  --    |
        12     => (D => X"AA55AA55", C => X"F"),  --    |
        13     => (D => X"55AA55AA", C => X"F"),  --    |
        14     => (D => X"AA55AA55", C => X"F"),  -- <---
        15     => (D => X"00000000", C => X"0"),
        16     => (D => X"00000000", C => X"0"),
        17     => (D => X"00000000", C => X"0"),
        18     => (D => X"00000000", C => X"0"),
        19     => (D => X"00000000", C => X"0"),
        20     => (D => X"00000000", C => X"0"),
        21     => (D => X"00000000", C => X"0"),
        22     => (D => X"00000000", C => X"0"),
        23     => (D => X"00000000", C => X"0"),
        24     => (D => X"00000000", C => X"0"),
        25     => (D => X"00000000", C => X"0"),
        26     => (D => X"00000000", C => X"0"),
        27     => (D => X"00000000", C => X"0"),
        28     => (D => X"00000000", C => X"0"),
        29     => (D => X"00000000", C => X"0"),
        30     => (D => X"00000000", C => X"0"),
        31     => (D => X"00000000", C => X"0")),
        LAST_QUAD_DATA_COLUMN_INDEX => 14,         -- Holds the index value for the last full column
      ERROR => false),
    1          => (                     -- Frame 1
      COLUMNS  => (
        0      => (D => X"03040506", C => X"F"),  
        1      => (D => X"05060102", C => X"F"),  
        2      => (D => X"02020304", C => X"F"),    
        3      => (D => X"EE110080", C => X"F"),  -- <---  
        4      => (D => X"11EE11EE", C => X"F"),  --    |  
        5      => (D => X"EE11EE11", C => X"F"),  --    |  
        6      => (D => X"11EE11EE", C => X"F"),  --    |   This part of the frame is looped
        7      => (D => X"EE11EE11", C => X"F"),  --    |   if FRAME_GEN_MULTIPLIER is set to 
        8      => (D => X"11EE11EE", C => X"F"),  --    |   more than 1
        9      => (D => X"EE11EE11", C => X"F"),  --    |
        10     => (D => X"11EE11EE", C => X"F"),  --    |
        11     => (D => X"EE11EE11", C => X"F"),  --    |
        12     => (D => X"11EE11EE", C => X"F"),  --    |
        13     => (D => X"EE11EE11", C => X"F"),  --    |
        14     => (D => X"11EE11EE", C => X"F"),  --    |
        15     => (D => X"EE11EE11", C => X"F"),  --    |
        16     => (D => X"11EE11EE", C => X"F"),  --    |
        17     => (D => X"EE11EE11", C => X"F"),  --    |
        18     => (D => X"11EE11EE", C => X"F"),  --    |
        19     => (D => X"EE11EE11", C => X"F"),  --    |
        20     => (D => X"11EE11EE", C => X"F"),  -- <---
        21     => (D => X"0000EE11", C => X"3"),
        22     => (D => X"00000000", C => X"0"),
        23     => (D => X"00000000", C => X"0"),
        24     => (D => X"00000000", C => X"0"),
        25     => (D => X"00000000", C => X"0"),
        26     => (D => X"00000000", C => X"0"),
        27     => (D => X"00000000", C => X"0"),
        28     => (D => X"00000000", C => X"0"),
        29     => (D => X"00000000", C => X"0"),
        30     => (D => X"00000000", C => X"0"),
        31     => (D => X"00000000", C => X"0")),
        LAST_QUAD_DATA_COLUMN_INDEX => 20,
      ERROR => false),
    2          => (                     -- Frame 2
      COLUMNS  => (
        0      => (D => X"04030201", C => X"F"),
        1      => (D => X"02020605", C => X"F"),
        2      => (D => X"06050403", C => X"F"),
        3      => (D => X"55AA2E80", C => X"F"),
        4      => (D => X"AA55AA55", C => X"F"),
        5      => (D => X"55AA55AA", C => X"F"),
        6      => (D => X"AA55AA55", C => X"F"),
        7      => (D => X"55AA55AA", C => X"F"),
        8      => (D => X"AA55AA55", C => X"F"),
        9      => (D => X"55AA55AA", C => X"F"),
        10     => (D => X"AA55AA55", C => X"F"),
        11     => (D => X"55AA55AA", C => X"F"),
        12     => (D => X"AA55AA55", C => X"F"),
        13     => (D => X"55AA55AA", C => X"F"),
        14     => (D => X"AA55AA55", C => X"F"),
        15     => (D => X"55AA55AA", C => X"F"),
        16     => (D => X"AA55AA55", C => X"F"),
        17     => (D => X"55AA55AA", C => X"F"),
        18     => (D => X"AA55AA55", C => X"F"),
        19     => (D => X"55AA55AA", C => X"F"),
        20     => (D => X"11EE11EE", C => X"F"),
        21     => (D => X"0000EE11", C => X"3"),
        22     => (D => X"00000000", C => X"0"),
        23     => (D => X"00000000", C => X"0"),
        24     => (D => X"00000000", C => X"0"),
        25     => (D => X"00000000", C => X"0"),
        26     => (D => X"00000000", C => X"0"),
        27     => (D => X"00000000", C => X"0"),
        28     => (D => X"00000000", C => X"0"),
        29     => (D => X"00000000", C => X"0"),
        30     => (D => X"00000000", C => X"0"),
        31     => (D => X"00000000", C => X"0")),
        LAST_QUAD_DATA_COLUMN_INDEX => 20,
      ERROR => true),
    3          => (                     -- Frame 3

      COLUMNS  => (
        0      => (D => X"03040506", C => X"F"),
        1      => (D => X"05060102", C => X"F"),
        2      => (D => X"02020304", C => X"F"),
        3      => (D => X"EE111500", C => X"F"),
        4      => (D => X"11EE11EE", C => X"F"),
        5      => (D => X"EE11EE11", C => X"F"),
        6      => (D => X"11EE11EE", C => X"F"),
        7      => (D => X"EE11EE11", C => X"F"),
        8      => (D => X"00EE11EE", C => X"F"),
        9      => (D => X"55AA55AA", C => X"F"),
        10     => (D => X"AA55AA55", C => X"F"),
        11     => (D => X"55AA55AA", C => X"F"),
        12     => (D => X"AA55AA55", C => X"F"),
        13     => (D => X"55AA55AA", C => X"F"),
        14     => (D => X"AA55AA55", C => X"F"),
        15     => (D => X"00000000", C => X"0"),
        16     => (D => X"00000000", C => X"0"),
        17     => (D => X"00000000", C => X"0"),
        18     => (D => X"00000000", C => X"0"),
        19     => (D => X"00000000", C => X"0"),
        20     => (D => X"00000000", C => X"0"),
        21     => (D => X"00000000", C => X"0"),
        22     => (D => X"00000000", C => X"0"),
        23     => (D => X"00000000", C => X"0"),
        24     => (D => X"00000000", C => X"0"),
        25     => (D => X"00000000", C => X"0"),
        26     => (D => X"00000000", C => X"0"),
        27     => (D => X"00000000", C => X"0"),
        28     => (D => X"00000000", C => X"0"),
        29     => (D => X"00000000", C => X"0"),
        30     => (D => X"00000000", C => X"0"),
        31     => (D => X"00000000", C => X"0")),
        LAST_QUAD_DATA_COLUMN_INDEX => 14,
      ERROR => false),
    4          => (                     -- Pause Frame

      COLUMNS  => (
        0      => (D => X"00000000", C => X"F"),
        1      => (D => X"80010000", C => X"F"),
        2      => (D => X"010000c2", C => X"F"),
        3      => (D => X"01000888", C => X"F"),
        4      => (D => X"0000cdab", C => X"F"),
        5      => (D => X"00000000", C => X"F"),
        6      => (D => X"00000000", C => X"F"),
        7      => (D => X"00000000", C => X"F"),
        8      => (D => X"00000000", C => X"F"),
        9      => (D => X"00000000", C => X"F"),
        10     => (D => X"00000000", C => X"F"),
        11     => (D => X"00000000", C => X"F"),
        12     => (D => X"00000000", C => X"F"),
        13     => (D => X"00000000", C => X"F"),
        14     => (D => X"00000000", C => X"F"),
        15     => (D => X"00000000", C => X"0"),
        16     => (D => X"00000000", C => X"0"),
        17     => (D => X"00000000", C => X"0"),
        18     => (D => X"00000000", C => X"0"),
        19     => (D => X"00000000", C => X"0"),
        20     => (D => X"00000000", C => X"0"),
        21     => (D => X"00000000", C => X"0"),
        22     => (D => X"00000000", C => X"0"),
        23     => (D => X"00000000", C => X"0"),
        24     => (D => X"00000000", C => X"0"),
        25     => (D => X"00000000", C => X"0"),
        26     => (D => X"00000000", C => X"0"),
        27     => (D => X"00000000", C => X"0"),
        28     => (D => X"00000000", C => X"0"),
        29     => (D => X"00000000", C => X"0"),
        30     => (D => X"00000000", C => X"0"),
        31     => (D => X"00000000", C => X"0")),
        LAST_QUAD_DATA_COLUMN_INDEX => 14,
      ERROR => false)
   );

        
   ------------------------------------------------------------------------------
   -- CRC engine
   ------------------------------------------------------------------------------
   function calc_crc (
      size                             : in integer;
      data_in                          : in std_logic_vector;
      fcs                              : in std_logic_vector)
   return std_logic_vector is
    
      variable crc                     : std_logic_vector(31 downto 0);
      variable crc_feedback            : std_logic;
    
      type array_type is array (0 to 3) of std_logic_vector(7 downto 0); 
      variable data                    : array_type;
   
   begin
      if size > 0 then
         data(0)                       := data_in(7 downto 0);
      end if;
      if size > 1 then
         data(1)                       := data_in(15 downto 8);
      end if;
      if size > 2 then
         data(2)                       := data_in(23 downto 16);
      end if;
      if size > 3 then
         data(3)                       := data_in(31 downto 24);
      end if;
    
      crc := not fcs;
      for J in 0 to size - 1 loop
         for I in 0 to 7 loop
            crc_feedback               := crc(0) xor data(J)(I);

            crc(4 downto 0)            := crc(5 downto 1);
            crc(5)                     := crc(6)  xor crc_feedback;
            crc(7 downto 6)            := crc(8 downto 7);
            crc(8)                     := crc(9)  xor crc_feedback;
            crc(9)                     := crc(10) xor crc_feedback;
            crc(14 downto 10)          := crc(15 downto 11);
            crc(15)                    := crc(16) xor crc_feedback;
            crc(18 downto 16)          := crc(19 downto 17);
            crc(19)                    := crc(20) xor crc_feedback;
            crc(20)                    := crc(21) xor crc_feedback;
            crc(21)                    := crc(22) xor crc_feedback;
            crc(22)                    := crc(23);
            crc(23)                    := crc(24) xor crc_feedback;
            crc(24)                    := crc(25) xor crc_feedback;
            crc(25)                    := crc(26);
            crc(26)                    := crc(27) xor crc_feedback;
            crc(27)                    := crc(28) xor crc_feedback;
            crc(28)                    := crc(29);
            crc(29)                    := crc(30) xor crc_feedback;
            crc(30)                    := crc(31) xor crc_feedback;
            crc(31)                    :=             crc_feedback;
         end loop;
      end loop;
   
   -- return the CRC result
      return not crc;
   end calc_crc;
  
   -- DUT signals
   signal reset                       : std_logic := '1';    -- start in
                                       -- reset
   signal aresetn                     : std_logic;
   signal address_swap_disable        : std_logic := '0';
  
   signal tx_statistics_vector        : std_logic;

   signal rx_statistics_vector        : std_logic;
  

   signal gtx_clk                      : std_logic := '0';
   signal xgmii_tx_clk                 : std_logic;
   signal xgmii_txd                    : std_logic_vector(63 downto 0);
   signal xgmii_txc                    : std_logic_vector(7 downto 0);
   signal xgmii_rx_clk_tb              : std_logic := '0';
   signal xgmii_rx_clk                 : std_logic;
   signal xgmii_rxd_tb                 : std_logic_vector(63 downto 0) := X"0707070707070707";
   signal xgmii_rxc_tb                 : std_logic_vector(7 downto 0) := "11111111";
   signal xgmii_rxd                    : std_logic_vector(63 downto 0);
   signal xgmii_rxc                    : std_logic_vector(7 downto 0); 

   -- testbench control semaphores/signals
   signal gen_active_count             : unsigned(3 downto 0) := (others => '0');
   signal check_active_count           : unsigned(3 downto 0) := (others => '0');
   signal gen_active_flash             : std_logic;
   signal check_active_flash           : std_logic;
   signal frame_error                  : std_logic;
   signal stats_fail                   : std_logic;
   signal read_stats                   : std_logic := '0';
   signal enable_bist                  : std_logic;
   signal pause_req                    : std_logic := '0';

   signal tx_monitor_finished          : boolean := false;
   signal rx_monitor_finished          : boolean := true;
   signal tx_monitor_errors            : boolean := false;
                         
   signal simulation_finished          : boolean := false;
   signal simulation_errors            : boolean := false;
begin  -- behav
   aresetn                             <= not reset;
   -----------------------------------------------------------------------------
   -- Wire up Device Under Test
   -----------------------------------------------------------------------------
   dut: ten_gig_eth_mac_0_example_design
   port map (
      reset                            => reset,
      tx_axis_aresetn                  => aresetn,
      rx_axis_aresetn                  => aresetn,
      address_swap_disable             => address_swap_disable,
      tx_statistics_vector             => tx_statistics_vector,
      rx_statistics_vector             => rx_statistics_vector,
      reset_error                      => '0',
      insert_error                     => '0',
      enable_pat_gen                   => enable_bist,
      enable_pat_check                 => enable_bist,

      gen_active_flash                 => gen_active_flash,
      check_active_flash               => check_active_flash,
      frame_error                      => frame_error,
      
      pause_req                        => pause_req,
    
      gtx_clk                          => gtx_clk,
      xgmii_tx_clk                     => xgmii_tx_clk,
      xgmii_txd                        => xgmii_txd,
      xgmii_txc                        => xgmii_txc,
      xgmii_rx_clk                     => xgmii_rx_clk,
      xgmii_rxd                        => xgmii_rxd,
      xgmii_rxc                        => xgmii_rxc
   );

   xgmii_rxd                           <= xgmii_rxd_tb when TB_MODE = "DEMO" else xgmii_txd;
   xgmii_rxc                           <= xgmii_rxc_tb when TB_MODE = "DEMO" else xgmii_txc;
   xgmii_rx_clk                        <= xgmii_rx_clk_tb when TB_MODE = "DEMO" else xgmii_tx_clk;

  
   address_swap_disable                <= '1' when IN_BAND_FCS_PASSING;
  
   -----------------------------------------------------------------------------
   -- Clock drivers
   -----------------------------------------------------------------------------
   p_gtx_clk : process                   -- drives GTX_CLK at 156.25 MHz
   begin
      gtx_clk                          <= '0';
      loop
         wait for 3.2 ns;                  -- 156.25 MHz GTX_CLK
         gtx_clk                       <= '1';
         wait for 3.2 ns;                  -- 156.25 MHz GTX_CLK
         gtx_clk                       <= '0';
      end loop;
   end process p_gtx_clk;
   
   p_xgmii_rx_clk : process
   begin
      xgmii_rx_clk_tb                  <= '0';
      wait for 1 ns;
      loop
         wait for 3.2 ns;                  -- 156.25 MHz GTX_CLK
         xgmii_rx_clk_tb               <= '1';
         wait for 3.2 ns;                  -- 156.25 MHz GTX_CLK
         xgmii_rx_clk_tb               <= '0';
      end loop;
   end process p_xgmii_rx_clk;



   -----------------------------------------------------------------------------
   -- Transmit Monitor process. This process checks the data coming out
   -- of the transmitter to make sure that it matches that inserted
   -- into the transmitter.
   -----------------------------------------------------------------------------
   p_tx_monitor : process
      variable cached_column_valid     : boolean := false;
      variable cached_column_data      : std_logic_vector(31 downto 0);
      variable cached_column_ctrl      : std_logic_vector(3 downto 0);
      variable current_frame           : natural := 0;

      procedure get_next_column (
         variable d                    : out std_logic_vector(31 downto 0);
         variable c                    : out std_logic_vector(3 downto 0)) is
      begin  -- get_next_column
         if cached_column_valid then
            d                          := cached_column_data;
            c                          := cached_column_ctrl;
            cached_column_valid        := false;
         else
            wait until xgmii_tx_clk = '0';
            d                          := xgmii_txd(31 downto 0);
            c                          := xgmii_txc(3 downto 0);
            cached_column_data         := xgmii_txd(63 downto 32);
            cached_column_ctrl         := xgmii_txc(7 downto 4);
            cached_column_valid        := true;
         end if;
      end get_next_column;

      procedure check_frame (
         constant frame                : in frame_typ) is
       
         variable d                    : std_logic_vector(31 downto 0) := X"07070707";
         variable c                    : std_logic_vector(3 downto 0) := "1111";
         variable delayed_data         : std_logic_vector(31 downto 0);
         variable fcs                  : std_logic_vector(31 downto 0);
         variable column_index         : integer; 
         variable lane_index           : integer;
         variable frame_length         : integer;
         variable length_decrement     : integer;
      begin
         fcs                           := (others => '0');
         -- Wait for start code
         while not (d(7 downto 0) = X"FB" and c(0) = '1') loop
            get_next_column(d,c);
         end loop;
         get_next_column(d,c);             -- skip rest of preamble
         get_next_column(d,c);
         column_index                  := 0;
         frame_length                  := to_integer(unsigned(to_stdlogicvector(frame.columns(3).d(7 downto 0)) & 
                                                              to_stdlogicvector(frame.columns(3).d(15 downto 8))));
         if (frame.columns(3).d(7 downto 0) & frame.columns(3).d(15 downto 8)) = X"8808" then
            frame_length               := 60-14; 
         end if;                                                    
         length_decrement              := frame_length + 2;  -- 2 is added to include the L/T field itself 
         while c = "0000" and column_index <= 2 loop
            if column_index = 0 and address_swap_disable = '0' then
               if d /= to_stdlogicvector(frame.columns(column_index+2).d(15 downto 0)) &
                       to_stdlogicvector(frame.columns(column_index+1).d(31 downto 16)) then
                  report "Transmit fail: data mismatch at PHY interface"
                    severity error;
                  tx_monitor_errors    <= true;
                  return;
               end if;
            elsif column_index = 1 and address_swap_disable = '0' then
               if d /= to_stdlogicvector(frame.columns(column_index-1).d(15 downto 0)) &
                       to_stdlogicvector(frame.columns(column_index+1).d(31 downto 16)) then
                  report "Transmit fail: data mismatch at PHY interface"
                     severity error;
                  tx_monitor_errors    <= true;
                  return;
               end if;
            elsif column_index = 2 and address_swap_disable = '0' then
               if d /= to_stdlogicvector(frame.columns(column_index-1).d(15 downto 0)) &
                       to_stdlogicvector(frame.columns(column_index-2).d(31 downto 16)) then
                  report "Transmit fail: data mismatch at PHY interface"
                     severity error;
                  tx_monitor_errors    <= true;
                  return;
               end if;
            end if;
            if column_index > 0 then
               fcs                     := calc_crc(4,delayed_data, fcs);
            end if;
            delayed_data               := d;
            column_index               := column_index + 1;
            get_next_column(d,c);
         end loop;
         if frame_length >= MIN_FRAME_DATA_BYTES - OVERHEAD then    -- no padding is done by the core
            while c = "0000" loop
               if column_index /= 3 then     -- to avoid duplicated address swap check 
                  if delayed_data /= to_stdlogicvector(frame.columns(column_index-1).d)  then
                     report "Transmit fail: data mismatch at PHY interface here 0"
                        severity error;
                     tx_monitor_errors <= true;
                     return;
                  end if;
               end if;
               fcs                     := calc_crc(4,delayed_data, fcs);
               delayed_data := d;
               get_next_column(d,c);
               if column_index >= frame.last_quad_data_column_index then
                  if delayed_data /= to_stdlogicvector(frame.columns(column_index).d) then
                     report "Transmit fail: data mismatch at PHY interface here 1"
                        severity error;
                     tx_monitor_errors <= true;
                     return;
                  end if;  
                  column_index         := 3;
               else
                  column_index         := column_index + 1;
               end if;
            end loop; 
         else       -- if (frame_length < `MIN_FRAME_DATA_BYTES - `OVERHEAD) 0 padding is inserted by the core on tx 
            while c = "0000" and length_decrement >= 4 loop
               if column_index /= 3 then     -- to avoid duplicated address swap check 
                  if delayed_data /= to_stdlogicvector(frame.columns(column_index-1).d)  then
                     report "Transmit fail: data mismatch at PHY interface"
                        severity error;
                     tx_monitor_errors <= true;
                     return;
                  end if;
               end if;
               if length_decrement = 4 then
                  if d /= to_stdlogicvector(frame.columns(column_index).d)  then
                     report "Transmit fail: data mismatch at PHY interface"
                        severity error;
                     tx_monitor_errors <= true;
                     return;
                  end if;
                  column_index         := 3;
               end if;
               fcs                     := calc_crc(4,delayed_data, fcs);
               delayed_data := d;
               if column_index >= frame.last_quad_data_column_index then
                  if d /= to_stdlogicvector(frame.columns(column_index).d) then
                     report "Transmit fail: data mismatch at PHY interface"
                        severity error;
                     tx_monitor_errors <= true;
                     return;
                  end if;  
                  column_index         := 3;
               else
                  column_index         := column_index + 1;
               end if;
               get_next_column(d,c);
               length_decrement        := length_decrement - 4;
            end loop;
            if c = "0000" and length_decrement <= 3 and length_decrement /= 0 then
               if length_decrement = 3 then
                  if delayed_data /= to_stdlogicvector(frame.columns(column_index-1).d)  then
                     report "Transmit fail: data mismatch at PHY interface"
                        severity error;
                     tx_monitor_errors <= true;
                     return;
                  end if;
                  if d(23 downto 0) /= to_stdlogicvector(frame.columns(column_index).d(23 downto 0))  then
                     report "Transmit fail: data mismatch at PHY interface"
                        severity error;
                     tx_monitor_errors <= true;
                     return;
                  end if;  
                  fcs                  := calc_crc(4,delayed_data, fcs);
                  delayed_data         := d;
                  column_index         := column_index + 1;   
                  get_next_column(d,c);   
                  length_decrement     := 0;        
               elsif length_decrement = 2 then
                  if delayed_data /= to_stdlogicvector(frame.columns(column_index-1).d)  then
                     report "Transmit fail: data mismatch at PHY interface"
                        severity error;
                     tx_monitor_errors <= true;
                     return;
                  end if;
                  if d(15 downto 0) /= to_stdlogicvector(frame.columns(column_index).d(15 downto 0))  then
                     report "Transmit fail: data mismatch at PHY interface"
                        severity error;
                     tx_monitor_errors <= true;
                     return;
                  end if;  
                  fcs                  := calc_crc(4,delayed_data, fcs);
                  delayed_data         := d;
                  column_index         := column_index + 1;   
                  get_next_column(d,c);   
                  length_decrement     := 0;     
               elsif length_decrement = 1 then
                  if delayed_data /= to_stdlogicvector(frame.columns(column_index-1).d)  then
                     report "Transmit fail: data mismatch at PHY interface"
                        severity error;
                     tx_monitor_errors <= true;
                     return;
                  end if;
                  if d(7 downto 0) /= to_stdlogicvector(frame.columns(column_index).d(7 downto 0))  then
                     report "Transmit fail: data mismatch at PHY interface"
                        severity error;
                     tx_monitor_errors <= true;
                     return;
                  end if;  
                  fcs                  := calc_crc(4,delayed_data, fcs);
                  delayed_data         := d;
                  column_index         := column_index + 1;   
                  get_next_column(d,c);   
                  length_decrement     := 0;     
               end if;
            end if;
            while c = "0000" and length_decrement = 0 loop
               fcs                     := calc_crc(4,delayed_data, fcs);
               delayed_data            := d;
               get_next_column(d,c);
            end loop;
         end if;
         if c = "1000" then
            if delayed_data(23 downto 0) /= to_stdlogicvector(frame.columns(frame.last_quad_data_column_index + 1).d(23 downto 0))  then
               report "Transmit fail: data mismatch at PHY interface"
                  severity error;
               tx_monitor_errors       <= true;
               return;
            end if;
            d(23 downto 0)             := not d(23 downto 0);
            fcs                        := calc_crc(3,delayed_data(23 downto 0), fcs);
            delayed_data(7 downto 0)   := not delayed_data(31 downto 24);
            fcs                        := calc_crc(1,delayed_data(7 downto 0), fcs);
            fcs                        := calc_crc(3,d(23 downto 0), fcs);
         elsif c = "1100" then
            if delayed_data(15 downto 0) /= to_stdlogicvector(frame.columns(frame.last_quad_data_column_index + 1).d(15 downto 0))  then
               report "Transmit fail: data mismatch at PHY interface"
                  severity error;
               tx_monitor_errors       <= true;
               return;
            end if;
            d(15 downto 0)             := not d(15 downto 0);
            fcs                        := calc_crc(2,delayed_data(15 downto 0), fcs);
            delayed_data(15 downto 0)  := not delayed_data(31 downto 16);
            fcs                        := calc_crc(2,delayed_data(15 downto 0), fcs);
            fcs                        := calc_crc(2,d(15 downto 0), fcs);
         elsif c = "1110" then
            if delayed_data(7 downto 0) /= to_stdlogicvector(frame.columns(frame.last_quad_data_column_index + 1).d(7 downto 0))  then
               report "Transmit fail: data mismatch at PHY interface"
                  severity error;
               tx_monitor_errors       <= true;
               return;
            end if;
            d(7 downto 0)              := not d(7 downto 0);
            fcs                        := calc_crc(1,delayed_data(7 downto 0), fcs);
            delayed_data(23 downto 0)  := not delayed_data(31 downto 8);
            fcs                        := calc_crc(3,delayed_data(23 downto 0), fcs);
            fcs                        := calc_crc(1,d(7 downto 0), fcs);
         elsif c = "1111" then
            delayed_data               := not delayed_data;
            fcs                        := calc_crc(4,delayed_data, fcs);
         end if;
         if fcs /= X"FFFFFFFF" then
            report "Transmit fail: CRC mismatch at PHY interface"
               severity error;
            tx_monitor_errors          <= true;
            return;
         end if;
         report "Transmitter: Frame completed at PHY interface"
           severity note;
      end check_frame;

   begin
      if TB_MODE = "DEMO" then
         for i in frame_data'low to 3 loop
            if not frame_data(i).error then
               check_frame(frame_data(i));
            end if;
         end loop;  -- i
      end if;
      tx_monitor_finished              <= true;
      if TB_MODE = "DEMO" then
         -- should see a pause frame after monitor finished - need to check content
         -- this is a hard coded frame so can use a very simple monitor
         check_frame(frame_data(4));
      end if;
      wait;
   end process p_tx_monitor;


   -----------------------------------------------------------------------------
   -- Receive Stimulus process. This process pushes frames of data through the
   --  receiver side of the core
   -----------------------------------------------------------------------------
   p_rx_stimulus : process
      variable cached_column_valid     : boolean := false;
      variable cached_column_data      : std_logic_vector(31 downto 0);
      variable cached_column_ctrl      : std_logic_vector(3 downto 0);

      procedure send_column (
         constant d                    : in std_logic_vector(31 downto 0);
         constant c                    : in std_logic_vector(3 downto 0)) is
      begin  -- send_column
         if cached_column_valid then
            wait until xgmii_rx_clk_tb = '1';
            wait for 3.4 ns;
            xgmii_rxd_tb(31 downto 0)  <= cached_column_data;
            xgmii_rxc_tb(3 downto 0)   <= cached_column_ctrl;
            xgmii_rxd_tb(63 downto 32) <= d;
            xgmii_rxc_tb(7 downto 4)   <= c;
            cached_column_valid        := false;
         else
            cached_column_data         := d;
            cached_column_ctrl         := c;
            cached_column_valid        := true;
         end if;
      end send_column;

      procedure send_column (
         constant c                    : in column_typ) is
      begin  -- send_column
         send_column(to_stdlogicvector(c.d),
                     not to_stdlogicvector(c.c));  -- invert "data_valid" sense
      end send_column;

      procedure send_idle is
      begin  -- send_idle
         send_column(X"07070707", "1111");
      end send_idle;

      procedure send_frame (
         constant frame                : in frame_typ) is
       
         variable column_index         : integer;
         variable lane_index           : integer;
         variable byte_count           : integer;
         variable scratch_column       : column_typ;
         variable fcs,rx_crc           : std_logic_vector(31 downto 0);
       
      begin  -- send_frame
         column_index                  := 0;
         lane_index                    := 0;
         byte_count                    := 0;
        
         fcs                           := (others => '0');
         rx_crc                        := (others => '0');
        
         -- send first lane of preamble
         send_column(X"555555FB", "0001");
         -- send second lane of preamble
         send_column(X"D5555555", "0000");
         while frame.columns(column_index).c = "1111" and column_index < 3 loop
            send_column(frame.columns(column_index));
            fcs                        := calc_crc(4,to_stdlogicvector(frame.columns(column_index).d), fcs);
            column_index               := column_index + 1;
            byte_count                 := byte_count + 4;
         end loop;
      
         -- send 32-bit data word blocks after DA/SA
         -- eg. if column[14] == X"F" then the block size is (14 + 1) - 3 = 12
         -- that means that 12 * 4 = 48 bytes are contained in one block
         -- If `FRAME_GEN_MULTIPLIER is set to 2 then 2*12*4 = 96 bytes are sent after DA/SA
         -- It also means that the same 48 byte will be sent 2 times.
         -- In order to get correct frames through the TYPE/LENGTH field is to be set to 94 in this case
         -- the general formula for LENGTH/TYPE field is as follows:
         -- [[(index of last complete ctrl column + 1) - 3] * 4 * FRAME_GEN_MULTIPLIER ]- 2 + 
         -- (0,1,2 or 3 depending from the value of the ctrl column after the last complete ctrl column)
                
         for I in 1 to FRAME_GEN_MULTIPLIER loop    --send bytes after frame byte 3 multiple times 
            column_index               := 3;
            while frame.columns(column_index).c = "1111" loop
               send_column(frame.columns(column_index));
               fcs                     := calc_crc(4,to_stdlogicvector(frame.columns(column_index).d), fcs);
               column_index            := column_index + 1;
               byte_count              := byte_count + 4;
            end loop;
         end loop;
         if frame.columns(column_index).c = "0111" then
            fcs                        := calc_crc(3,to_stdlogicvector(frame.columns(column_index).d), fcs);
         elsif frame.columns(column_index).c = "0011" then   
            fcs                        := calc_crc(2,to_stdlogicvector(frame.columns(column_index).d), fcs);
         elsif frame.columns(column_index).c = "0001" then    
            fcs                        := calc_crc(1,to_stdlogicvector(frame.columns(column_index).d), fcs);
         end if;
          
         -- send DATA bytes that are in last partial column
         while frame.columns(column_index).c(lane_index) = '1' loop
            scratch_column.d(lane_index*8+7 downto lane_index*8) := frame.columns(column_index).d(lane_index*8+7 downto lane_index*8);
            scratch_column.c(lane_index) := '1';
            lane_index                 := lane_index + 1;
            byte_count                 := byte_count + 1;
         end loop;
      
         -- reorder crc format  
         rx_crc                        := fcs(7 downto 0) & fcs(15 downto 8) &   
                                          fcs(23 downto 16) & fcs(31 downto 24);
  
          -- send the crc
         for i in 3 downto 0 loop
            if lane_index = 4 then
               send_column(scratch_column);
               lane_index              := 0;
            end if;
            scratch_column.d(lane_index*8+7 downto lane_index*8) := to_bitvector(rx_crc(i*8+7 downto i*8));
            scratch_column.c(lane_index) := '1';
            lane_index                 := lane_index + 1;
         end loop;  -- i
         -- send the terminate/error column
         if lane_index = 4 then
            send_column(scratch_column);
            lane_index                 := 0;
         end if;
         -- send error code
         if frame.error then
            scratch_column.d(lane_index*8+7 downto lane_index*8) := X"FE";
            scratch_column.c(lane_index) := '0';
         else
         -- send terminate code
            scratch_column.d(lane_index*8+7 downto lane_index*8) := X"FD";
            scratch_column.c(lane_index) := '0';
         end if;
         lane_index                    := lane_index + 1;
         -- send idles
         while lane_index < 4 loop
            scratch_column.d(lane_index*8+7 downto lane_index*8) := X"07";
            scratch_column.c(lane_index) := '0';
            lane_index                 := lane_index + 1;
         end loop;
         send_column(scratch_column);
         assert false
            report "Receiver: frame inserted into PHY interface"
            severity note;
            
      end send_frame; 

   begin
      if TB_MODE = "DEMO" then
         assert false
            report "Timing checks are not valid"
            severity note;
         while reset = '1' loop
            send_idle;
         end loop;
         -- wait for DCMs to lock
         for i in 1 to 175 loop
            send_idle;
         end loop;
         assert false
            report "Timing checks are valid"
            severity note;

         for i in frame_data'low to 3 loop
            send_frame(frame_data(i));
            send_idle;
            send_idle;
         end loop;  -- i
      end if; 
      while true loop
         send_idle;
      end loop;
   end process p_rx_stimulus;


   p_reset : process
   begin
      if TB_MODE = "DEMO" then
         enable_bist                   <= '0';
      else
         enable_bist                   <= '1';
      end if;
      -- reset the core
      assert false
         report "Resetting core..."
         severity note;
         reset                         <= '1';
      wait for 200 ns;
         reset                         <= '0';
      wait;
   end process p_reset;

   simulation_finished <=
      tx_monitor_finished;

   simulation_errors <=
      tx_monitor_errors;


   p_end_simulation : process
   begin
      if TB_MODE = "DEMO" then
         wait until simulation_finished for 10 us;
         assert simulation_finished
            report "ERROR: Testbench timed out."
            severity note;
         assert not (simulation_finished and simulation_errors)
            report "Test completed with errors"
            severity note;
         assert not (simulation_finished and not simulation_errors)
            report "Test completed successfully."
            severity note;
      else
         wait for 10 us;
         assert gen_active_count /= "0000" and check_active_count /= "0000" and frame_error = '0'
            report "Test completed with errors"
            severity note;
         assert not (gen_active_count /= "0000" and check_active_count /= "0000" and frame_error = '0')
            report "Test completed successfully."
            severity note;
      end if;
      
      report "Simulation stopped."
         severity failure;
   end process p_end_simulation;
   
   process (gen_active_flash)
   begin
      if gen_active_flash'event and gen_active_flash = '1' then
         if gen_active_count /= "1111" then
            gen_active_count           <= gen_active_count + "0001";
         end if;
      end if;
   end process;

   process (check_active_flash)
   begin
      if check_active_flash'event and check_active_flash = '1' then
         if gen_active_count /= "1111" then
            check_active_count         <= check_active_count + "0001";
         end if;
      end if;
   end process;

end behav;
