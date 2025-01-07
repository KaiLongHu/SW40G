/****************************************************************
*Company:  CETC54
*Engineer: 

*Create Date   : Wednesday, the 22 of September, 2021  10:06:04
*Design Name   :
*Module Name   : AxiStream2UserIfcBridge.v
*Project Name  :
*Target Devices: 
*Tool versions : vivado 2018
*Description   :  
*Revision:     : 1.0.0
*Revision 0.01 - File Created
*Additional Comments: 
*Modification Record :
*****************************************************************/


// synopsys translate_off
`timescale 1ns/1ns
// synopsys translate_on
module AxiStream2UserIfc64to128Bridge (
 input  wire Rst_n,
 input  wire FifoRst_n,

 input  wire [63:0] rx_axis_tdata,
 input  wire [7:0] rx_axis_tkeep,
 input  wire rx_axis_tvalid,
 input  wire rx_axis_tlast,
 output wire rx_axis_tready,
 input  wire rx_axis_uclk,

 input  wire tx_axis_uclk,
 input  wire tx_axis_tready,
 output reg  tx_axis_tvalid,    
 output reg  tx_axis_tlast,
 output reg  [127:0] tx_axis_tdata,
 output reg  [15:0] tx_axis_tkeep,    
 
 input  wire CntClr,
 output reg  [31:0] RxPkg_Cnt,
 output reg  [31:0] TxPkg_Cnt 
);

///////////////////////////////Signal Define/////////////////////////////////
 wire RxAxis_Rstn;
 wire TxAxis_Rstn;
 
 localparam IDLE = 0;
 localparam RX_STATE = 1;
 //localparam NOP = 2;

 reg [1:0] CurState;
 reg [1:0] NextState; 

 reg  WrDFifoEn;
 reg  [129:0] WrDFifoData;
 wire RdDFifoEn;
 wire [129:0] RdDFifoData;
 wire RdDFifoEmpty;
 wire WrDFifoAlmostFull;

 reg  WrCFifoEn;
 reg  [31:0] WrCFifoData;
 reg  RdCFifoEn;
 wire [31:0] RdCFifoData;
 wire RdCFifoEmpty;
 wire WrCFifoAlmostFull;
 
 reg  [15:0] qWordCnt; 
 wire [15:0] qByteCnt;
 
 wire [63:0] Rx_Data;
 
 wire rx_axis_treadyTemp;
 reg  rx_axis_treadyLck;

 reg  FifoRst_nD0;
 reg  FifoRst_nD1;
 
////////////////////////////////////////////////////////////////////////////////
  always@(posedge rx_axis_uclk)  begin
   FifoRst_nD0 <= FifoRst_n;
   FifoRst_nD1 <= FifoRst_nD0;
  end

/////////////////////////////////////////////////////////////////////////////
  ResetSync # (.RESET_SYNC_STAGES(8) )
  U_ResetSync(
   .qnReset(Rst_n),
   .Clock(rx_axis_uclk),
   .qnResetSync(RxAxis_Rstn)
 );
 
  ResetSync # (.RESET_SYNC_STAGES(8) )
  U_ResetSync1(
   .qnReset(Rst_n),
   .Clock(tx_axis_uclk),
   .qnResetSync(TxAxis_Rstn)
 ); 
/////////////////////////////////////////////////////////////////////////////

    assign rx_axis_tready = (CurState[IDLE] && rx_axis_treadyTemp) || rx_axis_treadyLck;

    always@(negedge RxAxis_Rstn or posedge rx_axis_uclk) begin
    	if(~RxAxis_Rstn)
    	  rx_axis_treadyLck <= 0;
    	else
    	  rx_axis_treadyLck <= (CurState[IDLE])? rx_axis_treadyTemp : rx_axis_treadyLck;
    end

    always@(negedge RxAxis_Rstn or posedge rx_axis_uclk) begin
    	if(~RxAxis_Rstn) begin
    	  CurState<= 0;
    	  CurState[IDLE] <= 1;
    	end
    	else
    	  CurState<= NextState;
    end
    
    assign rx_axis_treadyTemp = ((~WrDFifoAlmostFull) && (~WrCFifoAlmostFull));
    
    always@* begin
    	NextState = 0;
    	
    	case(1'b1)
    		CurState[IDLE]: begin
    			if(rx_axis_treadyTemp && rx_axis_tvalid)
    			  NextState[RX_STATE] = 1;
    			else
    			  NextState[IDLE] = 1;
    		end
    	
    		CurState[RX_STATE]: begin
    		  if(rx_axis_tvalid && rx_axis_tlast)
    		    NextState[IDLE] = 1;
    		  else
    		    NextState[RX_STATE] = 1;
    	  end

    	  default: NextState[IDLE] = 1;    	  	
    	endcase
    	
    end
/////////////////////////////////////////////////////////////////////
  always@(negedge RxAxis_Rstn or posedge rx_axis_uclk) begin
  	if(~RxAxis_Rstn) begin
  		 qWordCnt <= 16'h0000;
    end
  	else begin
  		 qWordCnt	<= (CurState[RX_STATE])? (qWordCnt + 1'b1) : 16'h0000;
   	end
  end	
  
  assign Flag = ~(qWordCnt[0]);
  assign qByteCnt = {(qWordCnt[12:0] + 2),3'b000};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  wire WrSopBit;
  wire WrEopBit;
  reg  WrSopBitD0; 

  assign  WrSopBit = (CurState[IDLE] && NextState[RX_STATE]);
  assign  WrEopBit = rx_axis_tlast;
  assign  Rx_Data  = {rx_axis_tdata[7:0],rx_axis_tdata[15:8],rx_axis_tdata[23:16], rx_axis_tdata[31:24],rx_axis_tdata[39:32],rx_axis_tdata[47:40],rx_axis_tdata[55:48],rx_axis_tdata[63:56]};

  always@(negedge RxAxis_Rstn or posedge rx_axis_uclk) begin
  	if(~RxAxis_Rstn) begin
  	  WrDFifoEn<=1'b0;
      WrDFifoData<=129'h0;
      WrCFifoEn<=1'b0;
      WrCFifoData<=32'h0;
      WrSopBitD0<= 1'b0;
    end
  	else begin
  	  WrDFifoEn <=(((CurState[IDLE] && NextState[RX_STATE]) ||CurState[RX_STATE]) && rx_axis_tvalid);
   	  
   	  if(CurState[RX_STATE] && rx_axis_tlast)
   	    WrDFifoData <=(~Flag)? {WrSopBit, WrEopBit, Rx_Data, 64'h0} : {WrSopBit, WrEopBit, WrDFifoData[127:64], Rx_Data};
   	  else if(CurState[IDLE] && NextState[RX_STATE]) begin
   	  	WrDFifoData[129] <= WrSopBitD0;
   	  	WrDFifoData[128] <= 1'b0;
   	    WrDFifoData[127:64] <= Rx_Data;
   	    WrDFifoData[63:0] <= 64'h0;
   	  end
   	  else begin
   	  	WrDFifoData[129]<=  WrSopBitD0;
   	  	WrDFifoData[128]<=  1'b0;
   	    WrDFifoData[127:64] <= (~Flag)?  Rx_Data : WrDFifoData[127:64];
   	    WrDFifoData[63:0]  <= (Flag)?  Rx_Data : WrDFifoData[63:0];
   	  end

  	  WrCFifoEn <=(CurState[RX_STATE] && NextState[IDLE]);
   	 
   	 if(CurState[RX_STATE] && NextState[IDLE]) begin
   	   case(rx_axis_tkeep)
   	     8'h01: begin
   	         WrCFifoData<= (~Flag)? {(qByteCnt - 7),rx_axis_tkeep,8'h00} : {(qByteCnt - 7),8'hff,rx_axis_tkeep};
   	         end
   	     8'h03: begin
   	         WrCFifoData<= (~Flag)? {(qByteCnt - 6),rx_axis_tkeep,8'h00} : {(qByteCnt - 6),8'hff,rx_axis_tkeep};
   	         end  	        
   	     8'h07: begin
   	         WrCFifoData<= (~Flag)? {(qByteCnt - 5),rx_axis_tkeep,8'h00} : {(qByteCnt - 5),8'hff,rx_axis_tkeep};
   	         end 	       
   	     8'h0f: begin 
   	         WrCFifoData<= (~Flag)? {(qByteCnt - 4),rx_axis_tkeep,8'h00} : {(qByteCnt - 4),8'hff,rx_axis_tkeep};
   	         end
   	     8'h1f: begin
   	         WrCFifoData<= (~Flag)? {(qByteCnt - 3),rx_axis_tkeep,8'h00} : {(qByteCnt - 3),8'hff,rx_axis_tkeep};
   	         end
   	     8'h3f: begin 
   	         WrCFifoData<= (~Flag)? {(qByteCnt - 2),rx_axis_tkeep,8'h00} : {(qByteCnt - 2),8'hff,rx_axis_tkeep};
   	         end   	            	     
   	     8'h7f: begin 
   	         WrCFifoData<= (~Flag)? {(qByteCnt - 1),rx_axis_tkeep,8'h00} : {(qByteCnt - 1),8'hff,rx_axis_tkeep};
   	       end
   	     8'hff: begin 
   	         WrCFifoData<= (~Flag)? {qByteCnt,rx_axis_tkeep,8'h00} : {qByteCnt,8'hff,rx_axis_tkeep};	               
   	         end
   	     default: begin
   	         WrCFifoData<= 24'h0;
   	     end
   	          
   	   endcase	
   	 end
   	   
   	 else begin
           WrCFifoData<= 32'h0;
     end
 	    	 
    end 
  end
/////////////////////////////////////////////////////////////////////////////
  /*XBramDcAFifo #(
   .FIFO_WRITE_DEPTH(1024),
   .WRITE_DATA_WIDTH(130),
   .READ_DATA_WIDTH(130),
   .READ_MODE("fwft"),   // std
   .FIFO_MEMORY_TYPE("block"),  //  "auto"- Allow Vivado Synthesis to choose;  "block"- Block RAM FIFO  ; "distributed"- Distributed RAM FIFO   
   .FIFO_READ_LATENCY(0),
   .W_ALMOST_LEVEL(800)
 )Axi2UserDFifo(
   .rst(~RxAxis_Rstn),
   .wtx_axis_uclk(rx_axis_uclk), 
   .rd_clk(tx_axis_uclk), 
   .din(WrDFifoData), 
   .wr_en(WrDFifoEn), 
   .rd_en(RdDFifoEn),
   .dout(RdDFifoData), 
   .full(), 
   .empty(RdDFifoEmpty), 
   .prog_full(WrDFifoAlmostFull) 
 );*/
 
  AsynBlkfifo130x1024 Axi2UserDFifo(
   .rst(~FifoRst_nD1),
   .wtx_axis_uclk(rx_axis_uclk),
   .rd_clk(tx_axis_uclk),
   .din(WrDFifoData),
   .wr_en(WrDFifoEn),
   .rd_en(RdDFifoEn),
   .dout(RdDFifoData),
   .full(),
   .empty(RdDFifoEmpty),
   .prog_full(WrDFifoAlmostFull)
   );
    
 /*XBramDcAFifo #(
   .FIFO_WRITE_DEPTH(64),
   .WRITE_DATA_WIDTH(32),
   .READ_DATA_WIDTH(32),
   .READ_MODE("fwft"),   // std
   .FIFO_MEMORY_TYPE("block"),  //  "auto"- Allow Vivado Synthesis to choose;  "block"- Block RAM FIFO  ; "distributed"- Distributed RAM FIFO   
   .FIFO_READ_LATENCY(0),
   .W_ALMOST_LEVEL(50)
 )Axi2UserCFifo(
   .rst(~RxAxis_Rstn),
   .wtx_axis_uclk(rx_axis_uclk), 
   .rd_clk(tx_axis_uclk),
   .din(WrCFifoData), 
   .wr_en(WrCFifoEn), 
   .rd_en(RdCFifoEn),
   .dout(RdCFifoData), 
   .full(), 
   .empty(RdCFifoEmpty), 
   .prog_full(WrCFifoAlmostFull) 
 );*/
 
  AsynDisfifo32x256 Axi2UserCFifo(
   .rst(~FifoRst_nD1),
   .wtx_axis_uclk(rx_axis_uclk),
   .rd_clk(tx_axis_uclk),
   .din(WrCFifoData),
   .wr_en(WrCFifoEn),
   .rd_en(RdCFifoEn),
   .dout(RdCFifoData),
   .full(),
   .empty(RdCFifoEmpty),
   .prog_full(WrCFifoAlmostFull)
  );
 
/////////////////////////////////////////////////////////////////////////////
  localparam TX_IDLE = 0;
  localparam TX_RD   = 1;
  //localparam TX_NOP  = 2;
  
  reg  [1:0] TxCState;
  reg  [1:0] TxNState;
  wire SopBit;
  wire EopBit;
  reg  [15:0] KeepLock;
  reg  [15:0] ByteLenLck;
  
  assign SopBit = RdDFifoData[129];
  assign EopBit = RdDFifoData[128];

////////////////////////////////////////////////////////////////////////////
  always@(negedge TxAxis_Rstn or posedge tx_axis_uclk) begin
     if(~TxAxis_Rstn) begin
       TxCState<= 0;
       TxCState[TX_IDLE]<= 1;
      end
     else
       TxCState<= TxNState;
  end
  
  always@* begin
  	TxNState = 0;
  	
  	case(1'b1)
  		TxCState[TX_IDLE]: begin
  			if((~RdDFifoEmpty) && (~RdCFifoEmpty) && tx_axis_tready) 
  			   TxNState[TX_RD] = 1;
  			  else 
  			  TxNState[TX_IDLE] = 1;
  		end

  		TxCState[TX_RD]: begin
  			if(EopBit && tx_axis_tready)
  			  TxNState[TX_IDLE] = 1; 
  			else
  			  TxNState[TX_RD] = 1;
  		end
  		
  		// TxCState[TX_NOP]: begin
  		// 	TxNState[TX_IDLE] = 1;
  		// end
  		
  		default: begin
  			TxNState[TX_IDLE] = 1;
  		end
  		  		
  	endcase
  	
  end


/////////////////////////////////////////////////////////////////////////////
  assign RdDFifoEn = TxCState[TX_RD] && tx_axis_tready;

  always@(negedge TxAxis_Rstn or posedge tx_axis_uclk) begin
  	if(~TxAxis_Rstn) begin
  	   RdCFifoEn<=1'b0;
  	   KeepLock<= 16'h0;
  	   ByteLenLck <= 16'h0;  	   
  	 end
  	else begin
  	   RdCFifoEn<=(TxCState[TX_IDLE] && TxNState[TX_RD]);
  	   KeepLock <=(TxCState[TX_IDLE])? RdCFifoData[15:0] : KeepLock;
  	   ByteLenLck<= (TxCState[TX_IDLE])? RdCFifoData[31:16] : ByteLenLck;
  	 end
  end

/////////////////////////////////////////////////////////////////////////////
  
   always@(negedge TxAxis_Rstn or posedge tx_axis_uclk) begin
  	if(~TxAxis_Rstn) begin
       tx_axis_tvalid<= 1'b0;
       tx_axis_tlast <= 1'b0;
       tx_axis_tdata <= 64'h0;
       tx_axis_tkeep <= 8'h0;       
  	 end
  	else begin
  	   tx_axis_tvalid<= TxCState[TX_RD] && tx_axis_tready;
  	   tx_axis_tlast  <= TxCState[TX_RD] && TxNState[TX_IDLE];
  	   tx_axis_tdata <= RdDFifoData[127:0];
  	   tx_axis_tkeep <= (TxCState[TX_RD] && EopBit)? KeepLock : 16'hffff;
  	end
  end
/////////////////////////////////////////////////////////////////////////////
 always@(negedge RxAxis_Rstn or posedge CntClr or posedge rx_axis_uclk) begin
   if((~RxAxis_Rstn) || CntClr)
     RxPkg_Cnt<=32'h0;
   else
     RxPkg_Cnt<=(rx_axis_tvalid && rx_axis_tlast)? (RxPkg_Cnt + 1'b1) : RxPkg_Cnt;
 end
 
// always@(negedge TxAxis_Rstn or posedge CntClr or posedge tx_axis_uclk) begin
//    if((~TxAxis_Rstn)|CntClr)
//      TxPkg_Cnt<=32'h0;
//    else
//      TxPkg_Cnt<=(U_RxVlaid && U_RxEn && U_RxEop)? (TxPkg_Cnt + 1'b1) : TxPkg_Cnt; 
// end

/////////////////////////////////////////////////////////////////////////////  
endmodule
