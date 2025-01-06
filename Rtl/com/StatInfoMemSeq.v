
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////////////////
///@file StatInfoMemSeq.v
///
///@brief 统计信息模块，接收统计请求，内部采用RAM存储统计信息，并可以提供统计信息读取�?
///该类型的统计模块输入更新请求�?次只有一个，不会同时有效�?
///
///@author douxg@sugon.com
///@date 2012-01-12
///
///建立文档，为了支持端口的二维数组声明，采用system verilog文件�?
///
///    统计信息读取接口时序�?
///                          __    __     __    __    __    __    __    __    __    __
///    Clock:             __|  |__|  |___|  |__|  |__|  |__|  |__|  |__|  |__|  |__|
///                              ______
///    qStatREn:          ______|      |______________________________________________
///                              ______
///    qvStatRAddr:       ______/      \______________________________________________
///                             \______/
///                                           ______
///    qvStatRData:       ___________________/      \_________________________________
///                                          \______/
////////////////////////////////////////////////////////////////////////////////////////////////

module StatInfoMemSeq # ( parameter STAT_CNT           = 16,    ///<请求统计的个数，根据分布式RAM的深度特点，本模块最大支�?64个统�?
                          parameter INC_LEN_BIT_WIDTH  = 1      ///<每个请求统计的长度的位宽
)
(
   //时钟复位
   input  wire                            Clock,
   input  wire                            nReset,
   //包数统计请求
   input  wire                            qStatUpdtReq,     ///<该信号不允许连续两个周期有效
   input  wire [5:0]                      qvStatUpdtReqIndex,
   input  wire [INC_LEN_BIT_WIDTH-1:0]    qvStatUpdtNum,    ///<0表示清除该项，否则加qvStatUpdtNum
   //统计信息读取
   input  wire                            qStatREn,         ///<该信号不允许连续两个周期有效
   input  wire [5:0]                      qvStatRAddr,
   output wire [31:0]                     qvStatRData       ///<qStatREn有效之后两个周期有效，见时序�?
);


   function integer log2;
      input integer val;

      begin
         log2 = 0;
         while (val > 0) begin
            val = val >> 1;
            log2 = log2 + 1;
         end
      end
   endfunction

   localparam     STAT_CNT_BIT_WIDTH   =  log2(STAT_CNT);      ///<请求统计个数信号的位�?


//////////////////////////////// 64x64分布式RAM，用于存储统计信�? //////////////////////////
   wire           qStatRAMWEn;
   reg   [5:0]    qvStatUpdtAddr = 0;
   reg   [31:0]   qvStatUpdtDataIn = 32'h0;
   reg   [5:0]    qvStatRamRAddr = 0;
   wire  [31:0]   qvStatRamRData;

generate
if ( STAT_CNT <= 32 ) begin:  USE_RAM_DEPTH_32
   /*DistRamSDPort32x32 StatRam(
      .clk        ( Clock              ),
      .we         ( qStatRAMWEn        ),
      .d          ( qvStatUpdtDataIn   ),
      .a          ( qvStatUpdtAddr     ),
      .dpra       ( qvStatRamRAddr     ),
      .qdpo       ( qvStatRamRData     )
   );*/
   
  XDistRamSDPort #(
   .BRAM_DEPTH(32),
   .DATA_WIDTH(32)
  )StatRam(
    .a(qvStatUpdtAddr[4:0]),
    .d(qvStatUpdtDataIn),
    .dpra(qvStatRamRAddr[4:0]),
    .clk(Clock),
    .we(qStatRAMWEn),
    .qdpo(qvStatRamRData)
  );
   
   
   
end
else begin:    USE_RAM_DEPTH_64
   /*DistRamSDPort32x64 StatRam(
      .clk        ( Clock              ),
      .we         ( qStatRAMWEn        ),
      .d          ( qvStatUpdtDataIn   ),
      .a          ( qvStatUpdtAddr     ),
      .dpra       ( qvStatRamRAddr     ),
      .qdpo       ( qvStatRamRData     )
   );*/
   
  XDistRamSDPort #(
   .BRAM_DEPTH(64),
   .DATA_WIDTH(32)
  )StatRam(
    .a(qvStatUpdtAddr),
    .d(qvStatUpdtDataIn),
    .dpra(qvStatRamRAddr),
    .clk(Clock),
    .we(qStatRAMWEn),
    .qdpo(qvStatRamRData)
  );
   
   
end
endgenerate


//////////////////////////////////////////////// 流水�? //////////////////////////////////////////////
   ///   cycle 1     cycle 2     cycle 3     cycle 4     cycle 5     cycle 6     cycle 7     cycle 8     cycle 9
   ///   cacl_r_addr r_addr      r_data      w_data
   ///               cacl_r_addr r_addr      r_data      w_data
   ///                           cacl_r_addr r_addr      r_data      w_data
   ///                                       software read, pipe stall for one cycle
   ///                                                   cacl_r_addr r_addr      r_data      w_data
   ///                                                               cacl_r_addr r_addr      r_data      w_data

   reg            qStatUpdtReq_d1;
   reg   [5:0]    qvStatUpdtReqIndex_d1;
   reg            qStatREn_d1;
   always @ ( posedge Clock ) begin
      if ( ~nReset ) begin
         qStatUpdtReq_d1       <= 0;
         qvStatUpdtReqIndex_d1 <= 0;
         qStatREn_d1           <= 0;
      end
      else begin
         qStatUpdtReq_d1       <= qStatUpdtReq;
         qvStatUpdtReqIndex_d1 <= qvStatUpdtReqIndex;
         qStatREn_d1           <= qStatREn;
      end
   end

   reg      qReadAddrVal;
   reg      qCaclWDataEn;
   reg      qWriteDataEn;

   always @ ( posedge Clock ) begin
      if ( ~nReset ) begin
         qReadAddrVal <= 0;
      end
      else begin
         qReadAddrVal <= (qStatUpdtReq && ~qStatREn) || (qStatUpdtReq_d1 && qStatREn_d1);
      end
   end

   always @ ( posedge Clock ) begin
      if ( ~nReset ) begin
         qCaclWDataEn <= 0;
         qWriteDataEn <= 1;
      end
      else begin
         qCaclWDataEn <= qReadAddrVal;
         qWriteDataEn <= qCaclWDataEn;
      end
   end


//////////////////////////////////// 接收各个模块的更新统计信息的请求 /////////////////////////////////
   reg   [5:0]   qvStatRamRAddr_d1;

   //qvStatRamRAddr
   always @ ( posedge Clock ) begin
      if ( qStatREn ) begin
         qvStatRamRAddr <= { 1'b0, qvStatRAddr };
      end
      else if ( qStatUpdtReq ) begin
         qvStatRamRAddr <= qvStatUpdtReqIndex;
      end
      else begin
         qvStatRamRAddr <= qvStatUpdtReqIndex_d1;
      end
   end

   always @ ( posedge Clock ) begin
      qvStatRamRAddr_d1 <= qvStatRamRAddr;
   end

   assign   qStatRAMWEn = qWriteDataEn;

   //qvStatUpdtAddr
   always @ ( posedge Clock ) begin
      if ( ~nReset ) begin
         qvStatUpdtAddr <= qvStatUpdtAddr + 1;     ///<复位�?要将缓冲区相关信息全部复�?
      end
      else if ( qCaclWDataEn ) begin
         qvStatUpdtAddr <= qvStatRamRAddr_d1;
      end
   end

   //qvStatUpdtDataIn
   always @ ( posedge Clock ) begin
      if ( ~nReset ) begin
         qvStatUpdtDataIn <= 0;
      end
      else if( qCaclWDataEn ) begin
         if ( qvStatUpdtNum ) begin
            qvStatUpdtDataIn <= qvStatRamRData + qvStatUpdtNum;
         end
         else begin
            qvStatUpdtDataIn <= 0;
         end
      end
   end

   assign   qvStatRData = qvStatRamRData;


endmodule