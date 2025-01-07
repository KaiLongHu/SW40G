`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/09 15:57:13
// Design Name: 
// Module Name: ten_gig_eth_mac_rx_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 处理超短帧错误，丢弃错误帧，保障帧首，丢弃超长帧，保障padding is being removed处理
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ten_gig_eth_mac_rx_fifo(
 input  wire       clk,
 input  wire       rst_n,
    
 (* mark_debug="true" *)input  wire[63:0] rx_axis_mac_tdata,
 (* mark_debug="true" *)input  wire[7:0]  rx_axis_mac_tkeep,
 (* mark_debug="true" *)input  wire       rx_axis_mac_tvalid,
 (* mark_debug="true" *)input  wire       rx_axis_mac_tlast,
 (* mark_debug="true" *)input  wire       rx_axis_mac_tuser,
 
 (* mark_debug="true" *)output wire[63:0] rx_axis_fifo_tdata,
 (* mark_debug="true" *)output wire[7:0]  rx_axis_fifo_tkeep,
 (* mark_debug="true" *)output wire       rx_axis_fifo_tvalid,
 (* mark_debug="true" *)output wire       rx_axis_fifo_tlast,
 (* mark_debug="true" *)input  wire       rx_axis_fifo_tready);
    
 
 localparam IDLE = 0;
 localparam RX_STATE = 1;

 reg [1:0] CurState;
 reg [1:0] NextState; 

 reg  WrDFifoEn;
 reg  [64:0] WrDFifoData;
 wire RdDFifoEn;
 wire [64:0] RdDFifoData;
 wire RdDFifoEmpty;
 wire WrDFifoAlmostFull;

 reg  WrCFifoEn;
 reg  [23:0] WrCFifoData;
 reg  RdCFifoEn;
 wire [23:0] RdCFifoData;
 wire RdCFifoEmpty;
 wire WrCFifoAlmostFull;
  
 wire rx_axis_tready;
 reg  [15:0] qWordCnt;
 
 reg  rx_not_valid;
 wire  WrCFifoA;//当数据包超长时将数据包丢弃
 reg  sop;
 reg  rx_axis_mac_tvalidD0;
 
   localparam MAX_PKG_LEN = 240;
  
    assign rx_axis_tready = ((~WrDFifoAlmostFull) && (~WrCFifoAlmostFull));
    
    always@(negedge rst_n or posedge clk) begin
      if(~rst_n) 
         sop <= 1'b1;
      else if(rx_axis_mac_tlast && rx_axis_mac_tvalid )
         sop <= 1'b1;
      else if(rx_axis_mac_tvalid)
         sop <= 1'b0;
    end
    /////////////////////////////////////////////////////////////////////////////
    always@(negedge rst_n or posedge clk) begin
        if(~rst_n) begin
          CurState<= 0;
          CurState[IDLE] <= 1;
        end
        else
          CurState<= NextState;
    end
    
    always@* begin
        NextState = 0;
        
        case(1'b1)
            CurState[IDLE]: begin
                if(sop && rx_axis_tready && rx_axis_mac_tvalid && (~rx_axis_mac_tlast))// (~rx_axis_mac_tlast)：只有一个周期的超短帧不写FIFO；sop保证每一帧从头写如缓冲区
                  NextState[RX_STATE] = 1;
                else
                  NextState[IDLE] = 1;
            end
        
            CurState[RX_STATE]: begin
              if(rx_axis_mac_tvalid && rx_axis_mac_tlast)
                NextState[IDLE] = 1;
              else
                NextState[RX_STATE] = 1;
          end

          default: NextState[IDLE] = 1;              
        endcase
        
    end
  
  always@(negedge rst_n or posedge clk) begin
      if(~rst_n) begin
         WrDFifoEn<=1'b0;
         WrDFifoData<=65'h0;
         WrCFifoEn<=1'b0;
         WrCFifoData<=24'h0;
      end
      else begin
         WrDFifoEn <=(CurState[IDLE] && NextState[RX_STATE]) || (CurState[RX_STATE] &&rx_axis_mac_tvalid && (~rx_not_valid)) ;
         WrCFifoEn <=(CurState[RX_STATE] && NextState[IDLE] && (~rx_not_valid))||(WrCFifoA && CurState[RX_STATE]);
         WrDFifoData<= {(rx_axis_mac_tlast || WrCFifoA),rx_axis_mac_tdata};              
         WrCFifoData<= {8'h0,7'h0,((~rx_axis_mac_tuser)||WrCFifoA),rx_axis_mac_tkeep};
      end
  end
 
    always@(negedge rst_n or posedge clk) begin
       if(~rst_n)      
           qWordCnt <= 16'h1; 
        else 
           if(CurState[IDLE] && NextState[RX_STATE])
              qWordCnt <= 16'h1;
           else if(CurState[RX_STATE] && rx_axis_mac_tvalid)   
              qWordCnt <= qWordCnt + 1;
    end
  
    assign WrCFifoA = (CurState[RX_STATE] && rx_axis_mac_tvalid  && qWordCnt == MAX_PKG_LEN )?1'b1:1'b0;
    
    always@(negedge rst_n or posedge clk) begin
       if(~rst_n)begin      
          rx_not_valid <= 1'b0; 
       end   
       else begin
          rx_not_valid <= (CurState[RX_STATE] && qWordCnt >= MAX_PKG_LEN )?1'b1:1'b0;
       end    
    end
    
    
    
    
/////////////////////////////////////////////////////////////////////////////
   XBramDcSynFifo #( 
  .FIFO_WRITE_DEPTH(512),
  .WRITE_DATA_WIDTH(65),
  .READ_DATA_WIDTH(65),
  .READ_MODE("fwft"),   // std
  .FIFO_MEMORY_TYPE("block"), 
  .FIFO_READ_LATENCY(0),
  .W_ALMOST_LEVEL(256)
  )MacRxDFifo(
   .rst(~rst_n),
   .clk(clk), 
   .din(WrDFifoData), 
   .wr_en(WrDFifoEn), 
   .rd_en(RdDFifoEn),
   .dout(RdDFifoData), 
   .full(), 
   .empty(RdDFifoEmpty), 
   .prog_full(WrDFifoAlmostFull) 
 );

XBramDcSynFifo #( 
 .FIFO_WRITE_DEPTH(64),
 .WRITE_DATA_WIDTH(24),
 .READ_DATA_WIDTH(24),
 .READ_MODE("fwft"),   // std
 .FIFO_MEMORY_TYPE("distributed"), 
 .FIFO_READ_LATENCY(0),
 .W_ALMOST_LEVEL(50)
)MacRxCFifo(
 .rst(~rst_n),
 .clk(clk), 
 .din(WrCFifoData), 
 .wr_en(WrCFifoEn), 
 .rd_en(RdCFifoEn),
 .dout(RdCFifoData), 
 .full(), 
 .empty(RdCFifoEmpty), 
 .prog_full(WrCFifoAlmostFull) 
);
 
/////////////////////////////////////////////////////////////////////////////
  localparam TX_IDLE  = 0;
  localparam TX_RD    = 1;
  localparam TX_DROP  = 2;
  localparam TX_NOP   = 3;
  
  reg  [3:0] TxCState;
  reg  [3:0] TxNState;
  wire EopBit;
  reg  [7:0] KeepLock;
  wire       Drop;
  
  assign EopBit  = RdDFifoData[64];
  assign Drop = RdCFifoData[8];//丢弃当前包

//output wire[63:0] rx_axis_fifo_tdata,
//output wire[7:0]  rx_axis_fifo_tkeep,
//output wire       rx_axis_fifo_tvalid,
//output wire       rx_axis_fifo_tlast,
//input  wire       rx_axis_fifo_tready);

////////////////////////////////////////////////////////////////////////////
  always@(negedge rst_n or posedge clk) begin
     if(~rst_n) begin
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
              if((~RdDFifoEmpty) && (~RdCFifoEmpty)) 
                 if(Drop) 
                    TxNState[TX_DROP] = 1;
                 else
                    TxNState[TX_RD] = 1;
              else 
                 TxNState[TX_IDLE] = 1;
          end          
       
          TxCState[TX_RD]: begin
              if(EopBit && rx_axis_fifo_tready)
                TxNState[TX_NOP] = 1; 
              else
                TxNState[TX_RD] = 1;
          end

          TxCState[TX_DROP]: begin
              if(EopBit)
                TxNState[TX_NOP] = 1; 
              else
                TxNState[TX_DROP] = 1;
          end

          TxCState[TX_NOP]: begin
              TxNState[TX_IDLE] = 1;
          end
          
          default: begin
              TxNState[TX_IDLE] = 1;
          end
                    
      endcase
      
  end
/////////////////////////////////////////////////////////////////////////////
  assign RdDFifoEn = (TxCState[TX_RD] && rx_axis_fifo_tready) || TxCState[TX_DROP];
  
  assign rx_axis_fifo_tdata = RdDFifoData[63:0];
  assign rx_axis_fifo_tlast = RdDFifoData[64] && TxCState[TX_RD] && rx_axis_fifo_tready;
  assign rx_axis_fifo_tvalid = TxCState[TX_RD] && rx_axis_fifo_tready;
  assign rx_axis_fifo_tkeep = (rx_axis_fifo_tlast)?KeepLock:8'hff;

  always@(negedge rst_n or posedge clk) begin
      if(~rst_n) begin
         RdCFifoEn<=1'b0;
         KeepLock<= 8'h0;      
       end
      else begin
         RdCFifoEn<=(TxCState[TX_IDLE] && (TxNState[TX_DROP] || TxNState[TX_RD]));
         KeepLock <=(TxCState[TX_IDLE])? RdCFifoData[7:0] : KeepLock;
       end
  end


endmodule
