
`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////////////////////
// Company:        CETC54
// Engineer:       Li Yuan
//
// Modify Date:    16:42:37 07/04/2011
// Design Name:
// Module Name:    RRArbiter32Input
// Project Name:
// Target Devices:
// Tool versions:
//
// Description:
//    Round Robin总线仲裁器，对输入的18个请求qvRequest进行轮询仲裁，给出结果qvGrant
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
//
// Additional Comments:
//    Round Robin总线仲裁器仲裁出结果需要两个时钟周期，两次请求仲裁之间需要一个时钟周期间隔：
//    clock:             __    __    __    __    __    __    __    __    __
//                    __|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__
//    qvRequest :           _____              _____
//                    _____/     \____________/     \_________________________
//                         \_____/            \_____/
//    qvGrant:                          _____
//                    _________________/     \________________________________
//                                     \_____/
//    qvGrantIndex:                     _____
//                    _________________/     \________________________________
//                                     \_____/
//
//////////////////////////////////////////////////////////////////////////////////////////////////


module RRArbiter32Input(
   input  wire       clock,
   input  wire       nReset,
   input  wire       qArbitEnable,
   input  wire [31:0] qvRequest,          //请求
   output reg  [31:0] qvGrant = 0,        //授权
   output reg  [4:0]  qvGrantIndex = 0    //授权号的下标
);

   reg   [4:0] qvNextRoundStartIndex = 0;       //记录一轮仲裁起始编号

   reg   [31:0] qvGrantReg;

   always @ ( posedge clock ) begin
      if ( ~nReset ) begin
         qvGrantReg <= 32'h00000000;
      end
      else begin
         case (qvNextRoundStartIndex)
           0: begin
               qvGrantReg[0] <= qArbitEnable && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:0] == 18'b100000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:0] == 19'b1000000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:0] == 20'b10000000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:0] == 21'b100000000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:0] == 22'b1000000000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:0] == 23'b10000000000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:0] == 24'b100000000000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:0] == 25'b1000000000000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:0] == 26'b10000000000000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:0] == 27'b100000000000000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:0] == 28'b1000000000000000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:0] == 29'b10000000000000000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:0] == 30'b100000000000000000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:0] == 31'b1000000000000000000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:0] == 32'b10000000000000000000000000000000);
               end
           1: begin
               qvGrantReg[1] <= qArbitEnable && (qvRequest[1:1] == 1'b1);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[2:1] == 2'b10);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[3:1] == 3'b100);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:1] == 4'b1000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:1] == 5'b10000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:1] == 6'b100000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:1] == 7'b1000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:1] == 8'b10000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:1] == 9'b100000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:1] == 10'b1000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:1] == 11'b10000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:1] == 12'b100000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:1] == 13'b1000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:1] == 14'b10000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:1] == 15'b100000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:1] == 16'b1000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:1] == 17'b10000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:1] == 18'b100000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:1] == 19'b1000000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:1] == 20'b10000000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:1] == 21'b100000000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:1] == 22'b1000000000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:1] == 23'b10000000000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:1] == 24'b100000000000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:1] == 25'b1000000000000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:1] == 26'b10000000000000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:1] == 27'b100000000000000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:1] == 28'b1000000000000000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:1] == 29'b10000000000000000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:1] == 30'b100000000000000000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:1] == 31'b1000000000000000000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:1] == 31'b0000000000000000000000000000000) && (qvRequest[0:0] == 1'b1);
               end
           2: begin
               qvGrantReg[2] <= qArbitEnable && (qvRequest[2:2] == 1'b1);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[3:2] == 2'b10);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:2] == 3'b100);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:2] == 4'b1000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:2] == 5'b10000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:2] == 6'b100000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:2] == 7'b1000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:2] == 8'b10000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:2] == 9'b100000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:2] == 10'b1000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:2] == 11'b10000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:2] == 12'b100000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:2] == 13'b1000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:2] == 14'b10000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:2] == 15'b100000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:2] == 16'b1000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:2] == 17'b10000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:2] == 18'b100000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:2] == 19'b1000000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:2] == 20'b10000000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:2] == 21'b100000000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:2] == 22'b1000000000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:2] == 23'b10000000000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:2] == 24'b100000000000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:2] == 25'b1000000000000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:2] == 26'b10000000000000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:2] == 27'b100000000000000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:2] == 28'b1000000000000000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:2] == 29'b10000000000000000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:2] == 30'b100000000000000000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:2] == 30'b000000000000000000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:2] == 30'b000000000000000000000000000000) && (qvRequest[1:0] == 2'b10);
               end
           3: begin
               qvGrantReg[3] <= qArbitEnable && (qvRequest[3:3] == 1'b1);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:3] == 2'b10);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:3] == 3'b100);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:3] == 4'b1000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:3] == 5'b10000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:3] == 6'b100000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:3] == 7'b1000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:3] == 8'b10000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:3] == 9'b100000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:3] == 10'b1000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:3] == 11'b10000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:3] == 12'b100000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:3] == 13'b1000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:3] == 14'b10000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:3] == 15'b100000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:3] == 16'b1000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:3] == 17'b10000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:3] == 18'b100000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:3] == 19'b1000000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:3] == 20'b10000000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:3] == 21'b100000000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:3] == 22'b1000000000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:3] == 23'b10000000000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:3] == 24'b100000000000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:3] == 25'b1000000000000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:3] == 26'b10000000000000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:3] == 27'b100000000000000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:3] == 28'b1000000000000000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:3] == 29'b10000000000000000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:3] == 29'b00000000000000000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:3] == 29'b00000000000000000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:3] == 29'b00000000000000000000000000000) && (qvRequest[2:0] == 3'b100);
               end
           4: begin
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:4] == 1'b1);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:4] == 2'b10);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:4] == 3'b100);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:4] == 4'b1000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:4] == 5'b10000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:4] == 6'b100000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:4] == 7'b1000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:4] == 8'b10000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:4] == 9'b100000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:4] == 10'b1000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:4] == 11'b10000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:4] == 12'b100000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:4] == 13'b1000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:4] == 14'b10000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:4] == 15'b100000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:4] == 16'b1000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:4] == 17'b10000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:4] == 18'b100000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:4] == 19'b1000000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:4] == 20'b10000000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:4] == 21'b100000000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:4] == 22'b1000000000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:4] == 23'b10000000000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:4] == 24'b100000000000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:4] == 25'b1000000000000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:4] == 26'b10000000000000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:4] == 27'b100000000000000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:4] == 28'b1000000000000000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:4] == 28'b0000000000000000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:4] == 28'b0000000000000000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:4] == 28'b0000000000000000000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:4] == 28'b0000000000000000000000000000) && (qvRequest[3:0] == 4'b1000);
               end
           5: begin
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:5] == 1'b1);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:5] == 2'b10);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:5] == 3'b100);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:5] == 4'b1000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:5] == 5'b10000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:5] == 6'b100000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:5] == 7'b1000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:5] == 8'b10000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:5] == 9'b100000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:5] == 10'b1000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:5] == 11'b10000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:5] == 12'b100000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:5] == 13'b1000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:5] == 14'b10000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:5] == 15'b100000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:5] == 16'b1000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:5] == 17'b10000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:5] == 18'b100000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:5] == 19'b1000000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:5] == 20'b10000000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:5] == 21'b100000000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:5] == 22'b1000000000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:5] == 23'b10000000000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:5] == 24'b100000000000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:5] == 25'b1000000000000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:5] == 26'b10000000000000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:5] == 27'b100000000000000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:5] == 27'b000000000000000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:5] == 27'b000000000000000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:5] == 27'b000000000000000000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:5] == 27'b000000000000000000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:5] == 27'b000000000000000000000000000) && (qvRequest[4:0] == 5'b10000);
               end
           6: begin
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:6] == 1'b1);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:6] == 2'b10);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:6] == 3'b100);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:6] == 4'b1000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:6] == 5'b10000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:6] == 6'b100000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:6] == 7'b1000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:6] == 8'b10000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:6] == 9'b100000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:6] == 10'b1000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:6] == 11'b10000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:6] == 12'b100000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:6] == 13'b1000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:6] == 14'b10000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:6] == 15'b100000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:6] == 16'b1000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:6] == 17'b10000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:6] == 18'b100000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:6] == 19'b1000000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:6] == 20'b10000000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:6] == 21'b100000000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:6] == 22'b1000000000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:6] == 23'b10000000000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:6] == 24'b100000000000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:6] == 25'b1000000000000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:6] == 26'b10000000000000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:6] == 26'b00000000000000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:6] == 26'b00000000000000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:6] == 26'b00000000000000000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:6] == 26'b00000000000000000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:6] == 26'b00000000000000000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:6] == 26'b00000000000000000000000000) && (qvRequest[5:0] == 6'b100000);
               end
           7: begin
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:7] == 1'b1);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:7] == 2'b10);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:7] == 3'b100);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:7] == 4'b1000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:7] == 5'b10000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:7] == 6'b100000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:7] == 7'b1000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:7] == 8'b10000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:7] == 9'b100000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:7] == 10'b1000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:7] == 11'b10000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:7] == 12'b100000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:7] == 13'b1000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:7] == 14'b10000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:7] == 15'b100000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:7] == 16'b1000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:7] == 17'b10000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:7] == 18'b100000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:7] == 19'b1000000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:7] == 20'b10000000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:7] == 21'b100000000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:7] == 22'b1000000000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:7] == 23'b10000000000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:7] == 24'b100000000000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:7] == 25'b1000000000000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:7] == 25'b0000000000000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:7] == 25'b0000000000000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:7] == 25'b0000000000000000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:7] == 25'b0000000000000000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:7] == 25'b0000000000000000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:7] == 25'b0000000000000000000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:7] == 25'b0000000000000000000000000) && (qvRequest[6:0] == 7'b1000000);
               end
           8: begin
               qvGrantReg[8] <= qArbitEnable && (qvRequest[8:8] == 1'b1);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:8] == 2'b10);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:8] == 3'b100);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:8] == 4'b1000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:8] == 5'b10000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:8] == 6'b100000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:8] == 7'b1000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:8] == 8'b10000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:8] == 9'b100000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:8] == 10'b1000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:8] == 11'b10000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:8] == 12'b100000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:8] == 13'b1000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:8] == 14'b10000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:8] == 15'b100000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:8] == 16'b1000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:8] == 17'b10000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:8] == 18'b100000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:8] == 19'b1000000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:8] == 20'b10000000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:8] == 21'b100000000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:8] == 22'b1000000000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:8] == 23'b10000000000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:8] == 24'b100000000000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:8] == 24'b000000000000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:8] == 24'b000000000000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:8] == 24'b000000000000000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:8] == 24'b000000000000000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:8] == 24'b000000000000000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:8] == 24'b000000000000000000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:8] == 24'b000000000000000000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:8] == 24'b000000000000000000000000) && (qvRequest[7:0] == 8'b10000000);
               end
           9: begin
               qvGrantReg[9] <= qArbitEnable && (qvRequest[9:9] == 1'b1);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:9] == 2'b10);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:9] == 3'b100);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:9] == 4'b1000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:9] == 5'b10000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:9] == 6'b100000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:9] == 7'b1000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:9] == 8'b10000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:9] == 9'b100000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:9] == 10'b1000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:9] == 11'b10000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:9] == 12'b100000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:9] == 13'b1000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:9] == 14'b10000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:9] == 15'b100000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:9] == 16'b1000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:9] == 17'b10000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:9] == 18'b100000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:9] == 19'b1000000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:9] == 20'b10000000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:9] == 21'b100000000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:9] == 22'b1000000000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:9] == 23'b10000000000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:9] == 23'b00000000000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:9] == 23'b00000000000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:9] == 23'b00000000000000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:9] == 23'b00000000000000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:9] == 23'b00000000000000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:9] == 23'b00000000000000000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:9] == 23'b00000000000000000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:9] == 23'b00000000000000000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:9] == 23'b00000000000000000000000) && (qvRequest[8:0] == 9'b100000000);
               end
           10: begin
               qvGrantReg[10] <= qArbitEnable && (qvRequest[10:10] == 1'b1);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:10] == 2'b10);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:10] == 3'b100);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:10] == 4'b1000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:10] == 5'b10000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:10] == 6'b100000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:10] == 7'b1000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:10] == 8'b10000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:10] == 9'b100000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:10] == 10'b1000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:10] == 11'b10000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:10] == 12'b100000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:10] == 13'b1000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:10] == 14'b10000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:10] == 15'b100000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:10] == 16'b1000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:10] == 17'b10000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:10] == 18'b100000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:10] == 19'b1000000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:10] == 20'b10000000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:10] == 21'b100000000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:10] == 22'b1000000000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:10] == 22'b0000000000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:10] == 22'b0000000000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:10] == 22'b0000000000000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:10] == 22'b0000000000000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:10] == 22'b0000000000000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:10] == 22'b0000000000000000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:10] == 22'b0000000000000000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:10] == 22'b0000000000000000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:10] == 22'b0000000000000000000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:10] == 22'b0000000000000000000000) && (qvRequest[9:0] == 10'b1000000000);
               end
           11: begin
               qvGrantReg[11] <= qArbitEnable && (qvRequest[11:11] == 1'b1);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:11] == 2'b10);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:11] == 3'b100);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:11] == 4'b1000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:11] == 5'b10000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:11] == 6'b100000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:11] == 7'b1000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:11] == 8'b10000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:11] == 9'b100000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:11] == 10'b1000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:11] == 11'b10000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:11] == 12'b100000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:11] == 13'b1000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:11] == 14'b10000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:11] == 15'b100000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:11] == 16'b1000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:11] == 17'b10000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:11] == 18'b100000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:11] == 19'b1000000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:11] == 20'b10000000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:11] == 21'b100000000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:11] == 21'b000000000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:11] == 21'b000000000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:11] == 21'b000000000000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:11] == 21'b000000000000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:11] == 21'b000000000000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:11] == 21'b000000000000000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:11] == 21'b000000000000000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:11] == 21'b000000000000000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:11] == 21'b000000000000000000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:11] == 21'b000000000000000000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:11] == 21'b000000000000000000000) && (qvRequest[10:0] == 11'b10000000000);
               end
           12: begin
               qvGrantReg[12] <= qArbitEnable && (qvRequest[12:12] == 1'b1);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:12] == 2'b10);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:12] == 3'b100);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:12] == 4'b1000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:12] == 5'b10000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:12] == 6'b100000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:12] == 7'b1000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:12] == 8'b10000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:12] == 9'b100000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:12] == 10'b1000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:12] == 11'b10000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:12] == 12'b100000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:12] == 13'b1000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:12] == 14'b10000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:12] == 15'b100000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:12] == 16'b1000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:12] == 17'b10000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:12] == 18'b100000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:12] == 19'b1000000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:12] == 20'b10000000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:12] == 20'b00000000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:12] == 20'b00000000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:12] == 20'b00000000000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:12] == 20'b00000000000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:12] == 20'b00000000000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:12] == 20'b00000000000000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:12] == 20'b00000000000000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:12] == 20'b00000000000000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:12] == 20'b00000000000000000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:12] == 20'b00000000000000000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:12] == 20'b00000000000000000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:12] == 20'b00000000000000000000) && (qvRequest[11:0] == 12'b100000000000);
               end
           13: begin
               qvGrantReg[13] <= qArbitEnable && (qvRequest[13:13] == 1'b1);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:13] == 2'b10);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:13] == 3'b100);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:13] == 4'b1000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:13] == 5'b10000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:13] == 6'b100000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:13] == 7'b1000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:13] == 8'b10000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:13] == 9'b100000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:13] == 10'b1000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:13] == 11'b10000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:13] == 12'b100000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:13] == 13'b1000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:13] == 14'b10000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:13] == 15'b100000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:13] == 16'b1000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:13] == 17'b10000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:13] == 18'b100000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:13] == 19'b1000000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:13] == 19'b0000000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:13] == 19'b0000000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:13] == 19'b0000000000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:13] == 19'b0000000000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:13] == 19'b0000000000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:13] == 19'b0000000000000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:13] == 19'b0000000000000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:13] == 19'b0000000000000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:13] == 19'b0000000000000000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:13] == 19'b0000000000000000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:13] == 19'b0000000000000000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:13] == 19'b0000000000000000000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:13] == 19'b0000000000000000000) && (qvRequest[12:0] == 13'b1000000000000);
               end
           14: begin
               qvGrantReg[14] <= qArbitEnable && (qvRequest[14:14] == 1'b1);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:14] == 2'b10);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:14] == 3'b100);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:14] == 4'b1000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:14] == 5'b10000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:14] == 6'b100000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:14] == 7'b1000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:14] == 8'b10000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:14] == 9'b100000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:14] == 10'b1000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:14] == 11'b10000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:14] == 12'b100000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:14] == 13'b1000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:14] == 14'b10000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:14] == 15'b100000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:14] == 16'b1000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:14] == 17'b10000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:14] == 18'b100000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:14] == 18'b000000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:14] == 18'b000000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:14] == 18'b000000000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:14] == 18'b000000000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:14] == 18'b000000000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:14] == 18'b000000000000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:14] == 18'b000000000000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:14] == 18'b000000000000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:14] == 18'b000000000000000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:14] == 18'b000000000000000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:14] == 18'b000000000000000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:14] == 18'b000000000000000000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:14] == 18'b000000000000000000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:14] == 18'b000000000000000000) && (qvRequest[13:0] == 14'b10000000000000);
               end
           15: begin
               qvGrantReg[15] <= qArbitEnable && (qvRequest[15:15] == 1'b1);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:15] == 2'b10);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:15] == 3'b100);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:15] == 4'b1000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:15] == 5'b10000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:15] == 6'b100000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:15] == 7'b1000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:15] == 8'b10000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:15] == 9'b100000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:15] == 10'b1000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:15] == 11'b10000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:15] == 12'b100000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:15] == 13'b1000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:15] == 14'b10000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:15] == 15'b100000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:15] == 16'b1000000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:15] == 17'b10000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:15] == 17'b00000000000000000) && (qvRequest[14:0] == 15'b100000000000000);
               end
           16: begin
               qvGrantReg[16] <= qArbitEnable && (qvRequest[16:16] == 1'b1);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:16] == 2'b10);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:16] == 3'b100);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:16] == 4'b1000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:16] == 5'b10000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:16] == 6'b100000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:16] == 7'b1000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:16] == 8'b10000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:16] == 9'b100000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:16] == 10'b1000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:16] == 11'b10000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:16] == 12'b100000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:16] == 13'b1000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:16] == 14'b10000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:16] == 15'b100000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:16] == 16'b1000000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:16] == 16'b0000000000000000) && (qvRequest[15:0] == 16'b1000000000000000);
               end
           17: begin
               qvGrantReg[17] <= qArbitEnable && (qvRequest[17:17] == 1'b1);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:17] == 2'b10);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:17] == 3'b100);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:17] == 4'b1000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:17] == 5'b10000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:17] == 6'b100000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:17] == 7'b1000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:17] == 8'b10000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:17] == 9'b100000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:17] == 10'b1000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:17] == 11'b10000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:17] == 12'b100000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:17] == 13'b1000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:17] == 14'b10000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:17] == 15'b100000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:17] == 15'b000000000000000) && (qvRequest[16:0] == 17'b10000000000000000);
               end
           18: begin
               qvGrantReg[18] <= qArbitEnable && (qvRequest[18:18] == 1'b1);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:18] == 2'b10);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:18] == 3'b100);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:18] == 4'b1000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:18] == 5'b10000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:18] == 6'b100000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:18] == 7'b1000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:18] == 8'b10000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:18] == 9'b100000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:18] == 10'b1000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:18] == 11'b10000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:18] == 12'b100000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:18] == 13'b1000000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:18] == 14'b10000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[31:18] == 14'b00000000000000) && (qvRequest[17:0] == 18'b100000000000000000);
               end
           19: begin
               qvGrantReg[19] <= qArbitEnable && (qvRequest[19:19] == 1'b1);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:19] == 2'b10);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:19] == 3'b100);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:19] == 4'b1000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:19] == 5'b10000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:19] == 6'b100000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:19] == 7'b1000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:19] == 8'b10000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:19] == 9'b100000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:19] == 10'b1000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:19] == 11'b10000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:19] == 12'b100000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:19] == 13'b1000000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[17:0] == 18'b100000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[31:19] == 13'b0000000000000) && (qvRequest[18:0] == 19'b1000000000000000000);
               end
           20: begin
               qvGrantReg[20] <= qArbitEnable && (qvRequest[20:20] == 1'b1);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:20] == 2'b10);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:20] == 3'b100);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:20] == 4'b1000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:20] == 5'b10000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:20] == 6'b100000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:20] == 7'b1000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:20] == 8'b10000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:20] == 9'b100000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:20] == 10'b1000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:20] == 11'b10000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:20] == 12'b100000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[17:0] == 18'b100000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[18:0] == 19'b1000000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[31:20] == 12'b000000000000) && (qvRequest[19:0] == 20'b10000000000000000000);
               end
           21: begin
               qvGrantReg[21] <= qArbitEnable && (qvRequest[21:21] == 1'b1);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:21] == 2'b10);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:21] == 3'b100);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:21] == 4'b1000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:21] == 5'b10000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:21] == 6'b100000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:21] == 7'b1000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:21] == 8'b10000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:21] == 9'b100000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:21] == 10'b1000000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:21] == 11'b10000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[17:0] == 18'b100000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[18:0] == 19'b1000000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[19:0] == 20'b10000000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[31:21] == 11'b00000000000) && (qvRequest[20:0] == 21'b100000000000000000000);
               end
           22: begin
               qvGrantReg[22] <= qArbitEnable && (qvRequest[22:22] == 1'b1);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:22] == 2'b10);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:22] == 3'b100);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:22] == 4'b1000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:22] == 5'b10000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:22] == 6'b100000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:22] == 7'b1000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:22] == 8'b10000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:22] == 9'b100000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:22] == 10'b1000000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[17:0] == 18'b100000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[18:0] == 19'b1000000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[19:0] == 20'b10000000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[20:0] == 21'b100000000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[31:22] == 10'b0000000000) && (qvRequest[21:0] == 22'b1000000000000000000000);
               end
           23: begin
               qvGrantReg[23] <= qArbitEnable && (qvRequest[23:23] == 1'b1);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:23] == 2'b10);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:23] == 3'b100);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:23] == 4'b1000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:23] == 5'b10000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:23] == 6'b100000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:23] == 7'b1000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:23] == 8'b10000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:23] == 9'b100000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[17:0] == 18'b100000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[18:0] == 19'b1000000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[19:0] == 20'b10000000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[20:0] == 21'b100000000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[21:0] == 22'b1000000000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[31:23] == 9'b000000000) && (qvRequest[22:0] == 23'b10000000000000000000000);
               end
           24: begin
               qvGrantReg[24] <= qArbitEnable && (qvRequest[24:24] == 1'b1);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:24] == 2'b10);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:24] == 3'b100);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:24] == 4'b1000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:24] == 5'b10000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:24] == 6'b100000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:24] == 7'b1000000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:24] == 8'b10000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[17:0] == 18'b100000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[18:0] == 19'b1000000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[19:0] == 20'b10000000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[20:0] == 21'b100000000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[21:0] == 22'b1000000000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[22:0] == 23'b10000000000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[31:24] == 8'b00000000) && (qvRequest[23:0] == 24'b100000000000000000000000);
               end
           25: begin
               qvGrantReg[25] <= qArbitEnable && (qvRequest[25:25] == 1'b1);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:25] == 2'b10);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:25] == 3'b100);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:25] == 4'b1000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:25] == 5'b10000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:25] == 6'b100000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:25] == 7'b1000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[17:0] == 18'b100000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[18:0] == 19'b1000000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[19:0] == 20'b10000000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[20:0] == 21'b100000000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[21:0] == 22'b1000000000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[22:0] == 23'b10000000000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[23:0] == 24'b100000000000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[31:25] == 7'b0000000) && (qvRequest[24:0] == 25'b1000000000000000000000000);
               end
           26: begin
               qvGrantReg[26] <= qArbitEnable && (qvRequest[26:26] == 1'b1);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:26] == 2'b10);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:26] == 3'b100);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:26] == 4'b1000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:26] == 5'b10000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:26] == 6'b100000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[17:0] == 18'b100000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[18:0] == 19'b1000000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[19:0] == 20'b10000000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[20:0] == 21'b100000000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[21:0] == 22'b1000000000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[22:0] == 23'b10000000000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[23:0] == 24'b100000000000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[24:0] == 25'b1000000000000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[31:26] == 6'b000000) && (qvRequest[25:0] == 26'b10000000000000000000000000);
               end
           27: begin
               qvGrantReg[27] <= qArbitEnable && (qvRequest[27:27] == 1'b1);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:27] == 2'b10);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:27] == 3'b100);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:27] == 4'b1000);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:27] == 5'b10000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[17:0] == 18'b100000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[18:0] == 19'b1000000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[19:0] == 20'b10000000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[20:0] == 21'b100000000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[21:0] == 22'b1000000000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[22:0] == 23'b10000000000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[23:0] == 24'b100000000000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[24:0] == 25'b1000000000000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[25:0] == 26'b10000000000000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[31:27] == 5'b00000) && (qvRequest[26:0] == 27'b100000000000000000000000000);
               end
           28: begin
               qvGrantReg[28] <= qArbitEnable && (qvRequest[28:28] == 1'b1);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:28] == 2'b10);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:28] == 3'b100);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:28] == 4'b1000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[17:0] == 18'b100000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[18:0] == 19'b1000000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[19:0] == 20'b10000000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[20:0] == 21'b100000000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[21:0] == 22'b1000000000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[22:0] == 23'b10000000000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[23:0] == 24'b100000000000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[24:0] == 25'b1000000000000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[25:0] == 26'b10000000000000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[26:0] == 27'b100000000000000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[31:28] == 4'b0000) && (qvRequest[27:0] == 28'b1000000000000000000000000000);
               end
           29: begin
               qvGrantReg[29] <= qArbitEnable && (qvRequest[29:29] == 1'b1);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:29] == 2'b10);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:29] == 3'b100);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[17:0] == 18'b100000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[18:0] == 19'b1000000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[19:0] == 20'b10000000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[20:0] == 21'b100000000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[21:0] == 22'b1000000000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[22:0] == 23'b10000000000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[23:0] == 24'b100000000000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[24:0] == 25'b1000000000000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[25:0] == 26'b10000000000000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[26:0] == 27'b100000000000000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[27:0] == 28'b1000000000000000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[31:29] == 3'b000) && (qvRequest[28:0] == 29'b10000000000000000000000000000);
               end
           30: begin
               qvGrantReg[30] <= qArbitEnable && (qvRequest[30:30] == 1'b1);
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:30] == 2'b10);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[17:0] == 18'b100000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[18:0] == 19'b1000000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[19:0] == 20'b10000000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[20:0] == 21'b100000000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[21:0] == 22'b1000000000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[22:0] == 23'b10000000000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[23:0] == 24'b100000000000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[24:0] == 25'b1000000000000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[25:0] == 26'b10000000000000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[26:0] == 27'b100000000000000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[27:0] == 28'b1000000000000000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[28:0] == 29'b10000000000000000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[31:30] == 2'b00) && (qvRequest[29:0] == 30'b100000000000000000000000000000);
               end
           default: begin
               qvGrantReg[31] <= qArbitEnable && (qvRequest[31:31] == 1'b1);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[0:0] == 1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[1:0] == 2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[2:0] == 3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[3:0] == 4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[4:0] == 5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[5:0] == 6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[6:0] == 7'b1000000);
               qvGrantReg[7] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[7:0] == 8'b10000000);
               qvGrantReg[8] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[8:0] == 9'b100000000);
               qvGrantReg[9] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[9:0] == 10'b1000000000);
               qvGrantReg[10] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[10:0] == 11'b10000000000);
               qvGrantReg[11] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[11:0] == 12'b100000000000);
               qvGrantReg[12] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[12:0] == 13'b1000000000000);
               qvGrantReg[13] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[13:0] == 14'b10000000000000);
               qvGrantReg[14] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[14:0] == 15'b100000000000000);
               qvGrantReg[15] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[15:0] == 16'b1000000000000000);
               qvGrantReg[16] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[16:0] == 17'b10000000000000000);
               qvGrantReg[17] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[17:0] == 18'b100000000000000000);
               qvGrantReg[18] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[18:0] == 19'b1000000000000000000);
               qvGrantReg[19] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[19:0] == 20'b10000000000000000000);
               qvGrantReg[20] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[20:0] == 21'b100000000000000000000);
               qvGrantReg[21] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[21:0] == 22'b1000000000000000000000);
               qvGrantReg[22] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[22:0] == 23'b10000000000000000000000);
               qvGrantReg[23] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[23:0] == 24'b100000000000000000000000);
               qvGrantReg[24] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[24:0] == 25'b1000000000000000000000000);
               qvGrantReg[25] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[25:0] == 26'b10000000000000000000000000);
               qvGrantReg[26] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[26:0] == 27'b100000000000000000000000000);
               qvGrantReg[27] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[27:0] == 28'b1000000000000000000000000000);
               qvGrantReg[28] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[28:0] == 29'b10000000000000000000000000000);
               qvGrantReg[29] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[29:0] == 30'b100000000000000000000000000000);
               qvGrantReg[30] <= qArbitEnable && (qvRequest[31:31] == 1'b0) && (qvRequest[30:0] == 31'b1000000000000000000000000000000);
                 end
          endcase
      end
   end

   //qvNextRoundScanOrder
   always @ ( posedge clock ) begin
      if ( ~nReset ) begin
         qvNextRoundStartIndex <= 0;
      end
      else begin
         qvNextRoundStartIndex <= (qvGrantIndex == 31)? 0 : (qvGrantIndex + 1);
      end
   end


//////////////////////////////////////////////// 端口输出 ///////////////////////////////
   
   //qvGrant
   always @ ( posedge clock ) begin
      qvGrant <= qvGrantReg;
   end

   //qvGrantIndex
always @ ( posedge clock ) begin
  case( qvGrantReg )
    32'b00000000000000000000000000000001: qvGrantIndex<= 0;
    32'b00000000000000000000000000000010: qvGrantIndex<= 1;
    32'b00000000000000000000000000000100: qvGrantIndex<= 2;
    32'b00000000000000000000000000001000: qvGrantIndex<= 3;
    32'b00000000000000000000000000010000: qvGrantIndex<= 4;
    32'b00000000000000000000000000100000: qvGrantIndex<= 5;
    32'b00000000000000000000000001000000: qvGrantIndex<= 6;
    32'b00000000000000000000000010000000: qvGrantIndex<= 7;
    32'b00000000000000000000000100000000: qvGrantIndex<= 8;
    32'b00000000000000000000001000000000: qvGrantIndex<= 9;
    32'b00000000000000000000010000000000: qvGrantIndex<= 10;
    32'b00000000000000000000100000000000: qvGrantIndex<= 11;
    32'b00000000000000000001000000000000: qvGrantIndex<= 12;
    32'b00000000000000000010000000000000: qvGrantIndex<= 13;
    32'b00000000000000000100000000000000: qvGrantIndex<= 14;
    32'b00000000000000001000000000000000: qvGrantIndex<= 15;
    32'b00000000000000010000000000000000: qvGrantIndex<= 16;
    32'b00000000000000100000000000000000: qvGrantIndex<= 17;
    32'b00000000000001000000000000000000: qvGrantIndex<= 18;
    32'b00000000000010000000000000000000: qvGrantIndex<= 19;
    32'b00000000000100000000000000000000: qvGrantIndex<= 20;
    32'b00000000001000000000000000000000: qvGrantIndex<= 21;
    32'b00000000010000000000000000000000: qvGrantIndex<= 22;
    32'b00000000100000000000000000000000: qvGrantIndex<= 23;
    32'b00000001000000000000000000000000: qvGrantIndex<= 24;
    32'b00000010000000000000000000000000: qvGrantIndex<= 25;
    32'b00000100000000000000000000000000: qvGrantIndex<= 26;
    32'b00001000000000000000000000000000: qvGrantIndex<= 27;
    32'b00010000000000000000000000000000: qvGrantIndex<= 28;
    32'b00100000000000000000000000000000: qvGrantIndex<= 29;
    32'b01000000000000000000000000000000: qvGrantIndex<= 30;
    32'b10000000000000000000000000000000: qvGrantIndex<= 31;
  default: qvGrantIndex<= qvGrantIndex;
  endcase
end
//////////////////////////////////////////////////////////////////////////////////////////////

endmodule

