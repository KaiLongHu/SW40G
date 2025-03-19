/****************************************************************
*Company:  CETC54
*Engineer: liyuan
 
*Create Date   : Sunday, the 21 of April, 2019  09:18:09
*Design Name   :
*Module Name   : CZCSUCpuIfc.sv
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
`timescale 1ns / 1ns
// synopsys translate_on
module LedTestCpuIfc (
    input wire SysClk,
    input wire RstCpu_n,
    input wire CpuClk,
    input wire CpuCs_n,
    input wire CpuWr_n,
    input wire CpuRd_n,
    input wire [16:0] CpuAddr,
    input wire [15:0] CpuData_out,
    output wire [15:0] CpuData_in,


    output wire CpuLocWr,
    output wire CpuLocRd,
    output wire [22:0] CpuLocAddr,  //Address
    output wire [15:0] CpuLocWrData,

    output wire CpuLocCsn2,
    input wire [15:0] CpuLocRdData2,
    output wire CpuLocCsn3,
    input wire [15:0] CpuLocRdData3,
    output wire CpuLocCsn41,
    input wire [15:0] CpuLocRdData41,


    output reg  AllCntClr,
    output wire Soft_Rst_n


);
  ///////////////////////////////Signal Define/////////////////////////////////
  wire CpuLocCsn;
  reg [15:0] WrDataLock;

  wire CpuLocCsn1;
  reg [15:0] CpuLocRdData1;
  wire CpuLocCsn4;
  reg [15:0] CpuRdDataReg;
  wire [23:0] CpuCsVector;

  reg Soft_Rst;

  // wire CpuLocCsn41;
  // wire [15:0] CpuLocRdData41;
  wire CpuLocCsn42;
  wire [15:0] CpuLocRdData42;
  wire CpuLocCsn43;
  wire [15:0] CpuLocRdData43;
  wire CpuLocCsn44;
  wire [15:0] CpuLocRdData44;
  wire CpuLocCsn45;
  wire [15:0] CpuLocRdData45;
  wire CpuLocCsn46;
  wire [15:0] CpuLocRdData46;
  wire CpuLocCsn47;
  wire [15:0] CpuLocRdData47;
  wire CpuLocCsn48;
  wire [15:0] CpuLocRdData48;

  wire CpuLocCsn5;
  wire [15:0] CpuLocRdData5;
  wire CpuLocCsn6;
  wire [15:0] CpuLocRdData6;
  ////////////////////////////////////////////////////////////////////////////////////////////////
  assign CpuLocCsn = (~CpuCs_n) ? 1'b0 : 1'b1;
  assign CpuLocWr = ~CpuWr_n;
  assign CpuLocRd = ~CpuRd_n;
  assign CpuLocAddr = CpuAddr;
  assign CpuLocWrData = ((~CpuCs_n) && (~CpuWr_n)) ? CpuData_out : WrDataLock;

  always @(negedge RstCpu_n or posedge CpuClk) begin
    if (~RstCpu_n) WrDataLock <= 16'h0000;
    else WrDataLock <= CpuLocWrData;
  end
  ////////////////////////////////////////////////////////////////////////////////

  assign CpuLocCsn1 = ((~CpuLocCsn) && (CpuLocAddr[16:14] == 0)) ? 1'b0 : 1'b1;  //0x00000
  assign CpuLocCsn2 = ((~CpuLocCsn) && (CpuLocAddr[16:14] == 1)) ? 1'b0 : 1'b1;  //0x04000
  assign CpuLocCsn3 = ((~CpuLocCsn) && (CpuLocAddr[16:14] == 2)) ? 1'b0 : 1'b1;  //0x08000

  assign CpuLocCsn4 = ((~CpuLocCsn) && (CpuLocAddr[16:14] == 3)) ? 1'b0 : 1'b1;  //0x0c000
  assign CpuLocCsn41 = ((~CpuLocCsn4) && (CpuLocAddr[13:11] == 0)) ? 1'b0 : 1'b1;  //0x0c000;
  assign CpuLocCsn42 = ((~CpuLocCsn4) && (CpuLocAddr[13:11] == 1)) ? 1'b0 : 1'b1;  //0x0c800;
  assign CpuLocCsn43 = ((~CpuLocCsn4) && (CpuLocAddr[13:11] == 2)) ? 1'b0 : 1'b1;  //0x0d000;
  assign CpuLocCsn44 = ((~CpuLocCsn4) && (CpuLocAddr[13:11] == 3)) ? 1'b0 : 1'b1;  //0x0d800;
  assign CpuLocCsn45 = ((~CpuLocCsn4) && (CpuLocAddr[13:11] == 4)) ? 1'b0 : 1'b1;  //0x0e000;
  assign CpuLocCsn46 = ((~CpuLocCsn4) && (CpuLocAddr[13:11] == 5)) ? 1'b0 : 1'b1;  //0x0e800;
  assign CpuLocCsn47 = ((~CpuLocCsn4) && (CpuLocAddr[13:11] == 6)) ? 1'b0 : 1'b1;  //0x0f000;
  assign CpuLocCsn48 = ((~CpuLocCsn4) && (CpuLocAddr[13:11] == 7)) ? 1'b0 : 1'b1;  //0x0f800;

  assign CpuLocCsn5 = ((~CpuLocCsn) && (CpuLocAddr[16:14] == 4)) ? 1'b0 : 1'b1;  //0x10000
  assign CpuLocCsn6 = ((~CpuLocCsn) && (CpuLocAddr[16:14] == 5)) ? 1'b0 : 1'b1;  //0x14000
  ////////////////////////////////////////////////////////////////////////////////

  assign CpuCsVector = {
    11'b0,
    (~CpuLocCsn6),
    (~CpuLocCsn5),
    (~CpuLocCsn48),
    (~CpuLocCsn47),
    (~CpuLocCsn46),
    (~CpuLocCsn45),
    (~CpuLocCsn44),
    (~CpuLocCsn43),
    (~CpuLocCsn42),
    (~CpuLocCsn41),
    (~CpuLocCsn3),
    (~CpuLocCsn2),
    (~CpuLocCsn1)
  };

  always @(negedge RstCpu_n or posedge CpuClk) begin
    if (~RstCpu_n) CpuRdDataReg <= 16'h0000;
    else begin
      case (CpuCsVector)
        24'h000001: CpuRdDataReg <= CpuLocRdData1;
        24'h000002: CpuRdDataReg <= CpuLocRdData2;
        24'h000004: CpuRdDataReg <= CpuLocRdData3;
        24'h000008: CpuRdDataReg <= CpuLocRdData41;
        24'h000010: CpuRdDataReg <= CpuLocRdData42;
        24'h000020: CpuRdDataReg <= CpuLocRdData43;
        24'h000040: CpuRdDataReg <= CpuLocRdData44;
        24'h000080: CpuRdDataReg <= CpuLocRdData45;
        24'h000100: CpuRdDataReg <= CpuLocRdData46;
        24'h000200: CpuRdDataReg <= CpuLocRdData47;
        24'h000400: CpuRdDataReg <= CpuLocRdData48;
        24'h000800: CpuRdDataReg <= CpuLocRdData5;
        24'h001000: CpuRdDataReg <= CpuLocRdData6;
        default: CpuRdDataReg <= 16'hffff;
      endcase
    end
  end
  //////////////////////////////////////////////////////////////////////////////////
  assign CpuData_in = CpuRdDataReg;
  /////////////////////////////////////////////////////////////////////////////////
  //Global Cfg
  always @(negedge RstCpu_n or posedge CpuClk) begin
    if (~RstCpu_n) begin
      Soft_Rst         <= 1'b0;
    end else begin
      Soft_Rst         <= ((~CpuLocCsn1) && CpuLocWr && (CpuLocAddr[7:0] == 9'h00b))? CpuLocWrData[0]  : Soft_Rst;
    end
  end

  assign Soft_Rst_n = ~Soft_Rst;

  always @* begin
    if (~CpuLocCsn1) begin
      case (CpuLocAddr[8:0])
        9'h000: CpuLocRdData1 = 16'h0001;  //Board Type
        9'h001: CpuLocRdData1 = 16'h0001;  //Board Version
        9'h002: CpuLocRdData1 = 16'h1971;  //BOARD US_NUM
        9'h003: CpuLocRdData1 = 16'h0101;  //FPGA Version,V0.1.0.1
        9'h004: CpuLocRdData1 = 16'h2024;  //Year
        9'h005: CpuLocRdData1 = 16'h0109;  //Month,Day
        9'h006: CpuLocRdData1 = 16'h0109;  //Time
        9'h00b: CpuLocRdData1 = {15'h0, Soft_Rst};
        default: CpuLocRdData1 = 16'hffff;
      endcase
    end
  end




  ////////////////////////////////////////////////////////////////////////////////
endmodule
