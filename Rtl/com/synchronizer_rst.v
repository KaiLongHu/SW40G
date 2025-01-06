/****************************************************************
*Company:  CETC54
*Engineer: liyuan

*Create Date   : Monday, the 04 of March, 2019  11:39:30
*Design Name   :
*Module Name   : synchronizer_rst.v
*Project Name  :
*Target Devices: C5
*Tool versions : Quartus II 15.0
*Description   :  
*Revision:     : 1.0.0
*Revision 0.01 - File Created
*Additional Comments: 
*Modification Record :
*****************************************************************/


// synopsys translate_off
`timescale 1ns/1ns
// synopsys translate_on
module synchronizer_rst #(
    parameter C_NUM_SYNC_REGS = 3,
    parameter C_RVAL          = 1'b0
)(
    input  wire clk,
    input  wire rst,
    input  wire data_in,
    output wire data_out
);

///////////////////////////////Signal Define/////////////////////////////////////////////////////////////////////

 (* shreg_extract = "no", ASYNC_REG = "TRUE" *) reg [C_NUM_SYNC_REGS - 1:0] syncl_r = {C_NUM_SYNC_REGS{C_RVAL}};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 always@(posedge clk or posedge rst) begin
   if(rst)
     syncl_r<={C_NUM_SYNC_REGS{C_RVAL}};  
   else
   	 syncl_r<={syncl_r[C_NUM_SYNC_REGS-2:0], data_in};
 end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  assign data_out = syncl_r[C_NUM_SYNC_REGS - 1];

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
endmodule
