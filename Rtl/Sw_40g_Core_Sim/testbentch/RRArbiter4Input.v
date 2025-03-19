
/////////////////////////////////////////////////////////////////////////////////////////////////
// 
// Create Date:    14:16:37 9/2/2016 
// Design Name:    
// Module Name:    RRArbiter4Input 
// Project Name:   
// Target Devices: 
// Tool versions: 
//
// Description: 
//    Round Robin�����ٲ������������4������qvRequest������ѯ�ٲã��������qvGrant
//
//
// Additional Comments: 
//    Round Robin�����ٲ����ٲó������Ҫһ��ʱ�����ڣ��������������ٲ�֮����Ҫһ��ʱ�����ڼ����    
//    clock:             __    __    __    __    __    __    __    __    __
//                    __|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__
//    qvRequest :           _____        _____        
//                    _____/     \______/     \_______________________________
//                         \_____/      \_____/
//    qvGrant:                   _____                
//                    __________/     \_______________________________________
//                              \_____/  
//    qvGrantIndex:              _____                
//                    __________/     \_______________________________________
//                              \_____/  
//
//////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module RRArbiter4Input(
   input  wire       clock,
   input  wire       nReset,
   input  wire       qArbitEnable,
   input  wire [3:0] qvRequest,          //����
   output reg  [3:0] qvGrant = 0,        //��Ȩ
   output reg  [1:0] qvGrantIndex = 0    //��Ȩ�ŵ��±�
);
   
   reg   [1:0] qvNextRoundStartIndex = 0;       //��¼һ���ٲ���ʼ���
   
   //vGrant
   reg   [3:0] vGrant;
   
   always @ ( posedge clock ) begin
   	if(~nReset) begin
   	   vGrant<= 0;
   	 end
   	else begin
      case ( qvNextRoundStartIndex )
         2'b00: begin
            vGrant[0] <= qArbitEnable && qvRequest[0];
            vGrant[1] <= qArbitEnable && ~qvRequest[0] &&  qvRequest[1];
            vGrant[2] <= qArbitEnable && ~qvRequest[0] && ~qvRequest[1] &&  qvRequest[2];
            vGrant[3] <= qArbitEnable && ~qvRequest[0] && ~qvRequest[1] && ~qvRequest[2] && qvRequest[3];
         end
         2'b01: begin
            vGrant[1] <= qArbitEnable &&  qvRequest[1];
            vGrant[2] <= qArbitEnable && ~qvRequest[1] &&  qvRequest[2];
            vGrant[3] <= qArbitEnable && ~qvRequest[1] && ~qvRequest[2] &&  qvRequest[3];
            vGrant[0] <= qArbitEnable && ~qvRequest[1] && ~qvRequest[2] && ~qvRequest[3] && qvRequest[0];
         end
         2'b10: begin
            vGrant[2] <= qArbitEnable &&  qvRequest[2];
            vGrant[3] <= qArbitEnable && ~qvRequest[2] &&  qvRequest[3];
            vGrant[0] <= qArbitEnable && ~qvRequest[2] && ~qvRequest[3] &&  qvRequest[0];
            vGrant[1] <= qArbitEnable && ~qvRequest[2] && ~qvRequest[3] && ~qvRequest[0] && qvRequest[1];
         end
         default: begin
            vGrant[3] <= qArbitEnable &&  qvRequest[3];
            vGrant[0] <= qArbitEnable && ~qvRequest[3] &&  qvRequest[0];
            vGrant[1] <= qArbitEnable && ~qvRequest[3] && ~qvRequest[0] &&  qvRequest[1];
            vGrant[2] <= qArbitEnable && ~qvRequest[3] && ~qvRequest[0] && ~qvRequest[1] && qvRequest[2];      
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
   
   
//////////////////////////////////////////////// �˿���� ///////////////////////////////
   //qvGrant
   always @ ( posedge clock ) begin
      qvGrant <= vGrant;
   end
   
   //qvGrantIndex
   always @ ( posedge clock ) begin
      case( vGrant )
         4'b0001:    begin
            qvGrantIndex <= 0;
         end
         4'b0010:    begin
            qvGrantIndex <= 1;
         end
         4'b0100:    begin
            qvGrantIndex <= 2;
         end
         4'b1000:    begin
            qvGrantIndex <= 3;
         end
         default: qvGrantIndex<= qvGrantIndex;
      endcase 
   end
   
   
endmodule //RRArbiter4Input

