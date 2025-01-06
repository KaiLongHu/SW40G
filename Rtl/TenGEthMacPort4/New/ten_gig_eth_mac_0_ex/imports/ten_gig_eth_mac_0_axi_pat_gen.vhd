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
-- Title      : Frame generator for 10 Gig Ethernet 
-- Project    : 10 Gigabit Ethernet Core
--------------------------------------------------------------------------------------------
-- File       : ten_gig_eth_mac_0_axi_pat_gen.vhd
-- Author     : Xilinx Inc.
-- -----------------------------------------------------------------------------------------
-- Description: This is a very simple pattern generator which will generate packets 
--              with the supplied dest_addr and src_addr and incrementing data.  The packet size 
--              increments between the min and max size (which can be set to the same value if a 
--              specific size is required
--              
--              the pattern generator is throttled by the FIFO hitting full which in turn
--              is throttled by the transmit rate of the MAC.  Since the example
--              design system does not use active flow control it is possible for the FIFO's to 
--              overflow on RX.  To avoid this a basic rate controller is implemented which will
--              throttle the pattern generator output to below the maximum data rate.
--------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;


entity ten_gig_eth_mac_0_axi_pat_gen is
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
end ten_gig_eth_mac_0_axi_pat_gen;

architecture rtl of ten_gig_eth_mac_0_axi_pat_gen is

   type STATES is (IDLE,PREAMBLE,ADDR,ADDR_TL_D,ADDR_VLAN,TL_D,DATA);
                
   -- data_out_state
   type DO_STATES is (IDLE, REST_OF_FRAME);
  
   -- we want to use less than 100% bandwidth to account for clock PPM 
   -- difference between two connected peers' clock sources
   -- The value of 200 gives 200/255 = 78.4% 
   constant BW                         : unsigned(7 downto 0) := X"FF";
   
   -- frame overhead values
   constant VLAN_OVERHEAD              : unsigned(5 downto 0) := "010110"; --22;
   constant ETH_OVERHEAD               : unsigned(5 downto 0) := "010010"; --18;  
   
   -- used when custom preamble is enabled
   constant START_CODE                 : std_logic_vector(7 downto 0):= X"FB";
  
   -- These registers hold the data that is being sent out
   signal gen_data_reg_7_6             : std_logic_vector(15 downto 0)  := (others => '0');            
   signal gen_data_reg_5_4             : std_logic_vector(15 downto 0)  := (others => '0');            
   signal gen_data_reg_3_2             : std_logic_vector(15 downto 0)  := (others => '0');            
   signal gen_data_reg_1_0             : std_logic_vector(15 downto 0)  := (others => '0');            
  
   signal byte_count                   : unsigned(15 downto 0)          := (others => '0');            
   signal header_count                 : unsigned(3 downto 0)           := (others => '0');             
   signal payload_size                 : unsigned(15 downto 0)          := (others => '0');            
   signal frame_bigger_8               : std_logic;                            
   signal frame_bigger_8_reg           : std_logic                      := '0';
   signal gen_state                    : STATES;
   signal pkt_adjust                   : unsigned(5 downto 0);
   signal vlan_header                  : std_logic_vector(31 downto 0);
  
   -- frame generation control signals    
   signal first_frame_gen_done         : std_logic                      := '0';
   signal column_after_idle            : std_logic                      := '0';
   signal frame_after_idle             : std_logic                      := '0';
   signal frame_end                    : std_logic;
   signal gen_ahead                    : std_logic;
   signal stay_in_idle                 : std_logic;
   signal force_next_state             : std_logic;
   
   signal tvalid_int                   : std_logic;
   signal tvalid_out                   : std_logic;
   signal tlast_int                    : std_logic                      := '0';
   signal tkeep_int                    : std_logic_vector(7 downto 0)   := (others => '0');                
   signal tdata_int                    : std_logic_vector(63 downto 0)  := (others => '0');               
   signal tlast_int_reg                : std_logic                      := '0';                   
   signal tkeep_int_reg                : std_logic_vector(7 downto 0)   := (others => '0');                
   signal tdata_int_reg                : std_logic_vector(63 downto 0)  := (others => '0');               
  
   signal gen_active_count             : unsigned(20 downto 0)          := (others => '0');                 
    
   -- rate control signals
   signal basic_rc_counter             : unsigned(7 downto 0);                   
   signal add_credit                   : std_logic;                         
   signal credit_count                 : unsigned(12 downto 0);                 
   signal fast_flash                   : std_logic                      := '1'; 
  
   signal data_out_state               : DO_STATES;
 
 begin
   
   tvalid                              <= tvalid_out;
 
   -- rate control logic
  
   -- first we need an always active counter to provide the credit control
   p_rc_count : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' or enable_pat_gen = '0' then 
            basic_rc_counter           <= BW;
         else
            basic_rc_counter           <= basic_rc_counter + X"01";
         end if;
      end if;
   end process p_rc_count;
  
   -- now we need to set the compare level depending upon the selected speed
   -- the credits are applied using a simple less-than check
   p_rc_credit : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if basic_rc_counter < BW then 
            add_credit                 <= '1';
         else
            add_credit                 <= '0';
         end if;
      end if;
   end process p_rc_credit;
  
   -- basic credit counter - -ve value means do not send a frame
   p_credit_count : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            credit_count               <= (others => '0');
         else
            if gen_state /= IDLE then 
               if add_credit = '0' and credit_count(12 downto 10) /= "110" then
                  credit_count         <= credit_count - 1;
               end if;
            else
               if add_credit = '1' and credit_count(12 downto 11) /= "01" then
                  credit_count         <= credit_count + 1;
               end if;
            end if;
         end if;
      end if;
   end process p_credit_count;
  
      
   -- work out the adjustment required to get the right packet size.
   -- 6(DA) + 6(SA) + 4(VLAN OPT) + 2(L/T) + 4(CRC)  
   pkt_adjust                          <= VLAN_OVERHEAD when enable_vlan = '1' else ETH_OVERHEAD;
  
   -- generate the vlan fields
   vlan_header                         <= X"81" & X"00" & vlan_priority & '0' & vlan_id;
  
   -- this should translate to an LED flashing 
   -- flash rate depends the size of frames being sent eg. small frames fast flashing
   p_flash : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            gen_active_flash           <= '0';
         elsif enable_pat_gen = '1' then 
            if fast_flash = '1' then
               gen_active_flash        <= gen_active_count(3);
            else
               gen_active_flash        <= gen_active_count(20);
            end if;
         else 
            gen_active_flash           <= '0';
         end if;
      end if;
   end process p_flash;
     
   -- activity flash control
   p_active : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            gen_active_count           <= (others => '0');
         elsif (gen_state = ADDR) and tvalid_out = '1' and tready = '1' then 
            gen_active_count           <= gen_active_count + 1;
         end if;
      end if;
   end process p_active;
  
   -- when the active_count is below 64 use a fast output for the flash
   p_fast : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if gen_active_count(6) = '1' then 
            fast_flash                 <= '0';
         end if;
      end if;
   end process p_fast;
   
   -- byte_count is used for data generation per columns
   p_byte_count : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            byte_count                 <= (others => '0');
         elsif (gen_state = ADDR) and enable_vlan = '0' then 
            byte_count                 <= payload_size + 6;
         elsif gen_state = ADDR_VLAN then 
            byte_count                 <= payload_size + 2;
         elsif ((gen_state = ADDR_TL_D or gen_state = TL_D or gen_state = DATA) and 
                (byte_count > 8)) and tready = '1' then
            byte_count                 <= byte_count - 8;
         end if;
      end if;
   end process p_byte_count;
  
  
   -- generate data here
   p_gen_data : process(byte_count, insert_error)
   begin
      if insert_error = '1' then
         gen_data_reg_1_0              <= X"abcd";
         gen_data_reg_3_2              <= X"efab";
         gen_data_reg_5_4              <= X"cdef";
         gen_data_reg_7_6              <= X"acdf";  
      else 
         gen_data_reg_1_0              <= std_logic_vector(byte_count);
         gen_data_reg_3_2              <= std_logic_vector(byte_count - 2);
         gen_data_reg_5_4              <= std_logic_vector(byte_count - 4);
         gen_data_reg_7_6              <= std_logic_vector(byte_count - 6);
      end if;   
   end process p_gen_data;
     
   -- adjust parameter values by 18 to allow for header and crc
   -- so the payload_size can be issued directly in the size field
   -- payload_size is updated at frame end only after the first frame has been generated
  
   p_payload_size : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            payload_size               <= '0' & (min_size - pkt_adjust);
         elsif (gen_state = DATA) and frame_bigger_8 = '0' and tready = '1' then 
            if payload_size >= (max_size - pkt_adjust) then
               payload_size            <= '0' & (min_size - pkt_adjust);
            elsif first_frame_gen_done = '1' and payload_size < (max_size - pkt_adjust) then
               payload_size            <= payload_size + 1;
            end if;
         end if;
      end if;
   end process p_payload_size;
  
   ----------------------------
   -- Main state machine 
   ----------------------------
   -- (if preamble enabled)
   -- 1st cycle : PREAMBLE 
   -- 2nd cycle : DA + SA
   -- 3rd cycle : SA + L/T + DATA  OR!  SA + VLAN 
   -- 4th cycle : DATA OR! L/T + DATA
   -- 5th cycle : DATA
  
   -- (if preamble disabled)
   -- 1st cycle : DA + SA 
   -- 2nd cycle : SA + L/T + DATA  OR!  SA + VLAN 
   -- 3rd cycle : DATA OR! L/T + DATA
   -- 4th cycle : DATA 
  
   -- At startup state of tready is unknown therefore we have to generate a cycle ahead
   -- regardless of tready state. This is achieved by asserting gen_ahead signal when tready is low
   -- and de-asserted where appropriate.

   -- Note here that the generated frame is one cycle behind the frame being output therefore 
   -- in IDLE state we check whether at frame_end there has been a high or low tready
   -- If it has been low we have to wait in idle till we see tready asserted. 
 
 
    
   -- keep track of current frame size 
   frame_bigger_8                      <= '1' when byte_count > 8 else '0';
  
   stay_in_idle                        <= first_frame_gen_done and not tready and frame_end;
   force_next_state                    <= not tready and frame_after_idle and gen_ahead;
  
   -- frame_bigger_8_reg is used in case there has been a low tready at the time the last column of the frame 
   -- would be transmitted 
   p_more_eight : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            frame_bigger_8_reg         <= '0';
         else 
            frame_bigger_8_reg         <= frame_bigger_8;
         end if;
      end if;
   end process p_more_eight;
  
   -- first_frame_gen_done is set at the end of the generated frame and is driven low only by reset
   p_first_frame : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            first_frame_gen_done       <= '0';
         elsif gen_state = DATA and (frame_bigger_8_reg = '0' or frame_bigger_8 = '0') then
            first_frame_gen_done       <= '1';
         end if;
      end if;
   end process p_first_frame;
  
   -- frame_after_idle is kept set when we come out from IDLE until we see a frame end
   p_frame_idle : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            frame_after_idle           <= '0';
         elsif gen_state = IDLE and enable_pat_gen = '1' and credit_count(12) = '0' and 
                 stay_in_idle = '0' then
            frame_after_idle           <= '1';
         elsif gen_state = DATA and ((force_next_state = '1' and frame_bigger_8_reg = '0') or 
                                       (tready = '1' and frame_bigger_8 = '0')) then
            frame_after_idle           <= '0';
         end if;
      end if;
   end process p_frame_idle;
  
   -- column_after_idle is set when we exit the IDLE frame generation state
   p_column_idle : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            column_after_idle          <= '0';
         elsif gen_state = IDLE and enable_pat_gen = '1' and credit_count(12) = '0' and stay_in_idle = '0' then
            column_after_idle          <= '1';
         elsif gen_state = PREAMBLE or gen_state = ADDR then
            column_after_idle          <= '0';
         end if;
      end if;
   end process p_column_idle;

   -- Frame_end is set when tready is high when we are at a point in a frame
   -- that the generated column contains 8 or less data bytes.
   -- It is also set when we should have seen a tready but we didn't 
   p_frame_end : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            frame_end                  <= '0';
         elsif gen_state = DATA and credit_count(12) = '0' and
               ((frame_bigger_8 = '0' and tready = '1') or (force_next_state = '1' and frame_bigger_8_reg = '0')) then
            frame_end                  <= '1';
         elsif gen_state = IDLE and ((enable_pat_gen = '1' and credit_count(12) = '0' and stay_in_idle = '0') or
               (tready = '1' and credit_count(12) = '1')) then
            frame_end                  <= '0';
         end if;
      end if;
   end process p_frame_end;

   -- At startup state of tready is unknown therefore we have to generate a cycle ahead
   -- regardless of tready state. This is achieved by asserting gen_ahead signal when tready is low
   -- and de-asserted where appropriate.
   p_gen_ahead : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            gen_ahead                  <= '0';
         elsif gen_state = IDLE and ((enable_pat_gen = '1' and credit_count(12) = '0' and tready = '0') or
               (gen_state /= IDLE and tready = '1')) then
            gen_ahead                  <= '1';
         elsif gen_state /= IDLE and tready = '0' then
            gen_ahead                  <= '0';
         end if;
      end if;
   end process p_gen_ahead;
 
   p_state_machine : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            gen_state                  <= IDLE;
         else
            case gen_state is
               when IDLE =>
                  if enable_pat_gen = '1' and credit_count(12) = '0' then
                     if stay_in_idle = '1' then                    
                        gen_state      <= IDLE;
                     else
                        if enable_custom_preamble = '1' then
                           gen_state   <= PREAMBLE;
                        else 
                           gen_state   <= ADDR;
                        end if;
                     end if;
                  end if;
               when PREAMBLE =>
                  if tready = '1' or force_next_state = '1' then
                     gen_state         <= ADDR;
                  end if;
               when ADDR =>
                  if tready = '1' or (force_next_state = '1' and enable_custom_preamble = '0') then
                     if enable_vlan = '1' then
                        gen_state      <= ADDR_VLAN;
                     else
                        gen_state      <= ADDR_TL_D;
                     end if;
                  end if;
               when ADDR_TL_D =>
                  if tready = '1' then
                     gen_state         <= DATA;
                  end if;
               when ADDR_VLAN =>
                  if tready = '1' then
                     gen_state         <= TL_D;
                  end if;
               when TL_D =>
                  if tready = '1' then
                     gen_state         <= DATA;
                  end if;
               when DATA =>
                  if tready = '1' then
                     if frame_bigger_8 = '1' then
                        gen_state      <= DATA;
                     else
                        if credit_count(12) = '0' then
                           if enable_custom_preamble = '1' then
                              gen_state <= PREAMBLE;
                           else
                              gen_state <= ADDR;
                           end if;
                        else
                           gen_state   <= IDLE;
                        end if;
                     end if;
                  else 
                     if frame_after_idle = '1' and gen_ahead = '1' then
                        if frame_bigger_8_reg = '1' then
                           gen_state   <= DATA;
                        else
                           if credit_count(12) = '0' then                      
                              if enable_custom_preamble = '1' then
                                 gen_state <= PREAMBLE;
                              else
                                 gen_state <= ADDR;
                              end if;
                           else
                              gen_state <= IDLE;
                           end if;
                        end if;
                     end if;
                  end if;
               when others =>
                  gen_state            <= IDLE;
            end case;
         end if;
      end if;
   end process p_state_machine;
 
   -- Flip-flop used as storage at the end of the frame
   p_hold_axi : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            tdata_int_reg              <= (others => '0');
            tkeep_int_reg              <= (others => '0');
            tlast_int_reg              <= '0';
         elsif gen_state = DATA and frame_bigger_8 = '0' and tready = '1' then
            tdata_int_reg              <= tdata_int;
            tkeep_int_reg              <= tkeep_int;
            tlast_int_reg              <= tlast_int;
         end if;
      end if;
   end process p_hold_axi;
  
     
   p_axi_cntl : process(gen_state, frame_bigger_8, byte_count, first_frame_gen_done,
                        tlast_int_reg, tkeep_int_reg)
   begin 
      if gen_state /= IDLE and not (gen_state = DATA and frame_bigger_8 = '0') then
         tkeep_int                     <= "11111111";
         tlast_int                     <= '0';
      elsif gen_state = DATA and frame_bigger_8 = '0' and byte_count /= X"0000" then
         tlast_int                     <= '1';
         case byte_count(3 downto 0) is
            when X"8" =>
               tkeep_int               <= "11111111";
            when X"7" =>
               tkeep_int               <= "01111111";
            when X"6" =>
               tkeep_int               <= "00111111";
            when X"5" =>
               tkeep_int               <= "00011111";
            when X"4" =>
               tkeep_int               <= "00001111";
            when X"3" =>
               tkeep_int               <= "00000111";  
            when X"2" =>
               tkeep_int               <= "00000011";  
            when X"1" =>
               tkeep_int               <= "00000001";  
            when others =>   
               tkeep_int               <= "00000000";
         end case;
      elsif gen_state = IDLE and first_frame_gen_done = '0' then
         tlast_int                     <= '0';
         tkeep_int                     <= "00000000";
      else 
         tlast_int                     <= tlast_int_reg;
         tkeep_int                     <= tkeep_int_reg;
      end if;
   end process p_axi_cntl;
     
   tvalid_int                          <= '1' when (gen_state /= IDLE) or 
                                          (column_after_idle = '1' and first_frame_gen_done = '1') or 
                                          (tlast_int = '1' and gen_state /= IDLE) else '0';
  
 
   -- Form tdata_int here 
   -- opreg7to0 
   p_lane0 : process(gen_state, dest_addr, src_addr, payload_size, gen_data_reg_1_0, tdata_int_reg)
   begin
      case gen_state is
         when PREAMBLE  => tdata_int(7 downto 0)   <= START_CODE;
         when ADDR      => tdata_int(7 downto 0)   <= dest_addr(7 downto 0);
         when ADDR_TL_D => tdata_int(7 downto 0)   <= src_addr(23 downto 16);
         when ADDR_VLAN => tdata_int(7 downto 0)   <= src_addr(23 downto 16);
         when TL_D      => tdata_int(7 downto 0)   <= std_logic_vector(payload_size(15 downto 8));
         when DATA      => tdata_int(7 downto 0)   <= gen_data_reg_1_0(7 downto 0);   
         when IDLE      => tdata_int(7 downto 0)   <= tdata_int_reg(7 downto 0);
         when others    => tdata_int(7 downto 0)   <= tdata_int_reg(7 downto 0);
      end case;
   end process p_lane0;
  
   -- opreg15to8 
  
   p_lane1 : process(gen_state, dest_addr, src_addr, payload_size, gen_data_reg_1_0, tdata_int_reg, preamble_data)
   begin
      case gen_state is
         when PREAMBLE  => tdata_int(15 downto 8)   <= preamble_data(7 downto 0);
         when ADDR      => tdata_int(15 downto 8)   <= dest_addr(15 downto 8);
         when ADDR_TL_D => tdata_int(15 downto 8)   <= src_addr(31 downto 24);
         when ADDR_VLAN => tdata_int(15 downto 8)   <= src_addr(31 downto 24);
         when TL_D      => tdata_int(15 downto 8)   <= std_logic_vector(payload_size(7 downto 0));
         when DATA      => tdata_int(15 downto 8)   <= gen_data_reg_1_0(15 downto 8);   
         when IDLE      => tdata_int(15 downto 8)   <= tdata_int_reg(15 downto 8);
         when others    => tdata_int(15 downto 8)   <= tdata_int_reg(15 downto 8);
      end case;
   end process p_lane1;
  
   -- opreg23to16 
  
   p_lane2 : process(gen_state, dest_addr, src_addr, gen_data_reg_3_2, tdata_int_reg, preamble_data)
   begin
      case gen_state is
         when PREAMBLE  => tdata_int(23 downto 16)  <= preamble_data(15 downto 8);
         when ADDR      => tdata_int(23 downto 16)  <= dest_addr(23 downto 16);
         when ADDR_TL_D => tdata_int(23 downto 16)  <= src_addr(39 downto 32);
         when ADDR_VLAN => tdata_int(23 downto 16)  <= src_addr(39 downto 32);
         when TL_D      => tdata_int(23 downto 16)  <= gen_data_reg_3_2(7 downto 0);
         when DATA      => tdata_int(23 downto 16)  <= gen_data_reg_3_2(7 downto 0);   
         when IDLE      => tdata_int(23 downto 16)  <= tdata_int_reg(23 downto 16);
         when others    => tdata_int(23 downto 16)  <= tdata_int_reg(23 downto 16);
      end case;
   end process p_lane2;
  
   -- opreg31to24 
  
   p_lane3 : process(gen_state, dest_addr, src_addr, gen_data_reg_3_2, tdata_int_reg, preamble_data)
   begin
      case gen_state is
         when PREAMBLE  => tdata_int(31 downto 24)  <= preamble_data(23 downto 16);
         when ADDR      => tdata_int(31 downto 24)  <= dest_addr(31 downto 24);
         when ADDR_TL_D => tdata_int(31 downto 24)  <= src_addr(47 downto 40);
         when ADDR_VLAN => tdata_int(31 downto 24)  <= src_addr(47 downto 40);
         when TL_D      => tdata_int(31 downto 24)  <= gen_data_reg_3_2(15 downto 8);
         when DATA      => tdata_int(31 downto 24)  <= gen_data_reg_3_2(15 downto 8);   
         when IDLE      => tdata_int(31 downto 24)  <= tdata_int_reg(31 downto 24);
         when others    => tdata_int(31 downto 24)  <= tdata_int_reg(31 downto 24);
      end case;
   end process p_lane3;
  
   -- opreg39to32 
  
   p_lane4 : process(gen_state, dest_addr, vlan_header, payload_size, gen_data_reg_5_4, tdata_int_reg, preamble_data)
   begin
      case gen_state is
         when PREAMBLE  => tdata_int(39 downto 32)  <= preamble_data(31 downto 24);
         when ADDR      => tdata_int(39 downto 32)  <= dest_addr(39 downto 32);
         when ADDR_TL_D => tdata_int(39 downto 32)  <= std_logic_vector(payload_size(15 downto 8));
         when ADDR_VLAN => tdata_int(39 downto 32)  <= vlan_header(31 downto 24);
         when TL_D      => tdata_int(39 downto 32)  <= gen_data_reg_5_4(7 downto 0);
         when DATA      => tdata_int(39 downto 32)  <= gen_data_reg_5_4(7 downto 0);   
         when IDLE      => tdata_int(39 downto 32)  <= tdata_int_reg(39 downto 32);
         when others    => tdata_int(39 downto 32)  <= tdata_int_reg(39 downto 32);
      end case;
   end process p_lane4;
  
   -- opreg47to40 
  
   p_lane5 : process(gen_state, dest_addr, vlan_header, payload_size, gen_data_reg_5_4, tdata_int_reg, preamble_data)
   begin
      case gen_state is
         when PREAMBLE  => tdata_int(47 downto 40)  <= preamble_data(39 downto 32);
         when ADDR      => tdata_int(47 downto 40)  <= dest_addr(47 downto 40);
         when ADDR_TL_D => tdata_int(47 downto 40)  <= std_logic_vector(payload_size(7 downto 0));
         when ADDR_VLAN => tdata_int(47 downto 40)  <= vlan_header(23 downto 16);
         when TL_D      => tdata_int(47 downto 40)  <= gen_data_reg_5_4(15 downto 8);
         when DATA      => tdata_int(47 downto 40)  <= gen_data_reg_5_4(15 downto 8);   
         when IDLE      => tdata_int(47 downto 40)  <= tdata_int_reg(47 downto 40);
         when others    => tdata_int(47 downto 40)  <= tdata_int_reg(47 downto 40);
      end case;
   end process p_lane5;
  
   -- opreg55to48
  
   p_lane6 : process(gen_state, vlan_header, src_addr, gen_data_reg_7_6, tdata_int_reg, preamble_data)
   begin
      case gen_state is
         when PREAMBLE  => tdata_int(55 downto 48)  <= preamble_data(47 downto 40);
         when ADDR      => tdata_int(55 downto 48)  <= src_addr(7 downto 0);
         when ADDR_TL_D => tdata_int(55 downto 48)  <= gen_data_reg_7_6(7 downto 0);
         when ADDR_VLAN => tdata_int(55 downto 48)  <= vlan_header(15 downto 8);
         when TL_D      => tdata_int(55 downto 48)  <= gen_data_reg_7_6(7 downto 0);
         when DATA      => tdata_int(55 downto 48)  <= gen_data_reg_7_6(7 downto 0);   
         when IDLE      => tdata_int(55 downto 48)  <= tdata_int_reg(55 downto 48);
         when others    => tdata_int(55 downto 48)  <= tdata_int_reg(55 downto 48);
      end case;
   end process p_lane6;
  
   -- opreg63to56 
  
   p_lane7 : process(gen_state, vlan_header, src_addr, gen_data_reg_7_6, tdata_int_reg, preamble_data)
   begin
      case gen_state is
         when PREAMBLE  => tdata_int(63 downto 56)  <= preamble_data(55 downto 48);
         when ADDR      => tdata_int(63 downto 56)  <= src_addr(15 downto 8);
         when ADDR_TL_D => tdata_int(63 downto 56)  <= gen_data_reg_7_6(15 downto 8);
         when ADDR_VLAN => tdata_int(63 downto 56)  <= vlan_header(7 downto 0);
         when TL_D      => tdata_int(63 downto 56)  <= gen_data_reg_7_6(15 downto 8);
         when DATA      => tdata_int(63 downto 56)  <= gen_data_reg_7_6(15 downto 8);   
         when IDLE      => tdata_int(63 downto 56)  <= tdata_int_reg(63 downto 56);
         when others    => tdata_int(63 downto 56)  <= tdata_int_reg(63 downto 56);
      end case;
   end process p_lane7;
 
   -----------------------------------------------
   -- Push generated data to output state machine 
   -----------------------------------------------
   -- Output data is a clock cycle behind the generated data
   -- Note that tvalid_int represents the valid signal of the generated frame and not the 
   -- frame that is being output
   -- If there has been a frame_end with a low tready valid_out has to be kept
   -- high until we see a tready therefore the additional term after tvalid_int
 
   -- Once we got past IDLE we only want to refresh the data when both tready and tvalid_int are set

   p_flop_axi : process(aclk)
   begin
      if aclk'event and aclk = '1' then
         if areset = '1' then 
            tdata                      <= (others => '0');
            tkeep                      <= (others => '0');
            tlast                      <= '0';
            tvalid_out                 <= '0';
            data_out_state             <= IDLE;
         else
            case data_out_state is 
               when IDLE =>
                  if gen_state = IDLE then
                     tvalid_out        <= tvalid_int or (frame_end and not tready);
                  else
                     tvalid_out        <= tvalid_int;
                  end if;
                  tdata                <= tdata_int;
                  tkeep                <= tkeep_int;
                  tlast                <= tlast_int;
                  if gen_state = PREAMBLE or gen_state = ADDR then
                     data_out_state    <= REST_OF_FRAME;
                  end if;
               when REST_OF_FRAME =>
                  if gen_state = IDLE then
                     tvalid_out        <= tvalid_int or (frame_end and not tready);
                  else
                     tvalid_out        <= tvalid_int;
                  end if;
                  if tready = '1' and tvalid_int = '1' then
                     tdata             <= tdata_int;
                     tkeep             <= tkeep_int;
                     tlast             <= tlast_int;
                  elsif tvalid_int = '0' then
                     data_out_state    <= IDLE;
                  end if;
               when others =>
                  data_out_state       <= IDLE;
            end case;
         end if;
      end if;
   end process p_flop_axi;
  
end rtl;
