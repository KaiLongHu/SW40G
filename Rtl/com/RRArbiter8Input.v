
`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////////////////////
// Company:        Dawning
// Engineer:       Li Xu
//
// Modify Date:    16:42:37 07/04/2011
// Design Name:
// Module Name:    RRArbiter8Input
// Project Name:
// Target Devices:
// Tool versions:
//
// Description:
//    Round Robin总线仲裁器，对输入的8个请求qvRequest进行轮询仲裁，给出结果qvGrant
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


module RRArbiter8Input(
   input  wire       clock,
   input  wire       nReset,
   input  wire       qArbitEnable,
   input  wire [7:0] qvRequest,          //请求
   output reg  [7:0] qvGrant = 0,        //授权
   output reg  [2:0] qvGrantIndex = 0    //授权号的下标
);

   reg   [2:0] qvNextRoundStartIndex = 0;       //记录一轮仲裁起始编号

   reg   [7:0] qvGrantReg;

   always @ ( posedge clock ) begin
      if ( ~nReset ) begin
         qvGrantReg <= 0;
      end
      else begin
         case ( qvNextRoundStartIndex )
            0: begin
               qvGrantReg[0] <= qArbitEnable && (qvRequest[0:0]==1'b1       );
               qvGrantReg[1] <= qArbitEnable && (qvRequest[1:0]==2'b10      );
               qvGrantReg[2] <= qArbitEnable && (qvRequest[2:0]==3'b100     );
               qvGrantReg[3] <= qArbitEnable && (qvRequest[3:0]==4'b1000    );
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:0]==5'b10000   );
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:0]==6'b100000  );
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:0]==7'b1000000 );
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:0]==8'b10000000);
            end
            1: begin
               qvGrantReg[1] <= qArbitEnable && (qvRequest[1:1]==1'b1      );
               qvGrantReg[2] <= qArbitEnable && (qvRequest[2:1]==2'b10     );
               qvGrantReg[3] <= qArbitEnable && (qvRequest[3:1]==3'b100    );
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:1]==4'b1000   );
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:1]==5'b10000  );
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:1]==6'b100000 );
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:1]==7'b1000000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[7:1]==7'b0000000) && (qvRequest[0:0]==1'b1);
            end
            2: begin
               qvGrantReg[2] <= qArbitEnable && (qvRequest[2:2]==1'b1     );
               qvGrantReg[3] <= qArbitEnable && (qvRequest[3:2]==2'b10    );
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:2]==3'b100   );
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:2]==4'b1000  );
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:2]==5'b10000 );
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:2]==6'b100000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[7:2]==6'b000000) && (qvRequest[0:0]==1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[7:2]==6'b000000) && (qvRequest[1:0]==2'b10);
            end
            3: begin
               qvGrantReg[3] <= qArbitEnable && (qvRequest[3:3]==1'b1    );
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:3]==2'b10   );
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:3]==3'b100  );
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:3]==4'b1000 );
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:3]==5'b10000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[7:3]==6'b00000) && (qvRequest[0:0]==1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[7:3]==6'b00000) && (qvRequest[1:0]==2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[7:3]==6'b00000) && (qvRequest[2:0]==3'b100);
            end
            4: begin
               qvGrantReg[4] <= qArbitEnable && (qvRequest[4:4]==1'b1   );
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:4]==2'b10  );
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:4]==3'b100 );
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:4]==4'b1000);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[7:4]==4'b0000) && (qvRequest[0:0]==1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[7:4]==4'b0000) && (qvRequest[1:0]==2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[7:4]==4'b0000) && (qvRequest[2:0]==3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[7:4]==4'b0000) && (qvRequest[3:0]==4'b1000);
            end
            5: begin
               qvGrantReg[5] <= qArbitEnable && (qvRequest[5:5]==1'b1  );
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:5]==2'b10 );
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:5]==3'b100);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[7:5]==3'b000) && (qvRequest[0:0]==1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[7:5]==3'b000) && (qvRequest[1:0]==2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[7:5]==3'b000) && (qvRequest[2:0]==3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[7:5]==3'b000) && (qvRequest[3:0]==4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[7:5]==3'b000) && (qvRequest[4:0]==5'b10000);
            end
            6: begin
               qvGrantReg[6] <= qArbitEnable && (qvRequest[6:6]==1'b1 );
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7:6]==2'b10);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[7:6]==2'b00) && (qvRequest[0:0]==1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[7:6]==2'b00) && (qvRequest[1:0]==2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[7:6]==2'b00) && (qvRequest[2:0]==3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[7:6]==2'b00) && (qvRequest[3:0]==4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[7:6]==2'b00) && (qvRequest[4:0]==5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[7:6]==2'b00) && (qvRequest[5:0]==6'b100000);
            end
            default: begin
               qvGrantReg[7] <= qArbitEnable && (qvRequest[7]==1'b1);
               qvGrantReg[0] <= qArbitEnable && (qvRequest[7]==1'b0) && (qvRequest[0:0]==1'b1);
               qvGrantReg[1] <= qArbitEnable && (qvRequest[7]==1'b0) && (qvRequest[1:0]==2'b10);
               qvGrantReg[2] <= qArbitEnable && (qvRequest[7]==1'b0) && (qvRequest[2:0]==3'b100);
               qvGrantReg[3] <= qArbitEnable && (qvRequest[7]==1'b0) && (qvRequest[3:0]==4'b1000);
               qvGrantReg[4] <= qArbitEnable && (qvRequest[7]==1'b0) && (qvRequest[4:0]==5'b10000);
               qvGrantReg[5] <= qArbitEnable && (qvRequest[7]==1'b0) && (qvRequest[5:0]==6'b100000);
               qvGrantReg[6] <= qArbitEnable && (qvRequest[7]==1'b0) && (qvRequest[6:0]==7'b1000000);
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
         qvNextRoundStartIndex <= qvGrantIndex + 1;
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
         8'b00000001:    qvGrantIndex <= 0;
         8'b00000010:    qvGrantIndex <= 1;
         8'b00000100:    qvGrantIndex <= 2;
         8'b00001000:    qvGrantIndex <= 3;
         8'b00010000:    qvGrantIndex <= 4;
         8'b00100000:    qvGrantIndex <= 5;
         8'b01000000:    qvGrantIndex <= 6;
         8'b10000000:    qvGrantIndex <= 7;
         default:        qvGrantIndex<= qvGrantIndex;
      endcase
   end


endmodule

