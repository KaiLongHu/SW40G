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
--------------------------------------------------------------------------------------------
-- Title      : Frame generation wrapper for 10 Gig Ethernet 
-- Project    : 10 Gigabit Ethernet Core
--------------------------------------------------------------------------------------------
-- File       : ten_gig_eth_mac_0_gen_check_wrapper.vhd
-- Author     : Xilinx Inc.
-- -----------------------------------------------------------------------------------------
-- Description: This module allows either a user side loopback, with address swapping,
--              OR the generation of simple packets.  The selection being controlled by a top level input
--              which can be sourced fdrom a DIP switch in hardware.
--              The packet generation is controlled by simple parameters giving the ability to set the DA,
--              SA amd max/min size packets.  The data portion of each packet is always a simple
--              incrementing pattern.
--              When configured to loopback the first two columns of the packet are accepted and then the
--              packet is output with/without address swapping. Currently, this is hard wired in the address
--              swap logic.
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;


entity ten_gig_eth_mac_0_gen_check_wrapper is
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
end ten_gig_eth_mac_0_gen_check_wrapper;

architecture rtl of ten_gig_eth_mac_0_gen_check_wrapper is

   ------------------------------------------------------------------------------
   -- Component Declarations
   ------------------------------------------------------------------------------
   component ten_gig_eth_mac_0_axi_pat_gen
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

      enable_pat_gen                   : in  std_logic;
      insert_error                     : in  std_logic;

      tdata                            : out std_logic_vector(63 downto 0);
      tkeep                            : out std_logic_vector(7 downto 0);
      tvalid                           : out std_logic;
      tlast                            : out std_logic;
      tready                           : in  std_logic;
      
      gen_active_flash                 : out std_logic
   );
   end component;

   component ten_gig_eth_mac_0_sync_reset is
   port (
      reset_in                         : in  std_logic; 
      clk                              : in  std_logic; 
      reset_out                        : out std_logic
   );
   end component;
    
   component ten_gig_eth_mac_0_sync_block is
   port (
      data_in                          : in  std_logic; 
      clk                              : in  std_logic; 
      data_out                         : out std_logic
   );
   end component;
    
   component ten_gig_eth_mac_0_axi_pat_check
   port (
      dest_addr                        : in  std_logic_vector(47 downto 0);
      src_addr                         : in  std_logic_vector(47 downto 0);
      max_size                         : in  unsigned(14 downto 0);
      min_size                         : in  unsigned(14 downto 0);
      enable_vlan                      : in  std_logic;
      vlan_id                          : in  std_logic_vector(11 downto 0);
      vlan_priority                    : in  std_logic_vector(2 downto 0);
      enable_custom_preamble           : in  std_logic;
      preamble_data                    : in  std_logic_vector(55 downto 0);

      aclk                             : in  std_logic;
      areset                           : in  std_logic;

      enable_pat_check                 : in  std_logic;
      reset_error                      : in  std_logic;

      tdata                            : in  std_logic_vector(63 downto 0);
      tkeep                            : in  std_logic_vector(7 downto 0);
      tvalid                           : in  std_logic;
      tlast                            : in  std_logic;
      tready                           : in  std_logic;
      tuser                            : in  std_logic;

      frame_error                      : out std_logic;
      check_active_flash               : out std_logic
   );
   end component;

   component ten_gig_eth_mac_0_address_swap
   port (
      aclk                             : in  std_logic;                    
      areset                           : in  std_logic;                    

      enable_address_swap              : in  std_logic;                    
      enable_custom_preamble           : in  std_logic;                    

      -- data from the RX FIFO
      rx_axis_tdata                    : in  std_logic_vector(63 downto 0); 
      rx_axis_tkeep                    : in  std_logic_vector(7 downto 0); 
      rx_axis_tvalid                   : in  std_logic;                    
      rx_axis_tlast                    : in  std_logic;                    
      rx_axis_tready                   : out std_logic;                    
      -- data TO the tx fifo
      tx_axis_tdata                    : out std_logic_vector(63 downto 0); 
      tx_axis_tkeep                    : out std_logic_vector(7 downto 0); 
      tx_axis_tvalid                   : out std_logic;                    
      tx_axis_tlast                    : out std_logic;                    
      tx_axis_tready                   : in std_logic                      

  );
  end component;

   component ten_gig_eth_mac_0_axi_mux
   port (
      mux_select                       : in  std_logic;

      -- mux inputs
      tdata0                           : in  std_logic_vector(63 downto 0);
      tkeep0                           : in  std_logic_vector(7 downto 0);
      tvalid0                          : in  std_logic;
      tlast0                           : in  std_logic;
      tready0                          : out std_logic;

      tdata1                           : in  std_logic_vector(63 downto 0);
      tkeep1                           : in  std_logic_vector(7 downto 0);
      tvalid1                          : in  std_logic;
      tlast1                           : in  std_logic;
      tready1                          : out std_logic;

      -- mux outputs
      tdata                            : out std_logic_vector(63 downto 0);
      tkeep                            : out std_logic_vector(7 downto 0);
      tvalid                           : out std_logic;
      tlast                            : out std_logic;
      tready                           : in  std_logic
   );
   end component;


   signal sync_reset                   : std_logic; 
   
   signal rx_axis_tdata_int            : std_logic_vector(63 downto 0);
   signal rx_axis_tkeep_int            : std_logic_vector(7 downto 0); 
   signal rx_axis_tvalid_int           : std_logic;    
   signal rx_axis_tlast_int            : std_logic;    
   signal rx_axis_tready_int           : std_logic;    

   signal pat_gen_tdata                : std_logic_vector(63 downto 0);
   signal pat_gen_tkeep                : std_logic_vector(7 downto 0); 
   signal pat_gen_tvalid               : std_logic;    
   signal pat_gen_tlast                : std_logic;    
   signal pat_gen_tready               : std_logic;    

   signal mux_tdata                    : std_logic_vector(63 downto 0);
   signal mux_tkeep                    : std_logic_vector(7 downto 0); 
   signal mux_tvalid                   : std_logic;    
   signal mux_tlast                    : std_logic;    
   signal mux_tready                   : std_logic;    

   signal tx_axis_as_tdata             : std_logic_vector(63 downto 0); 
   signal tx_axis_as_tkeep             : std_logic_vector(7 downto 0);
   signal tx_axis_as_tvalid            : std_logic;    
   signal tx_axis_as_tlast             : std_logic;    
   signal tx_axis_as_tready            : std_logic;  
     
   signal enable_address_swap          : std_logic; 
   signal enable_pat_gen_sync          : std_logic;
   signal enable_pat_check_sync        : std_logic;
   signal insert_error_sync            : std_logic;
   signal reset_error_sync             : std_logic;
    
begin

   tx_axis_tdata                       <= tx_axis_as_tdata;  
   tx_axis_tkeep                       <= tx_axis_as_tkeep;  
   tx_axis_tvalid                      <= tx_axis_as_tvalid; 
   tx_axis_tlast                       <= tx_axis_as_tlast;  
   tx_axis_as_tready                   <= tx_axis_tready; 
   rx_axis_tready                      <= rx_axis_tready_int;
   
   -- do the address swap when in loopback, no address swap when in pat_gen is enabled   
   enable_address_swap                 <= not enable_pat_gen_sync;

   rx_reset_gen :  ten_gig_eth_mac_0_sync_reset
   port map (
      reset_in                         => areset,
      clk                              => aclk,
      reset_out                        => sync_reset
   );
    
   sync_pat_gen :  ten_gig_eth_mac_0_sync_block
   port map (
      data_in                          => enable_pat_gen,
      clk                              => aclk,
      data_out                         => enable_pat_gen_sync
   );
    
   sync_pat_chk :  ten_gig_eth_mac_0_sync_block
   port map (
      data_in                          => enable_pat_check,
      clk                              => aclk,
      data_out                         => enable_pat_check_sync
   );
    
   sync_insert_error :  ten_gig_eth_mac_0_sync_block
   port map (
      data_in                          => insert_error,
      clk                              => aclk,
      data_out                         => insert_error_sync
   );
    
   sync_reset_error :  ten_gig_eth_mac_0_sync_block
   port map (
      data_in                          => reset_error,
      clk                              => aclk,
      data_out                         => reset_error_sync
   );
    
   generator : ten_gig_eth_mac_0_axi_pat_gen
   port map (
      dest_addr                        => dest_addr,
      src_addr                         => src_addr,
      max_size                         => max_size,
      min_size                         => min_size,
      enable_vlan                      => enable_vlan,
      vlan_id                          => vlan_id,
      vlan_priority                    => vlan_priority,
      preamble_data                    => preamble_data,
      enable_custom_preamble           => enable_custom_preamble,
                        
      aclk                             => aclk,
      areset                           => sync_reset,
      insert_error                     => insert_error_sync,
      enable_pat_gen                   => enable_pat_gen_sync,
                        
      tdata                            => pat_gen_tdata,
      tkeep                            => pat_gen_tkeep,
      tvalid                           => pat_gen_tvalid,
      tlast                            => pat_gen_tlast,
      tready                           => pat_gen_tready,
      gen_active_flash                 => gen_active_flash
   );
  
   -- simple mux between the rx_fifo AXI interface and the pat gen output
   axi_mux_inst : ten_gig_eth_mac_0_axi_mux 
   port map (
      mux_select                       => enable_pat_gen_sync,
                         
      tdata0                           => rx_axis_tdata,
      tkeep0                           => rx_axis_tkeep,
      tvalid0                          => rx_axis_tvalid,
      tlast0                           => rx_axis_tlast,
      tready0                          => rx_axis_tready_int,
                         
      tdata1                           => pat_gen_tdata,
      tkeep1                           => pat_gen_tkeep,
      tvalid1                          => pat_gen_tvalid,
      tlast1                           => pat_gen_tlast,
      tready1                          => pat_gen_tready,
                         
      tdata                            => mux_tdata,
      tkeep                            => mux_tkeep,
      tvalid                           => mux_tvalid,
      tlast                            => mux_tlast,
      tready                           => mux_tready
   );
  
  
   -- address swap module: based around a Dual port distributed ram
   -- data is written in and the read only starts once the da/sa have been
   -- stored.  

   address_swap  : ten_gig_eth_mac_0_address_swap 
   port map (
      aclk                             => aclk,
      areset                           => sync_reset,  
      enable_custom_preamble           => enable_custom_preamble,
      enable_address_swap              => enable_address_swap,  
                                                                
      rx_axis_tdata                    => mux_tdata,
      rx_axis_tkeep                    => mux_tkeep,
      rx_axis_tvalid                   => mux_tvalid,
      rx_axis_tlast                    => mux_tlast,
      rx_axis_tready                   => mux_tready, 
      tx_axis_tdata                    => tx_axis_as_tdata,
      tx_axis_tkeep                    => tx_axis_as_tkeep,
      tx_axis_tvalid                   => tx_axis_as_tvalid,
      tx_axis_tlast                    => tx_axis_as_tlast,
      tx_axis_tready                   => tx_axis_as_tready
   );
 
  
   checker : ten_gig_eth_mac_0_axi_pat_check
   port map (
      dest_addr                        => dest_addr,
      src_addr                         => src_addr,
      max_size                         => max_size,
      min_size                         => min_size,
      enable_vlan                      => enable_vlan,
      vlan_id                          => vlan_id,
      vlan_priority                    => vlan_priority,
      preamble_data                    => preamble_data,
      enable_custom_preamble           => enable_custom_preamble,
                         
      aclk                             => aclk,
      areset                           => sync_reset,
      reset_error                      => reset_error_sync,
      enable_pat_check                 => enable_pat_check_sync,
                         
      tdata                            => rx_axis_tdata,
      tkeep                            => rx_axis_tkeep,
      tvalid                           => rx_axis_tvalid,
      tlast                            => rx_axis_tlast,
      tready                           => rx_axis_tready_int,
      tuser                            => '1',
      frame_error                      => frame_error,
      check_active_flash               => check_active_flash
   );

end rtl;
