-------------------------------------------------------------------------------
-- File       : ten_gig_eth_mac_0_example_design.vhd
-- Author     : Xilinx Inc.
-------------------------------------------------------------------------------
-- Description: This is the example design level vhdl code for the
-- Ten Gigabit Ethernet MAC. It contains the FIFO block level instance and
-- Transmit clock generation.  Dependent on configuration options, it  may
-- also contain the address swap module for cores with both Transmit and
-- Receive.
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
use ieee.numeric_std.all;

entity ten_gig_eth_mac_0_example_design is
port(
   ---------------------------------------------------------------------------
   -- Interface to the management block.
   ---------------------------------------------------------------------------
   reset                               : in  std_logic;                       -- Resets the MAC.
   tx_axis_aresetn                     : in  std_logic;
   rx_axis_aresetn                     : in  std_logic;
   tx_statistics_vector                : out std_logic;                       -- Statistics information on the last frame.
   rx_statistics_vector                : out std_logic;                       -- Statistics info on the last received frame.
   gen_active_flash                    : out std_logic;
   check_active_flash                  : out std_logic;
   frame_error                         : out std_logic;


    user_clk                         : out std_logic;
    rx_axis_fifo_tdata               : out std_logic_vector(63 downto 0);
    rx_axis_fifo_tkeep               : out std_logic_vector(7 downto 0);
    rx_axis_fifo_tvalid              : out std_logic;
    rx_axis_fifo_tlast               : out std_logic;
    rx_axis_fifo_tready              : in  std_logic;

    tx_axis_fifo_tdata               : in  std_logic_vector(63 downto 0);
    tx_axis_fifo_tkeep               : in  std_logic_vector(7 downto 0);
    tx_axis_fifo_tvalid              : in  std_logic;
    tx_axis_fifo_tlast               : in  std_logic;
    tx_axis_fifo_ready              : out std_logic;
   
   
   pause_req                           : in  std_logic;
   pause_val                           : in  std_logic_vector(15 downto 0);
   	
   status_vector       : out std_logic_vector(2 downto 0);
   tx_fifo_full        : out std_logic;
   tx_fifo_status      : out std_logic_vector(3 downto 0);
   tx_axis_mac_tready  : out std_logic;

   gtx_clk                             : in  std_logic;                       -- The global transmit clock from the outside world.
   xgmii_tx_clk                        : out std_logic;                       -- the TX clock from the reconcilliation sublayer.
   xgmii_txd                           : out std_logic_vector(63 downto 0);   -- Transmitted data
   xgmii_txc                           : out std_logic_vector(7 downto 0);    -- Transmitted control
   xgmii_rx_clk                        : in  std_logic;                       -- The rx clock from the PHY layer.
   xgmii_rxd                           : in  std_logic_vector(63 downto 0);   -- Received data
   xgmii_rxc                           : in  std_logic_vector(7 downto 0)     -- received control
);
end ten_gig_eth_mac_0_example_design;

library unisim;
use unisim.vcomponents.all;

architecture wrapper of ten_gig_eth_mac_0_example_design is
   attribute DowngradeIPIdentifiedWarnings : string;
   attribute DowngradeIPIdentifiedWarnings of wrapper : architecture is "yes";

   -----------------------------------------------------------------------------
   -- Component Declarations
   -----------------------------------------------------------------------------
   component ten_gig_eth_mac_0_fifo_block
   generic (
      FIFO_SIZE                        : integer := 512);
   port (
      tx_clk0                          : in  std_logic;
      reset                            : in  std_logic;
      
      tx_fifo_full        : out std_logic;
      tx_fifo_status      : out std_logic_vector (3 downto 0);
      tx_axis_mac_tready_StateOut  : out std_logic;

      rx_axis_fifo_aresetn             : in  std_logic;
      rx_axis_mac_aresetn              : in  std_logic;
      rx_axis_fifo_tdata               : out std_logic_vector(63 downto 0);
      rx_axis_fifo_tkeep               : out std_logic_vector(7 downto 0);
      rx_axis_fifo_tvalid              : out std_logic;
      rx_axis_fifo_tlast               : out std_logic;
      rx_axis_fifo_tready              : in  std_logic;
      tx_axis_fifo_aresetn             : in  std_logic;
      tx_axis_mac_aresetn              : in std_logic;
      tx_axis_fifo_tdata               : in  std_logic_vector(63 downto 0);
      tx_axis_fifo_tkeep               : in  std_logic_vector(7 downto 0);
      tx_axis_fifo_tvalid              : in  std_logic;
      tx_axis_fifo_tlast               : in  std_logic;
      tx_axis_fifo_tready              : out std_logic;
      tx_ifg_delay                     : in   std_logic_vector(7 downto 0);
      tx_statistics_vector             : out std_logic_vector(25 downto 0);
      tx_statistics_valid              : out std_logic;
      pause_val                        : in  std_logic_vector(15 downto 0);
      pause_req                        : in  std_logic;
      rx_statistics_vector             : out std_logic_vector(29 downto 0);
      rx_statistics_valid              : out std_logic;
      tx_configuration_vector          : in std_logic_vector(79 downto 0);
      rx_configuration_vector          : in std_logic_vector(79 downto 0);
      status_vector                    : out std_logic_vector(2 downto 0);
      tx_dcm_locked                    : in std_logic;
      xgmii_txd                        : out std_logic_vector(63 downto 0); -- Transmitted data
      xgmii_txc                        : out std_logic_vector(7 downto 0);  -- Transmitted control
      rx_clk0                          : in std_logic;
      rx_dcm_locked                    : in std_logic;
      xgmii_rxd                        : in  std_logic_vector(63 downto 0); -- Received data
      xgmii_rxc                        : in  std_logic_vector(7 downto 0)   -- received control
  );
   end component;

   component ten_gig_eth_mac_0_physical_if
   port (
      reset                            : in std_logic;
      rx_axis_rstn                     : in std_logic;
      tx_clk0                          : in  std_logic;
      tx_dcm_locked                    : in  std_logic;
      xgmii_txd_core                   : in std_logic_vector(63 downto 0);
      xgmii_txc_core                   : in std_logic_vector(7 downto 0);
      xgmii_txd                        : out std_logic_vector(63 downto 0);
      xgmii_txc                        : out std_logic_vector(7 downto 0);
      xgmii_tx_clk                     : out std_logic;
      rx_clk0                          : out  std_logic;
      rx_dcm_locked                    : out std_logic;
      xgmii_rx_clk                     : in  std_logic;
      xgmii_rxd                        : in  std_logic_vector(63 downto 0);
      xgmii_rxc                        : in  std_logic_vector(7 downto 0);
      xgmii_rxd_core                   : out  std_logic_vector(63 downto 0);
      xgmii_rxc_core                   : out  std_logic_vector(7 downto 0)
   );
   end component;

   component ten_gig_eth_mac_0_clocking
   port (
      -- inputs
      gtx_clk_in                       : in  std_logic; -- TX clock input
      tx_mmcm_reset                    : in  std_logic; -- reset for MMCM

      -- clock outputs
      tx_clk0                          : out std_logic; -- TX system clock

      -- status outputs
      tx_mmcm_locked                   : out std_logic);
   end component;


   component ten_gig_eth_mac_0_gen_check_wrapper
   port (
      dest_addr                        : in  std_logic_vector(47 downto 0);
      src_addr                         : in  std_logic_vector(47 downto 0);
      max_size                         : in  unsigned(14 downto 0);
      min_size                         : in  unsigned(14 downto 0);
      enable_vlan                      : in  std_logic;
      vlan_id                          : in  std_logic_vector(11 downto 0);
      vlan_priority                    : in  std_logic_vector(2 downto 0);
      preamble_data                    : in  std_logic_vector(55 downto 0);
      enable_custom_preamble           : in  std_logic;

      aclk                             : in  std_logic;
      areset                           : in  std_logic;
      reset_error                      : in  std_logic;
      insert_error                     : in  std_logic;
      enable_pat_gen                   : in  std_logic;
      enable_pat_check                 : in  std_logic;

      -- data from the RX data path
      rx_axis_tdata                    : in  std_logic_vector(63 downto 0);
      rx_axis_tkeep                    : in  std_logic_vector(7 downto 0);
      rx_axis_tvalid                   : in  std_logic;
      rx_axis_tlast                    : in  std_logic;
      rx_axis_tready                   : out std_logic;

      -- data to the TX data path
      tx_axis_tdata                    : out std_logic_vector(63 downto 0);
      tx_axis_tkeep                    : out std_logic_vector(7 downto 0);
      tx_axis_tvalid                   : out std_logic;
      tx_axis_tlast                    : out std_logic;
      tx_axis_tready                   : in  std_logic;

      gen_active_flash                 : out std_logic;
      check_active_flash               : out std_logic;
      frame_error                      : out std_logic
   );
   end component;

   component ten_gig_eth_mac_0_config_vector_sm is
   port (
      gtx_clk                          : in  std_logic;
      gtx_reset                        : in  std_logic;

      enable_vlan                      : in  std_logic;
      enable_custom_preamble           : in  std_logic;

      rx_configuration_vector          : out std_logic_vector(79 downto 0);
      tx_configuration_vector          : out std_logic_vector(79 downto 0)
   );
   end component;

   component ten_gig_eth_mac_0_sync_reset is
   port (
      reset_in                         : in  std_logic;
      clk                              : in  std_logic;
      reset_out                        : out std_logic
   );
   end component;

   constant FIFO_SIZE                  : integer := 1024;

  -----------------------------------------------------------------------------
  -- Internal Signal Declaration for XGMAC (the 10Gb/E MAC core).
  -----------------------------------------------------------------------------

   attribute keep : string;
   signal tx_dcm_locked                : std_logic;

   signal tx_clk0                      : std_logic;  -- transmit clock on global routing

   signal rx_clk_int                   : std_logic;
   signal rx_dcm_locked                : std_logic;
   signal tx_configuration_vector_core : std_logic_vector(79 downto 0);
   signal rx_configuration_vector_core : std_logic_vector(79 downto 0);


   signal  rx_axis_fifo_tdataWire               :  std_logic_vector(63 downto 0);
   signal  rx_axis_fifo_tkeepWire               :  std_logic_vector(7 downto 0);
   signal  rx_axis_fifo_tvalidWire              :  std_logic;
   signal  rx_axis_fifo_tlastWire                :  std_logic;


--   signal rx_axis_fifo_tdata           : std_logic_vector(63 downto 0);
--   signal rx_axis_fifo_tkeep           : std_logic_vector(7 downto 0);
--   signal rx_axis_fifo_tvalid          : std_logic;
--   signal rx_axis_fifo_tlast           : std_logic;
--   signal rx_axis_fifo_tready          : std_logic;
   signal rx_statistics_vector_int     : std_logic_vector(29 downto 0) := (others => '0');
   signal rx_statistics_valid_int      : std_logic := '0';
   signal rx_statistics_valid          : std_logic := '0';
   signal rx_statistics_shift          : std_logic_vector(31 downto 0) := (others => '0');

   signal tx_statistics_vector_int     : std_logic_vector(25 downto 0) := (others => '0');
   signal tx_statistics_valid_int      : std_logic := '0';
   signal tx_statistics_valid          : std_logic := '0';
   signal tx_statistics_shift          : std_logic_vector(27 downto 0) := (others => '0');
--   signal tx_axis_fifo_tdata           : std_logic_vector(63 downto 0);
--   signal tx_axis_fifo_tkeep           : std_logic_vector(7 downto 0);
--   signal tx_axis_fifo_tvalid          : std_logic;
--   signal tx_axis_fifo_tlast           : std_logic;
--   signal tx_axis_fifo_ready           : std_logic;
   signal tx_reset                     : std_logic;
   signal rx_reset                     : std_logic;
   signal xgmii_txd_core               : std_logic_vector(63 downto 0);
   signal xgmii_txc_core               : std_logic_vector(7 downto 0);
   signal xgmii_rxd_core               : std_logic_vector(63 downto 0);
   signal xgmii_rxc_core               : std_logic_vector(7 downto 0);
   signal gtx_reset                    : std_logic;
   -- change this tie off to alter the mode
   signal enable_vlan                  : std_logic := '1';
   signal enable_custom_preamble       : std_logic := '0';

begin
   tx_reset                            <= reset or not tx_axis_aresetn;
   rx_reset                            <= reset or not rx_axis_aresetn;


   ------------------------------
   -- Instantiate the XGMAC core
   ------------------------------
   fifo_block_i : ten_gig_eth_mac_0_fifo_block
   generic map (
      FIFO_SIZE                        => FIFO_SIZE)
   port map (
      tx_clk0                          => tx_clk0,
      reset                              => reset,
      
      tx_fifo_full        => tx_fifo_full,
      tx_fifo_status      => tx_fifo_status,
      tx_axis_mac_tready_StateOut  => tx_axis_mac_tready,

    
      rx_axis_mac_aresetn              => rx_axis_aresetn,
      rx_axis_fifo_aresetn             => rx_axis_aresetn,
      rx_axis_fifo_tdata               => rx_axis_fifo_tdataWire,
      rx_axis_fifo_tkeep               => rx_axis_fifo_tkeepWire,
      rx_axis_fifo_tvalid              => rx_axis_fifo_tvalidWire,
      rx_axis_fifo_tlast               => rx_axis_fifo_tlastWire,
      rx_axis_fifo_tready              => rx_axis_fifo_tready,
      tx_axis_mac_aresetn              => tx_axis_aresetn,
      tx_axis_fifo_aresetn             => tx_axis_aresetn,
      tx_axis_fifo_tdata               => tx_axis_fifo_tdata,
      tx_axis_fifo_tkeep               => tx_axis_fifo_tkeep,
      tx_axis_fifo_tvalid              => tx_axis_fifo_tvalid,
      tx_axis_fifo_tlast               => tx_axis_fifo_tlast,
      tx_axis_fifo_tready              => tx_axis_fifo_ready,
      pause_val                        => pause_val,
      pause_req                        => pause_req,
      tx_ifg_delay                     => X"00",
      tx_statistics_vector             => tx_statistics_vector_int,
      tx_statistics_valid              => tx_statistics_valid_int,
      rx_statistics_vector             => rx_statistics_vector_int,
      rx_statistics_valid              => rx_statistics_valid_int,
      tx_configuration_vector          => tx_configuration_vector_core,
      rx_configuration_vector          => rx_configuration_vector_core,
      status_vector                    => status_vector,
      tx_dcm_locked                    => tx_dcm_locked,
      xgmii_txd                        => xgmii_txd_core,
      xgmii_txc                        => xgmii_txc_core,
      rx_clk0                          => rx_clk_int,
      rx_dcm_locked                    => rx_dcm_locked,
      xgmii_rxd                        => xgmii_rxd_core,
      xgmii_rxc                        => xgmii_rxc_core);

    user_clk <= rx_clk_int;

    rx_axis_fifo_tdata  <=  rx_axis_fifo_tdataWire;
    rx_axis_fifo_tkeep  <=  rx_axis_fifo_tkeepWire;
    rx_axis_fifo_tvalid <=  rx_axis_fifo_tvalidWire;
    rx_axis_fifo_tlast  <=  rx_axis_fifo_tlastWire;

   -----------------------------------------------------------------------------
   -- Instantiation of 64-bit XGMII Interface
   -----------------------------------------------------------------------------
   xgmac_phy_if : ten_gig_eth_mac_0_physical_if
   port map (
      reset                            => reset,
      rx_axis_rstn                     => rx_axis_aresetn,
      tx_clk0                          => tx_clk0,
      tx_dcm_locked                    => tx_dcm_locked,
      xgmii_txd_core                   => xgmii_txd_core,
      xgmii_txc_core                   => xgmii_txc_core,
      xgmii_txd                        => xgmii_txd,
      xgmii_txc                        => xgmii_txc,
      xgmii_tx_clk                     => xgmii_tx_clk,
      rx_clk0                          => rx_clk_int,
      rx_dcm_locked                    => rx_dcm_locked,
      xgmii_rx_clk                     => xgmii_rx_clk,
      xgmii_rxd                        => xgmii_rxd,
      xgmii_rxc                        => xgmii_rxc,
      xgmii_rxd_core                   => xgmii_rxd_core,
      xgmii_rxc_core                   => xgmii_rxc_core
   );

   -- Clock management
   tx_clocking_i : ten_gig_eth_mac_0_clocking
   port map (
      gtx_clk_in                       => gtx_clk,
      tx_mmcm_reset                    => tx_reset,
      tx_clk0                          => tx_clk0,
      tx_mmcm_locked                   => tx_dcm_locked
   );


--   pat_gen : ten_gig_eth_mac_0_gen_check_wrapper
--   port map (
--      dest_addr                        => X"0504030201DA",
--      src_addr                         => X"05040302015A",
--      max_size                         => "000000011001000",
--      min_size                         => "000000001000000",
--      enable_vlan                      => enable_vlan,
--      vlan_id                          => X"ABC",
--      vlan_priority                    => "000",
--      preamble_data                    => X"55555555555555",
--      enable_custom_preamble           => enable_custom_preamble,

--      aclk                             => rx_clk_int,
--      areset                           => rx_reset,
--      reset_error                      => reset_error,
--      insert_error                     => insert_error,
--      enable_pat_gen                   => enable_pat_gen,
--      enable_pat_check                 => enable_pat_check,

--      -- data from the RX data path
--      rx_axis_tdata                    => rx_axis_fifo_tdata,
--      rx_axis_tkeep                    => rx_axis_fifo_tkeep,
--      rx_axis_tvalid                   => rx_axis_fifo_tvalid,
--      rx_axis_tlast                    => rx_axis_fifo_tlast,
--      rx_axis_tready                   => rx_axis_fifo_tready,

--      -- data to the TX data path
--      tx_axis_tdata                    => tx_axis_fifo_tdata,
--      tx_axis_tkeep                    => tx_axis_fifo_tkeep,
--      tx_axis_tvalid                   => tx_axis_fifo_tvalid,
--      tx_axis_tlast                    => tx_axis_fifo_tlast,
--      tx_axis_tready                   => tx_axis_fifo_ready,

--      gen_active_flash                 => gen_active_flash,
--      check_active_flash               => check_active_flash,
--      frame_error                      => frame_error
--   );


   gtx_reset_gen : ten_gig_eth_mac_0_sync_reset
   port map (
      reset_in                         => reset,
      clk                              => gtx_clk,
      reset_out                        => gtx_reset
   );

   config_vector_sm : ten_gig_eth_mac_0_config_vector_sm
   port map (
      gtx_clk                          => gtx_clk,
      gtx_reset                        => gtx_reset,

      enable_vlan                      => enable_vlan,
      enable_custom_preamble           => enable_custom_preamble,

      rx_configuration_vector          => rx_configuration_vector_core,
      tx_configuration_vector          => tx_configuration_vector_core
   );


  -- serialise the stats vector output to ensure logic isn't stripped during synthesis and to
  -- reduce the IO required by the example design
  p_tx_statistic_vector_regs : process (tx_clk0)
  begin
    if tx_clk0'event and tx_clk0 = '1' then
      tx_statistics_valid              <= tx_statistics_valid_int;
      if (tx_statistics_valid = '0' and tx_statistics_valid_int = '1') then
         tx_statistics_shift           <= "01" & tx_statistics_vector_int;
      else
         tx_statistics_shift           <= tx_statistics_shift(26 downto 0) & '0';
      end if;
    end if;
  end process p_tx_statistic_vector_regs;

  tx_statistics_vector        <= tx_statistics_shift(27);

  p_rx_statistic_vector_reg : process (rx_clk_int)
  begin
    if rx_clk_int'event and rx_clk_int = '1' then
      rx_statistics_valid              <= rx_statistics_valid_int;
      if (rx_statistics_valid = '0' and rx_statistics_valid_int = '1') then
         rx_statistics_shift           <= "01" & rx_statistics_vector_int;
      else
         rx_statistics_shift           <= rx_statistics_shift(30 downto 0) & '0';
      end if;
    end if;
  end process p_rx_statistic_vector_reg;

  rx_statistics_vector        <= rx_statistics_shift(31);

end wrapper;


