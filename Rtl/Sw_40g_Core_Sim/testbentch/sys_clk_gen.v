/****************************************************************
*Company:  CETC54
*Engineer: liyuan

*Create Date   : Thursday, the 13 of April, 2023  14:26:54
*Design Name   :
*Module Name   : sys_clk_gen.v
*Project Name  :
*Target Devices: xilinx
*Tool versions : xilinx
*Description   :  
*Revision:     : 1.0.0
*Revision 0.01 - File Created
*Additional Comments: 
*Modification Record :
****************************************************************/
`timescale 1ns/1ns
module sys_clk_gen #(
 parameter
 CLK_FREQUENCE = 100,  //Mhz
 CLK_PHASE     =   0 //ns
)(
 output wire clk
);
/******************************************/
localparam TIME_UNIT = 1000.000;
localparam CLK_CYCLE = TIME_UNIT/CLK_FREQUENCE;
/******************************************/
reg clk_reg;

/******************************************/
initial begin
 clk_reg = 1'b0;
 #(CLK_PHASE);
 forever begin
  #(CLK_CYCLE/2) clk_reg = ~clk_reg;
 end
end
/******************************************/
assign clk = clk_reg;
/******************************************/
endmodule
