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
------------------------------------------------------------------------
-- Title      : Address Swap block for 10 Gig Ethernet 
-- Project    : 10 Gigabit Ethernet Core
------------------------------------------------------------------------
-- File       : ten_gig_eth_mac_0_address_swap.vhd  
-- Author     : Xilinx Inc.
------------------------------------------------------------------------
-- Description: This is the Address swap block  for the 10 Gigabit Ethernet MAC core. 
--              It swaps the destination and source addresses of frames that pass through.
--              When address swap is not enabled this module is transparent
--              otherwise acts as a slave.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;


entity ten_gig_eth_mac_0_address_swap is
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
end ten_gig_eth_mac_0_address_swap;

architecture rtl of ten_gig_eth_mac_0_address_swap is

   type STATES is (IDLE, PREAMBLE, ADDR, TLAST_SEEN);
              
   signal state                        : STATES;
   ---------------------------------------------------------------------
   ---- internal signals used in this design example.
   ---------------------------------------------------------------------

   -- two state fifo state machine
   signal data_stored_n                : std_logic;

   -- single register in Local Link datapath
   signal rx_axis_tdata_out_reg        : std_logic_vector(63 downto 0);
   signal tx_data_in                   : std_logic_vector(63 downto 0);
   signal tx_axis_tdata_out            : std_logic_vector(63 downto 0);
   signal rx_axis_tdata_out_reg_reg    : std_logic_vector(31 downto 0);
   signal rx_axis_tkeep_reg            : std_logic_vector(7 downto 0); 
   signal tx_axis_tkeep_out            : std_logic_vector(7 downto 0); 
   signal rx_sof_n_reg                 : std_logic;
   signal rx_sof_n_reg_reg             : std_logic;
   signal rx_axis_tlast_reg            : std_logic;
   signal rx_axis_tvalid_reg           : std_logic;

   signal axis_data_beat               : std_logic;
  
   signal tx_axis_tlast_out            : std_logic;
   signal tx_axis_tvalid_reg           : std_logic;
   signal tx_axis_tvalid_out           : std_logic;
  
begin

   ----------------------------------------------------------------------
   -- State machine to determine Start Of Frame
   ----------------------------------------------------------------------

   p_state_machine : process(aclk)
   begin
      if aclk'event and aclk= '1' then
         if areset = '1' then 
            state                      <= IDLE;
            rx_sof_n_reg               <= '0';
         else
            case state is
               when IDLE =>
                  if rx_axis_tvalid = '1' and rx_axis_tkeep /= "00000000" and 
                     enable_custom_preamble = '1' and tx_axis_tready = '1' then
                     state             <= PREAMBLE;
                  elsif rx_axis_tvalid = '1' and rx_axis_tkeep /= "00000000" and 
                        enable_custom_preamble = '0' and tx_axis_tready = '1' then
                     rx_sof_n_reg      <= '1';
                     state             <= ADDR;
                  end if;
               when PREAMBLE =>
                  if rx_axis_tvalid = '1' and rx_axis_tkeep /= "00000000" and tx_axis_tready = '1' then
                     rx_sof_n_reg      <= '1';
                  end if;
                  state                <= ADDR;
               when ADDR =>
                  rx_sof_n_reg         <= '0';
                  if rx_axis_tvalid = '1' and rx_axis_tlast = '1' and tx_axis_tready = '1' then
                     state             <= TLAST_SEEN;
                  end if;
               when TLAST_SEEN =>
                  if rx_axis_tvalid = '1' and rx_axis_tkeep /= "00000000" and 
                     enable_custom_preamble = '1' and tx_axis_tready = '1' then
                     state             <= PREAMBLE;
                  elsif rx_axis_tvalid = '1' and rx_axis_tkeep /= "00000000" and enable_custom_preamble = '0' and tx_axis_tready = '1' then
                     rx_sof_n_reg      <= '1';
                     state             <= ADDR;
                  end if;
               when others =>
                  state                <= IDLE;
            end case;
         end if;
      end if;
   end process p_state_machine;

   ----------------------------------------------------------------------
   -- Buffer one and a half words to allow address swap
   ----------------------------------------------------------------------

   axis_data_beat                      <= rx_axis_tvalid and tx_axis_tready;

   p_buffer : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            rx_axis_tdata_out_reg      <= (others => '0');
            rx_axis_tkeep_reg          <= (others => '0');
            rx_sof_n_reg_reg           <= '0';
            rx_axis_tlast_reg          <= '0';
            rx_axis_tdata_out_reg_reg  <= (others => '0');
            data_stored_n              <= '0';
            rx_axis_tvalid_reg         <= '0';
         else
            rx_axis_tvalid_reg         <= rx_axis_tvalid;
            rx_axis_tlast_reg          <= '0';
            if axis_data_beat = '1' then
               data_stored_n           <= '1';
               rx_axis_tdata_out_reg   <= rx_axis_tdata;
               rx_axis_tkeep_reg       <= rx_axis_tkeep;
               rx_sof_n_reg_reg        <= rx_sof_n_reg;
               rx_axis_tlast_reg       <= rx_axis_tlast;
               rx_axis_tdata_out_reg_reg <= rx_axis_tdata_out_reg(47 downto 16);
            elsif axis_data_beat = '0' and rx_axis_tlast_reg = '1' then
               rx_axis_tlast_reg       <= rx_axis_tlast_reg;
               data_stored_n           <= '0';
            end if;
         end if;
      end if;
   end process p_buffer;


   ----------------------------------------------------------------------
   -- Output to Tx
   ----------------------------------------------------------------------

   -- address swap following new SOF
   p_mux_addr : process (rx_sof_n_reg, rx_axis_tdata_out_reg, rx_axis_tdata,
                         rx_sof_n_reg_reg, rx_axis_tdata_out_reg_reg)
   begin
      if rx_sof_n_reg = '1' then
         tx_data_in                    <= rx_axis_tdata_out_reg(15 downto 0) &
                                          rx_axis_tdata(31 downto 0) &
                                          rx_axis_tdata_out_reg(63 downto 48);
      elsif rx_sof_n_reg_reg = '1' then
         tx_data_in                    <= rx_axis_tdata_out_reg(63 downto 32) &
                                          rx_axis_tdata_out_reg_reg;
      else
         tx_data_in                    <= rx_axis_tdata_out_reg;
      end if;
   end process p_mux_addr;


   p_out : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            tx_axis_tdata_out          <= (others => '0');
            tx_axis_tkeep_out          <= (others => '0');
            tx_axis_tvalid_out         <= '0';
            tx_axis_tvalid_reg         <= '0';
            tx_axis_tlast_out          <= '0';
         elsif tx_axis_tready = '1' then
            tx_axis_tdata_out          <= tx_data_in;
            tx_axis_tkeep_out          <= rx_axis_tkeep_reg;
            tx_axis_tvalid_reg         <= axis_data_beat;
            tx_axis_tvalid_out         <= tx_axis_tvalid_reg;
            tx_axis_tlast_out          <= rx_axis_tlast_reg;
         end if;
      end if;
   end process p_out;

   tx_axis_tvalid                      <= tx_axis_tvalid_out when enable_address_swap = '1' else rx_axis_tvalid;
   tx_axis_tdata                       <= tx_axis_tdata_out when enable_address_swap = '1' else rx_axis_tdata;
   tx_axis_tkeep                       <= tx_axis_tkeep_out when enable_address_swap = '1' else rx_axis_tkeep;
   tx_axis_tlast                       <= tx_axis_tlast_out and tx_axis_tready and tx_axis_tvalid_out when enable_address_swap = '1' else rx_axis_tlast;
   rx_axis_tready                      <= tx_axis_tready;

end rtl;
