/****************************************************************
*Company:  CETC54
*Engineer: liyuan

*Create Date   : Wednesday, the 17 of April, 2019  10:01:49
*Design Name   :
*Module Name   : Glb_Rst_Gen.v
*Project Name  :
*Target Devices: C5
*Tool versions : Quartus II 15.0
*Description   :  
*Revision:     : 1.0.0
*Revision 0.01 - File Created
*Additional Comments: 
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// clk_out1____25.000_____49.500______50.0______175.402_____98.575
// clk_out2___100.000______0.000______50.0______130.958_____98.575
// clk_out3___125.000______0.000______50.0______125.247_____98.575
// clk_out4___200.000______0.000______50.0______114.829_____98.575
// clk_out5___125.000______0.000______50.0______125.247_____98.575


*Modification Record :
*****************************************************************/


// synopsys translate_off
`timescale 1ns/1ns
// synopsys translate_on
module Glb_Rst_Gen (
   input  wire Hard_Rst_n,
   input  wire Soft_Rst_n,
   input  wire RefClk100M,
   //input  wire RefClk32M,
   input  wire DDR3InitComplete,
   output wire RstExtGlb_n,
   output wire RstSys_n,
   output wire CpuClk,
   output wire Clk100MOut,
   output wire Clk125MBfg,
   output wire ClkPh125M,
   output wire Clk200M,
   output wire Clk50M,
   output wire Clk10M,
   output wire Clk8M,
   
   input  wire Watchdog_Control,   // 0 --- Watchdog DisAble; 1 ----- Watchdog Enable
   input  wire Feed_Watchdog,     
   output wire PllLock,
   
	 output wire LS2K_SYS_RST        ,
	 output wire ZX5201_RSTN_2V5     ,
	 output wire VSC8512_PLL_RESET   ,
	 output wire VSC8512_RESET       ,
	 output wire CTC5160_RST_POR_B   ,
	 input  wire CTC5160_FUSE_DONE   ,
	 output wire CTC5160_RST_PCIE_B  ,
	 output wire CTC5160_RST_B       
);

///////////////////////////////Signal Define/////////////////////////////////
   localparam TIME200MS = 32'h017D7840;
   localparam TIME500MS = 32'h03B9ACA0;
   localparam TIME600MS = 32'h04786830;
   localparam TIME900MS = 32'h06B49D20;
   localparam TIME1400MS = 32'h0A6E49C0;
   localparam TIME1700MS = 32'h0CAA7E20;           
   localparam TIME6S    = 32'h2CB4_1780;

   localparam IDLE   = 0;
   localparam RST_AU53 = 1;
   localparam RST_S  = 2;
   localparam WAIT_RST_POR_B = 3;
   localparam RST_POR_B   = 4;
   localparam RST_PCIE_B  = 5;
   localparam RST_8512PLL = 6;
   localparam RST_CORE = 7;     
   localparam WAIT_S = 8;
   localparam WORK_S = 9;
   
   reg [9:0] CurState;
   reg [9:0] NextState;   
   
   wire ExrRst_n;
 
   wire ExrSysRst_n;
   wire DevReady;
   reg  [31:0] TimeCnt;
  
   reg  Watchdog_ControlD0;
   reg  Watchdog_ControlD1;
   
   wire RstCpu_n;
   reg  Feed_WatchdogD0;
   reg  Feed_WatchdogD1;
   reg  WatchdogConv;
   reg  WatchdogConvD0;
   reg  WatchdogConvD1;
   wire WatchdogXor;
   
   reg  Soft_RstD0_n;
   reg  Soft_RstD1_n;
   wire PllLock0;
   wire PllLock1;

   
  // reg CTC5160_FUSE_DONED0;
   
   assign ExrRst_n = Hard_Rst_n;
   assign PllLock  = PllLock0;
   assign DevReady = (DDR3InitComplete && PllLock);
////////////////////////////////////////////////////////////////////////////
   /*BUFGMUX  BUFGMUX_Inst(
      .O(Clk8M192),
      .I0(Clk8M192Out),
      .I1(BackUpClk),
      .S(~ClkSelect)
   );*/

/////////////////////////////////////////////////////////////////////////////
  ResetSync # ( .RESET_SYNC_STAGES(8) )
  SysResetn(
    .qnReset(ExrRst_n),
    .Clock(RefClk100M),
    .qnResetSync(ExrSysRst_n)
 );
 
 ResetSync # ( .RESET_SYNC_STAGES(8) )
  CpuResetn(
    .qnReset(ExrRst_n),
    .Clock(CpuClk),
    .qnResetSync(RstCpu_n)
 );

///////////////////////////////////////////////////////////////////////////// 
 ClockGen ClockGenInst(
  // Clock out ports
  .clk_out1(Clk100MOut),
  .clk_out2(CpuClk),
  .clk_out3(Clk125MBfg),
  .clk_out4(Clk200M),
  .clk_out5(Clk50M),
  .clk_out6(ClkPh125M),
  .clk_out7(Clk10M),
  // Status and control signals
  .reset(1'b0),   //~RstExtGlb_n
  .locked(PllLock0),
 // Clock in ports
  .clk_in1(RefClk100M)
 );
 
/* Clk8MGen Clk8MGenInst
 (
  // Clock out ports
  .clk_out1(Clk8M),
  // Status and control signals
  .reset(1'b0),
  .locked(),
 // Clock in ports
  .clk_in1(RefClk32M)
 );*/
// clk_wiz_0 clk_wiz_0_Inst( 
//   .clk_out1(Clk8M),
//   .reset(1'b0),
//   .locked(PllLock1),
//   .clk_in1(RefClk100M)
//);
 
/////////////////////////////////////////////////////////////////////////////
//Soft_Rst_n
  always@( posedge RefClk100M) begin
  	Soft_RstD0_n <= Soft_Rst_n;
  	Soft_RstD1_n <= Soft_RstD0_n;
  end
  
///////////////////////////////////////////////////////////////////
  always@(negedge ExrSysRst_n or posedge RefClk100M) begin
  	if(~ExrSysRst_n) begin
  	    CurState<= 0;
  	    CurState[IDLE]<= 1;
  	 end
  	else
  	   CurState<= NextState;
  end

  
  always@* begin
  	NextState = 0;
  	
  	case(1'b1)
  		CurState[IDLE]: begin
  			  NextState[RST_AU53] = 1;
  			end
  	  
  	  CurState[RST_AU53]: begin
  	  	if(TimeCnt == (TIME200MS - 1))
  	  	  NextState[RST_S] = 1;
  	  	else
  	  	  NextState[RST_AU53]  = 1;
  	  end
  	  	  
  	  CurState[RST_S]: begin
  	  	if(TimeCnt == (TIME500MS - 1))
  	  	  NextState[WAIT_RST_POR_B] = 1;
  	  	else
  	  	  NextState[RST_S]  = 1;
  	  end
  	  
  	  CurState[WAIT_RST_POR_B]: begin  	  
  	  	if(TimeCnt == (TIME600MS - 1))
  	  	  NextState[RST_POR_B] = 1;
  	  	else
  	  	  NextState[WAIT_RST_POR_B]  = 1;
  	  end  
  	  
  	  CurState[RST_POR_B]: begin  	  
  	  	if(CTC5160_FUSE_DONE)
  	  	  NextState[RST_PCIE_B] = 1;
  	  	else
  	  	  NextState[RST_POR_B]  = 1;	  	  
  	  end   	  	  

  	  CurState[RST_PCIE_B]: begin  	  
  	  	if(TimeCnt == (TIME900MS - 1))
  	  	  NextState[RST_8512PLL] = 1;
  	  	else
  	  	  NextState[RST_PCIE_B]  = 1;	  	  
  	  end 

  	  CurState[RST_8512PLL]: begin  	  
  	  	if(TimeCnt == (TIME1400MS - 1))
  	  	  NextState[RST_CORE] = 1;
  	  	else
  	  	  NextState[RST_8512PLL]  = 1;	  	  
  	  end

  	  CurState[RST_CORE]: begin  	  
  	  	if(TimeCnt == (TIME1700MS - 1))
  	  	  NextState[WAIT_S] = 1;
  	  	else
  	  	  NextState[RST_CORE]  = 1;	  	  
  	  end
  	  
  	  CurState[WAIT_S]: begin
  	  	if(DevReady)
  	  	  NextState[WORK_S] = 1;
  	  	else
  	  	  NextState[WAIT_S] = 1;
  	  end
  	  
  	  CurState[WORK_S]: begin
  	  	if((TimeCnt>=(TIME6S - 1)) || (~Soft_RstD1_n))
  	  	  NextState[IDLE] = 1;
  	  	else
  	  	  NextState[WORK_S] = 1;
  	  end
  	  
  	  default: begin
  	  	  NextState[IDLE] = 1;	  	
  	  end
  	  
  		
  	endcase
  	
  end
  
 
  assign RstExtGlb_n = ~(CurState[IDLE] || CurState[RST_AU53]|| CurState[RST_S]);
  assign RstSys_n = ~ (CurState[IDLE]|| CurState[RST_AU53] || CurState[RST_S] || CurState[WAIT_RST_POR_B]|| CurState[RST_POR_B] || CurState[RST_PCIE_B] || CurState[RST_8512PLL] || CurState[RST_CORE] || CurState[WAIT_S]);

  assign CTC5160_RST_POR_B = (CurState[WAIT_RST_POR_B] || CurState[RST_POR_B]);
  assign CTC5160_RST_PCIE_B = ~(CurState[IDLE] || CurState[RST_AU53]|| CurState[RST_S] || CurState[WAIT_RST_POR_B]|| CurState[RST_POR_B] || CurState[RST_PCIE_B]);
  assign VSC8512_PLL_RESET = (CurState[IDLE] || CurState[RST_AU53]|| CurState[RST_S] || CurState[WAIT_RST_POR_B]|| CurState[RST_POR_B] || CurState[RST_PCIE_B] || CurState[RST_8512PLL]);  
  assign CTC5160_RST_B  = ~(CurState[IDLE] || CurState[RST_AU53]|| CurState[RST_S] || CurState[WAIT_RST_POR_B]|| CurState[RST_POR_B] || CurState[RST_PCIE_B] || CurState[RST_8512PLL] || CurState[RST_CORE]);  
  assign VSC8512_RESET   = CTC5160_RST_B;
  assign LS2K_SYS_RST    = CTC5160_RST_B;
  assign ZX5201_RSTN_2V5 = CTC5160_RST_B;

  
  
  //assign ClkSelect  = (CurState[IDLE] || CurState[RST_S] || CurState[WAIT_S] || Clock_Lost);
////////////////////////////////////////////////////////////////////////////////
   always@(negedge RstCpu_n or posedge CpuClk) begin
   	if(~RstCpu_n) begin
   	  Feed_WatchdogD0<= 1'b0;
      Feed_WatchdogD1<= 1'b0;
      WatchdogConv   <= 1'b0;
     end
   	else begin
   		 Feed_WatchdogD0<=Feed_Watchdog;
   		 Feed_WatchdogD1<=Feed_WatchdogD0;
   		 WatchdogConv   <=(Feed_WatchdogD0 && (~Feed_WatchdogD1))? (~WatchdogConv) : WatchdogConv;
   	 end
   end
   
   always@(posedge RefClk100M) begin
     WatchdogConvD0<= WatchdogConv;
     WatchdogConvD1<= WatchdogConvD0;
   end
   
   assign WatchdogXor = (WatchdogConvD0 ^ WatchdogConvD1);
////////////////////////////////////////////////////////////////////////////////
//   always@(posedge RefClk100M) begin
//     CTC5160_FUSE_DONED0 <= CTC5160_FUSE_DONE;
//   end
   
//   assign FUSE_DONE = (~CTC5160_FUSE_DONED0) &&(CTC5160_FUSE_DONE);   
////////////////////////////////////////////////////////////////////////////////
  always@(negedge ExrSysRst_n or posedge RefClk100M) begin
  	if(~ExrSysRst_n) begin 
  	  TimeCnt<= 32'h0000_0000;
  	  Watchdog_ControlD0<= 1'b0;
      Watchdog_ControlD1<= 1'b0;
  	 end
  	else begin
  	  Watchdog_ControlD0<=Watchdog_Control;
  	  Watchdog_ControlD1<=Watchdog_ControlD0;
  	  
  	  //TimeCnt<=(CurState[RST_S])? (TimeCnt + 1'b1) : 32'h0000_0000;
    
      if(CurState[IDLE] || CurState[RST_AU53]|| CurState[RST_S] || CurState[WAIT_RST_POR_B]|| CurState[RST_POR_B] || CurState[RST_PCIE_B] || CurState[RST_8512PLL] || CurState[RST_CORE])
        TimeCnt<= TimeCnt + 1'b1;
      else if(CurState[WORK_S] && Watchdog_ControlD1) begin
         if(WatchdogXor) 
            TimeCnt<= 32'h0000_0000;
         else
            TimeCnt<=TimeCnt + 1'b1;  
       end
      else
         TimeCnt<= 32'h0000_0000;
    
    end
  end
///////////////////////////////////////////////////////////////////////////
//  reg [22:0] temp;

  //always@(posedge Clk25MOut) begin
  	//  temp<=temp+23'd1;
  //end
  //assign leddrv = temp[22];
/////////////////////////////////////////////////////////////////////////////
/*  Led_Ctrl #(
  .FLASH_INTERVAL(FLASH_INTERVAL), //ns
  .TIME_CYCLE(TIME_CYCLE)         //ns
  )Run_Ctrl_Inst(
  .RstSys_n(ExrSysRst_n),
  .SysClk(RefClk100M),
  .LedCfg(Run_Cfg),  // 0 --- On; 1 ---- Off; 2 ---- Flash 
  .LedDrv(Run_Led)
);

  Led_Ctrl #(
  .FLASH_INTERVAL(FLASH_INTERVAL), //ns
  .TIME_CYCLE(TIME_CYCLE)         //ns
  )Alarm_Ctrl_Inst(
  .RstSys_n(ExrSysRst_n),
  .SysClk(RefClk100M),
  .LedCfg(Alarm_Cfg),  // 0 --- On; 1 ---- Off; 2 ---- Flash 
  .LedDrv(Alarm_Led)
);*/
//////////////////////////////////////////////////////////////////////////////
  /*BackUpClkDetect BackUpClkDetect_Inst(
  .RstSysN(RstSys_n),
  .SysClk(Clk100MOut),
  .BackUpClk(BackUpClk),
  .Clock_Lost(Clock_Lost)
 );*/
//////////////////////////////////////////////////////////////////////////////
endmodule
