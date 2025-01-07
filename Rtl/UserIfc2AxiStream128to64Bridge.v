/****************************************************************
*Company:  CETC54
*Engineer: 

*Create Date   : Wednesday, the 22 of September, 2021  10:06:36
*Design Name   :
*Module Name   : UserIfc2AxiStreamBridge.v
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
module UserIfc2AxiStream128to64Bridge (
 input  wire Rst_n,
 input  wire FifoRst_n,

 input  wire rx_axis_uclk,
 output wire rx_axis_tready,
 input  wire rx_axis_tvalid,    
 input  wire rx_axis_tlast,
 input  wire [127:0] rx_axis_tdata,
 input  wire [15:0] rx_axis_tkeep,

 input  wire tx_axis_uclk,
 input  wire tx_axis_tready,
 output reg  tx_axis_tvalid,    
 output reg  tx_axis_tlast,
 output reg  [63:0] tx_axis_tdata,
 output reg  [7:0] tx_axis_tkeep,       
 
 input  wire CntClr,
 output reg  [31:0] RxPkg_Cnt,
 output reg  [31:0] TxPkg_Cnt
);

///////////////////////////////Signal Define/////////////////////////////////
 wire RxAxis_Rstn;
 wire Rst_Axis_n;
 
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
   .qnResetSync(Rst_Axis_n)
 ); 
///////////////////////////////Signal Define/////////////////////////////////
  localparam IDLE     = 0;
  localparam RX_STATE = 1;
  
  reg [1:0] CurState;
  reg [1:0] NextState;
  
  wire WrDFifoAlmostFull;
  wire WrCFifoAlmostFull;
       
  
  reg WrDFifoEn;
  reg [129:0] WrDFifoData;
  reg WrCFifoEn;
  reg [31:0] WrCFifoData; 
  reg [15:0] qWrCnt;
  wire [15:0] WrPkgLen;
  
  wire RdDFifoEmpty;
  reg   RdDFifoEn;
  wire [129:0] RdDFifoData;

  reg  [15:0] U_TxKeep;
  
  wire RdCFifoEmpty;
  reg  RdCFifoEn;
  wire [31:0] RdCFifoData;
  
  reg  [15:0] RdByte64Len;
  
  reg  WrTxDFifoEn;
  reg  [65:0] WrTxDFifoData;
  wire WrTxSopBit;
  wire WrTxEopBit;
  reg  WrTxCFifoEn;
  reg  [15:0] WrTxCFifoData;
  wire WrTxDFifoAFull;
  wire WrTxCFifoAFull;
  
  wire RdTxDFifoEmpty;
  wire RdTxCFifoEmpty;
  
  wire RdTxDFifoEn;
  wire [65:0] RdTxDFifoData;
  reg  RdTxCFifoEn;
  wire [15:0] RdTxCFifoData;

  reg  FifoRst_nD0;
  reg  FifoRst_nD1;
 
////////////////////////////////////////////////////////////////////////////////
  always@(posedge rx_axis_uclk)  begin
   FifoRst_nD0 <= FifoRst_n;
   FifoRst_nD1 <= FifoRst_nD0;
  end

/////////////////////////////////////////////////////////////////////////////  

  assign rx_axis_tready = (CurState[IDLE] && rx_axis_treadyTemp) || rx_axis_treadyLck;

  always@(negedge RxAxis_Rstn or posedge rx_axis_uclk) begin
    if(~RxAxis_Rstn)
      rx_axis_treadyLck <= 0;
    else
      rx_axis_treadyLck <= (CurState[IDLE])? rx_axis_treadyTemp : rx_axis_treadyLck;
  end

  assign rx_axis_treadyTemp = ((~WrDFifoAlmostFull) && (~WrCFifoAlmostFull));
  
/////////////////////////////////////////////////////////////////////////////
  always@(negedge RxAxis_Rstn or posedge rx_axis_uclk) begin
  	if(~RxAxis_Rstn) begin
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
  		
  		default: begin
  		  NextState[IDLE] = 1;
  		end
  		
  	endcase
  	
  end
/////////////////////////////////////////////////////////////////////////////////  
  wire WrSopBit;
  wire WrEopBit;

  assign  WrSopBit = (CurState[IDLE] && NextState[RX_STATE]);
  assign  WrEopBit = rx_axis_tlast;

  always@(negedge RxAxis_Rstn or posedge rx_axis_uclk) begin
  	if(~RxAxis_Rstn) begin
  	  WrDFifoEn<= 1'b0;
      WrDFifoData<= 130'h0;
      qWrCnt<=16'h0000;
     end
  	else begin
  		qWrCnt<=(((CurState[IDLE] && NextState[RX_STATE]) || CurState[RX_STATE])&& rx_axis_tvalid)? (qWrCnt + 1'b1) : 16'h0000;
  	  WrDFifoEn<=(((CurState[IDLE] && NextState[RX_STATE]) || CurState[RX_STATE])&& rx_axis_tvalid);
  	  WrDFifoData<= {WrSopBit, WrEopBit, rx_axis_tdata};
  	end
  end
  
  assign WrPkgLen = qWrCnt + 1'b1;
  
  always@(negedge RxAxis_Rstn or posedge rx_axis_uclk) begin
  	if(~RxAxis_Rstn) begin
  	   WrCFifoEn<= 1'b0;
       WrCFifoData<= 32'h0000;
  	 end
  	else begin
  	   WrCFifoEn<= (CurState[RX_STATE] && NextState[NOP]);
  	   WrCFifoData<={rx_axis_tkeep, WrPkgLen};
  	end
  end
/////////////////////////////////////////////////////////////////////////////////
  AsynBlkfifo130x1024 User2AxiDFifo(
   .rst(~FifoRst_nD1),
   .wr_clk(rx_axis_uclk),
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
   .FIFO_WRITE_DEPTH(1024),
   .WRITE_DATA_WIDTH(130),
   .READ_DATA_WIDTH(130),
   .READ_MODE("fwft"),   // std
   .FIFO_MEMORY_TYPE("block"),  //  "auto"- Allow Vivado Synthesis to choose;  "block"- Block RAM FIFO  ; "distributed"- Distributed RAM FIFO   
   .FIFO_READ_LATENCY(0),
   .W_ALMOST_LEVEL(800)
  )MuxDFifo(
   .rst(~RxAxis_Rstn),
   .wr_clk(rx_axis_uclk), 
   .rd_clk(tx_axis_uclk), 
   .din(WrDFifoData), 
   .wr_en(WrDFifoEn), 
   .rd_en(RdDFifoEn),
   .dout(RdDFifoData), 
   .full(), 
   .empty(RdDFifoEmpty), 
   .prog_full(WrDFifoAlomstFull) 
  );*/
  
  
  AsynDisfifo32x256 Axi2UserCFifo(
   .rst(~FifoRst_nD1),
   .wr_clk(rx_axis_uclk),
   .rd_clk(tx_axis_uclk),
   .din(WrCFifoData),
   .wr_en(WrCFifoEn),
   .rd_en(RdCFifoEn),
   .dout(RdCFifoData),
   .full(),
   .empty(RdCFifoEmpty),
   .prog_full(WrCFifoAlmostFull)
  );
  
  /*XBramDcAFifo #(
   .FIFO_WRITE_DEPTH(256),
   .WRITE_DATA_WIDTH(32),
   .READ_DATA_WIDTH(32),
   .READ_MODE("fwft"),   // std
   .FIFO_MEMORY_TYPE("block"),  //  "auto"- Allow Vivado Synthesis to choose;  "block"- Block RAM FIFO  ; "distributed"- Distributed RAM FIFO   
   .FIFO_READ_LATENCY(0),
   .W_ALMOST_LEVEL(240)
 )MuxCFifo(
   .rst(~RxAxis_Rstn),
   .wr_clk(rx_axis_uclk), 
   .rd_clk(tx_axis_uclk), 
   .din(WrCFifoData), 
   .wr_en(WrCFifoEn), 
   .rd_en(RdCFifoEn),
   .dout(RdCFifoData), 
   .full(), 
   .empty(RdCFifoEmpty), 
   .prog_full(WrCFifoAlomstFull) 
);*/
  
//////////////////////////////////////////////////////////////////////////////////
   localparam TX_IDLE  = 0;
   localparam TX_STATE = 1;
   localparam TX_NOP   = 2;
   
   reg [2:0] TxCState;
   reg [2:0] TxNState;
   
   wire [15:0] RdKeep;
   wire [15:0] RdWordLen;
   wire [15:0] RdWordLenDec;
   reg  [15:0] qByte64Cnt;
   reg  [127:0] qShiftReg;
   reg  [15:0] RdKeepLck;
////////////////////////////////////////////////////////////////////////////////////
  always@(negedge Rst_Axis_n or posedge tx_axis_uclk) begin
  	if(~Rst_Axis_n) begin
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
  			if((~RdDFifoEmpty) && (~RdCFifoEmpty) && (~WrTxDFifoAFull) && (~WrTxCFifoAFull))
  			  TxNState[TX_STATE] = 1;
  			else
  			  TxNState[TX_IDLE] = 1;
  		end
  		
  		TxCState[TX_STATE]: begin
  			if(qByte64Cnt == (RdByte64Len - 1))
  			  TxNState[TX_NOP] = 1;
  			else
  			   TxNState[TX_STATE] = 1;
  		end
  		
  		TxCState[TX_NOP]: begin
  			TxNState[TX_IDLE] = 1;
  		end
  		
  		default: begin
  			TxNState[TX_IDLE] = 1;
  		end
  		
  	endcase
  	
  end
////////////////////////////////////////////////////////////////////////////////////
  assign {RdKeep, RdWordLen} = RdCFifoData;
  
  assign RdWordLenDec = (RdWordLen - 1'b1);
  
  always@(negedge Rst_Axis_n or posedge tx_axis_uclk) begin
  	if(~Rst_Axis_n) begin
  	  RdByte64Len<=16'h0000;
  	  RdKeepLck<=16'h0;
    end
  	else begin
  	  if(TxCState[TX_IDLE]) begin
  	  	if(RdKeep[7:0] == 8'h00)
  	  		 RdByte64Len<={RdWordLenDec[14:0], 1'b1};
  	    else
           RdByte64Len<={RdWordLen[14:0], 1'b0};
  	  end

      RdKeepLck <= (TxCState[TX_IDLE])? RdKeep : RdKeepLck;
    end
  end

////////////////////////////////////////////////////////////////////////////////////
  always@(negedge Rst_Axis_n or posedge tx_axis_uclk) begin
  	if(~Rst_Axis_n)
  	  qByte64Cnt<=16'h0000;
  	else
  	  qByte64Cnt<=(TxCState[TX_STATE])? (qByte64Cnt + 1'b1) : 16'h0000;
  end

////////////////////////////////////////////////////////////////////////////////////
  always@(negedge Rst_Axis_n or posedge tx_axis_uclk) begin
  	if(~Rst_Axis_n) begin
  	  RdDFifoEn<=1'b0;
  	  RdCFifoEn<=1'b0;
  	end
  	else begin
  	  RdDFifoEn<=(TxCState[TX_STATE] && (qByte64Cnt[0] == 1'b0));
  	  RdCFifoEn<=(TxCState[TX_IDLE] && TxNState[TX_STATE]);
  	end
  end

/////////////////////////////////////////////////////////////////////////////////////
 always@(negedge Rst_Axis_n or posedge tx_axis_uclk) begin
   if(~Rst_Axis_n)	
 	   qShiftReg<=128'h0;
 	 else
 	   qShiftReg<=(TxCState[TX_STATE] && (qByte64Cnt[0] == 1'b0))? RdDFifoData[127:0] : {qShiftReg[63:0], 64'h0};  
 end

 assign WrTxSopBit = (TxCState[TX_STATE] && (qByte64Cnt == 0));
 assign WrTxEopBit = (TxCState[TX_STATE] && TxNState[TX_NOP]);
 
 always@(negedge Rst_Axis_n or posedge tx_axis_uclk) begin
   if(~Rst_Axis_n) begin
      WrTxDFifoEn  <= 1'b0;
      WrTxDFifoData<= 10'h0;
      WrTxCFifoEn<= 1'b0;
      WrTxCFifoData<=16'h0;
    end
   else begin	
 	    WrTxDFifoEn<=TxCState[TX_STATE];
 	    WrTxDFifoData<=(TxCState[TX_STATE] && (qByte64Cnt[0] == 1'b0))? {WrTxSopBit, WrTxEopBit,RdDFifoData[127:64]} : {WrTxSopBit, WrTxEopBit, qShiftReg[63:0]};
 	    WrTxCFifoEn<=(TxCState[TX_STATE] && TxNState[TX_NOP]);
 	    WrTxCFifoData<= RdKeepLck;
 	  end
 end
 
 
////////////////////////////////////////////////////////////////////////////////////////// 
 XBramDcSynFifo #( 
   .FIFO_WRITE_DEPTH(4096),
   .WRITE_DATA_WIDTH(66),
   .READ_DATA_WIDTH(66),
   .READ_MODE("fwft"),   // std
   .FIFO_MEMORY_TYPE("block"),  //  "auto"- Allow Vivado Synthesis to choose;  "block"- Block RAM FIFO  ; "distributed"- Distributed RAM FIFO   
   .FIFO_READ_LATENCY(0),
   .W_ALMOST_LEVEL(2048)
 )TxDFifo(
   .rst(~Rst_Axis_n),
   .clk(tx_axis_uclk), 
   .din(WrTxDFifoData), 
   .wr_en(WrTxDFifoEn), 
   .rd_en(RdTxDFifoEn),
   .dout(RdTxDFifoData), 
   .full(), 
   .empty(RdTxDFifoEmpty), 
   .prog_full(WrTxDFifoAFull) 
);


 XBramDcSynFifo #( 
   .FIFO_WRITE_DEPTH(256),
   .WRITE_DATA_WIDTH(16),
   .READ_DATA_WIDTH(16),
   .READ_MODE("fwft"),   // std
   .FIFO_MEMORY_TYPE("distributed"),  //  "auto"- Allow Vivado Synthesis to choose;  "block"- Block RAM FIFO  ; "distributed"- Distributed RAM FIFO   
   .FIFO_READ_LATENCY(0),
   .W_ALMOST_LEVEL(240)
 )TxCFifo(
   .rst(~Rst_Axis_n),
   .clk(tx_axis_uclk), 
   .din(WrTxCFifoData), 
   .wr_en(WrTxCFifoEn), 
   .rd_en(RdTxCFifoEn),
   .dout(RdTxCFifoData), 
   .full(), 
   .empty(RdTxCFifoEmpty), 
   .prog_full(WrTxCFifoAFull) 
);
///////////////////////////////////////////////////////////////////////////////////////////////
   localparam  RD_IDLE  = 0;
   localparam  RD_STATE = 1;
   //localparam  RD_NOP   = 2;
   
   reg [1:0] CurRdState;
   reg [1:0] NxtRdState;
   wire RdSopBit;
   wire RdEopBit;
   reg [15:0] TxKeepLck;
   
   always@(negedge Rst_Axis_n or posedge tx_axis_uclk) begin
     if(~Rst_Axis_n)	begin
   	    CurRdState<= 0;
   	    CurRdState[RD_IDLE]<= 1;
   	  end
   	 else
   	    CurRdState<= NxtRdState;
   end
   
   assign RdSopBit = RdTxDFifoData[65];
   assign RdEopBit = RdTxDFifoData[64];
   
   always@* begin
   	NxtRdState = 0;
   	
   	case(1'b1)
   		CurRdState[RD_IDLE]: begin
   			  if((~RdTxDFifoEmpty) && (~RdTxCFifoEmpty) && tx_axis_tready)
   			    NxtRdState[RD_STATE] = 1;
   			  else
   			    NxtRdState[RD_IDLE] = 1; 
   			end
   		CurRdState[RD_STATE]: begin
   			  if(RdEopBit && tx_axis_tready)
   			    NxtRdState[RD_IDLE] = 1;
   			  else
   			    NxtRdState[RD_STATE] = 1;
   		 end
   		 
   		/*CurRdState[RD_NOP]: begin
   			 NxtRdState[RD_IDLE] = 1;
   		 end*/
   		 
   		 default: begin
   		 	 NxtRdState[RD_IDLE] = 1;
   		 end
   		  
   	endcase
   	
   end
//////////////////////////////////////////////////////////////////////////////////////////////
  
  assign RdTxDFifoEn = (CurRdState[RD_STATE] & tx_axis_tready);
  
  always@(negedge Rst_Axis_n or posedge tx_axis_uclk) begin
  	if(~Rst_Axis_n) begin
  	  RdTxCFifoEn<= 1'b0;
  	  TxKeepLck <= 16'h0;
        end
  	else begin
  	  RdTxCFifoEn<=(CurRdState[RD_IDLE] && NxtRdState[RD_STATE]);
  	  TxKeepLck <= (CurRdState[RD_IDLE])? RdTxCFifoData : TxKeepLck;
    end  
  end

/////////////////////////////////////////////////////////////////////////////
  wire [63:0] TxData;
  reg  [7:0] TxKeep;
  
  //assign TxData = {RdTxDFifoData[7:0],RdTxDFifoData[15:8],RdTxDFifoData[23:16],RdTxDFifoData[31:24],RdTxDFifoData[39:32],RdTxDFifoData[47:40],RdTxDFifoData[55:48],RdTxDFifoData[63:56]};

  always@(negedge Rst_Axis_n or posedge tx_axis_uclk) begin
  	if(~Rst_Axis_n) begin
  		tx_axis_tdata  <= 64'h0;
  	  tx_axis_tvalid <= 1'b0;  
      tx_axis_tlast  <= 1'b0;
      tx_axis_tkeep <= 8'h0;
  	 end
  	else begin
  	  tx_axis_tvalid <= CurRdState[RD_STATE];
  	  tx_axis_tlast  <= (CurRdState[RD_STATE]  && NxtRdState[RD_IDLE]);   	  
  	  tx_axis_tdata  <= (CurRdState[RD_STATE] && tx_axis_tready)? RdTxDFifoData : tx_axis_tdata;
  	  
  	  if (CurRdState[RD_STATE]  && NxtRdState[RD_IDLE])
        tx_axis_tkeep <= (TxKeepLck[7:0]==8'h0)? TxKeepLck[15:8] : TxKeepLck[7:0];
  	  else
        tx_axis_tkeep <= 8'hff;
  	end
  end
 
 
//  always@* begin
//   case(TxKeep) 
//     8'h80: begin
//         tx_axis_tkeep = 8'h01; 	         
//         end
//     8'hc0: begin
//         tx_axis_tkeep = 8'h03;
//         end  	        
//     8'he0: begin
//         tx_axis_tkeep = 8'h07;
//         end 	       
//     8'hf0: begin 
//         tx_axis_tkeep = 8'h0f;
//         end
//     8'hf8: begin
//         tx_axis_tkeep = 8'h1f;
//         end
//     8'hfc: begin
//         tx_axis_tkeep = 8'h3f;
//         end   	            	     
//     8'hfe: begin 
//         tx_axis_tkeep = 8'h7f;
//       end
//     8'hff: begin 
//         tx_axis_tkeep = 8'hff;   	               
//         end
//     default:begin
//         tx_axis_tkeep = 8'h0; 
//         end	     
//   endcase	
//   end
  
//////////////////////////////////////////////////////////////////////////////////////////////
 always@(negedge RxAxis_Rstn or posedge CntClr or posedge rx_axis_uclk) begin
   if((~RxAxis_Rstn) || CntClr)
     RxPkg_Cnt<=32'h0;
   else
     RxPkg_Cnt<=(U_TxEn && U_TxValid && U_TxSop)? (RxPkg_Cnt + 1'b1) : RxPkg_Cnt;
 end
 
 always@(negedge Rst_Axis_n or posedge CntClr or posedge tx_axis_uclk) begin
    if((~Rst_Axis_n)|CntClr)
      TxPkg_Cnt<=32'h0;
    else
      TxPkg_Cnt<=(tx_axis_tvalid && tx_axis_tlast)? (TxPkg_Cnt + 1'b1) : TxPkg_Cnt; 
 end

/////////////////////////////////////////////////////////////////////////////
endmodule
