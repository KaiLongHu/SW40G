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
//Gen Clk--------------------------------------------
// `define ClkGen_125M;
`define ClkGen_CpuClk;
// `define ClkGen_SpiClk;
// `define ClkGen_25M;
//Gen Simulation Data--------------------------------------------
// `define Cpu_Inf;


//--------------------------------------------
`define RgmiiEthTestData    Sw_40g_Core_Tb.BaseXEthTestData_InstRgmii
`define CpuIfcTest          Sw_40g_Core_Tb.CpuIfcTest_Inst
`define RapidIO_PkgDta      Sw_40g_Core_Tb.BaseXEthTestData_Inst0

module Sw_40g_Core_Tb();
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////        SIG DEF                   ///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //CFG SETTING--------------------------------------------

  //General CLK RST--------------------------------------------
  bit RstSys_n;
  bit Rst_n;
  bit SysClk;
  //Cpu LocalBus--------------------------------------------
  bit CpuCs_n=1'b1;
  bit CpuWr_n;
  bit CpuRd_n;
  bit [16:0] CpuAddr;
  bit [15:0] CpuWrData;
  bit [15:0] CpuRdData;
  //ETH PKG GEN--------------------------------------------
  bit [7:0]Test_Ready;
  bit [7:0]Test_Valid;
  bit [7:0]Test_Sop;
  bit [7:0]Test_Eop;
  bit [7:0][31:0]Test_Data;
  bit [7:0][3:0] Test_Keep;
  //DUT CORE--------------------------------------------
  bit  log_rst;
  bit  FifoRst_n;
  bit  Clk125m;
  bit  Rstaxis_n;
  bit  s_axis_clk;
  bit  [1:0][1:0][7:0] deviceid;
  bit  [1:0]s_axis_ireq_tvalid;
  bit  [1:0]s_axis_ireq_tready;
  bit  [1:0]s_axis_ireq_tlast;
  bit  [1:0][63:0] s_axis_ireq_tdata;
  bit  [1:0][7:0] s_axis_ireq_tkeep;
  bit  [1:0][31:0] s_axis_ireq_tuser;
  bit  [1:0]m_axis_iresp_tvalid;
  bit  [1:0]m_axis_iresp_tready;
  bit  [1:0]m_axis_iresp_tlast;
  bit  [1:0][63:0] m_axis_iresp_tdata;
  bit  [1:0][7:0] m_axis_iresp_tkeep;
  bit  [1:0][31:0] m_axis_iresp_tuser;
  bit  [1:0]m_axis_treq_tvalid;
  bit  [1:0]m_axis_treq_tready;
  bit  [1:0]m_axis_treq_tlast;
  bit  [1:0][63:0] m_axis_treq_tdata;
  bit  [1:0][7:0] m_axis_treq_tkeep;
  bit  [1:0][31:0] m_axis_treq_tuser;
  bit  [1:0]s_axis_tresp_tvalid;
  bit  [1:0]s_axis_tresp_tready;
  bit  [1:0]s_axis_tresp_tlast;
  bit  [1:0][63:0] s_axis_tresp_tdata;
  bit  [1:0][7:0] s_axis_tresp_tkeep;
  bit  [1:0][31:0] s_axis_tresp_tuser;

  bit  RapidIO_RxReady;
  bit  RapidIO_RxEn;
  bit  RapidIO_RxMirType;
  bit  RapidIO_RxSop;
  bit  RapidIO_RxEop;
  bit  RapidIO_RxValid;
  bit  [31:0]RapidIO_RxData;
  bit  [3:0] RapidIO_RxKeep;
  bit   RapidIO_TxReady;
  bit  RapidIO_TxEn;
  bit   RapidIO_TxValid;
  bit   RapidIO_TxSop;
  bit   RapidIO_TxEop;
  bit  [31:0] RapidIO_TxData;
  bit  [3:0] RapidIO_TxKeep;
  bit  [15:0] RapidIO_TxLen;
  bit CntClr;
  bit  CpuClk;
  bit  Cpu_Cs;
  bit  Cpu_Wr;
  bit  Cpu_Rd;
  bit [16:0] Cpu_Addr;
  bit [15:0] Cpu_WrData;
  bit  [15:0] Cpu_RdData;

  //--------------------------------------------
  bit CpuCs;
  bit CpuWr;
  bit CpuRd;
  bit [15:0] CpuData_out;
  bit [15:0] CpuData_in;

  bit CpuLocWr;
  bit CpuLocRd;
  bit [22:0] CpuLocAddr;
  bit [15:0] CpuLocWrData;
  bit CpuLocCsn2;
  bit [15:0] CpuLocRdData2;
  bit CpuLocCsn3;
  bit [15:0] CpuLocRdData3;
  bit CpuLocCsn41;
  bit [15:0] CpuLocRdData41;
  bit AllCntClr;
  bit Soft_Rst_n;

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////        CLK RST GEN                   ///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  sys_reset_gen #(
                  .RST_TIME(200),
                  .RST_LEVEL(0)
                )sys_reset_gen_inst(
                  .reset(RstSys_n)
                );

  sys_reset_gen #(
                  .RST_TIME(200),
                  .RST_LEVEL(0)
                )reset_gen_inst(
                  .reset(Rst_n)
                );


  sys_clk_gen #(
                .CLK_FREQUENCE(100),
                .CLK_PHASE(0)
              )sys_clk_gen_inst(
                .clk(SysClk)
              );
  ///////////////////////////////////////////////////////////////////////////////////////////////
  sys_reset_gen #(
                  .RST_TIME(200),
                  .RST_LEVEL(1)
                )log_n_inst(
                  .reset(log_rst)
                );

  sys_reset_gen #(
                  .RST_TIME(300),
                  .RST_LEVEL(0)
                )fifo_n_inst(
                  .reset(FifoRst_n)
                );

  bit RefCLK25M;
  sys_clk_gen #(
                .CLK_FREQUENCE(25),
                .CLK_PHASE(0)
              )sys_clk_gen_instx(
                .clk(RefCLK25M)
              );


  bit RefClk125M;
  sys_clk_gen #(
                .CLK_FREQUENCE(125),
                .CLK_PHASE(0)
              )sys_clk_gen_inst1(
                .clk(RefClk125M)
              );

  bit RefPhShiftClk125M;
  sys_clk_gen #(
                .CLK_FREQUENCE(125),
                .CLK_PHASE(62.5)
              )sys_clk_gen_inst125Ph(
                .clk(RefPhShiftClk125M)
              );


  bit XUpdataSpiClk;
  sys_clk_gen #(
                .CLK_FREQUENCE(10),
                .CLK_PHASE(0)
              )sys_clk_gen_inst6(
                .clk(XUpdataSpiClk)
              );
  sys_clk_gen #(
                .CLK_FREQUENCE(100),
                .CLK_PHASE(50)
              )cpu_clk_gen(
                .clk(CpuClk)
              );

  bit log_clk;
  sys_clk_gen #(
                .CLK_FREQUENCE(31.25),
                .CLK_PHASE(0)
              )log_clk_gen(
                .clk(log_clk)
              );

              bit CLK_156_25;
  sys_clk_gen #(
                .CLK_FREQUENCE(156.25),
                .CLK_PHASE(0)
              )clk156_gen(
                .clk(CLK_156_25)
              );
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////              Support                   /////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  assign CpuCs =  ~CpuCs_n;
  assign CpuWr =  ~CpuWr_n;
  assign CpuRd =  ~CpuRd_n;


  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////        Vector Gen                   ///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  CpuIfcTest CpuIfcTest_Inst(
               .Rst_n(Rst_n),
               .CpuClk(SysClk),
               .CpuCs(CpuCs_n),
               .CpuWr(CpuWr_n),
               .CpuRd(CpuRd_n),
               .CpuAddr(CpuAddr),
               .CpuWrData(CpuData_out),//O
               .CpuRdData(CpuData_in)
             );




  BaseXEthTestData BaseXEthTestData_Inst0(
                     .SysClk(CLK_156_25),

                     .BaseXTxReady(1'b1),
                     .BaseXTxValid(RapidIO_RxValid),
                     .BaseXTxSop(RapidIO_RxSop),
                     .BaseXTxEop(RapidIO_RxEop),
                     .BaseXTxData(RapidIO_RxData),
                     .BaseXTxKeep(RapidIO_RxKeep)
                   );





  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////        DUT                   ///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Sw_40g_Core  Sw_40g_Core_inst (
                 .Rst_n(Rst_n),
                 .SysClk(SysClk),
                 .lane1_s_axi_tx_clk(CLK_156_25),
                 .lane1_s_axi_tx_tdata(),
                 .lane1_s_axi_tx_tkeep(),
                 .lane1_s_axi_tx_tlast(),
                 .lane1_s_axi_tx_tvalid(),
                 .lane1_s_axi_tx_tready('0),
                 .lane1_m_axi_rx_clk(CLK_156_25),
                 .lane1_m_axi_rx_tdata({3{RapidIO_RxData}}),
                 .lane1_m_axi_rx_tkeep({3{RapidIO_RxKeep}}),
                 .lane1_m_axi_rx_tlast({3{RapidIO_RxEop}}),
                 .lane1_m_axi_rx_tvalid({3{RapidIO_RxValid}}),
                 .lane4_s_axi_tx_clk(CLK_156_25),
                 .lane4_s_axi_tx_tdata(),
                 .lane4_s_axi_tx_tkeep(),
                 .lane4_s_axi_tx_tlast(),
                 .lane4_s_axi_tx_tvalid(),
                 .lane4_s_axi_tx_tready('0),
                 .lane4_m_axi_rx_clk(CLK_156_25),
                 .lane4_m_axi_rx_tdata(lane4_m_axi_rx_tdata),
                 .lane4_m_axi_rx_tkeep(lane4_m_axi_rx_tkeep),
                 .lane4_m_axi_rx_tlast(lane4_m_axi_rx_tlast),
                 .lane4_m_axi_rx_tvalid(lane4_m_axi_rx_tvalid),
                 .Base10G_tx_axis_fifo_aclk(CLK_156_25),
                 .Base10G_tx_axis_fifo_tdata(Base10G_tx_axis_fifo_tdata),
                 .Base10G_tx_axis_fifo_tkeep(Base10G_tx_axis_fifo_tkeep),
                 .Base10G_tx_axis_fifo_tvalid(Base10G_tx_axis_fifo_tvalid),
                 .Base10G_tx_axis_fifo_tlast(Base10G_tx_axis_fifo_tlast),
                 .Base10G_tx_axis_fifo_tready(Base10G_tx_axis_fifo_tready),
                 .Base10G_rx_axis_fifo_aclk(CLK_156_25),
                 .Base10G_rx_axis_fifo_tdata(Base10G_rx_axis_fifo_tdata),
                 .Base10G_rx_axis_fifo_tkeep(Base10G_rx_axis_fifo_tkeep),
                 .Base10G_rx_axis_fifo_tvalid(Base10G_rx_axis_fifo_tvalid),
                 .Base10G_rx_axis_fifo_tlast(Base10G_rx_axis_fifo_tlast),
                 .Base10G_rx_axis_fifo_tready(Base10G_rx_axis_fifo_tready)
               );





  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////        Initial                   ///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  initial
  begin
    begin
      while(~RstSys_n)
        @(posedge SysClk);
      $display("@%0t:Simulation Begin",$time);
      repeat(5000) @(posedge SysClk);
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      begin
        int i;
        for(i=0; i<10; i=i+1)
        begin
          `RapidIO_PkgDta.BaseXEthVlanDataTest(1,12'h101,48'haabb_ccdd_eeff,48'h1122_3344_5566,8'h11,32'h5454_1234,32'h5454_5678,16'h2711,16'h2710,7'h3f,(16'd64+i));
          repeat(500) @(posedge SysClk);
        end
      end


      repeat(100) @(posedge SysClk);
      $stop();
    end
  end

endmodule
