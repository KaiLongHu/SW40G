/****************************************************************
*Company:  CETC54
*Engineer: liyuan

*Create Date   : Tuesday, the 07 of May, 2019  09:42:45
*Design Name   :
*Module Name   : Led_Ctrl.v
*Project Name  :
*Target Devices: C5
*Tool versions : Quartus II 15.0
*Description   :  
*Revision:     : 1.0.0
*Revision 0.01 - File Created
*Additional Comments: 
*Modification Record :
*****************************************************************/


// synopsys translate_off
`timescale 1ns/1ns
// synopsys translate_on
module Led_Ctrl #(
  parameter
  FLASH_INTERVAL = 500000000, //ns
  TIME_CYCLE     = 10         //ns
)(
  input  wire RstSys_n,
  input  wire SysClk,
  input  wire [1:0] LedCfg,  // 0 --- On; 1 ---- Off; 2 ---- Flash 
  output reg  LedDrv
);

///////////////////////////////Signal Define/////////////////////////////////
   localparam MAX_CONV_CNT = (FLASH_INTERVAL/TIME_CYCLE);
   
   reg [31:0] LenTimeCnt;
   reg [1:0] LedCfgD0;
   reg [1:0] LedCfgD1;
   reg LedConv; 
/////////////////////////////////////////////////////////////////////////////
   always@(negedge RstSys_n or posedge SysClk ) begin
     if(~RstSys_n) begin
       LenTimeCnt <= 32'h0;
       LedConv    <= 1'b0;
      end
     else begin 
     	  
     	 LedConv    <=(LenTimeCnt == MAX_CONV_CNT)? (~LedConv) :  LedConv;
     	
       if(LedCfgD1 ==2'b10)
        LenTimeCnt <=(LenTimeCnt>=MAX_CONV_CNT)? 32'h0 : (LenTimeCnt + 1'b1);
       else 
        LenTimeCnt <= 32'h0;
      end
   end
/////////////////////////////////////////////////////////////////////////////
  always@(negedge RstSys_n or posedge SysClk ) begin
     if(~RstSys_n) begin
       LedCfgD0 <= 2'h0;
       LedCfgD1 <= 2'h0;
      end
     else begin
       LedCfgD0 <= LedCfg;
       LedCfgD1 <= LedCfgD0;
     end
   end
/////////////////////////////////////////////////////////////////////////////
    always@* begin
    	case(LedCfgD1)
    		2'b00: LedDrv = 1'b0;  //On
    		2'b01: LedDrv = 1'b1;  // Off
    		2'b10: LedDrv = LedConv;
    		default: LedDrv= 1'b1;
    	endcase
    end
/////////////////////////////////////////////////////////////////////////////

endmodule
