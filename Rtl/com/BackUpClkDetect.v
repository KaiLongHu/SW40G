/****************************************************************
*Company:  CETC54
*Engineer: liyuan

*Create Date   : Sunday, the 09 of July, 2017  19:31:43
*Design Name   :
*Module Name   : BackUpClkDetect.v
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
module BackUpClkDetect(
  input wire RstSysN,
  input wire SysClk,
  input wire BackUpClk,
  output wire Clock_Lost
);
/////////////////////////////////////////////////////////////////////////////
  reg [2:0]  ShiftClkReg;
  reg [15:0] PosEgdCnt;
  reg [15:0] PosEgdCntLock;
  reg [15:0] SysCnt;  
  reg [1:0]  DiffCnt;
/////////////////////////////////////////////////////////////////////////////
  always@(negedge RstSysN or posedge SysClk) begin
    if(!RstSysN)
	   ShiftClkReg<=3'b000;
	 else
	   ShiftClkReg<={ShiftClkReg[1:0], BackUpClk}; 
  end
  
  always@(negedge RstSysN or posedge SysClk) begin
    if(!RstSysN)
	   PosEgdCnt<=16'h0000;
	 else
	   PosEgdCnt<=(ShiftClkReg[2:1] == 2'b01)? (PosEgdCnt + 1'b1) : PosEgdCnt;   
  end
  
  always@(negedge RstSysN or posedge SysClk) begin
    if(!RstSysN) begin
	    PosEgdCntLock<=16'h0000;
		 SysCnt<=16'h0000;
		 DiffCnt<=2'b00;
	 end
	 else begin
 	    PosEgdCntLock<=(SysCnt == 16'h0000)? PosEgdCnt : PosEgdCntLock;
		  SysCnt<=SysCnt + 1'b1;
		 
		if(SysCnt ==16'h0000) begin 
		  if(PosEgdCntLock != PosEgdCnt)
		    DiffCnt<=2'b00;
		  else  begin
		    if(DiffCnt == 2'b11)
			  DiffCnt<=2'b11; 
			 else
		     DiffCnt<=DiffCnt + 1'b1;
			end 
		 end
		 
	 end
  end
  
  assign Clock_Lost = (DiffCnt == 2'b11);
/////////////////////////////////////////////////////////////////////////////
endmodule
