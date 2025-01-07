/****************************************************************
*Company:  CETC54
*Engineer: menglc

*Create Date   : Wednesday, the 12 of July, 2023  11:43:03
*Design Name   :
*Module Name   : AxiRxFifoBridge.v
*Project Name  :
*Target Devices: K7
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
module AxiRxFifoBridge (

 input  wire RstMac_n,
 input  wire Clk156M25,

 input  wire RstFifo_n,
 input  wire ClkXfi156M25,

 input  wire [63:0] rx_axis_tdata,
 input  wire [7:0] rx_axis_tkeep,
 input  wire rx_axis_tvalid,
 input  wire rx_axis_tuser,
 input  wire rx_axis_tlast,
 output wire rx_axis_tready,
 
 output wire [63:0] tx_axis_tdata,
 output wire [7:0] tx_axis_tkeep,
 output wire tx_axis_tvalid,
 output wire tx_axis_tlast,
 input  wire tx_axis_tready,
 
 input  wire CntClr,
 output reg  [31:0] RxPkg_Cnt,
 output reg  [31:0] RxPkgErr_Cnt,
 output reg  [31:0] TxPkg_Cnt,
 output wire [7:0]XauiRxFifoStatus
 
);

///////////////////////////////Signal Define/////////////////////////////////

  localparam IDLE = 0;
  localparam RX_STATE = 1;
  
  reg [1:0] CurState;
  reg [1:0] NextState;
  
  wire rx_axis_treadyTemp;
  reg  rx_axis_treadyLck;

  reg  [31:0] qWordCnt;

  wire WrEopBit;
  wire WrSopBit;

  reg  [65:0] WrDFifoData;
  reg  WrDFifoEn;
  wire RdDFifoEn;
  wire [65:0] RdDFifoData;
  wire RdDFifoEmpty;
  wire WrDFifoAlmostFull;

  reg  [40:0] WrCFifoData;
  reg  WrCFifoEn;
  reg  RdCFifoEn;
  wire [40:0] RdCFifoData;
  wire RdCFifoEmpty;
  wire WrCFifoAlmostFull;



  assign XauiRxFifoStatus = {
    WrDFifoEn,
    RdDFifoEn,
    RdDFifoEmpty,
    WrDFifoAlmostFull,
    WrCFifoEn,
    RdCFifoEn,
    RdCFifoEmpty,
    WrCFifoAlmostFull
  };

/////////////////////////////////////////////////////////////////////////////

    assign rx_axis_tready = (CurState[IDLE] && rx_axis_treadyTemp) || rx_axis_treadyLck;

    always@(negedge RstMac_n or posedge Clk156M25) begin
    	if(~RstMac_n)
    	  rx_axis_treadyLck <= 0;
    	else
    	  rx_axis_treadyLck <= (CurState[IDLE])? rx_axis_treadyTemp : rx_axis_treadyLck;
    end

    always@(negedge RstMac_n or posedge Clk156M25) begin
    	if(~RstMac_n) begin
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
    	  
    	  /*CurState[NOP]: begin
  			 NextState[IDLE] = 1;
  		  end*/
    	  
    	  default: NextState[IDLE] = 1;    	  	
    	endcase
    	
    end

  assign WrSopBit = (CurState[IDLE] && NextState[RX_STATE]);
  assign WrEopBit = CurState[RX_STATE] && rx_axis_tlast;

/////////////////////////////////////////////////////////////////////
  always@(negedge RstMac_n or posedge Clk156M25) begin
  	if(~RstMac_n) begin
  		 qWordCnt <= 16'h0000;
    end
  	else begin
  		 qWordCnt	<= ((CurState[IDLE] && NextState[RX_STATE]) || CurState[RX_STATE])? (qWordCnt + 1'b1) : 16'h0000;
   	end
  end

/////////////////////////////////////////////////////////////////////
  always@(negedge RstMac_n or posedge Clk156M25) begin
  	if(~RstMac_n) begin
  		 WrDFifoEn <= 1'b0;
  		 WrDFifoData <= 66'h0;
  		 WrCFifoEn <= 1'b0;
  		 WrCFifoData <= 8'h0;
    end
  	else begin
  		 WrDFifoEn <= ((CurState[IDLE] && NextState[RX_STATE]) || CurState[RX_STATE]);
  		 WrDFifoData <= {WrSopBit,WrEopBit,rx_axis_tdata};
  		 WrCFifoEn <= (CurState[RX_STATE] && NextState[IDLE]);
  		 WrCFifoData <= {rx_axis_tkeep};
   	end
  end	

/////////////////////////////////////////////////////////////////////////////
//   XBramDcAFifo #(
//    .FIFO_WRITE_DEPTH(16384),
//    .WRITE_DATA_WIDTH(66),
//    .READ_DATA_WIDTH(66),
//    .READ_MODE("fwft"),   // std
//    .FIFO_MEMORY_TYPE("block"),  //  "auto"- Allow Vivado Synthesis to choose;  "block"- Block RAM FIFO  ; "distributed"- Distributed RAM FIFO   
//    .FIFO_READ_LATENCY(0),
//    .W_ALMOST_LEVEL(15000)
//  )Axi2UserDFifo(
//    .rst(~RstMac_n),
//    .wr_clk(Clk156M25), 
//    .rd_clk(ClkXfi156M25), 
//    .din(WrDFifoData), 
//    .wr_en(WrDFifoEn), 
//    .rd_en(RdDFifoEn),
//    .dout(RdDFifoData), 
//    .full(), 
//    .empty(RdDFifoEmpty), 
//    .prog_full(WrDFifoAlmostFull) 
//  );

  SynBlkfifo66x16384  Axi2UserDFifo(
    .srst(~RstMac_n),
    .clk(Clk156M25),
    .din(WrDFifoData),
    .wr_en(WrDFifoEn),
    .rd_en(RdDFifoEn),
    .dout(RdDFifoData),
    .full(),
    .empty(RdDFifoEmpty),
    .prog_full(WrDFifoAlmostFull)
    );

//  XBramDcAFifo #( 
//    .FIFO_WRITE_DEPTH(256),
//    .WRITE_DATA_WIDTH(41),
//    .READ_DATA_WIDTH(41),
//    .READ_MODE("fwft"),   // std
//    .FIFO_MEMORY_TYPE("block"),  //  "auto"- Allow Vivado Synthesis to choose;  "block"- Block RAM FIFO  ; "distributed"- Distributed RAM FIFO   
//    .FIFO_READ_LATENCY(0),
//    .W_ALMOST_LEVEL(240)
//  )EthDemuxCFifo(
//    .rst(~RstMac_n),
//    .wr_clk(Clk156M25), 
//    .rd_clk(ClkXfi156M25), 
//    .din(WrCFifoData), 
//    .wr_en(WrCFifoEn), 
//    .rd_en(RdCFifoEn),
//    .dout(RdCFifoData), 
//    .full(), 
//    .empty(RdCFifoEmpty), 
//    .prog_full(WrCFifoAlmostFull) 
//  );

    SynBlkfifo41x256  EthDemuxCFifo(
      .srst(~RstMac_n),
      .clk(Clk156M25),
      .din(WrCFifoData),
      .wr_en(WrCFifoEn),
      .rd_en(RdCFifoEn),
      .dout(RdCFifoData),
      .full(),
      .empty(RdCFifoEmpty),
      .prog_full(WrCFifoAlmostFull)
      );

///////////////////////////////////////////////////////////////////////////////////////////////
   localparam  RD_IDLE  = 0;
   localparam  RD_STATE = 1;
   
   reg  [1:0] CurRdState;
   reg  [1:0] NxtRdState;
   wire RdSopBit;
   wire RdEopBit;
   
   reg  [15:0] qTxWordCnt;
   reg  [7:0] TxKeepLck;

/////////////////////////////////////////////////////////////////////
   always@(negedge RstFifo_n or posedge ClkXfi156M25) begin
     if(~RstFifo_n)	begin
   	    CurRdState<= 0;
   	    CurRdState[RD_IDLE]<= 1;
   	  end
   	 else
   	    CurRdState<= NxtRdState;
   end
   
   assign RdSopBit = RdDFifoData[65];
   assign RdEopBit = RdDFifoData[64];
   
   always@* begin
   	NxtRdState = 0;
   	
   	case(1'b1)
   		CurRdState[RD_IDLE]: begin
   			  if((~RdDFifoEmpty) && (~RdCFifoEmpty) && tx_axis_tready)
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

   		 default: begin
   		 	 NxtRdState[RD_IDLE] = 1;
   		 end
   		  
   	endcase
   	
   end

//////////////////////////////////////////////////////////////////////////////////////////////
  
  assign RdDFifoEn = (CurRdState[RD_STATE] & tx_axis_tready);

  always@(negedge RstFifo_n or posedge ClkXfi156M25) begin
  	if(~RstFifo_n) begin
  		 qTxWordCnt <= 16'h0000;
    end
  	else begin
  		 qTxWordCnt	<= (CurRdState[RX_STATE])? (qTxWordCnt + 1'b1) : 16'h0000;
   	end
  end	

  always@(negedge RstFifo_n or posedge ClkXfi156M25) begin
  	if(~RstFifo_n) begin
  	  RdCFifoEn<= 1'b0;
  	  TxKeepLck <= 8'h0;
    end
  	else begin
  	  RdCFifoEn <= (CurRdState[RD_IDLE] && NxtRdState[RD_STATE]);
      TxKeepLck <= (CurRdState[RD_IDLE])? RdCFifoData[7:0] : TxKeepLck;
    end  
  end

///////////////////////////////////////////////////////////////////////////////////////////////////
  /*always@(negedge RstFifo_n or posedge ClkXfi156M25) begin
  	if(~RstFifo_n) begin
  		tx_axis_tdata  <= 64'h0;
  	  tx_axis_tvalid <= 1'b0;  
      tx_axis_tlast  <= 1'b0;
      tx_axis_tkeep  <= 8'h0;
  	 end
  	else begin
  	  tx_axis_tvalid <= CurRdState[RD_STATE];
  	  tx_axis_tlast  <= (CurRdState[RD_STATE]  && NxtRdState[RD_IDLE]);  
      tx_axis_tdata  <= RdDFifoData[63:0];
  	  tx_axis_tkeep  <= (CurRdState[RD_STATE]  && NxtRdState[RD_IDLE])? TxKeepLck : 8'hff;
  	end
  end*/

  assign tx_axis_tdata = RdDFifoData[63:0];
  assign tx_axis_tvalid = CurRdState[RD_STATE];
  assign tx_axis_tlast = (CurRdState[RD_STATE]  && NxtRdState[RD_IDLE] && tx_axis_tready);
  assign tx_axis_tkeep = (CurRdState[RD_STATE]  && NxtRdState[RD_IDLE])? TxKeepLck : 8'hff;



//////////////////////////////////////////////////////////////////////////////////////////////
//  always@(negedge RstMac_n or posedge CntClr or posedge Clk156M25) begin
//     if((~RstMac_n)|CntClr) begin
//       RxPkg_Cnt<=32'h0;
//     end
//     else begin
//     	RxPkg_Cnt<=(rx_axis_tvalid && rx_axis_tlast)? (RxPkg_Cnt + 1'b1) : RxPkg_Cnt; 
//     end
//  end

//////////////////////////////////////////////////////////////////////////////////////////////
 always@(negedge RstFifo_n or posedge CntClr or posedge ClkXfi156M25) begin
    if((~RstFifo_n)|CntClr) begin
      TxPkg_Cnt<=32'h0;
    end
    else begin
    	TxPkg_Cnt<=(tx_axis_tvalid && tx_axis_tlast)? (TxPkg_Cnt + 1'b1) : TxPkg_Cnt; 
    end
 end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 always@(negedge RstMac_n or posedge CntClr or posedge Clk156M25) begin
  if((~RstMac_n)|CntClr) begin
    RxPkg_Cnt<=32'h0;
    RxPkgErr_Cnt<=32'h0;
  end
  else begin
    RxPkg_Cnt<=(rx_axis_tvalid && rx_axis_tlast && rx_axis_tuser)? (RxPkg_Cnt + 1'b1) : RxPkg_Cnt; 
    RxPkgErr_Cnt<=(rx_axis_tvalid && rx_axis_tlast && (~rx_axis_tuser))? (RxPkgErr_Cnt + 1'b1) : RxPkgErr_Cnt; 
  end
end

/////////////////////////////////////////////////////////////////////////////
endmodule
