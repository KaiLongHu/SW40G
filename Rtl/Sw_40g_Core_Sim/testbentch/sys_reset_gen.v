/****************************************************************
*Company:  CETC54
*Engineer: liyuan

*Create Date   : Thursday, the 13 of April, 2023  14:26:54
*Design Name   :
*Module Name   : sys_reset_gen.v
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
module sys_reset_gen #(
 parameter
 RST_TIME  = 200,//ns
 RST_LEVEL = 0//0 or 1
)(
 output reg reset
);
/******************************************/
initial begin
 reset = RST_LEVEL;
 #(RST_TIME) reset = (!RST_LEVEL);
end
/******************************************/
endmodule
