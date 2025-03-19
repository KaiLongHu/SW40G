`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////////////////
///@file ResetSync.v
///
///@brief 各个模块调用的复位同步模块，用于将复位信号同步到模块内部的时钟域。
///
///@date 2016-09-01
///
///建立文档。
////////////////////////////////////////////////////////////////////////////////////////////////

module ResetSync # ( parameter RESET_SYNC_STAGES = 8 )
(
   input  wire    qnReset,
   input  wire    Clock,
   output wire    qnResetSync
);


   reg [RESET_SYNC_STAGES-1:0] reset_reg = 0;

   always @(posedge Clock, negedge qnReset) begin
      if ( ~qnReset ) begin
         reset_reg <= {RESET_SYNC_STAGES{1'b0}};
      end
      else begin
         reset_reg <= {reset_reg[RESET_SYNC_STAGES-2:0], 1'b1};
      end
   end

   assign   qnResetSync = reset_reg[RESET_SYNC_STAGES-1];


endmodule