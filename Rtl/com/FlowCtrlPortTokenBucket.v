/****************************************************************
*Company:  CETC54
*Engineer: liyuan

*Create Date   : Monday, the 12 of June, 2017  14:47:37
*Design Name   :
*Module Name   : FlowCtrlPortTokenBucket.v
*Project Name  :
*Target Devices: C5
*Tool versions : Quartusii 15.0
*Description   :  
*Revision:     : 1.0.0
*Revision 0.01 - File Created
*Additional Comments: 
*Modification Record :
*****************************************************************/


// synopsys translate_off
`timescale 1ns/1ns
// synopsys translate_on
module FlowCtrlPortTokenBucket(
   input  wire Rst_n,
   input  wire SysClk,
   input  wire [7:0] TokenNum,
   input  wire FetchTokenEn,
   input  wire flow_en,
   input  wire PutTokenEn,
   output wire TokenFull,
   output wire TokenEmpty
);

///////////////////////////////Signal Define/////////////////////////////////
   localparam TOKEN_BUCKET_CAP = 16;  //Default : Opposite Buffer-- 4*53*8 Bit , 4 ATM cell Threhold

   //wire flow_en;
   
   wire [7:0] TokenNumCfg;
   reg  [7:0] TokenCnt;

/////////////////////////////////////////////////////////////////////////////

  assign TokenNumCfg = (TokenNum == 0)? TOKEN_BUCKET_CAP : TokenNum;
  //assign flow_en = 1'b1;

  always@(negedge Rst_n or posedge SysClk) begin
  	if(!Rst_n)
  	  TokenCnt<=8'h00;
  	else
      if(!flow_en)
  	     TokenCnt<=TokenNumCfg;
      else if(flow_en) begin
      	if(PutTokenEn & (!FetchTokenEn))
      	  TokenCnt<=(TokenCnt >= TokenNumCfg)? TokenCnt : (TokenCnt + 1'b1);
      	else if((!PutTokenEn) & (FetchTokenEn))
      	  TokenCnt<=(TokenCnt == 8'h00)? 8'h00 : (TokenCnt - 1'b1);
      	else 
      	  TokenCnt<=TokenCnt;
      end  	     
  end
/////////////////////////////////////////////////////////////////////////////
  assign TokenFull  = (TokenCnt == TokenNumCfg);
  assign TokenEmpty = (TokenCnt == 8'h00);
/////////////////////////////////////////////////////////////////////////////
endmodule
