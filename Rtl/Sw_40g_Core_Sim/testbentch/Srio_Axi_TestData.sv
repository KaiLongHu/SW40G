/*//////////////////////////////////////////////////////////////////////////////////////////////
+--+--+---+-+---+----+
|  |  |   | /   |    |
|  |--|   --    |    |
|  |  |   | \   ---- |
|--+--+---+-+--------+
Module Name:
Provider:HuKaiLong
Modify Time:
Target Platform:
Function Description: 
//////////////////////////////////////////////////////////////////////////////////////////////*/
`timescale 1ns/1ns

module RapidIOTestIfc(
    input  wire      axis_clk,
    output  reg      m_axis_treq_tvalid,             // Indicates Valid Output on the Response Channel
    input  wire          m_axis_treq_tready,             // Beat has been accepted
    output reg            m_axis_treq_tlast,              // Indicates last beat
    output reg  [63:0]    m_axis_treq_tdata,              // Resp Data Bus
    output reg  [7:0]     m_axis_treq_tkeep,              // Resp Keep Bus
    output reg  [31:0]    m_axis_treq_tuser,              // Resp User Bus


    input  wire        s_axis_ireq_tvalid,             // Indicates Valid Input on the Request Channel
    output              s_axis_ireq_tready,             // Beat has been accepted
    input  wire        s_axis_ireq_tlast,              // Indicates last beat
    input  wire [63:0] s_axis_ireq_tdata,              // Req Data Bus
    input  wire [7:0]  s_axis_ireq_tkeep,              // Req Keep Bus
    input  wire [31:0] s_axis_ireq_tuser              // Req User Bu

  );
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////
  localparam SRC_DEV_ID = 8'd7;
  localparam VUHFN12_DEV_ID = 8'd10;
  localparam VUHFN34_DEV_ID = 8'd11;
  localparam JIDS_DEV_ID    = 8'd12;
  localparam KSAT_DEV_ID    = 8'd8;
  localparam APM_DEV_ID     = 8'd20;
  localparam FPGA_ID        = 8'd7;
  localparam VUHFN12_DRB_DATA = 16'h0003;
  localparam VUHFN34_DRB_DATA = 16'h0004;
  localparam JIDS_DRB_DATA   = 16'h0005;
  localparam KSAT_DRB_DATA   = 16'h0006;
  localparam APM_DRB_DATA    = 16'h0007;
  localparam VUHFN12_BASE_ADDR = 32'h7000_0000;
  localparam VUHFN12_ADDR_MASK = 32'hf000_0000;
  localparam VUHFN34_BASE_ADDR = 32'h8000_0000;
  localparam VUHFN34_ADDR_MASK = 32'hf000_0000;
  localparam JIDS_BASE_ADDR    = 32'h9000_0000;
  localparam JIDS_ADDR_MASK    = 32'hf000_0000;
  localparam KSAT_BASE_ADDR    = 32'ha000_0000;
  localparam KSAT_ADDR_MASK    = 32'hf000_0000;
  localparam APM_BASE_ADDR     = 32'hb000_0000;
  localparam APM_ADDR_MASK     = 32'hf000_0000;

  localparam VUHFN12_BASE_ADDR_M = 32'h5410_0000;
  localparam VUHFN12_ADDR_MASK_M = 32'hfff0_0000;
  localparam VUHFN34_BASE_ADDR_M = 32'h5420_0000;
  localparam VUHFN34_ADDR_MASK_M = 32'hfff0_0000;
  localparam JIDS_BASE_ADDR_M    = 32'h5460_0000;
  localparam JIDS_ADDR_MASK_M    = 32'hfff0_0000;
  localparam KSAT_BASE_ADDR_M    = 32'h5430_0000;
  localparam KSAT_ADDR_MASK_M    = 32'hfff0_0000;
  localparam APM_BASE_ADDR_M     = 32'h5450_0000;
  localparam APM_ADDR_MASK_M     = 32'hfff0_0000;


  localparam [3:0] NREAD  = 4'h2;
  localparam [3:0] NWRITE = 4'h5;
  localparam [3:0] SWRITE = 4'h6;
  localparam [3:0] DOORB  = 4'hA;
  localparam [3:0] MESSG  = 4'hB;
  localparam [3:0] RESP   = 4'hD;
  localparam [3:0] FTYPE9 = 4'h9;

  localparam [3:0] TNWR   = 4'h4;
  localparam [3:0] TNWR_R = 4'h5;
  localparam [3:0] TNRD   = 4'h4;

  localparam [3:0] TNDATA = 4'h0;
  localparam [3:0] MSGRSP = 4'h1;
  localparam [3:0] TWDATA = 4'h8;


  localparam  R = 1'b0;
  localparam  [1:0] PRIO = 2'h0;

  bit [7:0] SrcTID = 8'h11;
  bit [7:0] TestID= 8'h22;
  bit [7:0] RealBurstLen;

  bit [2047:0][7:0] RpDataArray;
  bit [255 :0][63:0] Rp64BArray;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //     task  automatic Axis_Treq_NwriteTest_AA;

  //     input bit[3:0]   DstDevId;
  //     input bit[31:0]  DstBaseAddr;
  //     bit [31:0] WrAddr;
  //     bit [33:0] WrAddr_m;
  //     bit [7:0]BurstLen;
  //     BurstLen=8'd0;
  //     while(~m_axis_treq_tready)
  //         @(posedge axis_clk);
  //     //initial
  //     m_axis_treq_tvalid = 1'b0;
  //     m_axis_treq_tkeep  = 8'hff;
  //     m_axis_treq_tuser  = 32'h0;
  //     m_axis_treq_tlast  = 1'b0;
  //     m_axis_treq_tdata  = 64'h0;
  //     @(posedge axis_clk);
  //     //Send Hdr
  //     WrAddr_m = DstBaseAddr<<2;
  //     m_axis_treq_tvalid = 1'b1;
  //     m_axis_treq_tlast  = 1'b0;
  //     m_axis_treq_tkeep  = 8'hff;
  //     m_axis_treq_tuser  ={8'h0, SRC_DEV_ID, 8'h0, DstDevId};
  //     m_axis_treq_tdata = {SrcTID,NWRITE,TNWR,R,PRIO,R,BurstLen,R,R, WrAddr_m};
  //     @(posedge axis_clk);
  //     m_axis_treq_tdata = 64'hAA;
  //     m_axis_treq_tlast  = 1'b1;
  //     @(posedge axis_clk);
  //     m_axis_treq_tvalid = 1'b0;
  //     m_axis_treq_tkeep  = 8'hff;
  //     m_axis_treq_tuser  = 32'h0;
  //     m_axis_treq_tlast  = 1'b0;
  //     m_axis_treq_tdata  = 64'h0;
  //     SrcTID++;
  //     @(posedge axis_clk);

  // endtask
  //////////////////////////////////////////////////////////////////////////////////////////////////
  function automatic int GenZHPkg;
    input bit[31:0] PkgLen; //RapidIO内传递的消息总字节数，不包括32B数据头
    input bit[7:0]SrcIdLock;
    input bit[7:0]DstIdLock;
    input bit[7:0]Info_Attr; //2
    input bit[7:0]Info_Type; //1//2

    int Pkg64B_Len;

    RpDataArray[0] = PkgLen[31:24];
    RpDataArray[1] = PkgLen[23:16];
    RpDataArray[2] = PkgLen[15:8];
    RpDataArray[3] = PkgLen[7 :0];

    RpDataArray[4] = 8'h0;
    RpDataArray[5] = 8'h0;
    RpDataArray[6] = 8'h0;
    RpDataArray[7] = 8'h0;


    for(int i=0; i<24;i++)
    begin
      RpDataArray[i+8] = 8'hff;
    end

    /*
    SysRdData[31:24] : SrcIdLock
    SysRdData[23:16] : DstIdLock
    SysRdData[15:8]  : Info_Attr
    SysRdData[7:0]   : Info_Type
    */
    RpDataArray[32] = SrcIdLock;
    RpDataArray[33] = DstIdLock;
    RpDataArray[34] = Info_Attr;
    RpDataArray[35] = Info_Type;

    for(int j=0; j<(PkgLen-4); j++)
    begin
      RpDataArray[j+36] = j;
    end


    Pkg64B_Len = (((PkgLen+32)%8) == 0)? ((PkgLen+32)/8) : ((PkgLen+32)/8+1);

    for(int k =0; k<Pkg64B_Len; k++)
    begin
      Rp64BArray[k][63:56] = RpDataArray[k*8];
      Rp64BArray[k][55:48] = RpDataArray[k*8+1];
      Rp64BArray[k][47:40] = RpDataArray[k*8+2];
      Rp64BArray[k][39:32] = RpDataArray[k*8+3];
      Rp64BArray[k][31:24] = RpDataArray[k*8+4];
      Rp64BArray[k][23:16] = RpDataArray[k*8+5];
      Rp64BArray[k][15:8]  = RpDataArray[k*8+6];
      Rp64BArray[k][7 :0]  = RpDataArray[k*8+7];
    end


    return(32+PkgLen);

  endfunction

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  task automatic Axis_Treq_NwriteIfc;
    input bit[3:0]   DstDevId;
    input bit[31:0]  DstBaseAddr;
    input bit[15:0]  DstOffsetAddr;
    input bit[15 :0]  Size;
    input bit [31:0][63:0] RpHelloData;

    int BurstLen;
    bit [31:0] WrAddr;
    bit [33:0] WrAddr_m;

    BurstLen = ((Size%8) == 0)? (Size/8) : (Size/8 + 1);

    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    @(posedge axis_clk);


    while(~m_axis_treq_tready)
      @(posedge axis_clk);

    WrAddr = DstBaseAddr + {16'h0, DstOffsetAddr};
    WrAddr_m = WrAddr<<2;
    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, SRC_DEV_ID, 8'h0, DstDevId};
    m_axis_treq_tdata = {SrcTID,NWRITE,TNWR,R,PRIO,R, (Size[7:0] - 1'b1), R, R, WrAddr_m};
    @(posedge axis_clk);


    for(int i=0; i<BurstLen; i++)
    begin
      while(~m_axis_treq_tready)
        @(posedge axis_clk);

      m_axis_treq_tvalid<= 1'b1;
      m_axis_treq_tlast <=(i == (BurstLen - 1'b1))? 1'b1 : 1'b0;
      m_axis_treq_tkeep <= 8'hff;
      m_axis_treq_tuser <={8'h0, SRC_DEV_ID, 8'h0, DstDevId};
      m_axis_treq_tdata <=RpHelloData[i];
      @(posedge axis_clk);
    end

    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    @(posedge axis_clk);
  endtask
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  task  automatic Rp_Treq_NwriteZhData;
    input bit[31:0] Rp_PkgLen;
    input bit[3:0]   DstDevId;
    input bit[31:0]  DstBaseAddr;
    input bit[15:0]  DstOffsetAddr;

    input bit[7:0]SrcIdLock;
    input bit[7:0]DstIdLock;
    input bit[7:0]Info_Attr; //2
    input bit[7:0]Info_Type; //1//2

    int Zh_Len;
    int BurstHelloCnt;
    int End64BCnt;
    int EndBytes;
    int i;
    int j;
    bit [31:0][63:0] HelloData;

    bit[15:0]  OffsetAddr;

    Zh_Len = GenZHPkg(Rp_PkgLen,SrcIdLock,DstIdLock,Info_Attr,Info_Type);

    BurstHelloCnt  = (Zh_Len%256 == 0)? (Zh_Len/256) : (Zh_Len/256 + 1'b1);

    EndBytes = Zh_Len%256;

    if(EndBytes == 0)
      End64BCnt = 32;
    else
      End64BCnt = (EndBytes%8 == 0)? (EndBytes/8) : (EndBytes/8 + 1);

    OffsetAddr = DstOffsetAddr;

    for(i=0; i<BurstHelloCnt; i++)
    begin
      if(i == (BurstHelloCnt - 1))
      begin
        for(j=0; j<End64BCnt; j++)
        begin
          HelloData[j] = Rp64BArray[32*i+j];
        end

        Axis_Treq_NwriteIfc(DstDevId, DstBaseAddr, OffsetAddr,EndBytes, HelloData);

      end
      else
      begin
        for(j=0; j<32; j++)
        begin
          HelloData[j] = Rp64BArray[32*i+j];
        end

        Axis_Treq_NwriteIfc(DstDevId, DstBaseAddr, OffsetAddr,256, HelloData);
      end

      OffsetAddr = OffsetAddr + 16'd64;

    end

  endtask
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  task  automatic Rp_Treq_Wr_VUHFN1; //1
    input bit[15:0] PkgLen;
    Axis_Treq_NreadTest(4'h0, VUHFN12_BASE_ADDR_M, 1, 16);
    repeat(50) @(posedge axis_clk);
    Rp_Treq_NwriteZhData(PkgLen, 4'h0, VUHFN12_BASE_ADDR_M, 16'h0,VUHFN12_DEV_ID,8'h00,8'h2,8'h1);
    repeat(50) @(posedge axis_clk);
    Axis_Treq_DrbellTest(VUHFN12_DEV_ID, VUHFN12_DEV_ID);
    $display("@%0t:Wr_VUHFN1 DONE",$time);
  endtask

  task  automatic Rp_Treq_Wr_VUHFN2; //2
    input bit[15:0] PkgLen;
    Axis_Treq_NreadTest(4'h0, VUHFN12_BASE_ADDR_M, 1, 16);
    Rp_Treq_NwriteZhData(PkgLen, 4'h0, VUHFN12_BASE_ADDR_M, 16'h0,VUHFN12_DEV_ID,8'h00,8'h2,8'h2);
    Axis_Treq_DrbellTest(VUHFN12_DEV_ID, VUHFN12_DEV_ID);
    $display("@%0t:Wr_VUHFN2 DONE",$time);
  endtask

  task  automatic Rp_Treq_Wr_VUHFN3; //3
    input bit[15:0] PkgLen;
    Axis_Treq_NreadTest(4'h0, VUHFN34_BASE_ADDR_M, 1, 16);
    Rp_Treq_NwriteZhData(PkgLen, 4'h0, VUHFN34_BASE_ADDR_M, 16'h0,VUHFN34_DEV_ID,8'h00,8'h2,8'h1);
    Axis_Treq_DrbellTest(FPGA_ID, VUHFN34_DEV_ID);
    $display("@%0t:Wr_VUHFN3 DONE",$time);
  endtask

  task  automatic Rp_Treq_Wr_VUHFN4; //4
    input bit[15:0] PkgLen;
    Axis_Treq_NreadTest(4'h0, VUHFN34_BASE_ADDR_M, 1, 16);
    Rp_Treq_NwriteZhData(PkgLen, 4'h0, VUHFN34_BASE_ADDR_M, 16'h0,VUHFN34_DEV_ID,8'h00,8'h2,8'h2);
    Axis_Treq_DrbellTest(VUHFN34_DEV_ID, VUHFN34_DEV_ID);
    $display("@%0t:Wr_VUHFN4 DONE",$time);
  endtask

  task  automatic Rp_Treq_Wr_JIDS;
    input bit[15:0] PkgLen;
    Axis_Treq_NreadTest(4'h0, JIDS_BASE_ADDR_M, 1, 16);
    Rp_Treq_NwriteZhData(PkgLen, 4'h0, JIDS_BASE_ADDR_M, 16'h0,JIDS_DEV_ID,8'h00,8'h2,8'h1);
    Axis_Treq_DrbellTest(JIDS_DEV_ID, JIDS_DEV_ID);
    $display("@%0t:Wr_JIDS DONE",$time);
  endtask

  task  automatic Rp_Treq_Wr_KSAT;
    input bit[15:0] PkgLen;
    Axis_Treq_NreadTest(4'h0, KSAT_BASE_ADDR_M, 1, 16);
    Rp_Treq_NwriteZhData(PkgLen, 4'h0, KSAT_BASE_ADDR_M, 16'h0,KSAT_DEV_ID,8'h00,8'h2,8'h1);
    Axis_Treq_DrbellTest(KSAT_DEV_ID, KSAT_DEV_ID);
    $display("@%0t:Wr_KSAT DONE",$time);
  endtask

  task  automatic Rp_Treq_Wr_APM;
    input bit[15:0] PkgLen;
    Axis_Treq_NreadTest(4'h0, APM_BASE_ADDR_M, 1, 16);
    Rp_Treq_NwriteZhData(PkgLen, 4'h0, APM_BASE_ADDR_M, 16'h0,APM_DEV_ID,8'h00,8'h2,8'h1);
    Axis_Treq_DrbellTest(APM_DEV_ID, APM_DEV_ID);
    $display("@%0t:Wr_APM DONE",$time);
  endtask


  //..new


  ///////////////////////////////////////////////////////////////////////////////////////////////


  task  automatic Rp_Treq_Wr_VHF1_New;
    Axis_Treq_NreadTest_new(FPGA_ID,VUHFN12_DEV_ID,VUHFN12_BASE_ADDR_M, 1, 16);
    repeat(100) @(posedge axis_clk);

    Axis_Treq_NWrite_aa(VUHFN12_DEV_ID,FPGA_ID,VUHFN12_BASE_ADDR_M);
    repeat(100) @(posedge axis_clk);

    Axis_Treq_NWrite_AA2ND(VUHFN12_DEV_ID,FPGA_ID,VUHFN12_BASE_ADDR_M);
    repeat(100) @(posedge axis_clk);

    Axis_Treq_NWrite_r_AA3rd(VUHFN12_DEV_ID,FPGA_ID,VUHFN12_BASE_ADDR_M);
    repeat(100) @(posedge axis_clk);

    Axis_Treq_DrbellTest(VUHFN12_DEV_ID, VUHFN12_DEV_ID);
    $display("@%0t:Wr_APM DONE",$time);
  endtask


  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /*task  automatic Axis_Treq_NwriteTest;

      input bit[3:0]   DstDevId;
      input bit[31:0]  DstBaseAddr;
      input bit[15:0]  DstOffsetAddr;
      input bit[7 :0]  BurstLen;

      bit [31:0] WrAddr;
      bit [33:0] WrAddr_m;
      
      RealBurstLen=BurstLen-1;
      while(~m_axis_treq_tready)
          @(posedge axis_clk);
      //initial
      m_axis_treq_tvalid = 1'b0;
      m_axis_treq_tkeep  = 8'hff;
      m_axis_treq_tuser  = 32'h0;
      m_axis_treq_tlast  = 1'b0;
      m_axis_treq_tdata  = 64'h0;
      @(posedge axis_clk);
      //Send Hdr
      WrAddr = DstBaseAddr + {16'h0, DstOffsetAddr};
      WrAddr_m = WrAddr<<2;
      m_axis_treq_tvalid = 1'b1;
      m_axis_treq_tlast  = 1'b0;
      m_axis_treq_tkeep  = 8'hff;
      m_axis_treq_tuser  ={8'h0, SRC_DEV_ID, 8'h0, DstDevId};
      m_axis_treq_tdata = {SrcTID,NWRITE,TNWR,R,PRIO,R,(RealBurstLen),R,R, WrAddr_m};



      @(posedge axis_clk);
      m_axis_treq_tdata[63:0] = {24'h0,(RealBurstLen*8),32'h0}; //32bit:LENGTH + 32标识


      @(posedge axis_clk);
      for(int i=1; i<8; i++)
      begin
          m_axis_treq_tdata[63:0] = i; //Reserved
          @(posedge axis_clk);
      end

      @(posedge axis_clk);
      // for(int i=0; i<BurstLen; i++)
      for(int i=1; i<BurstLen; i++)
      begin
          while(~m_axis_treq_tready)
              @(axis_clk);
          m_axis_treq_tvalid = 1'b1;
          m_axis_treq_tkeep  = 8'hff;
          m_axis_treq_tuser  ={8'h0, SRC_DEV_ID, 8'h0, DstDevId};
          m_axis_treq_tlast = (i==(BurstLen - 1'b1));
          m_axis_treq_tdata[63:60] = i*2-1;
          m_axis_treq_tdata[59:56] = i*2-1;
          m_axis_treq_tdata[55:52] = i*2-1;
          m_axis_treq_tdata[51:48] = i*2-1;
          m_axis_treq_tdata[47:44] = i*2-1;
          m_axis_treq_tdata[43:40] = i*2-1;
          m_axis_treq_tdata[39:36] = i*2-1;
          m_axis_treq_tdata[35:32] = i*2-1;
          m_axis_treq_tdata[31:28] = i*2;
          m_axis_treq_tdata[27:24] = i*2;
          m_axis_treq_tdata[23:20] = i*2;
          m_axis_treq_tdata[19:16] = i*2;
          m_axis_treq_tdata[15:12] = i*2;
          m_axis_treq_tdata[11:8]  = i*2;
          m_axis_treq_tdata[7:4]   = i*2;
          m_axis_treq_tdata[3:0]   = i*2;
          @(posedge axis_clk);
      end

      m_axis_treq_tvalid = 1'b0;
      m_axis_treq_tkeep  = 8'hff;
      m_axis_treq_tuser  = 32'h0;
      m_axis_treq_tlast  = 1'b0;
      m_axis_treq_tdata  = 64'h0;
      SrcTID++;
      @(posedge axis_clk);

  endtask*/

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  task  automatic Axis_Treq_NreadTest;
    input bit[3:0]   DstDevId;
    input bit[31:0]  DstBaseAddr;
    input bit[15:0]  DstOffsetAddr;
    input bit[7 :0]  BurstLen;
    bit [31:0] WrAddr;
    bit [33:0] WrAddr_m;
    RealBurstLen=BurstLen-1;
    while(~m_axis_treq_tready)
      @(posedge axis_clk);
    //initial
    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    @(posedge axis_clk);

    //Send Hdr
    WrAddr = DstBaseAddr + {16'h0, DstOffsetAddr};
    WrAddr_m = WrAddr<<2;

    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b1;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, SRC_DEV_ID, 8'h0, DstDevId};

    m_axis_treq_tdata = {SrcTID, NREAD,TNWR,R,PRIO,R,RealBurstLen,R,R,WrAddr_m};
    @(posedge axis_clk);
    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    SrcTID++;
  endtask
  ///////////////////////////////////////////////////////////////////////////////////////////////
  task  automatic Axis_Treq_DrbellTest;
    input bit[7:0]   DstDevId;
    input bit[7 :0]  Drbell_SrcId;
    bit [31:0] WrAddr;

    while(~m_axis_treq_tready)
      @(posedge axis_clk);
    //initial
    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    @(posedge axis_clk);
    //Send Hdr
    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b1;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, DstDevId, 8'h0,FPGA_ID };
    m_axis_treq_tdata = {SrcTID, DOORB,52'h0};
    @(posedge axis_clk);
    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    TestID++;
    SrcTID++;

  endtask



  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  /*  */
  task  automatic Axis_Treq_NreadTest_new;
    input bit[7:0]   SrcDevId;
    input bit[7:0]   DstDevId;
    input bit[31:0]  DstBaseAddr;
    input bit[15:0]  DstOffsetAddr;
    input bit[7 :0]  BurstLen;
    bit [31:0] WrAddr;
    bit [33:0] WrAddr_m;
    RealBurstLen=BurstLen-1;
    while(~m_axis_treq_tready)
      @(posedge axis_clk);
    //initial
    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    @(posedge axis_clk);

    //Send Hdr
    WrAddr = DstBaseAddr + {16'h0, DstOffsetAddr};
    WrAddr_m = WrAddr<<2;

    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b1;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, DstDevId, 8'h0, SrcDevId};

    m_axis_treq_tdata = {SrcTID, NREAD,TNWR,R,PRIO,R,8'h03,R,R,34'h0_5410_0000};//len=f
    @(posedge axis_clk);
    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    SrcTID++;
  endtask

  task  automatic Axis_Treq_NWrite_aa;
    input bit[7:0]   SrcDevId;
    input bit[7:0]   DstDevId;
    input bit[31:0]   BaseAdr;

    while(~m_axis_treq_tready)
      @(posedge axis_clk);
    //initial
    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    @(posedge axis_clk);

    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, DstDevId, 8'h0, SrcDevId};

    m_axis_treq_tdata = {SrcTID, 4'd5,4'd4,R,PRIO,R,8'h1f,R,R,34'h0_5410_0000};//len=f

    @(posedge axis_clk);
    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, DstDevId, 8'h0, SrcDevId};
    m_axis_treq_tdata = 64'h0000_0012_aaaa_aaaa;
    @(posedge axis_clk);
    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, DstDevId, 8'h0, SrcDevId};
    // m_axis_treq_tdata = 64'h0000_0000_0000_0000;
    m_axis_treq_tdata = 64'hDDDD_DDDD_DDDD_DDDD;
    @(posedge axis_clk);
    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, DstDevId, 8'h0, SrcDevId};
    m_axis_treq_tdata = 64'hEEEE_EEEE_EEEE_EEEE;

    @(posedge axis_clk);
    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b1;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, DstDevId, 8'h0, SrcDevId};
    m_axis_treq_tdata = 64'hFFFF_FFFF_FFFF_FFFF;

    @(posedge axis_clk);
    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    SrcTID++;
  endtask

  task  automatic Axis_Treq_NWrite_AA2ND;
    input bit[7:0]   SrcDevId;
    input bit[7:0]   DstDevId;
    input bit[31:0]   BaseAdr;

    bit [31:0] BaseAdr_m;
    bit [31:0] BaseAdr_m1;


    while(~m_axis_treq_tready)
      @(posedge axis_clk);
    //initial
    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    @(posedge axis_clk);

    BaseAdr_m1 = BaseAdr;
    BaseAdr_m = BaseAdr_m1<<2;

    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, DstDevId, 8'h0, SrcDevId};

    m_axis_treq_tdata = {SrcTID, 4'd5,4'd4,R,PRIO,R,8'h0f,R,R,34'h0_5410_0020};//len=f

    @(posedge axis_clk);
    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, DstDevId, 8'h0, SrcDevId};
    m_axis_treq_tdata = 64'h0a07_0201_0000_000a;

    @(posedge axis_clk);
    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b1;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, DstDevId, 8'h0, SrcDevId};
    m_axis_treq_tdata = 64'h0001_0203_0405_0607;


    @(posedge axis_clk);
    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    SrcTID++;
  endtask
  ///////////////////////////////////////////////////////////////////////////////////////////////
  task  automatic Axis_Treq_NWrite_r_AA3rd;
    input bit[7:0]   SrcDevId;
    input bit[7:0]   DstDevId;
    input bit[31:0]   BaseAdr;

    while(~m_axis_treq_tready)
      @(posedge axis_clk);
    //initial
    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    @(posedge axis_clk);

    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, DstDevId, 8'h0, SrcDevId};
    m_axis_treq_tdata = {SrcTID, 4'd5,4'd5,R,PRIO,R,8'h01,R,R,34'h0_5410_0036};

    @(posedge axis_clk);
    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b1;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, DstDevId, 8'h0, SrcDevId};
    m_axis_treq_tdata = 64'h0809_0102_0000_0000;

    @(posedge axis_clk);
    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    SrcTID++;
  endtask


  ///////////////////////////////////////////////////////////////////////////////////////////////
  task automatic Axis_Treq_NwriteIfc_new;
    input bit[3:0]   DstDevId;
    input bit[31:0]  DstBaseAddr;
    input bit[15:0]  DstOffsetAddr;
    input bit[15 :0]  Size;
    input bit [31:0][63:0] RpHelloData;

    int BurstLen;
    bit [31:0] WrAddr;
    bit [33:0] WrAddr_m;

    BurstLen = ((Size%8) == 0)? (Size/8) : (Size/8 + 1);

    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    @(posedge axis_clk);


    while(~m_axis_treq_tready)
      @(posedge axis_clk);

    WrAddr = DstBaseAddr + {16'h0, DstOffsetAddr};
    WrAddr_m = WrAddr<<2;
    m_axis_treq_tvalid = 1'b1;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  ={8'h0, DstDevId, 8'h0, FPGA_ID};
    m_axis_treq_tdata = {SrcTID,NWRITE,4'd4,R,PRIO,R, (Size[7:0] - 1'b1), R, R, 34'h0_5410_0000};
    @(posedge axis_clk);


    for(int i=0; i<BurstLen; i++)
    begin
      while(~m_axis_treq_tready)
        @(posedge axis_clk);

      m_axis_treq_tvalid<= 1'b1;
      m_axis_treq_tlast <=(i == (BurstLen - 1'b1))? 1'b1 : 1'b0;
      m_axis_treq_tkeep <= 8'hff;
      m_axis_treq_tuser <={8'h0, DstDevId, 8'h0, FPGA_ID};
      m_axis_treq_tdata <=RpHelloData[i];
      @(posedge axis_clk);
    end

    m_axis_treq_tvalid = 1'b0;
    m_axis_treq_tkeep  = 8'hff;
    m_axis_treq_tuser  = 32'h0;
    m_axis_treq_tlast  = 1'b0;
    m_axis_treq_tdata  = 64'h0;
    @(posedge axis_clk);
  endtask
  ///////////////////////////////////////////////////////////////////////////////////////////////
  task  automatic Rp_Treq_NwriteZhData_new;
    input bit[31:0] Rp_PkgLen;
    input bit[7:0]   DstDevId;
    input bit[31:0]  DstBaseAddr;
    input bit[15:0]  DstOffsetAddr;

    input bit[7:0]SrcIdLock;
    input bit[7:0]DstIdLock;
    input bit[7:0]Info_Attr; //2
    input bit[7:0]Info_Type; //1//2

    int Zh_Len;
    int BurstHelloCnt;
    int End64BCnt;
    int EndBytes;
    int i;
    int j;
    bit [31:0][63:0] HelloData;

    bit[15:0]  OffsetAddr;

    Zh_Len = GenZHPkg(Rp_PkgLen,SrcIdLock,DstIdLock,Info_Attr,Info_Type);

    BurstHelloCnt  = (Zh_Len%256 == 0)? (Zh_Len/256) : (Zh_Len/256 + 1'b1);

    EndBytes = Zh_Len%256;

    if(EndBytes == 0)
      End64BCnt = 32;
    else
      End64BCnt = (EndBytes%8 == 0)? (EndBytes/8) : (EndBytes/8 + 1);

    OffsetAddr = DstOffsetAddr;

    for(i=0; i<BurstHelloCnt; i++)
    begin
      if(i == (BurstHelloCnt - 1))
      begin
        for(j=0; j<End64BCnt; j++)
        begin
          HelloData[j] = Rp64BArray[32*i+j];
        end

        Axis_Treq_NwriteIfc_new(DstDevId, DstBaseAddr, OffsetAddr,EndBytes, HelloData);

      end
      else
      begin
        for(j=0; j<32; j++)
        begin
          HelloData[j] = Rp64BArray[32*i+j];
        end

        Axis_Treq_NwriteIfc_new(DstDevId, DstBaseAddr, OffsetAddr,256, HelloData);
      end

      OffsetAddr = OffsetAddr + 16'd64;

    end

  endtask

endmodule

