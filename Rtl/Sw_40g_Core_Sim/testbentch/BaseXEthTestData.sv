/****************************************************************
*Company:  CETC54
*Engineer: liyuan

*Create Date   : Monday, the 13 of May, 2019  15:54:55
*Design Name   :
*Module Name   : AIfcCoreTestData.sv
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
module BaseXEthTestData (
   input  wire SysClk,
   
   input  wire BaseXTxReady,
   output reg  BaseXTxValid,
   output reg  BaseXTxSop,
   output reg  BaseXTxEop,
   output reg  [31:0] BaseXTxData,
   output reg  [3:0]  BaseXTxKeep

);

///////////////////////////////Signal Define/////////////////////////////////
 bit [2047:0][7:0] MacDataArray;
 bit [2047:0][7:0] DataArray[2];
///////////////////////////////Signal Define/////////////////////////////////
  localparam LOCAL_MAC_ADDR = 48'h0054_5400_11aa;
  localparam SW_MAC_ADDR    = 48'h0054_5400_22bb;
  localparam CPU_MAC_ADDR   = 48'h0054_5400_33cc;


/////////////////////////////////////////////////////////////////////////////
  function automatic int GenUdpPkg;
     input int PortNum;
     input bit [15:0] UdpSrcPortNum;
     input bit [15:0] UdpDstPortNum;
     input bit [6:0] UUi;
     input int PayLoadLen;
     
     bit [15:0] UDPTolLen;
     
     UDPTolLen = PayLoadLen + 20;

     //Udp Head
     DataArray[PortNum][36] = UdpSrcPortNum[15:8];
     DataArray[PortNum][37] = UdpSrcPortNum[7:0];

     DataArray[PortNum][38] = UdpDstPortNum[15:8];
     DataArray[PortNum][39] = UdpDstPortNum[7:0];

     DataArray[PortNum][40] = UDPTolLen[15:8];
     DataArray[PortNum][41] = UDPTolLen[7:0];

     DataArray[PortNum][42] = 8'h00;
     DataArray[PortNum][43] = 8'h00;

     DataArray[PortNum][44] = 8'h00;
     DataArray[PortNum][45] = {1'b0,UUi};

     for(int i=0; i<10; i++) begin
     	DataArray[PortNum][46+i] = 8'h00;
     end

     for(int j=0; j<PayLoadLen; j++) begin
       DataArray[PortNum][56+j] = j;
     end

     return(20+PayLoadLen);

  endfunction
//////////////////////////////////////////////////////////////////////////////
   function  automatic int  GenEthIpPkg;
      input int PortNum;
      input bit [7:0]  IpType;
      input bit [31:0] SrcIpAddr;
      input bit [31:0] DstIpAddr;
      input bit [15:0] UdpLen;

      bit [15:0] IpLen;

      IpLen = UdpLen + 20;

      DataArray[PortNum][16] = 8'h45;
      DataArray[PortNum][17] = 8'h00;
      DataArray[PortNum][18] = IpLen[15:8];
      DataArray[PortNum][19] = IpLen[7:0];

      DataArray[PortNum][20] = 8'h00;
      DataArray[PortNum][21] = 8'h00;
      DataArray[PortNum][22] = 8'h00;
      DataArray[PortNum][23] = 8'h00;

      DataArray[PortNum][24] = 8'hff;
      DataArray[PortNum][25] = IpType;
      DataArray[PortNum][26] = 8'h00;
      DataArray[PortNum][27] = 8'h00;

      DataArray[PortNum][28] = SrcIpAddr[31:24];
      DataArray[PortNum][29] = SrcIpAddr[23:16];
      DataArray[PortNum][30] = SrcIpAddr[15:8];
      DataArray[PortNum][31] = SrcIpAddr[7:0];

      DataArray[PortNum][32] = DstIpAddr[31:24];
      DataArray[PortNum][33] = DstIpAddr[23:16];
      DataArray[PortNum][34] = DstIpAddr[15:8];
      DataArray[PortNum][35] = DstIpAddr[7:0];

      return(IpLen);

   endfunction
//////////////////////////////////////////////////////////////////////////////
   function automatic int GenEthMacNoVlanData;
      input int PortNum;
      input bit [47:0] SrcMacAddr;
      input bit [47:0] DstMacAddr;
      input bit [7:0]  IpType;
      input bit [31:0] SrcIpAddr;
      input bit [31:0] DstIpAddr;
      input bit [15:0] SrcPortNum;
      input bit [15:0] DstPortNum;
      input bit [6:0]  UUi;
      input bit [15:0] IpPkgLen;

      int PlLen;
      int UdpLen;
      int IpLen;

      PlLen  = (IpPkgLen - 40);
      UdpLen = GenUdpPkg(PortNum, SrcPortNum, DstPortNum, UUi, PlLen);
      IpLen  = GenEthIpPkg(PortNum, IpType, SrcIpAddr, DstIpAddr, UdpLen);

       DataArray[PortNum][0] = DstMacAddr[47:40];
       DataArray[PortNum][1] = DstMacAddr[39:32];
       DataArray[PortNum][2] = DstMacAddr[31:24];
       DataArray[PortNum][3] = DstMacAddr[23:16];
       DataArray[PortNum][4] = DstMacAddr[15:8];
       DataArray[PortNum][5] = DstMacAddr[7:0];

       DataArray[PortNum][6]  = SrcMacAddr[47:40];
       DataArray[PortNum][7]  = SrcMacAddr[39:32];
       DataArray[PortNum][8]  = SrcMacAddr[31:24];
       DataArray[PortNum][9]  = SrcMacAddr[23:16];
       DataArray[PortNum][10] = SrcMacAddr[15:8];
       DataArray[PortNum][11] = SrcMacAddr[7:0];

       DataArray[PortNum][12] = 8'h08;
       DataArray[PortNum][13] = 8'h06;

       DataArray[PortNum][14] = 8'h00;
       DataArray[PortNum][15] = 8'h00;

       return(IpPkgLen+16);

   endfunction
////////////////////////////////////////////////////////////////////////////////
   task automatic BaseXEthNoVlanDataTest;
      input int PortNum;
      input bit [47:0] SrcMacAddr;
      input bit [47:0] DstMacAddr;
      input bit [7:0]  IpType;
      input bit [31:0] SrcIpAddr;
      input bit [31:0] DstIpAddr;
      input bit [15:0] SrcPortNum;
      input bit [15:0] DstPortNum;
      input bit [6:0]  UUi;
      input bit [15:0] IpPkgLen;

      int TotalLen;
      int PkgWordLen;
      bit [3:0] Keep;

      TotalLen = GenEthMacNoVlanData(PortNum, SrcMacAddr, DstMacAddr, IpType, SrcIpAddr, DstIpAddr, SrcPortNum, DstPortNum, UUi, IpPkgLen);

      PkgWordLen = ((TotalLen%4) == 0)? (TotalLen/4) : (TotalLen/4 + 1);
         $display("%d", PkgWordLen);
      case(TotalLen%4)
        0: Keep = 4'hf;
        1: Keep = 4'h8;
        2: Keep = 4'hc;
        3: Keep = 4'he;
        default: Keep = 4'hf;
      endcase


      //BaseX_TxReady = '1;

      while(~BaseXTxReady) @(posedge SysClk);
      for(int i=0; i<PkgWordLen; i++) begin

        BaseXTxValid = '1;
        BaseXTxSop   = (i == 0);
        BaseXTxEop   = (i ==(PkgWordLen - 1));
        BaseXTxKeep  = (i ==(PkgWordLen - 1))? Keep : 4'h0;

        if( i == (PkgWordLen - 1)) begin
        	 case(Keep)
            4'h8: BaseXTxData  = {DataArray[PortNum][i*4], 24'h0};
            4'hc: BaseXTxData  = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], 16'h0};
            4'he: BaseXTxData  = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], 8'h0};
            default: BaseXTxData= {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], DataArray[PortNum][i*4+3]};
          endcase
         end
        else
        BaseXTxData	 = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], DataArray[PortNum][i*4+3]};

        @(posedge SysClk);

      end


      BaseXTxValid = '0;
      BaseXTxSop   = '0;
      BaseXTxEop   = '0;
      BaseXTxKeep  = '0;
      BaseXTxData  = '0; 
      @(posedge SysClk);

   endtask



/////////////////////////////////////////////////////////////////////////////
  function automatic int GenUdpVlanPkg;
     input int PortNum;
     input bit [15:0] UdpSrcPortNum;
     input bit [15:0] UdpDstPortNum;
     input bit [6:0] UUi;
     input int PayLoadLen;
     
     bit [15:0] UDPTolLen;
     
     UDPTolLen = PayLoadLen + 20;

     //Udp Head
     DataArray[PortNum][40] = UdpSrcPortNum[15:8];
     DataArray[PortNum][41] = UdpSrcPortNum[7:0];

     DataArray[PortNum][42] = UdpDstPortNum[15:8];
     DataArray[PortNum][43] = UdpDstPortNum[7:0];

     DataArray[PortNum][44] = UDPTolLen[15:8];
     DataArray[PortNum][45] = UDPTolLen[7:0];

     DataArray[PortNum][46] = 8'h00;
     DataArray[PortNum][47] = 8'h00;

     DataArray[PortNum][48] = 8'h00;
     DataArray[PortNum][49] = {1'b0,UUi};

     for(int i=0; i<10; i++) begin
     	DataArray[PortNum][50+i] = 8'h00;
     end

     for(int j=0; j<PayLoadLen; j++) begin
       DataArray[PortNum][60+j] = j;
     end

     return(20+PayLoadLen);

  endfunction
//////////////////////////////////////////////////////////////////////////////
   function  automatic int  GenVlanIpPkg;
      input int PortNum;
      input bit [7:0]  IpType;
      input bit [31:0] SrcIpAddr;
      input bit [31:0] DstIpAddr;
      input bit [15:0] UdpLen;

      bit [15:0] IpLen;

      IpLen = UdpLen + 20;

      DataArray[PortNum][20] = 8'h45;
      DataArray[PortNum][21] = 8'h00;
      DataArray[PortNum][22] = IpLen[15:8];
      DataArray[PortNum][23] = IpLen[7:0];

      DataArray[PortNum][24] = 8'h00;
      DataArray[PortNum][25] = 8'h00;
      DataArray[PortNum][26] = 8'h00;
      DataArray[PortNum][27] = 8'h00;

      DataArray[PortNum][28] = 8'hff;
      DataArray[PortNum][29] = IpType;
      DataArray[PortNum][30] = 8'h00;
      DataArray[PortNum][31] = 8'h00;

      DataArray[PortNum][32] = SrcIpAddr[31:24];
      DataArray[PortNum][33] = SrcIpAddr[23:16];
      DataArray[PortNum][34] = SrcIpAddr[15:8];
      DataArray[PortNum][35] = SrcIpAddr[7:0];

      DataArray[PortNum][36] = DstIpAddr[31:24];
      DataArray[PortNum][37] = DstIpAddr[23:16];
      DataArray[PortNum][38] = DstIpAddr[15:8];
      DataArray[PortNum][39] = DstIpAddr[7:0];

      return(IpLen);

   endfunction
//////////////////////////////////////////////////////////////////////////////
   function automatic int GenVlanMacData;
      input int PortNum;
      input bit [11:0] VlanCfg;
      input bit [47:0] SrcMacAddr;
      input bit [47:0] DstMacAddr;
      input bit [7:0]  IpType;
      input bit [31:0] SrcIpAddr;
      input bit [31:0] DstIpAddr;
      input bit [15:0] SrcPortNum;
      input bit [15:0] DstPortNum;
      input bit [6:0]  UUi;
      input bit [15:0] IpPkgLen;

      int PlLen;
      int UdpLen;
      int IpLen;

      PlLen  = (IpPkgLen - 40);
      UdpLen = GenUdpVlanPkg(PortNum, SrcPortNum, DstPortNum, UUi, PlLen);
      IpLen  = GenVlanIpPkg(PortNum, IpType, SrcIpAddr, DstIpAddr, UdpLen);

       DataArray[PortNum][0] = DstMacAddr[47:40];
       DataArray[PortNum][1] = DstMacAddr[39:32];
       DataArray[PortNum][2] = DstMacAddr[31:24];
       DataArray[PortNum][3] = DstMacAddr[23:16];
       DataArray[PortNum][4] = DstMacAddr[15:8];
       DataArray[PortNum][5] = DstMacAddr[7:0];

       DataArray[PortNum][6]  = SrcMacAddr[47:40];
       DataArray[PortNum][7]  = SrcMacAddr[39:32];
       DataArray[PortNum][8]  = SrcMacAddr[31:24];
       DataArray[PortNum][9]  = SrcMacAddr[23:16];
       DataArray[PortNum][10] = SrcMacAddr[15:8];
       DataArray[PortNum][11] = SrcMacAddr[7:0];

       DataArray[PortNum][12] = 8'h81;
       DataArray[PortNum][13] = 8'h00;
       DataArray[PortNum][14] = {4'h0, VlanCfg[11:8]};
       DataArray[PortNum][15] = VlanCfg[7:0];

       DataArray[PortNum][16] = 8'h08;
       DataArray[PortNum][17] = 8'h00;

       DataArray[PortNum][18] = 8'h00;
       DataArray[PortNum][19] = 8'h00;

       return(IpPkgLen+20);

   endfunction
////////////////////////////////////////////////////////////////////////////////
   task automatic BaseXEthVlanDataTest;
      input int PortNum;
      input bit [11:0] VlanTag;
      input bit [47:0] SrcMacAddr;
      input bit [47:0] DstMacAddr;
      input bit [7:0]  IpType;
      input bit [31:0] SrcIpAddr;
      input bit [31:0] DstIpAddr;
      input bit [15:0] SrcPortNum;
      input bit [15:0] DstPortNum;
      input bit [6:0]  UUi;
      input bit [15:0] IpPkgLen;

      int TotalLen;
      int PkgWordLen;
      bit [3:0] Keep;

      TotalLen = GenVlanMacData(PortNum, VlanTag, SrcMacAddr, DstMacAddr, IpType, SrcIpAddr, DstIpAddr, SrcPortNum, DstPortNum, UUi, IpPkgLen);

      PkgWordLen = ((TotalLen%4) == 0)? (TotalLen/4) : (TotalLen/4 + 1);
         $display("%d", PkgWordLen);
      case(TotalLen%4)
        0: Keep = 4'hf;
        1: Keep = 4'h8;
        2: Keep = 4'hc;
        3: Keep = 4'he;
        default: Keep = 4'hf;
      endcase


      //BaseX_TxReady = '1;

      while(~BaseXTxReady) @(posedge SysClk);
      for(int i=0; i<PkgWordLen; i++) begin

        BaseXTxValid = '1;
        BaseXTxSop   = (i == 0);
        BaseXTxEop   = (i ==(PkgWordLen - 1));
        BaseXTxKeep  = (i ==(PkgWordLen - 1))? Keep : 4'h0;

        if( i == (PkgWordLen - 1)) begin
        	 case(Keep)
            4'h8: BaseXTxData  = {DataArray[PortNum][i*4], 24'h0};
            4'hc: BaseXTxData  = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], 16'h0};
            4'he: BaseXTxData  = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], 8'h0};
            default: BaseXTxData= {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], DataArray[PortNum][i*4+3]};
          endcase
         end
        else
        BaseXTxData	 = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], DataArray[PortNum][i*4+3]};

        @(posedge SysClk);

      end


      BaseXTxValid = '0;
      BaseXTxSop   = '0;
      BaseXTxEop   = '0;
      BaseXTxKeep  = '0;
      BaseXTxData  = '0; 
      @(posedge SysClk);

   endtask

///////////////////////////////////////////////////////////////////////////////////
   function automatic int GenPrnData;
      input int PortNum;
      input bit [47:0] SrcMacAddr;
      input bit [47:0] DstMacAddr;
      input bit [11:0] VlanID;
      input bit [7:0]  Version;
      input bit [7:0]  MsgType;
      input bit [47:0] RadioID;
      input bit [15:0] EnSeqNum;
      input bit [7:0]  Mode;


       DataArray[PortNum][0] = DstMacAddr[47:40];
       DataArray[PortNum][1] = DstMacAddr[39:32];
       DataArray[PortNum][2] = DstMacAddr[31:24];
       DataArray[PortNum][3] = DstMacAddr[23:16];
       DataArray[PortNum][4] = DstMacAddr[15:8];
       DataArray[PortNum][5] = DstMacAddr[7:0];

       DataArray[PortNum][6]  = SrcMacAddr[47:40];
       DataArray[PortNum][7]  = SrcMacAddr[39:32];
       DataArray[PortNum][8]  = SrcMacAddr[31:24];
       DataArray[PortNum][9]  = SrcMacAddr[23:16];
       DataArray[PortNum][10] = SrcMacAddr[15:8];
       DataArray[PortNum][11] = SrcMacAddr[7:0];


       DataArray[PortNum][12] = 8'h81;
       DataArray[PortNum][13] = 8'h00;

       DataArray[PortNum][14] = {4'h0,VlanID[11:8]};
       DataArray[PortNum][15] = VlanID[7:0];

       DataArray[PortNum][16] = 8'h08;
       DataArray[PortNum][17] = 8'h55;
       DataArray[PortNum][18] = 8'h00;
       DataArray[PortNum][19] = 8'h00;

       DataArray[PortNum][20] = Version;
       DataArray[PortNum][21] = MsgType;
       DataArray[PortNum][22] = 8'h00;
       DataArray[PortNum][23] = 8'hB1;

       DataArray[PortNum][24] = RadioID[47:40];
       DataArray[PortNum][25] = RadioID[39:32];
       DataArray[PortNum][26] = RadioID[31:24];
       DataArray[PortNum][27] = RadioID[23:16];
       DataArray[PortNum][28] = RadioID[15:8];
       DataArray[PortNum][29] = RadioID[7:0];
       DataArray[PortNum][30] = EnSeqNum[15:8];
       DataArray[PortNum][31] = EnSeqNum[7:0];

       DataArray[PortNum][32] = Mode;
       DataArray[PortNum][33] = 8'h70;
       DataArray[PortNum][34] = 8'h00;
       DataArray[PortNum][35] = 8'hA1;
       DataArray[PortNum][36] = 8'h00;

       for(int j=0; j<160; j++) begin
         DataArray[PortNum][37+j] = j;
       end


       return(197);

   endfunction
////////////////////////////////////////////////////////////////////////////////
   task automatic RadioPrnDataTest;
      input int PortNum;
      input bit [47:0] SrcMacAddr;
      input bit [47:0] DstMacAddr;
      input bit [11:0] VlanID;
      input bit [7:0]  Version;
      input bit [7:0]  MsgType;
      input bit [47:0] RadioID;
      input bit [15:0] EnSeqNum;
      input bit [7:0]  Mode;
   
      int TotalLen;
      int PkgWordLen;
      bit [3:0] Keep;

      TotalLen = GenPrnData(PortNum, SrcMacAddr, DstMacAddr, VlanID, Version, MsgType, RadioID, EnSeqNum, Mode);

      PkgWordLen = ((TotalLen%4) == 0)? (TotalLen/4) : (TotalLen/4 + 1);
         $display("%d", PkgWordLen);
      case(TotalLen%4)
        0: Keep = 4'hf;
        1: Keep = 4'h8;
        2: Keep = 4'hc;
        3: Keep = 4'he;
        default: Keep = 4'hf;
      endcase


     // BaseX_TxReady  = '1;

      while(~BaseXTxReady) @(posedge SysClk);
      for(int i=0; i<PkgWordLen; i++) begin
        BaseXTxValid  = '1;
        BaseXTxSop    = (i == 0);
        BaseXTxEop    = (i ==(PkgWordLen - 1));
        BaseXTxKeep   = (i ==(PkgWordLen - 1))? Keep : 4'h0;

        if( i == (PkgWordLen - 1)) begin
        	 case(Keep)
            4'h8: BaseXTxData   = {DataArray[PortNum][i*4], 24'h0};
            4'hc: BaseXTxData   = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], 16'h0};
            4'he: BaseXTxData   = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], 8'h0};
            default: BaseXTxData = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], DataArray[PortNum][i*4+3]};
          endcase
         end
        else
        BaseXTxData = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], DataArray[PortNum][i*4+3]};

        @(posedge SysClk);

      end

      BaseXTxValid = '0;
      BaseXTxSop   = '0;
      BaseXTxEop   = '0;
      BaseXTxKeep  = '0;
      BaseXTxData  = '0;
      @(posedge SysClk);

   endtask

/////////////////////////////////////////////////////////////////////////////
  function automatic int GenAtmCell;
     input int PortNum;
     input bit [7:0] Vpi;
     input bit [7:0] Vci;
     
     int AtmCelllen;
     
       AtmCelllen = 53;
   
     DataArray[PortNum][40] = {4'h0,Vpi[7:4]};
     DataArray[PortNum][41] = {Vpi[3:0],4'h0};
     
     DataArray[PortNum][42] = {4'h0,Vci[7:4]};;
     DataArray[PortNum][43] = {Vci[3:0],4'h0};;
     
     DataArray[PortNum][44] = 8'h00;
     
       
     for(int j=0; j<48; j++) begin
       DataArray[PortNum][45+j] = j; 	
     end
     
     return(AtmCelllen);
     
  endfunction
//////////////////////////////////////////////////////////////////////////////
   function  automatic int  GenIpPkg;
      input int PortNum;
      input bit [7:0]  IpType;
      input bit [31:0] SrcIpAddr;
      input bit [31:0] DstIpAddr;
      input bit [15:0] AtmCelllen;
      
      bit [15:0] IpLen;
      
      IpLen = AtmCelllen + 20;
      
      DataArray[PortNum][20] = 8'h45;
      DataArray[PortNum][21] = 8'h00;
      DataArray[PortNum][22] = IpLen[15:8];
      DataArray[PortNum][23] = IpLen[7:0];
      
      DataArray[PortNum][24] = 8'h00;
      DataArray[PortNum][25] = 8'h00;
      DataArray[PortNum][26] = 8'h00;
      DataArray[PortNum][27] = 8'h00;
      
      DataArray[PortNum][28] = 8'hff;
      DataArray[PortNum][29] = IpType;
      DataArray[PortNum][30] = 8'h00;
      DataArray[PortNum][31] = 8'h00;
      
      DataArray[PortNum][32] = SrcIpAddr[31:24];
      DataArray[PortNum][33] = SrcIpAddr[23:16];
      DataArray[PortNum][34] = SrcIpAddr[15:8];
      DataArray[PortNum][35] = SrcIpAddr[7:0];
      
      DataArray[PortNum][36] = DstIpAddr[31:24];
      DataArray[PortNum][37] = DstIpAddr[23:16];
      DataArray[PortNum][38] = DstIpAddr[15:8];
      DataArray[PortNum][39] = DstIpAddr[7:0];
      
      return(IpLen);
   
   endfunction 
//////////////////////////////////////////////////////////////////////////////   
   function automatic int GenEthMacData;
      input int PortNum;
      input bit [11:0] VlanCfg;
      input bit [47:0] SrcMacAddr;
      input bit [47:0] DstMacAddr;
      input bit [7:0]  IpType;
      input bit [31:0] SrcIpAddr;
      input bit [31:0] DstIpAddr;
      input bit [7:0] Vpi;
      input bit [7:0] Vci;
     

      int AtmCelllen;
      int IpLen;
      
    
      AtmCelllen = GenAtmCell(PortNum, Vpi, Vci);
      IpLen  = GenIpPkg(PortNum, IpType, SrcIpAddr, DstIpAddr, AtmCelllen);
      
       DataArray[PortNum][0] = SrcMacAddr[47:40];
       DataArray[PortNum][1] = SrcMacAddr[39:32];
       DataArray[PortNum][2] = SrcMacAddr[31:24];
       DataArray[PortNum][3] = SrcMacAddr[23:16];
       DataArray[PortNum][4] = SrcMacAddr[15:8];
       DataArray[PortNum][5] = SrcMacAddr[7:0];
       
       DataArray[PortNum][6]  = DstMacAddr[47:40];
       DataArray[PortNum][7]  = DstMacAddr[39:32];
       DataArray[PortNum][8]  = DstMacAddr[31:24];
       DataArray[PortNum][9]  = DstMacAddr[23:16];
       DataArray[PortNum][10] = DstMacAddr[15:8];
       DataArray[PortNum][11] = DstMacAddr[7:0];
       
       DataArray[PortNum][12] = 8'h81;
       DataArray[PortNum][13] = 8'h00;
       DataArray[PortNum][14] = {4'h0, VlanCfg[11:8]};
       DataArray[PortNum][15] = VlanCfg[7:0];
       
       DataArray[PortNum][16] = 8'h08;
       DataArray[PortNum][17] = 8'h00;
       
       DataArray[PortNum][18] = 8'h00;
       DataArray[PortNum][19] = 8'h00;
       
       return(IpLen+20);
   
   endfunction
////////////////////////////////////////////////////////////////////////////////
   task automatic VlanIfcEnCapAtmDataTest; 
      input int PortNum;
      input bit [11:0] VlanTag; 
      input bit [47:0] SrcMacAddr;
      input bit [47:0] DstMacAddr;
      input bit [7:0]  IpType;
      input bit [31:0] SrcIpAddr;
      input bit [31:0] DstIpAddr;
      input bit [7:0] Vpi;
      input bit [7:0] Vci;
     
      
      int TotalLen;
      int PkgWordLen;
      bit [3:0] Keep;
      
      TotalLen = GenEthMacData(PortNum, VlanTag, SrcMacAddr, DstMacAddr, IpType, SrcIpAddr, DstIpAddr, Vpi, Vci);
      
      PkgWordLen = ((TotalLen%4) == 0)? (TotalLen/4) : (TotalLen/4 + 1);  
      
      $display("%d", PkgWordLen);
      
      case(TotalLen%4)
        0: Keep = 4'hf;
        1: Keep = 4'h8;
        2: Keep = 4'hc;
        3: Keep = 4'he;
        default: Keep = 4'hf;  
      endcase

     // BaseX_TxReady  = '1;

      while(~BaseXTxReady) @(posedge SysClk);
      for(int i=0; i<PkgWordLen; i++) begin
        BaseXTxValid  = '1;
        BaseXTxSop    = (i == 0);
        BaseXTxEop    = (i ==(PkgWordLen - 1));
        BaseXTxKeep   = (i ==(PkgWordLen - 1))? Keep : 4'h0;

        if( i == (PkgWordLen - 1)) begin
        	 case(Keep)
            4'h8: BaseXTxData   = {DataArray[PortNum][i*4], 24'h0};
            4'hc: BaseXTxData   = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], 16'h0};
            4'he: BaseXTxData   = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], 8'h0};
            default: BaseXTxData = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], DataArray[PortNum][i*4+3]};
          endcase
         end
        else
        BaseXTxData = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], DataArray[PortNum][i*4+3]};

        @(posedge SysClk);

      end
      
      BaseXTxValid = '0;
      BaseXTxSop   = '0;
      BaseXTxEop   = '0;
      BaseXTxKeep  = '0;
      BaseXTxData  = '0;
      @(posedge SysClk);
       
   endtask 


////////////////////////////////////////////////////////////////////////////////
  initial begin

      BaseXTxValid = '0;
      BaseXTxSop   = '0;
      BaseXTxEop   = '0;
      BaseXTxKeep  = '0;
      BaseXTxData  = '0;      
      
      
  end

/////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////                           ///////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  function automatic int increasedata;
  input bit [15:0] length;

   for(int j=0; j<length; j++) begin
     DataArray[1][j] = j;
   end






   return(length);

endfunction

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

task automatic IncreaseDataTest;
      input bit [15:0] length;

      int TotalLen;
      int PkgWordLen;
      bit [3:0] Keep;
      int PortNum;
      PortNum = 1;

      TotalLen = increasedata(length);
      PkgWordLen = ((TotalLen%4) == 0)? (TotalLen/4) : (TotalLen/4 + 1);
         $display("%d", PkgWordLen);
      case(TotalLen%4)
        0: Keep = 4'hf;
        1: Keep = 4'h8;
        2: Keep = 4'hc;
        3: Keep = 4'he;
        default: Keep = 4'hf;
      endcase


      //BaseX_TxReady = '1;

      while(~BaseXTxReady) @(posedge SysClk);
      for(int i=0; i<PkgWordLen; i++) begin

        BaseXTxValid = '1;
        BaseXTxSop   = (i == 0);
        BaseXTxEop   = (i ==(PkgWordLen - 1));
        BaseXTxKeep  = (i ==(PkgWordLen - 1))? Keep : 4'h0;

        if( i == (PkgWordLen - 1)) begin
        	 case(Keep)
            4'h8: BaseXTxData  = {DataArray[PortNum][i*4], 24'h0};
            4'hc: BaseXTxData  = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], 16'h0};
            4'he: BaseXTxData  = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], 8'h0};
            default: BaseXTxData= {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], DataArray[PortNum][i*4+3]};
          endcase
         end
        else
        BaseXTxData	 = {DataArray[PortNum][i*4], DataArray[PortNum][i*4+1], DataArray[PortNum][i*4+2], DataArray[PortNum][i*4+3]};

        @(posedge SysClk);

      end


      BaseXTxValid = '0;
      BaseXTxSop   = '0;
      BaseXTxEop   = '0;
      BaseXTxKeep  = '0;
      BaseXTxData  = '0; 
      @(posedge SysClk);

   endtask





endmodule


