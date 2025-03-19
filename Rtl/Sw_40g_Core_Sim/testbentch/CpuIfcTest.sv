/****************************************************************
*Company:  CETC54
*Engineer: liyuan

*Create Date   : Friday, the 12 of April, 2019  14:33:38
*Design Name   :
*Module Name   : RtpAdaptCpuIfcTest.v
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
module CpuIfcTest (
   input   wire Rst_n,
   input   wire CpuClk,
   output  reg  CpuCs,
   output  reg  CpuWr,
   output  reg  CpuRd,
   output  reg  [16:0] CpuAddr,
   output  reg  [15:0] CpuWrData,
   input   wire [15:0] CpuRdData
);

///////////////////////////////Signal Define/////////////////////////////////
  

/////////////////////////////////////////////////////////////////////////////
//Cpu  16Bit Write Interface
   task Cpu16BitWrData;
    input bit [16:0] addr;
    input bit [15:0] data;
    
    CpuCs = '0;
    repeat(3) @(posedge CpuClk);
    
    CpuWr = '1;
    CpuAddr = addr;
    CpuWrData = data;
    repeat(16) @(posedge CpuClk);
    
    CpuWr = '0;
    repeat(1) @(posedge CpuClk);
   
    repeat(2) @(posedge CpuClk);
    
    CpuCs = '1;
    
    repeat(1) @(posedge CpuClk);
  endtask 
  
//Cpu  16Bit Read Interface       
  task  Cpu16BitRdData;
    input  bit  [16:0] addr;
    output bit  [15:0]  RdData;
    
    CpuCs = '0;
    repeat(3) @(posedge CpuClk);
    
    CpuRd = '1;
    CpuAddr = addr;
    repeat(16) @(posedge CpuClk);
    
    CpuRd = '0;
    RdData = CpuRdData;
    
     repeat(1) @(posedge CpuClk);
   
     repeat(2) @(posedge CpuClk);
     
    CpuCs = '1;
    
    repeat(1) @(posedge CpuClk); 
    
  endtask

//////////////////////////////////////////////////////////////////////////////////////////
    task CupCfgIndWrData;
      input bit [16:0] IndOpt;
      input bit [16:0] IndAddr;
      input bit [16:0] IndWrAddr;
      input bit [15:0] WrAddr;
      input bit [15:0] WrData;
      
      bit[15:0] RdData;
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      Cpu16BitWrData(IndAddr, WrAddr);
      
      //for(int i=0; i<4; i++) begin
      	Cpu16BitWrData(IndWrAddr, WrData);
      //end
     
      Cpu16BitWrData(IndOpt, 16'h0001);
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
        repeat(3) @(posedge CpuClk); 
    
    endtask
//////////////////////////////////////////////////////////////////////////////////////////
    task CupCfgIndWr8Data;
      input bit [7:0] IndOpt;
      input bit [7:0] IndAddr;
      input bit [7:0] IndWrAddr;
      input bit [11:0] WrAddr;
      input bit [7:0][15:0] WrData;
      
      bit[15:0] RdData;
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      Cpu16BitWrData(IndAddr, WrAddr);
      
      for(int i=0; i<8; i++) begin
      	Cpu16BitWrData((IndWrAddr + i), WrData[i]);
      end
     
      Cpu16BitWrData(IndOpt, 16'h0001);
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
        repeat(3) @(posedge CpuClk); 
    
    endtask
//////////////////////////////////////////////////////////////////////////////////////////
   task CupCfgIndRd8Data;
      input  bit [7:0] IndOpt;
      input  bit [7:0] IndAddr;
      input  bit [7:0] IndRdAddr;
      input  bit [11:0] RdAddr;
      output bit [7:0][15:0] RdCfgData;
      
      bit[15:0] RdData;
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      Cpu16BitWrData(IndAddr, RdAddr);
      
      Cpu16BitWrData(IndOpt, 16'h0002);
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      for(int i=0; i<8; i++) begin
        Cpu16BitRdData((IndRdAddr+i), RdCfgData[i]);
      end
      
      repeat(3) @(posedge CpuClk); 
     
   endtask
//////////////////////////////////////////////////////////////////////////////////////////
     task CupCfgIndWr11Data;
      input bit [16:0] IndOpt;
      input bit [16:0] IndAddr;
      input bit [16:0] IndWrAddr;
      input bit [15:0] WrAddr;
      input bit [7:0][15:0] WrData;
      
      bit[15:0] RdData;
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      Cpu16BitWrData(IndAddr, WrAddr);
      
      for(int i=0; i<8; i++) begin
      	Cpu16BitWrData((IndWrAddr + i), WrData[i]);
      end
     
      Cpu16BitWrData(IndOpt, 16'h0001);
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
        repeat(3) @(posedge CpuClk); 
    
    endtask
    
//////////////////////////////////////////////////////////////////////////////////////////
     task CupCfgIndRd11Data;
      input  bit [12:0] IndOpt;
      input  bit [12:0] IndAddr;
      input  bit [12:0] IndRdAddr;
      input  bit [15:0] RdAddr;
      output bit [10:0][15:0] RdCfgData;
      
      bit[15:0] RdData;
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      Cpu16BitWrData(IndAddr, RdAddr);
      
      Cpu16BitWrData(IndOpt, 16'h0002);
      
      RdData = 16'hffff;
      
       while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      for(int i=0; i<11; i++) begin
        Cpu16BitRdData((IndRdAddr + i), RdCfgData[i]);
      end
      
      repeat(3) @(posedge CpuClk); 
     
   endtask
//////////////////////////////////////////////////////////////////////////////////////////
   task CupCfgIndWr9Data;
      input bit [15:0] IndOpt;
      input bit [15:0] IndAddr;
      input bit [15:0] IndWrAddr;
      input bit [16:0] WrAddr;
      input bit [8:0][15:0] WrData;
      
      bit[15:0] RdData;
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      Cpu16BitWrData(IndAddr, WrAddr);
      
      for(int i=0; i<9; i++) begin
      	Cpu16BitWrData((IndWrAddr + i), WrData[i]);
      end
     
      Cpu16BitWrData(IndOpt, 16'h0001);
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
        repeat(3) @(posedge CpuClk); 
    
    endtask
    
//////////////////////////////////////////////////////////////////////////////////////////
     task CupCfgIndRd9Data;
      input  bit [7:0] IndOpt;
      input  bit [7:0] IndAddr;
      input  bit [7:0] IndRdAddr;
      input  bit [15:0] RdAddr;
      output bit [8:0][15:0] RdCfgData;
      
      bit[15:0] RdData;
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      Cpu16BitWrData(IndAddr, RdAddr);
      
      Cpu16BitWrData(IndOpt, 16'h0002);
      
      RdData = 16'hffff;
      
       while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      for(int i=0;i<9;i++) begin
        Cpu16BitRdData((IndRdAddr+i), RdCfgData[i]);
      end
      
      repeat(3) @(posedge CpuClk); 
     
   endtask
//////////////////////////////////////////////////////////////////////////////////////////
    task CupCfgIndWr6Data;
      input bit [7:0] IndOpt;
      input bit [7:0] IndAddr;
      input bit [7:0] IndWrAddr;
      input bit [11:0] WrAddr;
      input bit [5:0][15:0] WrData;
      
      bit[11:0] RdData;
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      Cpu16BitWrData(IndAddr, WrAddr);
      
      for(int i=0; i<6; i++) begin
      	Cpu16BitWrData((IndWrAddr + i), WrData[i]);
      end
     
      Cpu16BitWrData(IndOpt, 16'h0001);
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
        repeat(3) @(posedge CpuClk); 
    
    endtask
//////////////////////////////////////////////////////////////////////////////////////////
  task CupCfgIndRd6Data;
      input  bit [7:0] IndOpt;
      input  bit [7:0] IndAddr;
      input  bit [7:0] IndRdAddr;
      input  bit [11:0] RdAddr;
      output bit [5:0][15:0] RdCfgData;
      
      bit[11:0] RdData;
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      Cpu16BitWrData(IndAddr, RdAddr);
      
      Cpu16BitWrData(IndOpt, 16'h0002);
      
      RdData = 16'hffff;
      
       while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      for(int i=0;i<6;i++) begin
        Cpu16BitRdData((IndRdAddr+i), RdCfgData[i]);
      end
      
      repeat(3) @(posedge CpuClk); 
     
   endtask   
//////////////////////////////////////////////////////////////////////////////////////////
   task CupCfgIndWr3Data;
      input bit [16:0] IndOpt;
      input bit [16:0] IndAddr;
      input bit [16:0] IndWrAddr;
      input bit [15:0] WrAddr;
      input bit [2:0][15:0] WrData;
      
      bit[15:0] RdData;
      
      RdData = 16'hffff;
    
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);      	
      	
      end
      
      Cpu16BitWrData(IndAddr, WrAddr);

      for(int i=0; i<3; i++) begin
      	Cpu16BitWrData((IndWrAddr + i), WrData[i]);
      end
     
      Cpu16BitWrData(IndOpt, 16'h0001);
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
    
        repeat(3) @(posedge CpuClk); 
    
    endtask
    
//////////////////////////////////////////////////////////////////////////////////////////
     task CupCfgIndRd3Data;
      input  bit [16:0] IndOpt;
      input  bit [16:0] IndAddr;
      input  bit [16:0] IndRdAddr;
      input  bit [15:0] RdAddr;
      output bit [2:0][15:0] RdCfgData;
      
      bit[15:0] RdData;
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      Cpu16BitWrData(IndAddr, RdAddr);
      
      Cpu16BitWrData(IndOpt, 16'h0002);
      
      RdData = 16'hffff;
      
       while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      for(int i=0;i<3;i++) begin
        Cpu16BitRdData((IndRdAddr+i), RdCfgData[i]);
      end
      
      repeat(3) @(posedge CpuClk); 
     
   endtask
   
//////////////////////////////////////////////////////////////////////////////////////////
   task CupCfgIndWr7Data;
      input bit [16:0] IndOpt;
      input bit [16:0] IndAddr;
      input bit [16:0] IndWrAddr;
      input bit [15:0] WrAddr;
      input bit [6:0][15:0] WrData;
      
      bit[15:0] RdData;
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      Cpu16BitWrData(IndAddr, WrAddr);
      
      for(int i=0; i<7; i++) begin
      	Cpu16BitWrData((IndWrAddr + i), WrData[i]);
      end
     
      Cpu16BitWrData(IndOpt, 16'h0001);
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
        repeat(3) @(posedge CpuClk); 
    
    endtask
    
//////////////////////////////////////////////////////////////////////////////////////////
     task CupCfgIndRd7Data;
      input  bit [12:0] IndOpt;
      input  bit [12:0] IndAddr;
      input  bit [12:0] IndRdAddr;
      input  bit [15:0] RdAddr;
      output bit [6:0][15:0] RdCfgData;
      
      bit[15:0] RdData;
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      Cpu16BitWrData(IndAddr, RdAddr);
      
      Cpu16BitWrData(IndOpt, 16'h0002);
      
      RdData = 16'hffff;
      
       while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      for(int i=0;i<7;i++) begin
        Cpu16BitRdData((IndRdAddr+i), RdCfgData[i]);
      end
      
      repeat(3) @(posedge CpuClk); 
     
   endtask

//////////////////////////////////////////////////////////////////////////////////////////

task CupCfgIndRd4Data;
      input  bit [16:0] IndOpt;
      input  bit [16:0] IndAddr;
      input  bit [16:0] IndRdAddr;
      input  bit [15:0] RdAddr;
      output bit [3:0][15:0] RdCfgData;
      
      bit[15:0] RdData;
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      Cpu16BitWrData(IndAddr, RdAddr);
      
      Cpu16BitWrData(IndOpt, 16'h0002);
      
      RdData = 16'hffff;
      
      while(RdData != 0) begin
      	Cpu16BitRdData(IndOpt, RdData);
      end
      
      for(int i=0; i<4; i++) begin
        Cpu16BitRdData((IndRdAddr+i), RdCfgData[i]);
      end
      
      repeat(3) @(posedge CpuClk); 
     
   endtask

//////////////////////////////////////////////////////////////////////////////////////////
  task CpuHashTabCfg;
     input  bit[31:0] SrcIpAddr;
     input  bit[31:0] DstIpAddr;
     input  bit[15:0] SrcPortNum;
     input  bit[15:0] DstPortNum;
     input  bit[7:0]  IpType;
     input  bit[11:0] Index;
     bit    [7:0][15:0] WrData;
     bit    [7:0][15:0] RdData;
     bit    [15:0][7:0] Key;
     bit    [15:0][7:0] data;
     bit    [31:0] crc;
     bit    [31:0] newcrc;
            
     Key[0]=8'h00;
     Key[1]=8'h00;
     Key[2]=8'h00;
     Key[3]=IpType;
     Key[4]=SrcIpAddr[31:24];
     Key[5]=SrcIpAddr[23:16];
     Key[6]=SrcIpAddr[15:8];
     Key[7]=SrcIpAddr[7:0];
     Key[8]=DstIpAddr[31:24];
     Key[9]=DstIpAddr[23:16];
     Key[10]=DstIpAddr[15:8];
     Key[11]=DstIpAddr[7:0];
     Key[12]=SrcPortNum[15:8];
     Key[13]=SrcPortNum[7:0];
     Key[14]=DstPortNum[15:8];
     Key[15]=DstPortNum[7:0];
               
    for(int i=0; i<16; i++) begin      
     data[i][7] = Key[i][0];
     data[i][6] = Key[i][1];
     data[i][5] = Key[i][2];
     data[i][4] = Key[i][3];
     data[i][3] = Key[i][4];
     data[i][2] = Key[i][5];
     data[i][1] = Key[i][6];
     data[i][0] = Key[i][7];
    end
     
                
     for(int i=0;i<16;i++) begin
     	  if(i==0)
  	    crc = nextCRC32_D8(data[0], 32'hffff_ffff);  
  	    else
  	  	crc = nextCRC32_D8(data[i], crc);  	  	
     end   
     
     
    newcrc[31] = crc[0]^1;
    newcrc[30] = crc[1]^1;
    newcrc[29] = crc[2]^1;
    newcrc[28] = crc[3]^1;
    newcrc[27] = crc[4]^1;
    newcrc[26] = crc[5]^1;
    newcrc[25] = crc[6]^1;
    newcrc[24] = crc[7]^1; 
    newcrc[23] = crc[8]^1;    
    newcrc[22] = crc[9]^1;
    newcrc[21] = crc[10]^1;
    newcrc[20] = crc[11]^1;
    newcrc[19] = crc[12]^1;
    newcrc[18] = crc[13]^1;
    newcrc[17] = crc[14]^1; 
    newcrc[16] = crc[15]^1;
    newcrc[15] = crc[16]^1;
    newcrc[14] = crc[17]^1;
    newcrc[13] = crc[18]^1; 
    newcrc[12] = crc[19]^1; 
    newcrc[11] = crc[20]^1; 
    newcrc[10] = crc[21]^1; 
    newcrc[9] = crc[22]^1; 
    newcrc[8] = crc[23]^1;
    newcrc[7] = crc[24]^1;
    newcrc[6] = crc[25]^1;
    newcrc[5] = crc[26]^1;
    newcrc[4] = crc[27]^1;
    newcrc[3] = crc[28]^1;
    newcrc[2] = crc[29]^1; 
    newcrc[1] = crc[30]^1; 
    newcrc[0] = crc[31]^1; 
     
    WrData[0] = {4'b1000,4'b0000,IpType};
    WrData[1] = SrcIpAddr[31:16];
    WrData[2] = SrcIpAddr[15:0];
    WrData[3] = DstIpAddr[31:16];
    WrData[4] = DstIpAddr[15:0];
    WrData[5] = SrcPortNum;
    WrData[6] = DstPortNum;
    WrData[7] = {4'b0000,Index};
  	             
    CupCfgIndWr8Data(8'h00,8'h01,8'h02,{4'b0000,newcrc[11:0]},WrData);
  //CupCfgIndRd8Data(8'h00,8'h01,8'h0a,{4'b0000,newcrc[11:0]},RdData);
 
   $display("crc is : %h",newcrc);
     
//*** CpuHashTabData write&read ***//     
   /*  $display("CpuHashTabWr is : %h",WrData);
     $display("CpuHashTabRd is : %h",RdData);*/
   endtask  
      
///////////////////////////////////////////////////////////////    
   task CpuChParamTabCfg;
       input bit ChRelaceEn;
       input bit [11:0] ChIndex;
       input bit [7:0] NewIpType;
       input bit [7:0] FwdPortNum;
       input bit [15:0] NewSrcPort;
       input bit [15:0] NewDstPort;
       input bit [31:0] NewSrcIpAddr;
       input bit [31:0] NewDstIpAddr;
             bit [7:0][15:0] WrData;
             bit [7:0][15:0] RdData;
    
       WrData[0] = {15'b0000_0000_0000_000,ChRelaceEn};
       WrData[1] = {NewIpType,FwdPortNum};
       WrData[2] = NewSrcPort;
       WrData[3] = NewDstPort;
       WrData[4] = NewSrcIpAddr[31:16];
       WrData[5] = NewSrcIpAddr[15:0];
       WrData[6] = NewDstIpAddr[31:16];
       WrData[7] = NewDstIpAddr[15:0];
        
       CupCfgIndWr8Data(8'h40,8'h41,8'h42,{4'b0000,ChIndex},WrData);
     //CupCfgIndRd8Data(8'h40,8'h41,8'h4a,{4'b0000,ChIndex},RdData);
       
//***** CpuChParamTabData write&read *****//    
      /* $display("CpuChParamTabWr is : %h",WrData);
       $display("CpuChParamTabRd is : %h",RdData);*/
  endtask  

/////////////////////////////////////////////////////////////////////////////////////////
  /*task automatic TdmInitial;
    
    
    
    //initial Slot 
    
    for(int i=0; i<32; i++) begin
    	for(int j=0; j<8; j++) begin
    	   CupCfgIndWrData(17'h10000,17'h10001,17'h10002,(1024+(i*8)+j),(16'h0080 + i));   	  
    	end
    end
    
    Cpu16BitWrData(8'h09, 16'h1);
    //Clr Buffer
    
    CupCfgIndWrData(17'h10006, 17'h10007, 17'h10008, 16'h0, 16'h0);
    CupCfgIndWrData(17'h10006, 17'h10007, 17'h10008, 16'h1, 16'h0);
    CupCfgIndWrData(17'h10006, 17'h10007, 17'h10008, 16'h2, 16'h0);
    CupCfgIndWrData(17'h10006, 17'h10007, 17'h10008, 16'h3, 16'h0);

    
    //Enable Ch Valid
    Cpu16BitWrData(17'h10004, 16'h000f);
    
    
    
    
    //Enable Ch Valid

    
    for(int i=0; i<32; i++) begin
    	for(int j=0; j<8; j++) begin
    	   CupCfgIndWrData(17'h10010,17'h10011,17'h10012,(1024+(i*8)+j),(16'h0080 + i));   	  
    	end
    end
    
    Cpu16BitWrData(17'h10019, 16'h1);
    
    
    CupCfgIndWrData(17'h10016, 17'h10017, 17'h10018, 16'h0, 16'h0);
    CupCfgIndWrData(17'h10016, 17'h10017, 17'h10018, 16'h1, 16'h0);
    CupCfgIndWrData(17'h10016, 17'h10017, 17'h10018, 16'h2, 16'h0);
    CupCfgIndWrData(17'h10016, 17'h10017, 17'h10018, 16'h3, 16'h0);
    
    Cpu16BitWrData(17'h10014, 16'h000f);
    
  endtask
  
  task automatic TdmDelChn;
    input int PortNum;
    
    bit [15:0] ValidBit0;
    bit [15:0] ValidBit1;
    Cpu16BitRdData(17'h10004, ValidBit0);
    
    ValidBit0 = (ValidBit0 & (~(1<<PortNum)));
    
    Cpu16BitWrData(17'h10004, ValidBit0);     
  
    Cpu16BitRdData(17'h10014, ValidBit1);
    
    ValidBit1 = (ValidBit1 & (~(1<<PortNum)));
    
    Cpu16BitWrData(17'h10014, ValidBit1);  
    
  endtask
  
  task automatic TdmInitChn;
    input int PortNum;
    
    bit [15:0] ValidBit0;
    bit [15:0] ValidBit1;
    
    CupCfgIndWrData(17'h10006, 17'h10007, 17'h10008, PortNum, 16'h0);
    
    CupCfgIndWrData(17'h10016, 17'h10017, 17'h10018, PortNum, 16'h0);
    
    Cpu16BitRdData(17'h10004, ValidBit0);
    
    ValidBit0 = (ValidBit0 | (1<<PortNum)); 
    
    Cpu16BitWrData(17'h10004, ValidBit0);    
  
    Cpu16BitRdData(17'h10014, ValidBit1);
    
    ValidBit1 = (ValidBit1 | (1<<PortNum));
    
    Cpu16BitWrData(17'h10014, ValidBit1);  
    
  endtask*/

/////////////////////////////////////////////////////////////////////////////////////////
    task CpuDstMacCfg;
       
       input bit IpTabValid;
       input bit [31:0] DstIpAddr;
       input bit [47:0] DstMac;
       input bit [47:0] DefaultMac;
  
             bit [8:0][15:0] WrData;
             bit [8:0][15:0] RdData;
             bit [7:0] sum;
             bit [7:0] mod;
             
             
       sum = DstIpAddr[31:24]+DstIpAddr[23:16]+DstIpAddr[15:8]+DstIpAddr[7:0];       
       mod = (sum % 32)<<3;       
          
       WrData[0] = {15'b0000_0000_0000_000,IpTabValid};
       WrData[1] = DstIpAddr[31:16] ;
       WrData[2] = DstIpAddr[15:0];
       WrData[3] = DstMac[47:32];
       WrData[4] = DstMac[31:16];
       WrData[5] = DstMac[15:0];
       WrData[6] = DefaultMac[47:32];
       WrData[7] = DefaultMac[31:16];
       WrData[8] = DefaultMac[15:0];

       CupCfgIndWr6Data(8'h80,8'h81,8'h82,{8'h00,mod},WrData[5:0]);
       Cpu16BitWrData(8'h8e,WrData[6]);
       Cpu16BitWrData(8'h8f,WrData[7]);
       Cpu16BitWrData(8'h90,WrData[8]);
 
       CupCfgIndRd6Data(8'h80,8'h81,8'h88,{8'h00,mod},RdData[5:0]);
       Cpu16BitRdData(8'h8e,RdData[6]);
       Cpu16BitRdData(8'h8f,RdData[7]);
       Cpu16BitRdData(8'h90,RdData[8]);
//***** CpuDstMacData  writa&read *****//   
      /* $display("CpuDstMacWr is : %h",WrData);
       $display("CpuDstMacRd is : %h",RdData); */
     endtask 
          
////////////////////////////////////////////////////////////////////////////////////////    
    function [31:0] nextCRC32_D32;
    input [31:0] Data;
    input [31:0] crc;
    reg [31:0] d;
    reg [31:0] c;
    reg [31:0] newcrc;
    begin
    d = Data;
    c = crc;

    newcrc[0] = d[31] ^ d[30] ^ d[29] ^ d[28] ^ d[26] ^ d[25] ^ d[24] ^ d[16] ^ d[12] ^ d[10] ^ d[9] ^ d[6] ^ d[0] ^ c[0] ^ c[6] ^ c[9] ^ c[10] ^ c[12] ^ c[16] ^ c[24] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[1] = d[28] ^ d[27] ^ d[24] ^ d[17] ^ d[16] ^ d[13] ^ d[12] ^ d[11] ^ d[9] ^ d[7] ^ d[6] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[6] ^ c[7] ^ c[9] ^ c[11] ^ c[12] ^ c[13] ^ c[16] ^ c[17] ^ c[24] ^ c[27] ^ c[28];
    newcrc[2] = d[31] ^ d[30] ^ d[26] ^ d[24] ^ d[18] ^ d[17] ^ d[16] ^ d[14] ^ d[13] ^ d[9] ^ d[8] ^ d[7] ^ d[6] ^ d[2] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[2] ^ c[6] ^ c[7] ^ c[8] ^ c[9] ^ c[13] ^ c[14] ^ c[16] ^ c[17] ^ c[18] ^ c[24] ^ c[26] ^ c[30] ^ c[31];
    newcrc[3] = d[31] ^ d[27] ^ d[25] ^ d[19] ^ d[18] ^ d[17] ^ d[15] ^ d[14] ^ d[10] ^ d[9] ^ d[8] ^ d[7] ^ d[3] ^ d[2] ^ d[1] ^ c[1] ^ c[2] ^ c[3] ^ c[7] ^ c[8] ^ c[9] ^ c[10] ^ c[14] ^ c[15] ^ c[17] ^ c[18] ^ c[19] ^ c[25] ^ c[27] ^ c[31];
    newcrc[4] = d[31] ^ d[30] ^ d[29] ^ d[25] ^ d[24] ^ d[20] ^ d[19] ^ d[18] ^ d[15] ^ d[12] ^ d[11] ^ d[8] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ d[0] ^ c[0] ^ c[2] ^ c[3] ^ c[4] ^ c[6] ^ c[8] ^ c[11] ^ c[12] ^ c[15] ^ c[18] ^ c[19] ^ c[20] ^ c[24] ^ c[25] ^ c[29] ^ c[30] ^ c[31];
    newcrc[5] = d[29] ^ d[28] ^ d[24] ^ d[21] ^ d[20] ^ d[19] ^ d[13] ^ d[10] ^ d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[3] ^ c[4] ^ c[5] ^ c[6] ^ c[7] ^ c[10] ^ c[13] ^ c[19] ^ c[20] ^ c[21] ^ c[24] ^ c[28] ^ c[29];
    newcrc[6] = d[30] ^ d[29] ^ d[25] ^ d[22] ^ d[21] ^ d[20] ^ d[14] ^ d[11] ^ d[8] ^ d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[1] ^ c[2] ^ c[4] ^ c[5] ^ c[6] ^ c[7] ^ c[8] ^ c[11] ^ c[14] ^ c[20] ^ c[21] ^ c[22] ^ c[25] ^ c[29] ^ c[30];
    newcrc[7] = d[29] ^ d[28] ^ d[25] ^ d[24] ^ d[23] ^ d[22] ^ d[21] ^ d[16] ^ d[15] ^ d[10] ^ d[8] ^ d[7] ^ d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[0] ^ c[2] ^ c[3] ^ c[5] ^ c[7] ^ c[8] ^ c[10] ^ c[15] ^ c[16] ^ c[21] ^ c[22] ^ c[23] ^ c[24] ^ c[25] ^ c[28] ^ c[29];
    newcrc[8] = d[31] ^ d[28] ^ d[23] ^ d[22] ^ d[17] ^ d[12] ^ d[11] ^ d[10] ^ d[8] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[3] ^ c[4] ^ c[8] ^ c[10] ^ c[11] ^ c[12] ^ c[17] ^ c[22] ^ c[23] ^ c[28] ^ c[31];
    newcrc[9] = d[29] ^ d[24] ^ d[23] ^ d[18] ^ d[13] ^ d[12] ^ d[11] ^ d[9] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[1] ^ c[2] ^ c[4] ^ c[5] ^ c[9] ^ c[11] ^ c[12] ^ c[13] ^ c[18] ^ c[23] ^ c[24] ^ c[29];
    newcrc[10] = d[31] ^ d[29] ^ d[28] ^ d[26] ^ d[19] ^ d[16] ^ d[14] ^ d[13] ^ d[9] ^ d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[0] ^ c[2] ^ c[3] ^ c[5] ^ c[9] ^ c[13] ^ c[14] ^ c[16] ^ c[19] ^ c[26] ^ c[28] ^ c[29] ^ c[31];
    newcrc[11] = d[31] ^ d[28] ^ d[27] ^ d[26] ^ d[25] ^ d[24] ^ d[20] ^ d[17] ^ d[16] ^ d[15] ^ d[14] ^ d[12] ^ d[9] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[3] ^ c[4] ^ c[9] ^ c[12] ^ c[14] ^ c[15] ^ c[16] ^ c[17] ^ c[20] ^ c[24] ^ c[25] ^ c[26] ^ c[27] ^ c[28] ^ c[31];
    newcrc[12] = d[31] ^ d[30] ^ d[27] ^ d[24] ^ d[21] ^ d[18] ^ d[17] ^ d[15] ^ d[13] ^ d[12] ^ d[9] ^ d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[2] ^ c[4] ^ c[5] ^ c[6] ^ c[9] ^ c[12] ^ c[13] ^ c[15] ^ c[17] ^ c[18] ^ c[21] ^ c[24] ^ c[27] ^ c[30] ^ c[31];
    newcrc[13] = d[31] ^ d[28] ^ d[25] ^ d[22] ^ d[19] ^ d[18] ^ d[16] ^ d[14] ^ d[13] ^ d[10] ^ d[7] ^ d[6] ^ d[5] ^ d[3] ^ d[2] ^ d[1] ^ c[1] ^ c[2] ^ c[3] ^ c[5] ^ c[6] ^ c[7] ^ c[10] ^ c[13] ^ c[14] ^ c[16] ^ c[18] ^ c[19] ^ c[22] ^ c[25] ^ c[28] ^ c[31];
    newcrc[14] = d[29] ^ d[26] ^ d[23] ^ d[20] ^ d[19] ^ d[17] ^ d[15] ^ d[14] ^ d[11] ^ d[8] ^ d[7] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ c[2] ^ c[3] ^ c[4] ^ c[6] ^ c[7] ^ c[8] ^ c[11] ^ c[14] ^ c[15] ^ c[17] ^ c[19] ^ c[20] ^ c[23] ^ c[26] ^ c[29];
    newcrc[15] = d[30] ^ d[27] ^ d[24] ^ d[21] ^ d[20] ^ d[18] ^ d[16] ^ d[15] ^ d[12] ^ d[9] ^ d[8] ^ d[7] ^ d[5] ^ d[4] ^ d[3] ^ c[3] ^ c[4] ^ c[5] ^ c[7] ^ c[8] ^ c[9] ^ c[12] ^ c[15] ^ c[16] ^ c[18] ^ c[20] ^ c[21] ^ c[24] ^ c[27] ^ c[30];
    newcrc[16] = d[30] ^ d[29] ^ d[26] ^ d[24] ^ d[22] ^ d[21] ^ d[19] ^ d[17] ^ d[13] ^ d[12] ^ d[8] ^ d[5] ^ d[4] ^ d[0] ^ c[0] ^ c[4] ^ c[5] ^ c[8] ^ c[12] ^ c[13] ^ c[17] ^ c[19] ^ c[21] ^ c[22] ^ c[24] ^ c[26] ^ c[29] ^ c[30];
    newcrc[17] = d[31] ^ d[30] ^ d[27] ^ d[25] ^ d[23] ^ d[22] ^ d[20] ^ d[18] ^ d[14] ^ d[13] ^ d[9] ^ d[6] ^ d[5] ^ d[1] ^ c[1] ^ c[5] ^ c[6] ^ c[9] ^ c[13] ^ c[14] ^ c[18] ^ c[20] ^ c[22] ^ c[23] ^ c[25] ^ c[27] ^ c[30] ^ c[31];
    newcrc[18] = d[31] ^ d[28] ^ d[26] ^ d[24] ^ d[23] ^ d[21] ^ d[19] ^ d[15] ^ d[14] ^ d[10] ^ d[7] ^ d[6] ^ d[2] ^ c[2] ^ c[6] ^ c[7] ^ c[10] ^ c[14] ^ c[15] ^ c[19] ^ c[21] ^ c[23] ^ c[24] ^ c[26] ^ c[28] ^ c[31];
    newcrc[19] = d[29] ^ d[27] ^ d[25] ^ d[24] ^ d[22] ^ d[20] ^ d[16] ^ d[15] ^ d[11] ^ d[8] ^ d[7] ^ d[3] ^ c[3] ^ c[7] ^ c[8] ^ c[11] ^ c[15] ^ c[16] ^ c[20] ^ c[22] ^ c[24] ^ c[25] ^ c[27] ^ c[29];
    newcrc[20] = d[30] ^ d[28] ^ d[26] ^ d[25] ^ d[23] ^ d[21] ^ d[17] ^ d[16] ^ d[12] ^ d[9] ^ d[8] ^ d[4] ^ c[4] ^ c[8] ^ c[9] ^ c[12] ^ c[16] ^ c[17] ^ c[21] ^ c[23] ^ c[25] ^ c[26] ^ c[28] ^ c[30];
    newcrc[21] = d[31] ^ d[29] ^ d[27] ^ d[26] ^ d[24] ^ d[22] ^ d[18] ^ d[17] ^ d[13] ^ d[10] ^ d[9] ^ d[5] ^ c[5] ^ c[9] ^ c[10] ^ c[13] ^ c[17] ^ c[18] ^ c[22] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
    newcrc[22] = d[31] ^ d[29] ^ d[27] ^ d[26] ^ d[24] ^ d[23] ^ d[19] ^ d[18] ^ d[16] ^ d[14] ^ d[12] ^ d[11] ^ d[9] ^ d[0] ^ c[0] ^ c[9] ^ c[11] ^ c[12] ^ c[14] ^ c[16] ^ c[18] ^ c[19] ^ c[23] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
    newcrc[23] = d[31] ^ d[29] ^ d[27] ^ d[26] ^ d[20] ^ d[19] ^ d[17] ^ d[16] ^ d[15] ^ d[13] ^ d[9] ^ d[6] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[6] ^ c[9] ^ c[13] ^ c[15] ^ c[16] ^ c[17] ^ c[19] ^ c[20] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
    newcrc[24] = d[30] ^ d[28] ^ d[27] ^ d[21] ^ d[20] ^ d[18] ^ d[17] ^ d[16] ^ d[14] ^ d[10] ^ d[7] ^ d[2] ^ d[1] ^ c[1] ^ c[2] ^ c[7] ^ c[10] ^ c[14] ^ c[16] ^ c[17] ^ c[18] ^ c[20] ^ c[21] ^ c[27] ^ c[28] ^ c[30];
    newcrc[25] = d[31] ^ d[29] ^ d[28] ^ d[22] ^ d[21] ^ d[19] ^ d[18] ^ d[17] ^ d[15] ^ d[11] ^ d[8] ^ d[3] ^ d[2] ^ c[2] ^ c[3] ^ c[8] ^ c[11] ^ c[15] ^ c[17] ^ c[18] ^ c[19] ^ c[21] ^ c[22] ^ c[28] ^ c[29] ^ c[31];
    newcrc[26] = d[31] ^ d[28] ^ d[26] ^ d[25] ^ d[24] ^ d[23] ^ d[22] ^ d[20] ^ d[19] ^ d[18] ^ d[10] ^ d[6] ^ d[4] ^ d[3] ^ d[0] ^ c[0] ^ c[3] ^ c[4] ^ c[6] ^ c[10] ^ c[18] ^ c[19] ^ c[20] ^ c[22] ^ c[23] ^ c[24] ^ c[25] ^ c[26] ^ c[28] ^ c[31];
    newcrc[27] = d[29] ^ d[27] ^ d[26] ^ d[25] ^ d[24] ^ d[23] ^ d[21] ^ d[20] ^ d[19] ^ d[11] ^ d[7] ^ d[5] ^ d[4] ^ d[1] ^ c[1] ^ c[4] ^ c[5] ^ c[7] ^ c[11] ^ c[19] ^ c[20] ^ c[21] ^ c[23] ^ c[24] ^ c[25] ^ c[26] ^ c[27] ^ c[29];
    newcrc[28] = d[30] ^ d[28] ^ d[27] ^ d[26] ^ d[25] ^ d[24] ^ d[22] ^ d[21] ^ d[20] ^ d[12] ^ d[8] ^ d[6] ^ d[5] ^ d[2] ^ c[2] ^ c[5] ^ c[6] ^ c[8] ^ c[12] ^ c[20] ^ c[21] ^ c[22] ^ c[24] ^ c[25] ^ c[26] ^ c[27] ^ c[28] ^ c[30];
    newcrc[29] = d[31] ^ d[29] ^ d[28] ^ d[27] ^ d[26] ^ d[25] ^ d[23] ^ d[22] ^ d[21] ^ d[13] ^ d[9] ^ d[7] ^ d[6] ^ d[3] ^ c[3] ^ c[6] ^ c[7] ^ c[9] ^ c[13] ^ c[21] ^ c[22] ^ c[23] ^ c[25] ^ c[26] ^ c[27] ^ c[28] ^ c[29] ^ c[31];
    newcrc[30] = d[30] ^ d[29] ^ d[28] ^ d[27] ^ d[26] ^ d[24] ^ d[23] ^ d[22] ^ d[14] ^ d[10] ^ d[8] ^ d[7] ^ d[4] ^ c[4] ^ c[7] ^ c[8] ^ c[10] ^ c[14] ^ c[22] ^ c[23] ^ c[24] ^ c[26] ^ c[27] ^ c[28] ^ c[29] ^ c[30];
    newcrc[31] = d[31] ^ d[30] ^ d[29] ^ d[28] ^ d[27] ^ d[25] ^ d[24] ^ d[23] ^ d[15] ^ d[11] ^ d[9] ^ d[8] ^ d[5] ^ c[5] ^ c[8] ^ c[9] ^ c[11] ^ c[15] ^ c[23] ^ c[24] ^ c[25] ^ c[27] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    nextCRC32_D32 = newcrc;
    end
    endfunction
//////////////////////////////////////////////////////////////////////////////////////
function [31:0] nextCRC32_D8;

    input [7:0] Data;
    input [31:0] crc;
    reg [7:0] d;
    reg [31:0] c;
    reg [31:0] newcrc;
  begin
    d = Data;
    c = crc;

    newcrc[0] = d[6] ^ d[0] ^ c[24] ^ c[30];
    newcrc[1] = d[7] ^ d[6] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[30] ^ c[31];
    newcrc[2] = d[7] ^ d[6] ^ d[2] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[26] ^ c[30] ^ c[31];
    newcrc[3] = d[7] ^ d[3] ^ d[2] ^ d[1] ^ c[25] ^ c[26] ^ c[27] ^ c[31];
    newcrc[4] = d[6] ^ d[4] ^ d[3] ^ d[2] ^ d[0] ^ c[24] ^ c[26] ^ c[27] ^ c[28] ^ c[30];
    newcrc[5] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[6] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[7] = d[7] ^ d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
    newcrc[8] = d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
    newcrc[9] = d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[1] ^ c[25] ^ c[26] ^ c[28] ^ c[29];
    newcrc[10] = d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[2] ^ c[24] ^ c[26] ^ c[27] ^ c[29];
    newcrc[11] = d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[3] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
    newcrc[12] = d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ d[0] ^ c[4] ^ c[24] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30];
    newcrc[13] = d[7] ^ d[6] ^ d[5] ^ d[3] ^ d[2] ^ d[1] ^ c[5] ^ c[25] ^ c[26] ^ c[27] ^ c[29] ^ c[30] ^ c[31];
    newcrc[14] = d[7] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ c[6] ^ c[26] ^ c[27] ^ c[28] ^ c[30] ^ c[31];
    newcrc[15] = d[7] ^ d[5] ^ d[4] ^ d[3] ^ c[7] ^ c[27] ^ c[28] ^ c[29] ^ c[31];
    newcrc[16] = d[5] ^ d[4] ^ d[0] ^ c[8] ^ c[24] ^ c[28] ^ c[29];
    newcrc[17] = d[6] ^ d[5] ^ d[1] ^ c[9] ^ c[25] ^ c[29] ^ c[30];
    newcrc[18] = d[7] ^ d[6] ^ d[2] ^ c[10] ^ c[26] ^ c[30] ^ c[31];
    newcrc[19] = d[7] ^ d[3] ^ c[11] ^ c[27] ^ c[31];
    newcrc[20] = d[4] ^ c[12] ^ c[28];
    newcrc[21] = d[5] ^ c[13] ^ c[29];
    newcrc[22] = d[0] ^ c[14] ^ c[24];
    newcrc[23] = d[6] ^ d[1] ^ d[0] ^ c[15] ^ c[24] ^ c[25] ^ c[30];
    newcrc[24] = d[7] ^ d[2] ^ d[1] ^ c[16] ^ c[25] ^ c[26] ^ c[31];
    newcrc[25] = d[3] ^ d[2] ^ c[17] ^ c[26] ^ c[27];
    newcrc[26] = d[6] ^ d[4] ^ d[3] ^ d[0] ^ c[18] ^ c[24] ^ c[27] ^ c[28] ^ c[30];
    newcrc[27] = d[7] ^ d[5] ^ d[4] ^ d[1] ^ c[19] ^ c[25] ^ c[28] ^ c[29] ^ c[31];
    newcrc[28] = d[6] ^ d[5] ^ d[2] ^ c[20] ^ c[26] ^ c[29] ^ c[30];
    newcrc[29] = d[7] ^ d[6] ^ d[3] ^ c[21] ^ c[27] ^ c[30] ^ c[31];
    newcrc[30] = d[7] ^ d[4] ^ c[22] ^ c[28] ^ c[31];
    newcrc[31] = d[5] ^ c[23] ^ c[29];
    nextCRC32_D8 = newcrc;
  end
  endfunction    
//////////////////////////////////////////////////////////////////////////////////////
task crc32_32;
     input bit [31:0] key;
           bit [31:0] crc;
           bit [31:0] data;
           bit [31:0] newcrc;
     
     for(int i=0; i<4; i++) begin
     	 for(int j=0;j<8; j++) begin
     	    data[i*8+j] = key[i*8 +(7 - j)];  
     	 end
      end      
                        
  	 crc = nextCRC32_D32(data, 32'hffff_ffff);
  	   	 
  	newcrc[31] = crc[0]^1;
    newcrc[30] = crc[1]^1;
    newcrc[29] = crc[2]^1;
    newcrc[28] = crc[3]^1;
    newcrc[27] = crc[4]^1;
    newcrc[26] = crc[5]^1;
    newcrc[25] = crc[6]^1;
    newcrc[24] = crc[7]^1; 
    newcrc[23] = crc[8]^1;    
    newcrc[22] = crc[9]^1;
    newcrc[21] = crc[10]^1;
    newcrc[20] = crc[11]^1;
    newcrc[19] = crc[12]^1;
    newcrc[18] = crc[13]^1;
    newcrc[17] = crc[14]^1; 
    newcrc[16] = crc[15]^1;
    newcrc[15] = crc[16]^1;
    newcrc[14] = crc[17]^1;
    newcrc[13] = crc[18]^1; 
    newcrc[12] = crc[19]^1; 
    newcrc[11] = crc[20]^1; 
    newcrc[10] = crc[21]^1; 
    newcrc[9] = crc[22]^1; 
    newcrc[8] = crc[23]^1;
    newcrc[7] = crc[24]^1;
    newcrc[6] = crc[25]^1;
    newcrc[5] = crc[26]^1;
    newcrc[4] = crc[27]^1;
    newcrc[3] = crc[28]^1;
    newcrc[2] = crc[29]^1;
    newcrc[1] = crc[30]^1;
    newcrc[0] = crc[31]^1;  
  	 
     $display("crc is : %h", newcrc);
     
   endtask  
/////////////////////////////////////////////////////////////////////////////
 task crc32_8;
    input bit [7:0] key;
          bit[7:0] data;
          bit[31:0] newcrc;    
          bit [31:0] crc;
    data[7] = key[0];
    data[6] = key[1];
    data[5] = key[2];
    data[4] = key[3];
    data[3] = key[4];
    data[2] = key[5];
    data[1] = key[6];
    data[0] = key[7];
    
    
    crc = nextCRC32_D8(data, 32'hffff_ffff);
   
    newcrc[31] = crc[0]^1;
    newcrc[30] = crc[1]^1;
    newcrc[29] = crc[2]^1;
    newcrc[28] = crc[3]^1;
    newcrc[27] = crc[4]^1;
    newcrc[26] = crc[5]^1;
    newcrc[25] = crc[6]^1;
    newcrc[24] = crc[7]^1; 
    newcrc[23] = crc[8]^1;    
    newcrc[22] = crc[9]^1;
    newcrc[21] = crc[10]^1;
    newcrc[20] = crc[11]^1;
    newcrc[19] = crc[12]^1;
    newcrc[18] = crc[13]^1;
    newcrc[17] = crc[14]^1; 
    newcrc[16] = crc[15]^1;
    newcrc[15] = crc[16]^1;
    newcrc[14] = crc[17]^1;
    newcrc[13] = crc[18]^1; 
    newcrc[12] = crc[19]^1; 
    newcrc[11] = crc[20]^1; 
    newcrc[10] = crc[21]^1; 
    newcrc[9] = crc[22]^1; 
    newcrc[8] = crc[23]^1;
    newcrc[7] = crc[24]^1;
    newcrc[6] = crc[25]^1;
    newcrc[5] = crc[26]^1;
    newcrc[4] = crc[27]^1;
    newcrc[3] = crc[28]^1;
    newcrc[2] = crc[29]^1;
    newcrc[1] = crc[30]^1;
    newcrc[0] = crc[31]^1;  
     
    $display("crc is : %h", newcrc);
    
 endtask
////////////////////////////////////////////////////////////////////////////
  task  crc32_8x4;
    input bit[3:0][7:0] key;               
          bit[31:0] crc;
          bit[31:0] newcrc;
          bit[3:0][7:0] data;
          int i;
          
    for(i = 0; i<4; i++) begin      
    data[i][7] = key[i][0];
    data[i][6] = key[i][1];
    data[i][5] = key[i][2];
    data[i][4] = key[i][3];
    data[i][3] = key[i][4];
    data[i][2] = key[i][5];
    data[i][1] = key[i][6];
    data[i][0] = key[i][7];
    end
    
    for(i=0; i<4; i++) begin
    	if(i==0) begin
    		crc = nextCRC32_D8(data[0], 32'hffff_ffff);
    		//$display("crc is : %h",crc);
           end 
    	else  begin
    		crc = nextCRC32_D8(data[i], crc); 
        //$display("crc is : %h",crc);
         end
    end    
    //newCrc = crc ^ 32'hffff_ffff;
    newcrc[31] = crc[0]^1;
    newcrc[30] = crc[1]^1;
    newcrc[29] = crc[2]^1;
    newcrc[28] = crc[3]^1;
    newcrc[27] = crc[4]^1;
    newcrc[26] = crc[5]^1;
    newcrc[25] = crc[6]^1;
    newcrc[24] = crc[7]^1; 
    newcrc[23] = crc[8]^1;    
    newcrc[22] = crc[9]^1;
    newcrc[21] = crc[10]^1;
    newcrc[20] = crc[11]^1;
    newcrc[19] = crc[12]^1;
    newcrc[18] = crc[13]^1;
    newcrc[17] = crc[14]^1; 
    newcrc[16] = crc[15]^1;
    newcrc[15] = crc[16]^1;
    newcrc[14] = crc[17]^1;
    newcrc[13] = crc[18]^1; 
    newcrc[12] = crc[19]^1; 
    newcrc[11] = crc[20]^1; 
    newcrc[10] = crc[21]^1; 
    newcrc[9] = crc[22]^1; 
    newcrc[8] = crc[23]^1;
    newcrc[7] = crc[24]^1;
    newcrc[6] = crc[25]^1;
    newcrc[5] = crc[26]^1;
    newcrc[4] = crc[27]^1;
    newcrc[3] = crc[28]^1;
    newcrc[2] = crc[29]^1;
    newcrc[1] = crc[30]^1;
    newcrc[0] = crc[31]^1;  
    
    
    $display("crc is : %h",newcrc);
  endtask
////////////////////////////////////////////////////////////////////////////
task fwdschTableCfg;

 input bit [4:0] port;
 input bit Zk_ChnEn1;
 input bit Zk_ChnEn0;
 input bit [3:0] Port_Type;
 input bit PortMirrEn;
 input bit [1:0] Learn_mode;
 input bit [11:0] Fwd_Vid;
 input bit DebugEn;
 input bit [3:0] DebugIndex;
 input bit Egr_Mirror_En;
 input bit [3:0] Egr_Mirror_Index;
 input bit Ingr_Mirror_En;
 input bit [3:0] Ingr_Mirror_Index;
 input bit Trunk_Member;
 input bit [5:0] Trunk_Id;
 input bit Stg_Mode;
 input bit [5:0] Stg_Index;
 input bit [1:0] ARP_REQ_CMD;
 input bit [1:0] ARP_REPLY_CMD;
 input bit [11:0] O_Pvid;
 input bit [1:0] IGMP_MEM_LEAVE_CMD;
 input bit [1:0] IGMP_MEM_REPORT_CMD;
 input bit [1:0] IGMP_MEM_RELATION_CMD;
 input bit [1:0] IGMP_QUERY_CMD;
 input bit [1:0] UNREG_IPMC_CMD;
 input bit O_OTPIDEN;
 input bit [2:0] O_Pup;
 input bit [1:0] PKT_CMD;
 input bit [1:0] L2_USER_PROTOCOL_INDEX;
 input bit [7:0] VSD_ID;
 
 


 bit [15:0] WrData;
 Cpu16BitWrData(17'h14501,{10'h0,Zk_ChnEn1,Zk_ChnEn0,Port_Type});
 Cpu16BitWrData(17'h14502,{1'b0,PortMirrEn,Learn_mode,Fwd_Vid});
 Cpu16BitWrData(17'h14503,{1'b0,DebugEn,DebugIndex,Egr_Mirror_En,Egr_Mirror_Index,Ingr_Mirror_En,Ingr_Mirror_Index}); 
 Cpu16BitWrData(17'h14504,{2'b0,Trunk_Member,Trunk_Id,Stg_Mode,Stg_Index}); 
 Cpu16BitWrData(17'h14505,{ARP_REQ_CMD,ARP_REPLY_CMD,O_Pvid}); 
 Cpu16BitWrData(17'h14506,{6'b0,IGMP_MEM_LEAVE_CMD,IGMP_MEM_REPORT_CMD,IGMP_MEM_RELATION_CMD,IGMP_QUERY_CMD,UNREG_IPMC_CMD}); 
 Cpu16BitWrData(17'h14507,{O_OTPIDEN,O_Pup,PKT_CMD,L2_USER_PROTOCOL_INDEX,VSD_ID}); 

 WrData ={1'b1,10'h0,port};


 Cpu16BitWrData(17'h14500,WrData);

endtask

///////////////////////////
task PolicyKeyTableCfg;

 input bit [6:0] port;
 input bit [11:0] InVlan;
 input bit [31:0] SrcIpAddr;
 input bit [31:0] DstIpAddr;
 input bit [15:0] SrcPortNum;
 input bit [15:0] DstPortNum;
 input bit [7:0]  Ipv4_Protocol;
 input bit [7:0]  Port_Vid;

 bit [15:0] WrData;

   Cpu16BitWrData(17'h14901,{1'b1,14'h0,1'b0});
   Cpu16BitWrData(17'h14902,{4'h0,InVlan});
   Cpu16BitWrData(17'h14903,SrcIpAddr[31:16]);
   Cpu16BitWrData(17'h14904,SrcIpAddr[15:0]);
   Cpu16BitWrData(17'h14905,DstIpAddr[31:16]);
   Cpu16BitWrData(17'h14906,DstIpAddr[15:0]);
   Cpu16BitWrData(17'h14907,SrcPortNum);
   Cpu16BitWrData(17'h14908,DstPortNum);
   Cpu16BitWrData(17'h14909,{Ipv4_Protocol,Port_Vid});


 WrData ={1'b1,8'h0,port};


 Cpu16BitWrData(17'h14900,WrData);

endtask

///////////////////////////
task PolicyKeyNoProtTableCfg;

 input bit [6:0] port;
 input bit [127:0] policy_table_data;

 bit [15:0] WrData;

   Cpu16BitWrData(17'h14901,{1'b1,14'h0,1'b1});
   Cpu16BitWrData(17'h14902,policy_table_data[127:112]);
   Cpu16BitWrData(17'h14903,policy_table_data[111:96]);
   Cpu16BitWrData(17'h14904,policy_table_data[95:80]);
   Cpu16BitWrData(17'h14905,policy_table_data[79:64]);
   Cpu16BitWrData(17'h14906,policy_table_data[63:48]);
   Cpu16BitWrData(17'h14907,policy_table_data[47:32]);
   Cpu16BitWrData(17'h14908,policy_table_data[31:16]);
   Cpu16BitWrData(17'h14909,policy_table_data[15:0]);


 WrData ={1'b1,8'h0,port};


 Cpu16BitWrData(17'h14900,WrData);

endtask

////////////////////////////////////////////////////////////////////////////////
task PolicyMaskTableCfg;

 input bit [6:0] port;
 input bit [128:0] MaskData;

 bit [15:0] WrData;

   Cpu16BitWrData(17'h14941,{15'h1000,MaskData[128]});
   Cpu16BitWrData(17'h14942,MaskData[127:112]);
   Cpu16BitWrData(17'h14943,MaskData[111:96]);
   Cpu16BitWrData(17'h14944,MaskData[95:80]);
   Cpu16BitWrData(17'h14945,MaskData[79:64]);
   Cpu16BitWrData(17'h14946,MaskData[63:48]);
   Cpu16BitWrData(17'h14947,MaskData[47:32]);
   Cpu16BitWrData(17'h14948,MaskData[31:16]);
   Cpu16BitWrData(17'h14949,MaskData[15:0]);


 WrData ={1'b1,8'h0,port};


 Cpu16BitWrData(17'h14940,WrData);

endtask


////////////////////////////////////////////////////////////////////////////////
task PolicySearchTableCfg;

 input bit [6:0] port;
 input bit St_FlowEn;
 input bit [1:0]  NewPriority;
 input bit [7:0]  St_FlowId;
 input bit RemarkEn;
 input bit L3_RemarkEn;
 input bit [10:0]  L3_RemarkDstIndex;
 input bit [7:0]  NewDstPort;
 input bit [7:0]  NewDstSubType;
 input bit [7:0]  NewDstType;
 input bit [3:0]  DstVid;
 input bit [7:0]  TunId;

 bit [15:0] WrData;

   Cpu16BitWrData(17'h14981,{3'h0,St_FlowEn,2'h0,NewPriority,St_FlowId});
   Cpu16BitWrData(17'h14982,{RemarkEn,3'h0,L3_RemarkEn,L3_RemarkDstIndex});
   Cpu16BitWrData(17'h14983,{NewDstPort,NewDstSubType});
   Cpu16BitWrData(17'h14984,{4'h8,DstVid,NewDstType});
   Cpu16BitWrData(17'h14985,{8'h0,TunId});

 WrData ={1'b1,8'h0,port};


   Cpu16BitWrData(17'h14980,WrData);

endtask


////////////////////////////////////////////////////////////////////////////////
task PolicyOutKeyTableCfg;

 input bit [6:0] port;
 input bit [11:0] OutVlan;
 input bit [31:0] SrcIpAddr;
 input bit [31:0] DstIpAddr;
 input bit [15:0] SrcPortNum;
 input bit [15:0] DstPortNum;
 input bit [7:0]  Ipv4_Protocol;
 input bit [7:0]  Port_Vid;

 bit [15:0] WrData;

   Cpu16BitWrData(17'h14a01,{1'b1,3'b0,OutVlan});
   Cpu16BitWrData(17'h14a02,SrcIpAddr[31:16]);
   Cpu16BitWrData(17'h14a03,SrcIpAddr[15:0]);
   Cpu16BitWrData(17'h14a04,DstIpAddr[31:16]);
   Cpu16BitWrData(17'h14a05,DstIpAddr[15:0]);
   Cpu16BitWrData(17'h14a06,SrcPortNum);
   Cpu16BitWrData(17'h14a07,DstPortNum);
   Cpu16BitWrData(17'h14a08,{Ipv4_Protocol,Port_Vid});


 WrData ={1'b1,8'h0,port};


 Cpu16BitWrData(17'h14a00,WrData);

endtask
////////////////////////////////////////////////////////////////////////////////
task PolicyOutMaskTableCfg;

 input bit [6:0] port;
 input bit [112:0] MaskData;

 bit [15:0] WrData;

   Cpu16BitWrData(17'h14a41,{15'h0,MaskData[112]});
   Cpu16BitWrData(17'h14a42,MaskData[111:96]);
   Cpu16BitWrData(17'h14a43,MaskData[95:80]);
   Cpu16BitWrData(17'h14a44,MaskData[79:64]);
   Cpu16BitWrData(17'h14a45,MaskData[63:48]);
   Cpu16BitWrData(17'h14a46,MaskData[47:32]);
   Cpu16BitWrData(17'h14a47,MaskData[31:16]);
   Cpu16BitWrData(17'h14a48,MaskData[15:0]);


 WrData ={1'b1,8'h0,port};


 Cpu16BitWrData(17'h14a40,WrData);

endtask


////////////////////////////////////////////////////////////////////////////////
task PolicyOutSearchTableCfg;

 input bit [6:0] port;
 input bit St_FlowEn;
 input bit [1:0]  NewPriority;
 input bit [7:0]  St_FlowId;
 input bit RemarkEn;
 input bit Is_L3_Fwd;
 input bit [7:0]  NewDstPort;
 input bit [7:0]  NewDstSubType;
 input bit [7:0]  NewDstType;

 bit [15:0] WrData;

   Cpu16BitWrData(17'h14a81,{3'h0,St_FlowEn,2'h0,NewPriority,St_FlowId});
   Cpu16BitWrData(17'h14a82,{7'h0,RemarkEn,7'h0,Is_L3_Fwd});
   Cpu16BitWrData(17'h14a83,{NewDstPort,NewDstSubType});
   Cpu16BitWrData(17'h14a84,{8'h0,NewDstType});

 WrData ={1'b1,8'h0,port};


   Cpu16BitWrData(17'h14a80,WrData);

endtask



////////////////////////////////////////////////////////////////////////////////
 task automatic RdKeyData;
   input bit [5:0] port;

   bit [15:0] RdData0;
   bit [15:0] RdData1;
   bit [15:0] RdData2;
   bit [15:0] RdData3;
   bit [15:0] RdData4;
   bit [15:0] RdData5;
   bit [15:0] RdData6;
   bit [15:0] RdData7;
   bit [15:0] RdData8;

   Cpu16BitWrData(17'h14800, {10'b0,port});

   Cpu16BitRdData(17'h14800, RdData0);
   $display("KeyRdData0: %-0h",  RdData0);
   Cpu16BitRdData(17'h14809, RdData1);
   $display("KeyRdData1: %-0h",  RdData1);
   Cpu16BitRdData(17'h1480a, RdData2);
   $display("KeyRdData2: %-0h",  RdData2);
   Cpu16BitRdData(17'h1480b, RdData3);
   $display("KeyRdData3: %-0h",  RdData3);
   Cpu16BitRdData(17'h1480c, RdData4);
   $display("KeyRdData4: %-0h",  RdData4);
   Cpu16BitRdData(17'h1480d, RdData5);
   $display("KeyRdData5: %-0h",  RdData5);
   Cpu16BitRdData(17'h1480e, RdData6);
   $display("KeyRdData6: %-0h",  RdData6);
   Cpu16BitRdData(17'h1480f, RdData7);
   $display("KeyRdData7: %-0h",  RdData7);
   Cpu16BitRdData(17'h14810, RdData8);
   $display("KeyRdData8: %-0h",  RdData8);

 endtask

////////////////////////////////////////////////////////////////////////////////
 task automatic RdMaskData;
   input bit [5:0] port;

   bit [15:0] RdData0;
   bit [15:0] RdData1;
   bit [15:0] RdData2;
   bit [15:0] RdData3;
   bit [15:0] RdData4;
   bit [15:0] RdData5;
   bit [15:0] RdData6;
   bit [15:0] RdData7;
   bit [15:0] RdData8;

   Cpu16BitWrData(17'h14840, {10'b0,port});

   Cpu16BitRdData(17'h14840, RdData0);
   $display("MaskRdData0: %-0h",  RdData0);
   Cpu16BitRdData(17'h14849, RdData1);
   $display("MaskRdData1: %-0h",  RdData1);
   Cpu16BitRdData(17'h1484a, RdData2);
   $display("MaskRdData2: %-0h",  RdData2);
   Cpu16BitRdData(17'h1484b, RdData3);
   $display("MaskRdData3: %-0h",  RdData3);
   Cpu16BitRdData(17'h1484c, RdData4);
   $display("MaskRdData4: %-0h",  RdData4);
   Cpu16BitRdData(17'h1484d, RdData5);
   $display("MaskRdData5: %-0h",  RdData5);
   Cpu16BitRdData(17'h1484e, RdData6);
   $display("MaskRdData6: %-0h",  RdData6);
   Cpu16BitRdData(17'h1484f, RdData7);
   $display("MaskRdData7: %-0h",  RdData7);
   Cpu16BitRdData(17'h14850, RdData8);
   $display("MaskRdData8: %-0h",  RdData8);

 endtask

////////////////////////////////////////////////////////////////////////////////
 task automatic RdTabData;
   input bit [5:0] port;

   bit [15:0] RdData0;
   bit [15:0] RdData1;
   bit [15:0] RdData2;
   bit [15:0] RdData3;
   bit [15:0] RdData4;

   Cpu16BitWrData(17'h14880, {10'b0,port});

   Cpu16BitRdData(17'h14880, RdData0);
   $display("TabRdData0: %-0h",  RdData0);
   Cpu16BitRdData(17'h14885, RdData1);
   $display("TabRdData1: %-0h",  RdData1);
   Cpu16BitRdData(17'h14886, RdData2);
   $display("TabRdData2: %-0h",  RdData2);
   Cpu16BitRdData(17'h14887, RdData3);
   $display("TabRdData3: %-0h",  RdData3);
   Cpu16BitRdData(17'h14888, RdData4);
   $display("TabRdData4: %-0h",  RdData4);


 endtask
///////////////////////////////////////////////////////////////////////////////
task automatic ShappingqueCfgTest;
      input  bit [19:0] queueBurst;
      input  bit [13:0] Max_Pkt_Size;
      input  bit [19:0] rate_queue;
      input  bit [6:0] queueNum;

   bit [5:0][15:0] WrData;
   bit [15:0] RdData;

   WrData[0]  = {10'h0,queueBurst[19:14]};
   WrData[1]  = {queueBurst[13:0], Max_Pkt_Size[13:12]};
   WrData[2]  = {Max_Pkt_Size[11:0],rate_queue[19:16]};
   WrData[3]  = rate_queue[15:0];
   WrData[4]  = {1'b1,8'h0,queueNum};
   WrData[5]  = {1'b0,8'h0,queueNum};

   Cpu16BitWrData(17'h1442f,16'b0);
   Cpu16BitWrData(17'h1440a,WrData[0]);
   Cpu16BitWrData(17'h1440b,WrData[1]);
   Cpu16BitWrData(17'h1440c,WrData[2]);
   Cpu16BitWrData(17'h1440d,WrData[3]);
   Cpu16BitWrData(17'h14409,WrData[4]);
 endtask
///////////////////////////////////////////////////////////////////////////////
task automatic ShappingqCfgTest;
      input  bit [19:0] PortBurst;
      input  bit [13:0] Max_Pkt_Size;
      input  bit [19:0] rate_port;
      input  bit [6:0] PortNum;

   bit [5:0][15:0] WrData;
   bit [15:0] RdData;

   WrData[0]  = {10'h0,PortBurst[19:14]};
   WrData[1]  = {PortBurst[13:0], Max_Pkt_Size[13:12]};
   WrData[2]  = {Max_Pkt_Size[11:0],rate_port[19:16]};
   WrData[3]  = rate_port[15:0];
   WrData[4]  = {1'b1,8'h0,PortNum};
   WrData[5]  = {1'b0,8'h0,PortNum};

   Cpu16BitWrData(17'h14420,16'b0);
   Cpu16BitWrData(17'h14401,WrData[0]);
   Cpu16BitWrData(17'h14402,WrData[1]);
   Cpu16BitWrData(17'h14403,WrData[2]);
   Cpu16BitWrData(17'h14404,WrData[3]);
   Cpu16BitWrData(17'h14400,WrData[4]);
 endtask

////////////////////////////////////////////////////////////////////////////////
 task HostKeyTableCfg;

 input bit [7:0] port;
 input bit [31:0] DstIpAddr;

 bit [15:0] WrData;

   Cpu16BitWrData(17'h14801,16'h0001);
   Cpu16BitWrData(17'h14802,DstIpAddr[31:16]);
   Cpu16BitWrData(17'h14803,DstIpAddr[15:0]);

 WrData ={1'b1,7'h0,port};

   Cpu16BitWrData(17'h14800,WrData);

endtask

////////////////////////////////////////////////////////////////////////////////
 task HostMacTableCfg;

 input bit [7:0] port;
 input bit [47:0] HostMac;
 input bit [31:0] hostDstPort;
 input bit hostVlanEn;
 input bit [11:0] hostVlan;
 input bit [7:0] TunId;
 
 bit [15:0] WrData;

   Cpu16BitWrData(17'h14841,HostMac[15:0]);
   Cpu16BitWrData(17'h14842,HostMac[31:16]);
   Cpu16BitWrData(17'h14843,HostMac[47:32]);  
   Cpu16BitWrData(17'h14844,hostDstPort[15:0]);
   Cpu16BitWrData(17'h14845,hostDstPort[31:16]);
   Cpu16BitWrData(17'h14846,{hostVlanEn,3'b0,hostVlan});
   Cpu16BitWrData(17'h14847,{8'h0,TunId});
   

 WrData ={1'b1,7'h0,port};

   Cpu16BitWrData(17'h14840,WrData);

endtask

////////////////////////////////////////////////////////////////////////////////
task automatic RdHostKeyData;
   input bit [7:0] port;

   bit [15:0] RdData0;
   bit [15:0] RdData1;
   bit [15:0] RdData2;
  

   Cpu16BitWrData(17'h14800, {8'b0,port});

   Cpu16BitRdData(17'h14804, RdData0);
   $display("HostKeyRdData0: %-0h",  RdData0);
   Cpu16BitRdData(17'h14805, RdData1);
   $display("HostKeyRdData1: %-0h",  RdData1);
   Cpu16BitRdData(17'h14806, RdData2);
   $display("HostKeyRdData2: %-0h",  RdData2);
 endtask

////////////////////////////////////////////////////////////////////////////////
 task automatic RdHostMacData;
   input bit [7:0] port;

   bit [15:0] RdData0;
   bit [15:0] RdData1;
   bit [15:0] RdData2;
   bit [15:0] RdData3;
   bit [15:0] RdData4;
   bit [15:0] RdData5;

   Cpu16BitWrData(17'h14840, {8'b0,port});

   Cpu16BitRdData(17'h14840, RdData0);
   $display("HostKeyRdData0: %-0h",  RdData0);
   Cpu16BitRdData(17'h14846, RdData1);
   $display("HostKeyRdData1: %-0h",  RdData1);
   Cpu16BitRdData(17'h14847, RdData2);
   $display("HostKeyRdData2: %-0h",  RdData2);
     Cpu16BitRdData(17'h14848, RdData3);
   $display("HostKeyRdData1: %-0h",  RdData1);
   Cpu16BitRdData(17'h14849, RdData4);
   $display("HostKeyRdData2: %-0h",  RdData2);
     Cpu16BitRdData(17'h1484a, RdData5);
   $display("HostKeyRdData1: %-0h",  RdData1);
  
 endtask


////////////////////////////////////////////////////////////////////////////////
task NextHopCfg;

 input bit [10:0] NxHopAddr;
 input bit [47:0] NextHopDstMac;
 input bit [27:0] NextHopDstPort;
 input bit NextHopVlanEn;
 input bit [11:0] NextHopVlan;
 input bit [7:0] NextHopTunnelID;
 
 
 bit [15:0] WrData;

 Cpu16BitWrData(17'h14701,{5'h0,NxHopAddr});
 Cpu16BitWrData(17'h14702,NextHopDstMac[15:0]);
 Cpu16BitWrData(17'h14703,NextHopDstMac[31:16]);
 Cpu16BitWrData(17'h14704,NextHopDstMac[47:32]);
 Cpu16BitWrData(17'h14705,NextHopDstPort[15:0]);
 Cpu16BitWrData(17'h14706,{NextHopDstPort[27:24],4'h0,NextHopDstPort[23:16]});
 Cpu16BitWrData(17'h14707,{NextHopVlanEn,3'b0,NextHopVlan});
 Cpu16BitWrData(17'h14708,{8'h0,NextHopTunnelID});
 

 WrData ={8'h0,8'h1};


 Cpu16BitWrData(17'h14700,WrData);
endtask

////////////////////////////////////////////////////////////////////////////////
  task CpuWr1_hash;

    input bit [15:0] WrAddr;
    input bit [15:0] WrData;
   CupCfgIndWrData(17'h14600,17'h14601,17'h14602, WrAddr,WrData);
     $display("WrAddr is : %h",WrAddr);
     $display("WrData is : %h",WrData);

  endtask

  task CpuRd1_hash;

    input bit [15:0] RdAddr;

    bit [15:0] RdData;

   CupCfgIndRd11Data(13'h600,13'h601,13'h603, RdAddr,RdData);
     $display("RdAddr is : %h",RdAddr);
     $display("RdData is : %h",RdData);

  endtask

    task CpuWr1_tree;

    input bit [15:0] WrAddr;
    input bit [15:0] WrData;
   CupCfgIndWrData(17'h14620,17'h14621,17'h14622, WrAddr,WrData);
     $display("WrAddr is : %h",WrAddr);
     $display("WrData is : %h",WrData);

  endtask

  task CpuRd1_tree;

    input bit [15:0] RdAddr;

    bit [15:0] RdData;

   CupCfgIndRd11Data(13'h620,13'h621,13'h623, RdAddr,RdData);
     $display("RdAddr is : %h",RdAddr);
     $display("RdData is : %h",RdData);

  endtask
//////////////////////////////////////////////////////////////////////////////////
   task CpuWr2_hash;

    input bit [15:0] WrAddr;
    input bit [15:0] WrData;
   CupCfgIndWrData(17'h640,17'h641,17'h642, WrAddr,WrData);
     $display("WrAddr is : %h",WrAddr);
     $display("WrData is : %h",WrData);

  endtask

  task CpuRd2_hash;

    input bit [15:0] RdAddr;

    bit [15:0] RdData;

   CupCfgIndRd11Data(13'h640,13'h641,13'h643, RdAddr,RdData);
     $display("RdAddr is : %h",RdAddr);
     $display("RdData is : %h",RdData);

  endtask

    task CpuWr2_tree;

    input bit [15:0] WrAddr;
    input bit [15:0] WrData;
   CupCfgIndWrData(17'h660,17'h661,17'h662, WrAddr,WrData);
     $display("WrAddr is : %h",WrAddr);
     $display("WrData is : %h",WrData);

  endtask

  task CpuRd2_tree;

    input bit [15:0] RdAddr;

    bit [15:0] RdData;

   CupCfgIndRd11Data(13'h660,13'h661,13'h663, RdAddr,RdData);
     $display("RdAddr is : %h",RdAddr);
     $display("RdData is : %h",RdData);

  endtask

//////////////////////////////////////////////////////////////////////////////////
   task CpuWr3_hash;

    input bit [15:0] WrAddr;
    input bit [15:0] WrData;
   //CupCfgIndWrData(17'h680,17'h681,17'h682, WrAddr,WrData);

    Cpu16BitWrData(17'h682,WrData);
    Cpu16BitWrData(17'h681,WrAddr);
    Cpu16BitWrData(17'h680,16'h1);   
     
   
     $display("WrAddr is : %h",WrAddr);
     $display("WrData is : %h",WrData);

  endtask

  task CpuRd3_hash;

    input bit [15:0] RdAddr;

    bit [15:0] RdData;

   CupCfgIndRd11Data(13'h680,13'h681,13'h683, RdAddr,RdData);
     $display("RdAddr is : %h",RdAddr);
     $display("RdData is : %h",RdData);

  endtask

   task CpuWr3_tree;

    input bit [15:0] WrAddr;
    input bit [15:0] WrData;
   CupCfgIndWrData(17'h6a0,17'h6a1,17'h6a2, WrAddr,WrData);
     $display("WrAddr is : %h",WrAddr);
     $display("WrData is : %h",WrData);

  endtask

  task CpuRd3_tree;

    input bit [15:0] RdAddr;

    bit [15:0] RdData;

   CupCfgIndRd11Data(13'h6a0,13'h6a1,13'h6a3, RdAddr,RdData);
     $display("RdAddr is : %h",RdAddr);
     $display("RdData is : %h",RdData);

  endtask

///////////////////////////////////////////////////////////////////////////////
task automatic IvlanFilterCfg;
      input  bit [11:0] VlanIndex;
      input  bit [7:0] PortPermit;


   bit [15:0] WrData;


   WrData  = {8'h0,PortPermit};

   Cpu16BitWrData(17'h15041,WrData);
   Cpu16BitWrData(17'h15040,{4'h8,VlanIndex});
 endtask

///////////////////////////////////////////////////////////////////////////////
task automatic IvlanVsdCfg;
   input  bit [11:0] Cvlan;
   input  bit VsdValid;
   input  bit [7:0] Vsd;

   Cpu16BitWrData(17'h15081,{7'b0,VsdValid,Vsd});

   Cpu16BitWrData(17'h15080,{4'h8,Cvlan});
 endtask

////////////////////////////////////////////////////////////////////////////////
task automatic KpaPortTabCfg;
      input  bit [1:0] SrcPort;
      input  bit [5:0] PktType;
      input  bit TabValid;
      input  bit [2:0] PD_CMD;
      input  bit [2:0] NewPri;

   Cpu16BitWrData(17'h15131,{8'h0,TabValid,1'b0,PD_CMD,NewPri});

   Cpu16BitWrData(17'h15130,{8'h80,SrcPort,PktType});
 endtask

////////////////////////////////////////////////////////////////////////////////
task automatic UppL2KeyCfg;
      input  bit [3:0] KeyIndex;
      input  bit TabValid;
      input  bit [47:0] DstMac;
      input  bit [15:0] MacType;

   Cpu16BitWrData(17'h15141,{15'h0,TabValid});
   Cpu16BitWrData(17'h15142,DstMac[47:32]);
   Cpu16BitWrData(17'h15143,DstMac[31:16]);
   Cpu16BitWrData(17'h15144,DstMac[15:0]);
   Cpu16BitWrData(17'h15145,MacType[15:0]);

   Cpu16BitWrData(17'h15140,{12'h800,KeyIndex});
 endtask

////////////////////////////////////////////////////////////////////////////////
task automatic UppL2MaskCfg;
      input  bit [3:0] MaskIndex;
      input  bit TabValid;
      input  bit [47:0] DstMacMask;
      input  bit [15:0] MacTypeMask;

   Cpu16BitWrData(17'h15161,{15'h0,TabValid});
   Cpu16BitWrData(17'h15162,DstMacMask[47:32]);
   Cpu16BitWrData(17'h15163,DstMacMask[31:16]);
   Cpu16BitWrData(17'h15164,DstMacMask[15:0]);
   Cpu16BitWrData(17'h15165,MacTypeMask[15:0]);

   Cpu16BitWrData(17'h15160,{12'h800,MaskIndex});
 endtask

////////////////////////////////////////////////////////////////////////////////
task automatic UppL2GlbCfg;
      input  bit [3:0] KeyIndex;
      input  bit TabValid;
      input  bit [2:0] PD_CMD;
      input  bit [2:0] NewPri;

   Cpu16BitWrData(17'h15181,{8'h0,TabValid,1'b0,PD_CMD,NewPri});

   Cpu16BitWrData(17'h15180,{12'h800,KeyIndex});
 endtask


////////////////////////////////////////////////////////////////////////////////
task automatic UppL2PortCfg;
      input  bit [5:0] KeyIndex;
      input  bit TabValid;
      input  bit [2:0] PD_CMD;
      input  bit [2:0] NewPri;

   Cpu16BitWrData(17'h15191,{8'h0,TabValid,1'b0,PD_CMD,NewPri});

   Cpu16BitWrData(17'h15190,{4'h8,6'h00,KeyIndex});
 endtask

////////////////////////////////////////////////////////////////////////////////
task automatic UppL3KeyCfg;
      input  bit [3:0] KeyIndex;
      input  bit TabValid;
      input  bit [7:0] Ipv4Prot;
      input  bit [31:0] DstIp;
      input  bit [15:0] DstPortNum;

   Cpu16BitWrData(17'h151a1,{15'h0,TabValid});
   Cpu16BitWrData(17'h151a2,{8'h0,Ipv4Prot});
   Cpu16BitWrData(17'h151a3,DstIp[31:16]);
   Cpu16BitWrData(17'h151a4,DstIp[15:0]);
   Cpu16BitWrData(17'h151a5,DstPortNum[15:0]);

   Cpu16BitWrData(17'h151a0,{12'h800,KeyIndex});
 endtask

////////////////////////////////////////////////////////////////////////////////
task automatic UppL3MaskCfg;
      input  bit [3:0] MaskIndex;
      input  bit TabValid;
      input  bit [7:0] Ipv4ProtMask;
      input  bit [31:0] DstIpMask;
      input  bit [15:0] DstPortNumMask;

   Cpu16BitWrData(17'h151c1,{15'h0,TabValid});
   Cpu16BitWrData(17'h151c2,{8'h0,Ipv4ProtMask});
   Cpu16BitWrData(17'h151c3,DstIpMask[31:16]);
   Cpu16BitWrData(17'h151c4,DstIpMask[15:0]);
   Cpu16BitWrData(17'h151c5,DstPortNumMask[15:0]);

   Cpu16BitWrData(17'h151c0,{12'h800,MaskIndex});
 endtask

////////////////////////////////////////////////////////////////////////////////
task automatic UppL3GlbCfg;
      input  bit [3:0] KeyIndex;
      input  bit TabValid;
      input  bit [2:0] PD_CMD;
      input  bit [2:0] NewPri;

   Cpu16BitWrData(17'h151e1,{8'h0,TabValid,1'b0,PD_CMD,NewPri});

   Cpu16BitWrData(17'h151e0,{12'h800,KeyIndex});
 endtask


////////////////////////////////////////////////////////////////////////////////
task automatic UppL3PortCfg;
      input  bit [5:0] KeyIndex;
      input  bit TabValid;
      input  bit [2:0] PD_CMD;
      input  bit [2:0] NewPri;

   Cpu16BitWrData(17'h151f1,{8'h0,TabValid,1'b0,PD_CMD,NewPri});

   Cpu16BitWrData(17'h151f0,{4'h8,6'h00,KeyIndex});
 endtask
////////////////////////////////////////////////////////////////////////////////
task automatic FdbTableCfg;
      input  bit [7:0] Fdb_Vsd;
      input  bit [11:0] Fdb_Vid;
      input  bit [47:0] Fdb_Mac;
      input  bit [1:0] Egr_Type;
      input  bit [3:0] Egr_Intf;
      input  bit [1:0] Pkt_Cmd;
      input  bit Fdb_IsL3;
      input  bit Fdb_Static;
      input  bit Fbd_Vld; 
      
    bit [8:0] [15:0] WrData;
    
    WrData[0] = {8'h0,Fdb_Vsd};
    WrData[1] = {4'h0,Fdb_Vid};
    WrData[2] = Fdb_Mac[47:32];
    WrData[3] = Fdb_Mac[31:16];
    WrData[4] = Fdb_Mac[15:0];
    WrData[5] = 16'h0;
    WrData[6] = {10'h0,Egr_Intf,Egr_Type};
    WrData[7] = 16'h0;
    WrData[8] = {7'h0,Pkt_Cmd,Fdb_IsL3,2'b00,Fdb_Static,2'b00,Fbd_Vld};
    
    

   Cpu16BitWrData(17'h14c51,WrData[0]);
   Cpu16BitWrData(17'h14c52,WrData[1]);
   Cpu16BitWrData(17'h14c53,WrData[2]);
   Cpu16BitWrData(17'h14c54,WrData[3]);
   Cpu16BitWrData(17'h14c55,WrData[4]);
   Cpu16BitWrData(17'h14c56,WrData[5]);
   Cpu16BitWrData(17'h14c57,WrData[6]);
   Cpu16BitWrData(17'h14c58,WrData[7]);
   Cpu16BitWrData(17'h14c59,WrData[8]);
   Cpu16BitWrData(17'h14c50,16'h8000);
 endtask
////////////////////////////////////////////////////////////////////////////////
task automatic VlanMacCfg;
      input  bit [7:0] VlanIndex;
      input  bit [47:0] VlanMac;
      input  bit [5:0] mstg_index;

   Cpu16BitWrData(17'h15281,{mstg_index,9'h0,1'b1});
   Cpu16BitWrData(17'h15282,VlanMac[47:32]);
   Cpu16BitWrData(17'h15283,VlanMac[31:16]);
   Cpu16BitWrData(17'h15284,VlanMac[15:0]);
   Cpu16BitWrData(17'h15280,{8'h80,VlanIndex});
 endtask
///////////////////////////////////////////////////////////////////////////////////
task automatic MplsSearchTunIdCfg;
      input  bit [7:0] Src_Port;
      input  bit [11:0] In_Vlan;
      input  bit [19:0] Label;
      input  bit TabValid;
      input  bit [7:0] TunId;

   Cpu16BitWrData(17'h15301,{8'h0,Src_Port});
   Cpu16BitWrData(17'h15302,{In_Vlan,Label[19:16]});
   Cpu16BitWrData(17'h15303,Label[15:0]);
   Cpu16BitWrData(17'h15304,{TabValid, 7'h0,TunId});

   Cpu16BitWrData(17'h15300,16'h8000);
 endtask
////////////////////////////////////////////////////////////////////////////////////
task automatic MplsNextHopCfg;
      input  bit [47:0] NextHopMac;
      input  bit Flow_En;
      input  bit [2:0] Flow_Pri;
      input  bit [7:0] Flow_Id;
      input  bit [7:0] Dst_Port;
      input  bit [7:0] Dst_Type;
      input  bit [1:0] OperBit;
      input  bit [11:0] Out_Vlan;
      input  bit Out_VlanEn;
      input  bit [7:0] TunId;
      input  bit route_loop;
      
      input  bit [20:0] label0;
      input  bit [20:0] label1;
      input  bit [20:0] label2;
      input  bit [20:0] label3;
      input  bit [20:0] label4;
      input  bit [20:0] label5;
      
   
   Cpu16BitWrData(17'h15381,NextHopMac[15:0]);
   Cpu16BitWrData(17'h15382,NextHopMac[31:16]);
   Cpu16BitWrData(17'h15383,NextHopMac[47:32]);  
   Cpu16BitWrData(17'h15384,{8'h0,Dst_Port});
   Cpu16BitWrData(17'h15385,{route_loop,1'b0,OperBit,4'h0,Dst_Type});
   Cpu16BitWrData(17'h15386,{Out_VlanEn,3'h0,Out_Vlan});
   Cpu16BitWrData(17'h15387,{3'b000,Flow_En,1'b0,Flow_Pri,Flow_Id});
   
   Cpu16BitWrData(17'h15390,{label0[20],11'h0,label0[19:16]});
   Cpu16BitWrData(17'h15391,label0[15:0]);
   Cpu16BitWrData(17'h15392,{label1[20],11'h0,label1[19:16]});
   Cpu16BitWrData(17'h15393,label1[15:0]);
   Cpu16BitWrData(17'h15394,{label2[20],11'h0,label2[19:16]});
   Cpu16BitWrData(17'h15395,label2[15:0]);
   Cpu16BitWrData(17'h15396,{label3[20],11'h0,label3[19:16]});
   Cpu16BitWrData(17'h15397,label3[15:0]);
   Cpu16BitWrData(17'h15398,{label4[20],11'h0,label4[19:16]});
   Cpu16BitWrData(17'h15399,label4[15:0]);
   Cpu16BitWrData(17'h1539a,{label5[20],11'h0,label5[19:16]});
   Cpu16BitWrData(17'h1539b,label5[15:0]);
   Cpu16BitWrData(17'h15380,{1'b1,7'h0,TunId});
 endtask
////////////////////////////////////////////////////////////////////////////////
  task automatic VlanIdIndex;
      input  bit [11:0] VlanId;
      input  bit [3:0] VlanIndex;

   Cpu16BitWrData(17'h14d01,{12'h0,VlanIndex});
   Cpu16BitWrData(17'h14d00,{1'b1,3'h0,VlanId});
 endtask
////////////////////////////////////////////////////////////////////////////////
task automatic MstgstatusCfg;
      input  bit [7:0] MstgIndex;
      input  bit Mstgstatus;
      
       bit[15:0] RdData;
  
   Cpu16BitWrData(17'h14ccb,{15'h0,Mstgstatus});
   Cpu16BitWrData(17'h14cca,{8'h80,MstgIndex});
   
   //repeat(100) @(posedge CpuClk);
   
   Cpu16BitWrData(17'h14cca,{8'h00,MstgIndex});
   
   Cpu16BitRdData(17'h14ccc, RdData);
   $display("RdData: %-0h",  RdData);
   
 endtask

////////////////////////////////////////////////////////////////////////////////
task automatic VsdCopyPortCfg;
      input  bit [7:0] Vsd;
      input  bit [15:0] CopyPort;

   Cpu16BitWrData(17'h15201,CopyPort);

   Cpu16BitWrData(17'h15200,{4'h8,4'h0,Vsd});
 endtask

////////////////////////////////////////////////////////////////////////////
task automatic FlowStatResult;
      input  bit [7:0] FlowId;
      input  bit [5:0] SrcPort;
      input  bit [5:0] DstPort;
      input  bit [11:0] SrcVlan;
      input  bit [11:0] DstVlan;

   bit [5:0][15:0] RdData0;
   bit [5:0][15:0] RdData1;
   bit [5:0][15:0] RdData2;
   bit [5:0][15:0] RdData3;
   bit [5:0][15:0] RdData4;


   Cpu16BitWrData(17'h14b00,{8'h0,FlowId});
   Cpu16BitRdData(17'h14b02,RdData0[5]);
   Cpu16BitRdData(17'h14b03,RdData0[4]);
   Cpu16BitRdData(17'h14b04,RdData0[3]);
   Cpu16BitRdData(17'h14b05,RdData0[2]);
   Cpu16BitRdData(17'h14b06,RdData0[1]);
   Cpu16BitRdData(17'h14b07,RdData0[0]);
   $display("RdData0: %-0h",  RdData0);



   Cpu16BitWrData(17'h14b20,{10'h0,SrcPort});
   Cpu16BitRdData(17'h14b22,RdData1[5]);
   Cpu16BitRdData(17'h14b23,RdData1[4]);
   Cpu16BitRdData(17'h14b24,RdData1[3]);
   Cpu16BitRdData(17'h14b25,RdData1[2]);
   Cpu16BitRdData(17'h14b26,RdData1[1]);
   Cpu16BitRdData(17'h14b27,RdData1[0]);
   $display("RdData1: %-0h",  RdData1);


   Cpu16BitWrData(17'h14b40,{10'h0,DstPort});
   Cpu16BitRdData(17'h14b42,RdData2[5]);
   Cpu16BitRdData(17'h14b43,RdData2[4]);
   Cpu16BitRdData(17'h14b44,RdData2[3]);
   Cpu16BitRdData(17'h14b45,RdData2[2]);
   Cpu16BitRdData(17'h14b46,RdData2[1]);
   Cpu16BitRdData(17'h14b47,RdData2[0]);
   $display("RdData2: %-0h",  RdData2);


   Cpu16BitWrData(17'h14b60,{4'h0,SrcVlan});
   Cpu16BitRdData(17'h14b62,RdData3[5]);
   Cpu16BitRdData(17'h14b63,RdData3[4]);
   Cpu16BitRdData(17'h14b64,RdData3[3]);
   Cpu16BitRdData(17'h14b65,RdData3[2]);
   Cpu16BitRdData(17'h14b66,RdData3[1]);
   Cpu16BitRdData(17'h14b67,RdData3[0]);
   $display("RdData3: %-0h",  RdData3);

   Cpu16BitWrData(17'h14b80,{4'h0,DstVlan});
   Cpu16BitRdData(17'h14b82,RdData4[5]);
   Cpu16BitRdData(17'h14b83,RdData4[4]);
   Cpu16BitRdData(17'h14b84,RdData4[3]);
   Cpu16BitRdData(17'h14b85,RdData4[2]);
   Cpu16BitRdData(17'h14b86,RdData4[1]);
   Cpu16BitRdData(17'h14b87,RdData4[0]);
   $display("RdData4: %-0h",  RdData4);


 endtask



///////////////////////////////////////////////////////////////////////////



endmodule