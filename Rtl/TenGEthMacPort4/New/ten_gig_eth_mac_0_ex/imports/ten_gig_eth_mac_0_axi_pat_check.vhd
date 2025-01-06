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
-- Title      : Frame checker for 10 Gig Ethernet
-- Project    : 10 Gigabit Ethernet Core
--------------------------------------------------------------------------------
-- File       : ten_gig_eth_mac_0_axi_pat_check.vhd
-- Author     : Xilinx Inc.
-- -----------------------------------------------------------------------------
-- Description: A simple pattern checker - expects the same data pattern as generated
--              by the pat_gen with the same DA/SA regardless whether an address swap has been performed or not.
--              The checker will first sync to the data and then identify any errors (this is a sticky output but
--              the internal signal is per lane)
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;


entity ten_gig_eth_mac_0_axi_pat_check is
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
end ten_gig_eth_mac_0_axi_pat_check;

architecture rtl of ten_gig_eth_mac_0_axi_pat_check is

   type STATES is (IDLE,PREAMBLE,ADDR,ADDR_TL_D,ADDR_VLAN,TL_D,DATA);
   type reg_array is array (0 to 7) of std_logic_vector(7 downto 0);

   -- used when custom preamble is enabled
   constant START_CODE                 : std_logic_vector(7 downto 0)   := X"FB";

   -- frame overhead values
   constant VLAN_OVERHEAD              : unsigned(5 downto 0) := "010110"; --22;
   constant ETH_OVERHEAD               : unsigned(5 downto 0) := "010010"; --18;


   signal rx_state                     : STATES;
   signal prev_rx_state                : STATES;

   signal frame_error_int              : std_logic                      := '0';
   signal frame_dropped                : std_logic                      := '0';
   signal errored_data                 : std_logic_vector(7 downto 0)   := (others => '0');
   signal errored_addr                 : std_logic_vector(7 downto 0)   := (others => '0');
   signal errored_preamble             : std_logic_vector(7 downto 0)   := (others => '0');

   signal frame_activity_count         : unsigned(20 downto 0)  := (others => '0');

   -- these registers hold the data that is being
   -- compared against during data reception
   signal exp_data                     : reg_array;
   signal exp_preamble_data            : std_logic_vector(63 downto 0);
   signal exp_header_dest              : std_logic_vector(63 downto 0);
   signal exp_header_src               : std_logic_vector(63 downto 0);
   signal exp_vlan_header_dest         : std_logic_vector(63 downto 0);
   signal exp_vlan_header_src          : std_logic_vector(63 downto 0);
   signal exp_tl_header_dest           : std_logic_vector(63 downto 0);
   signal exp_tl_header_src            : std_logic_vector(63 downto 0);

   signal pkt_adjust                   : unsigned(5 downto 0);
   signal vlan_header                  : std_logic_vector(31 downto 0);
   signal got_payload_size             : std_logic_vector(15 downto 0)  := (others => '0');
   signal got_payload_size_plus1       : unsigned(15 downto 0)          := (others => '0');
   signal exp_payload_size             : unsigned(15 downto 0)          := (others => '0');
   signal byte_count                   : unsigned(15 downto 0)          := (others => '0');
   signal byte_count_less2             : unsigned(15 downto 0);
   signal byte_count_less4             : unsigned(15 downto 0);
   signal byte_count_less6             : unsigned(15 downto 0);

   signal first_frame_detected         : std_logic                      := '0';
   signal check_frame                  : std_logic                      := '0';
   signal fast_flash                   : std_logic                      := '1';

   signal reset                        : std_logic                      := '0';

begin

   p_reset : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' or reset_error = '1' then
            reset                      <= '1';
         else
            reset                      <= '0';
         end if;
      end if;
   end process p_reset;

   -- work out the adjustment required to get the right packet size.
   -- 6(DA) + 6(SA) + 4(VLAN OPT) + 2(L/T) + 4(CRC)
   pkt_adjust                          <= VLAN_OVERHEAD when enable_vlan = '1' else ETH_OVERHEAD;

   -- generate the vlan fields
   vlan_header                         <= X"81" & X"00" & vlan_priority & '0' & vlan_id;

   -- need a counter for frame activity to provide some feedback that frames are being received
   -- flash rate depends the size of frames being received eg. big frames slow flashing
   p_active : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if reset = '1' then
            frame_activity_count       <= (others => '0');
         elsif (rx_state = ADDR) and tvalid = '1' and tready = '1' then
            frame_activity_count       <= frame_activity_count + 1;
         end if;
      end if;
   end process p_active;

   -- when the active_count is below 64 use a fast output for the flash
   p_fast : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if frame_activity_count(6) = '1' then
            fast_flash                 <= '0';
         end if;
      end if;
   end process p_fast;

   p_flash : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if reset = '1' then
            check_active_flash         <= '0';
         elsif enable_pat_check = '1' then
            if fast_flash = '1' then
               check_active_flash      <= frame_activity_count(3);
            else
               check_active_flash      <= frame_activity_count(20);
            end if;
         else
            check_active_flash         <= '0';
         end if;
      end if;
   end process p_flash;

   -- we need a way to confirm data has been received to ensure that if no data is received it is
   -- flagged as an error

   p_frame_error : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if reset = '1' then
            frame_error                <= '0';
         elsif rx_state = DATA then
            frame_error                <= frame_error_int;
         end if;
      end if;
   end process p_frame_error;

   p_error : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if reset = '1' then
            frame_error_int            <= '0';
         elsif frame_dropped = '1' or errored_preamble /= X"00" or errored_addr /= X"00" or errored_data /= X"00" then
            frame_error_int            <= '1';
         end if;
      end if;
   end process p_error;

   -- the pattern checker is a slave, it so has to look for ackowledged data
   -- a simple state machine will keep track of the packet position


   p_state : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if reset = '1' then
            first_frame_detected          <= '0';
            rx_state                      <= IDLE;
         else
            case rx_state is
               --First tlast means we can start syncing with the incoming frames
               --Therefore first frame is not checked
               when IDLE =>
                  if tlast = '1' and tvalid = '1' and tready = '1' and enable_pat_check = '1' and first_frame_detected = '0' then
                     first_frame_detected <= '1';
                     rx_state             <= IDLE;
                  elsif tlast = '1' and tvalid = '1' and tready = '1' and enable_pat_check = '1' and enable_custom_preamble = '1' and
                        first_frame_detected = '1' then
                     rx_state             <= PREAMBLE;
                  elsif tlast = '1' and tvalid = '1' and tready = '1' and enable_pat_check = '1' and enable_custom_preamble = '0' and
                        first_frame_detected = '1' then
                     rx_state             <= ADDR;
                  end if;
               when PREAMBLE =>
                  if tvalid = '1' and tready = '1' and tuser = '1' then
                     rx_state             <= ADDR;
                  end if;
               when ADDR =>
                  if tvalid = '1' and tready = '1' and tuser = '1' and enable_vlan = '1' then
                     rx_state             <= ADDR_VLAN;
                  elsif tvalid = '1' and tready = '1' and tuser = '1' and enable_vlan = '0' then
                     rx_state             <= ADDR_TL_D;
                  end if;
               when ADDR_VLAN =>
                  if tvalid = '1' and tready = '1' and tuser = '1' then
                     rx_state             <= TL_D;
                  end if;
               when ADDR_TL_D =>
                  if tvalid = '1' and tready = '1' and tuser = '1' then
                     rx_state             <= DATA;
                  end if;
               when TL_D =>
                  if tvalid = '1' and tready = '1' and tuser = '1' then
                     rx_state             <= DATA;
                  end if;
               when DATA =>
                  if tlast = '1' and tvalid = '1' and tready = '1' and tkeep /= X"00" then
                     if tuser = '0' or frame_error_int = '1' then
                        rx_state          <= IDLE;
                     elsif enable_custom_preamble = '1' then
                        rx_state          <= PREAMBLE;
                     else
                        rx_state          <= ADDR;
                     end if;
                  end if;
               when others =>
                  rx_state                <= IDLE;
            end case;
         end if;
      end if;
   end process p_state;

   p_prev_state : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if reset = '1' then
            prev_rx_state              <= IDLE;
         else
            prev_rx_state              <= rx_state;
         end if;
      end if;
   end process p_prev_state;

   -- start checking only after first frame passed
   p_check : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if reset = '1' then
            check_frame                <= '0';
         elsif rx_state = DATA and tlast = '1' then
            check_frame                <= '1';
         end if;
      end if;
   end process p_check;

   -- need to get packet size info
   -- this is first initialised during the info state (the assumption being that
   -- the generate sends incrementing packet sizes (wrapping at MAX_SIZE)

   p_get_size : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if rx_state = ADDR_TL_D and tvalid = '1' and tready = '1' then
            got_payload_size           <= tdata(39 downto 32) & tdata(47 downto 40);
            got_payload_size_plus1     <= (unsigned(tdata(39 downto 32)) & (unsigned(tdata(47 downto 40)))) + 1;
         elsif rx_state = TL_D and tvalid = '1' and tready = '1' then
            got_payload_size           <= tdata(7 downto 0) & tdata(15 downto 8);
            got_payload_size_plus1     <= (unsigned(tdata(7 downto 0)) & (unsigned(tdata(15 downto 8)))) + 1;
         end if;
      end if;
   end process p_get_size;

   -- determine the expected frame size of the next frame
   p_exp_size : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if (unsigned(got_payload_size) >= (max_size - pkt_adjust)) and
            (prev_rx_state = ADDR_TL_D or prev_rx_state = TL_D) and tvalid = '1' then
            exp_payload_size           <= '0' & (min_size - pkt_adjust);
         elsif (prev_rx_state = ADDR_TL_D or prev_rx_state = TL_D) and tvalid = '1' then
            exp_payload_size           <= got_payload_size_plus1;
         end if;
      end if;
   end process p_exp_size;

   -- do frame size check after first frame received
   p_drop : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if reset = '1' or enable_pat_check = '0' then
            frame_dropped              <= '0';
         elsif (prev_rx_state = ADDR_TL_D or prev_rx_state = TL_D) and rx_state = DATA
              and tvalid = '1' and tready = '1' and check_frame = '1' and exp_payload_size /= unsigned(got_payload_size) then
            frame_dropped              <= '1';
         end if;
      end if;
   end process p_drop;

   -- byte_count is used for data checking per columns
   p_byte_count : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if reset = '1' or enable_pat_check = '0' then
            byte_count                 <= (others => '0');
         elsif rx_state = ADDR and enable_vlan = '0' and tready = '1' and tvalid = '1' then
            byte_count                 <= exp_payload_size + 6;
         elsif rx_state = ADDR_VLAN and tready = '1' and tvalid = '1' then
            byte_count                 <= exp_payload_size + 2;
         elsif (rx_state = TL_D or rx_state = ADDR_TL_D or rx_state = DATA) and
                byte_count > 8 and tready = '1' and tvalid = '1' then
            byte_count                 <= byte_count - 8;
         elsif rx_state = DATA and byte_count <= 8 and tready = '1' and tvalid = '1' then
            byte_count                 <= (others => '0');
         end if;
      end if;
   end process p_byte_count;

   -- before checking the data pattern we have to generate the expected data
   -- this can also be used to allow a generate statement to be used
      byte_count_less2                 <= byte_count - 2;
      byte_count_less4                 <= byte_count - 4;
      byte_count_less6                 <= byte_count - 6;
      exp_data(0)                      <= std_logic_vector(byte_count(7 downto 0));
      exp_data(1)                      <= std_logic_vector(byte_count(15 downto 8));
      exp_data(2)                      <= std_logic_vector(byte_count_less2(7 downto 0));
      exp_data(3)                      <= std_logic_vector(byte_count_less2(15 downto 8));
      exp_data(4)                      <= std_logic_vector(byte_count_less4(7 downto 0));
      exp_data(5)                      <= std_logic_vector(byte_count_less4(15 downto 8));
      exp_data(6)                      <= std_logic_vector(byte_count_less6(7 downto 0));
      exp_data(7)                      <= std_logic_vector(byte_count_less6(15 downto 8));
      exp_preamble_data                <= preamble_data & START_CODE;
      exp_header_dest                  <= src_addr(15 downto 0) & dest_addr(47 downto 0);
      exp_header_src                   <= dest_addr(15 downto 0) & src_addr(47 downto 0);
      exp_vlan_header_dest             <= vlan_header(7 downto 0) & vlan_header(15 downto 8) & vlan_header(23 downto 16) &
                                          vlan_header(31 downto 24) & dest_addr(47 downto 16);
      exp_vlan_header_src              <= vlan_header(7 downto 0) & vlan_header(15 downto 8) & vlan_header(23 downto 16) &
                                          vlan_header(31 downto 24) & src_addr(47 downto 16);
      exp_tl_header_dest               <= exp_data(7) & exp_data(6) & exp_data(6) & exp_data(7) & dest_addr(47 downto 16);
      exp_tl_header_src                <= exp_data(7) & exp_data(6) & exp_data(6) & exp_data(7) & src_addr(47 downto 16);

   -- do the byte to byte comparison here
   check_loop: for i in 7 downto 0 generate
      p_main_check : process(aclk)
      begin
         if aclk'event and aclk = '1' then
            if reset = '1' or enable_pat_check = '0' then
               errored_preamble(i)          <= '0';
               errored_addr(i)              <= '0';
               errored_data(i)              <= '0';
            else
               if tvalid = '1' and check_frame = '1' then
                  case rx_state is
                     when PREAMBLE =>
                        if tdata(((i+1)*8)-1 downto i*8) /= exp_preamble_data(((i+1)*8)-1 downto i*8) then
                           errored_preamble(i) <= '1';
                        end if;
                     when ADDR =>
                        if tdata(((i+1)*8)-1 downto i*8) /= exp_header_dest(((i+1)*8)-1 downto i*8) and
                           tdata(((i+1)*8)-1 downto i*8) /= exp_header_src(((i+1)*8)-1 downto i*8) then
                           errored_addr(i)   <= '1';
                        end if;
                     when ADDR_TL_D =>
                        if tdata(((i+1)*8)-1 downto i*8) /= exp_tl_header_dest(((i+1)*8)-1 downto i*8) and
                           tdata(((i+1)*8)-1 downto i*8) /= exp_tl_header_src(((i+1)*8)-1 downto i*8) then
                           errored_addr(i)   <= '1';
                        end if;
                     when ADDR_VLAN =>
                        if tdata(((i+1)*8)-1 downto i*8) /= exp_vlan_header_dest(((i+1)*8)-1 downto i*8) and
                           tdata(((i+1)*8)-1 downto i*8) /= exp_vlan_header_src(((i+1)*8)-1 downto i*8) then
                           errored_addr(i)   <= '1';
                        end if;
                     when TL_D =>
                        if tkeep(i) = '1' and tdata(((i+1)*8)-1 downto i*8) /= exp_data(i) then
                           errored_data(i)   <= '1';
                        end if;
                     when DATA =>
                        if tkeep(i) = '1' and tdata(((i+1)*8)-1 downto i*8) /= exp_data(i) then
                           errored_data(i)   <= '1';
                        end if;
                     when others =>
                        errored_preamble(i)  <= '0';
                        errored_addr(i)      <= '0';
                        errored_data(i)      <= '0';
                  end case;
               end if;
            end if;
         end if;
      end process p_main_check;
   end generate;

end rtl;
