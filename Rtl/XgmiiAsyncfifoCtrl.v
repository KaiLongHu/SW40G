/****************************************************************
*Company:  CETC54
*Engineer: 

*Create Date   : Tuesday, the 06 of June, 2023  18:48:09
*Design Name   :
*Module Name   : XgmiiAsyncfifoCtrl.v
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
module XgmiiAsyncfifoCtrl (
  input wire Rst_rx_n,
  input wire Xgmii_rxclk,
  input wire [63:0] Xgmii_rxd,
  input wire [7 :0] Xgmii_rxc,
  
  input wire Rst_tx_n,
  input wire Xgmii_txclk,
  output reg  [63:0] Xgmii_txd,
  output reg  [7 :0] Xgmii_txc,
  
  input  wire CntClr,
  output reg [31:0] Xgmii_rx_cnt,
  output reg [31:0] Xgmii_tx_cnt,
  output reg [15:0] Xgmii_drop_cnt
);

///////////////////////////////Signal Define/////////////////////////////////
  localparam MAX_RST_WAIT_CNT = 20;
  localparam MAX_RX_64BIT_LEN   = 255;
  

  localparam RST_IDLE = 0;
  localparam WR_IDLE  = 1;
  localparam WR_STATE = 2;
  
  reg [2:0] Wr_C_State;
  reg [2:0] Wr_N_State;
  
  
  reg [63:0] Xgmii_rxdD0;
  reg [7 :0] Xgmii_rxcD0;
  reg [15:0] RstWaitCnt;
  reg [15:0] WrfifoCnt;
  reg  [73:0] WrDfifoData;
  reg WrDfifoEn;
  wire SopBit;
  wire EopBit;
  wire  WrCfifoEn;
  wire  WrCfifoData;
  wire WrDFifoAFull;
  wire WrCFifoAFull;
 
 
  localparam  RD_IDLE  = 0;
  localparam  RD_STATE = 1;
  localparam  RD_DROP  = 2;
  localparam  RD_NOP   = 3;
  
  reg [3:0] Rd_C_State;
  reg [3:0] Rd_N_State;
  wire RdSopBit;
  wire RdEopBit;
  
  wire RdDfifoEmpty;
  wire RdCfifoEmpty;
  wire RdDropBit;
  
  wire RdCfifoData;
  reg  RdCfifoEn;
  
  wire [73:0] RdDfifoData;
  wire RdDfifoEn;
  
  wire [7:0]  Rd_txc;
  wire [63:0] Rd_txd;
  
   wire WrOverflowEn;
  wire WrOverLen;
/////////////////////////////////////////////////////////////////////////////
   always@(posedge Xgmii_rxclk) begin
   	  Xgmii_rxdD0<= Xgmii_rxd;
   	  Xgmii_rxcD0<= Xgmii_rxc;
   end
//////////////////////////////////////////////////////////////////////////////
  always@(negedge Rst_rx_n or posedge Xgmii_rxclk) begin
  	if(~Rst_rx_n) begin
  	   Wr_C_State<= 0;
  	   Wr_C_State[RST_IDLE]<= 1;
  	end
  	else
  	   Wr_C_State<= Wr_N_State;
  end

//////////////////////////////////////////////////////////////////////////////
   always@* begin
   	  Wr_N_State = 0;
   	  
   	  case(1'b1)
   	    Wr_C_State[RST_IDLE]: begin
   	    	if(RstWaitCnt == MAX_RST_WAIT_CNT)
   	    	  Wr_N_State[WR_IDLE] = 1;   	    	
   	    	else
   	    	  Wr_N_State[RST_IDLE] = 1;
   	    end
   	    
   	    Wr_C_State[WR_IDLE]: begin
   	    	if((Xgmii_rxcD0 == 8'hff) && (Xgmii_rxc != 8'hff) && (~WrDFifoAFull) && (~WrCFifoAFull))
   	    	  Wr_N_State[WR_STATE] = 1;
   	    	else
   	    	  Wr_N_State[WR_IDLE] = 1;
   	    end
   	    
   	    Wr_C_State[WR_STATE]: begin
   	    	if((WrfifoCnt>=MAX_RX_64BIT_LEN) || ((Xgmii_rxcD0 != 8'hff) && (Xgmii_rxc == 8'hff)))
   	    	  Wr_N_State[WR_IDLE] = 1;
   	    	else
   	    	  Wr_N_State[WR_STATE] = 1;
   	    end
   	    
   	    default: begin
   	    	Wr_N_State[WR_IDLE] = 1;
   	    end
   	   
   	  endcase
   	
   end
////////////////////////////////////////////////////////////////////////////////////
//RstWaitCnt
  always@(negedge Rst_rx_n or posedge Xgmii_rxclk) begin
     if(~Rst_rx_n) begin
   	   RstWaitCnt<= 16'd0;
   	   WrfifoCnt<= 16'h0;
   	 end
   	 else begin
   	   RstWaitCnt<=(Wr_C_State[RST_IDLE])? (RstWaitCnt + 1'b1) : 16'h0;
   	   WrfifoCnt <=((Wr_C_State[WR_IDLE] && Wr_N_State[WR_STATE]) || Wr_C_State[WR_STATE])? (WrfifoCnt + 1'b1) : 16'h0;
   	 end
  end
/////////////////////////////////////////////////////////////////////////////////////
  assign SopBit = (Wr_C_State[WR_IDLE] && Wr_N_State[WR_STATE]);
  assign EopBit = (Wr_C_State[WR_STATE] && Wr_N_State[WR_IDLE]);
   
  always@(negedge Rst_rx_n or posedge Xgmii_rxclk) begin
     if(~Rst_rx_n) begin
       WrDfifoData<=74'h0;
       WrDfifoEn  <= 1'b0;
     end
     else begin
       WrDfifoData<={SopBit, EopBit, Xgmii_rxc[7:0], Xgmii_rxd[63:0]};
       WrDfifoEn  <=((Wr_C_State[WR_IDLE] && Wr_N_State[WR_STATE]) || Wr_C_State[WR_STATE]);
     end
  end
  
  assign  WrCfifoEn  = EopBit;
  assign  WrCfifoData= (WrfifoCnt>=MAX_RX_64BIT_LEN);
  
///////////////////////////////////////////////////////////////////////////////////////////
 //DFifo
  XBramDcAFifo #(
   .FIFO_WRITE_DEPTH(1024),
   .WRITE_DATA_WIDTH(74),
   .READ_DATA_WIDTH(74),
   .READ_MODE("fwft"),   // std
   .FIFO_MEMORY_TYPE("block"),  //  "auto"- Allow Vivado Synthesis to choose;  "block"- Block RAM FIFO  ; "distributed"- Distributed RAM FIFO   
   .FIFO_READ_LATENCY(0),
   .W_ALMOST_LEVEL(512)
 )XgmiiDFifo(
   .rst(~Rst_rx_n),
   .wr_clk(Xgmii_rxclk), 
   .rd_clk(Xgmii_txclk), 
   .din(WrDfifoData), 
   .wr_en(WrDfifoEn), 
   .rd_en(RdDfifoEn),
   .dout(RdDfifoData), 
   .full(), 
   .empty(RdDfifoEmpty), 
   .prog_full(WrDFifoAFull) 
);

//Cfifo
  XBramDcAFifo #(
   .FIFO_WRITE_DEPTH(64),
   .WRITE_DATA_WIDTH(1),
   .READ_DATA_WIDTH(1),
   .READ_MODE("fwft"),   // std
   .FIFO_MEMORY_TYPE("distributed"),  //  "auto"- Allow Vivado Synthesis to choose;  "block"- Block RAM FIFO  ; "distributed"- Distributed RAM FIFO   
   .FIFO_READ_LATENCY(0),
   .W_ALMOST_LEVEL(50)
 )XgmiiCFifo(
   .rst(~Rst_rx_n),
   .wr_clk(Xgmii_rxclk), 
   .rd_clk(Xgmii_txclk), 
   .din(WrCfifoData), 
   .wr_en(WrCfifoEn), 
   .rd_en(RdCfifoEn),
   .dout(RdCfifoData), 
   .full(), 
   .empty(RdCfifoEmpty), 
   .prog_full(WrCFifoAFull) 
);


////////////////////////////////////////////////////////////////////////////////////////////
  always@(negedge Rst_tx_n or posedge Xgmii_txclk) begin
    if(~Rst_tx_n) begin
    	Rd_C_State<= 0;
    	Rd_C_State[RD_IDLE] <= 1;   	
    end
  	  Rd_C_State<= Rd_N_State;
  end
  
  
  assign RdDropBit = RdCfifoData;
  assign RdSopBit  = RdDfifoData[73];
  assign RdEopBit  = RdDfifoData[72];

  
  always@* begin
  	Rd_N_State = 0;
  	
  	case(1'b1)
  		Rd_C_State[RD_IDLE]: begin
  			if((~RdDfifoEmpty) && (~RdCfifoEmpty)) begin
  				 if(RdDropBit)
  				   Rd_N_State[RD_DROP] = 1;
  				 else
  				   Rd_N_State[RD_STATE] = 1;
  			end
  		end
  		
  		Rd_C_State[RD_STATE]: begin
  			if(RdEopBit)
  			  Rd_N_State[RD_NOP] = 1;
  			else
  			  Rd_N_State[RD_STATE] = 1;
  		end
  		
  		Rd_C_State[RD_DROP]: begin
  			if(RdEopBit)
  			  Rd_N_State[RD_NOP] = 1;
  			else
  			  Rd_N_State[RD_DROP] = 1;  			
  		end
  		
  		Rd_C_State[RD_NOP]: begin
  			Rd_N_State[RD_IDLE] = 1;
  		end
  		
  		default: Rd_N_State[RD_IDLE] = 1;
  		
  		
  	endcase
  	
  end
//////////////////////////////////////////////////////////////////////////////////////////
  assign RdDfifoEn = (Rd_C_State[RD_STATE] || Rd_C_State[RD_DROP]);

//RdCfifoEn
   always@(negedge Rst_tx_n or posedge Xgmii_txclk) begin
    if(~Rst_tx_n) begin
      RdCfifoEn<= 1'b0; 	
    end
  	  RdCfifoEn<= (Rd_C_State[RD_IDLE] && (~RdDfifoEmpty) && (~RdCfifoEmpty));
  end
  
  assign  Rd_txc = RdDfifoData[71:64];
  assign  Rd_txd = RdDfifoData[63:0];
  
  always@(negedge Rst_tx_n or posedge Xgmii_txclk) begin
  	if(~Rst_tx_n) begin
  	  Xgmii_txd <= 63'h0707_0707_0707_0707;
      Xgmii_txc <= 8'hff;
  	 end
  	else begin
  	  Xgmii_txd<=(Rd_C_State[RD_STATE])? Rd_txd : 63'h0707_0707_0707_0707;
  	  Xgmii_txc<=(Rd_C_State[RD_STATE])? Rd_txc : 8'hff; 
  	end
  end
 
 

///////////////////////////////////////////////////////////////////////////////////////////

  
  assign WrOverflowEn = (Wr_C_State[WR_IDLE] && (Xgmii_rxcD0 == 8'hff) && (Xgmii_rxc != 8'hff) && (WrDFifoAFull || WrCFifoAFull));
  assign WrOverLen    = (EopBit && (WrfifoCnt>=MAX_RX_64BIT_LEN));
 
   always@(posedge CntClr or negedge Rst_rx_n or posedge Xgmii_rxclk) begin
     if(CntClr || (~Rst_rx_n)) begin
        Xgmii_rx_cnt<= 32'h0;
        Xgmii_drop_cnt<= 16'h0; 
      end
     else begin
        Xgmii_rx_cnt<=(EopBit)? (Xgmii_rx_cnt + 1'b1) : Xgmii_rx_cnt;
        Xgmii_drop_cnt<=(WrOverflowEn || WrOverLen)? Xgmii_drop_cnt + 1'b1 : Xgmii_drop_cnt;
     end
   end
   
   
   always@(posedge CntClr or negedge Rst_tx_n or posedge Xgmii_txclk) begin
     if(CntClr || (~Rst_tx_n)) 
        Xgmii_tx_cnt<=32'h0;
     else 
        Xgmii_tx_cnt<=(RdCfifoEn)? (Xgmii_tx_cnt + 1'b1) : Xgmii_tx_cnt;
   end

///////////////////////////////////////////////////////////////////////////////////////////

endmodule
