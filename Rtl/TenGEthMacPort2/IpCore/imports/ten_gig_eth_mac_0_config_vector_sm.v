// ------------------------------------------------------------------------------
// (c) Copyright 2014 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES. 
// ------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Title      : Configuration state machine
// Project    : 10 Gig Ethernet MAC FIFO Reference Design
//------------------------------------------------------------------------------
// File       : ten_gig_eth_mac_0_config_vector_sm.v
// Author     : Xilinx Inc.
// -----------------------------------------------------------------------------
// Description:  This module is reponsible for bringing up the XGMAC
//               to enable basic packet transfer in both directions.
//
//---------------------------------------------------------------------------------------------

`timescale 1 ps/1 ps

module ten_gig_eth_mac_0_config_vector_sm (
   input                               gtx_clk,
   input                               gtx_reset,

   input                               enable_vlan,
   input                               enable_custom_preamble,
         
   output      [79:0]                  rx_configuration_vector,
   output      [79:0]                  tx_configuration_vector
);

   // main state machine

   parameter  STARTUP                  = 0,
              RESET_MAC                = 1,
              CHECK_MODE               = 2;

   //-------------------------------------------------
   // Wire/reg declarations
   reg         [1:0]                   control_status;          // used to keep track of axi transactions

   reg         [20:0]                  count_shift = 0;

   reg                                 tx_reset;
   wire                                tx_enable;
   wire                                tx_vlan_enable;
   wire                                tx_fcs_enable;
   wire                                tx_jumbo_enable;
   wire                                tx_fc_enable;
   wire                                tx_custom_preamble;
   wire                                tx_ifg_adjust;
   wire                                tx_wan_enable;
   wire                                tx_dic_enable;
   wire                                tx_max_frame_enable;
   wire        [14:0]                  tx_max_frame_length;
   wire        [47:0]                  tx_pause_addr;

   reg                                 rx_reset;
   wire                                rx_enable;
   wire                                rx_vlan_enable;
   wire                                rx_fcs_enable;
   wire                                rx_jumbo_enable;
   wire                                rx_fc_enable;
   wire                                rx_custom_preamble;
   wire                                rx_len_type_chk_disable;
   wire                                rx_control_len_chk_dis;
   wire                                rx_rs_inhibit;
   wire                                rx_max_frame_enable;
   wire        [14:0]                  rx_max_frame_length;
   wire        [47:0]                  rx_pause_addr;

   assign rx_configuration_vector =  {rx_pause_addr,
                                      1'b0, rx_max_frame_length,
                                      1'b0, rx_max_frame_enable,
                                      3'b000, rx_rs_inhibit, 
                                      rx_control_len_chk_dis,
                                      rx_len_type_chk_disable,
                                      rx_custom_preamble,
                                      1'b0, rx_fc_enable,
                                      rx_jumbo_enable,
                                      rx_fcs_enable,
                                      rx_vlan_enable,
                                      rx_enable,
                                      rx_reset};

   assign tx_configuration_vector =  {tx_pause_addr,
                                      1'b0, tx_max_frame_length,
                                      1'b0, tx_max_frame_enable,
                                      3'b000, tx_dic_enable,
                                      tx_wan_enable, tx_ifg_adjust,
                                      tx_custom_preamble, 
                                      1'b0, tx_fc_enable,
                                      tx_jumbo_enable,
                                      tx_fcs_enable,
                                      tx_vlan_enable,
                                      tx_enable,
                                      tx_reset};

   // don't reset this  - it will always be updated before it is used..
   // it does need an init value (zero)
   always @(posedge gtx_clk)
   begin
       count_shift <= {count_shift[19:0], (gtx_reset || tx_reset)};
   end

   //----------------------------------------------------------------------------
   // Management process. This process sets up the configuration by
   // turning off flow control and other functionality
   //----------------------------------------------------------------------------

   assign tx_enable               = 1'b1;
   assign tx_vlan_enable          = enable_vlan;
   assign tx_fcs_enable           = 1'b0;
   assign tx_jumbo_enable         = 1'b1;
   assign tx_fc_enable            = 1'b1;
   assign tx_custom_preamble      = enable_custom_preamble;
  // assign tx_ifg_adjust           = 1'b0;
   assign tx_ifg_adjust           = 1'b1;
   assign tx_wan_enable           = 1'b0;
   assign tx_dic_enable           = 1'b0;
   assign tx_max_frame_enable     = 1'b0;
   assign tx_max_frame_length     = 15'b0;
   assign tx_pause_addr           = 48'h0605040302DA;

   assign rx_enable               = 1'b1;
   assign rx_vlan_enable          = enable_vlan;
   assign rx_fcs_enable           = 1'b0;
   assign rx_jumbo_enable         = 1'b1;
   assign rx_fc_enable            = 1'b1;
   assign rx_custom_preamble      = enable_custom_preamble;
   assign rx_len_type_chk_disable = 1'b1;
   assign rx_control_len_chk_dis  = 1'b1;
   assign rx_rs_inhibit           = 1'b0;
   assign rx_max_frame_enable     = 1'b0;
   assign rx_max_frame_length     = 15'b0;
   assign rx_pause_addr           = 48'h0605040302DA;

   // since the main controls are all hard coded, only a reset will restart the state machine
   always @(posedge gtx_clk)
   begin
      if (gtx_reset) begin
         tx_reset                <= 0;
         rx_reset                <= 0;
         control_status          <= STARTUP;

      end
      // main state machine is kicking off multi cycle accesses in each state so has to
      // stall while they take place
      else  begin
         case (control_status)
            STARTUP : begin
               // this state will be ran after reset to wait for count_shift
               if (count_shift[20] == 1'b0) begin
                  control_status <= RESET_MAC;
               end
            end
            RESET_MAC : begin
               $display("** Note: Reseting MAC");
               tx_reset       <= 1;
               rx_reset       <= 1;
               control_status <= CHECK_MODE;
            end
            CHECK_MODE : begin
               // hold the tx/rx resets for a number of clocks to ensure they are caught
               if (count_shift[20] == 1'b1) begin
                  tx_reset       <= 0;
                  rx_reset       <= 0;
               end
            end
            default : begin
               control_status  <= STARTUP;
            end
         endcase
      end
   end


endmodule

