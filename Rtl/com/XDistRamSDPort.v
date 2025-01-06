/****************************************************************
*Company:  CETC54
*Engineer: liyuan

*Create Date   : Wednesday, the 03 of April, 2019  17:04:20
*Design Name   :
*Module Name   : XDistRamSDPort.v
*Project Name  :
*Target Devices: K7
*Tool versions : Vivado 2016
*Description   :  
*Revision:     : 1.0.0
*Revision 0.01 - File Created
*Additional Comments: 
*Modification Record :
*****************************************************************/


// synopsys translate_off
`timescale 1ns/1ns
// synopsys translate_on
module XDistRamSDPort #(
  parameter
  BRAM_DEPTH = 64,
  DATA_WIDTH = 32,
  ADDR_WIDTH = log2(BRAM_DEPTH)
)(
    input wire [ADDR_WIDTH -1  : 0]  a,
    input wire [DATA_WIDTH - 1 : 0]  d,
    input wire [ADDR_WIDTH - 1 : 0]  dpra,
    input wire clk,
    input wire we,
    output wire [DATA_WIDTH - 1 : 0] qdpo
);

///////////////////////////////Signal Define/////////////////////////////////

   localparam MEMORY_SIZE = BRAM_DEPTH*DATA_WIDTH;

/////////////////////////////////////////////////////////////////////////
  function integer log2;  
     input integer value;
           begin
               for (log2=0; value>0; log2=log2+1)
                   value = value>>1;
               log2 = log2 - 1;
           end
 endfunction


/////////////////////////////////////////////////////////////////////////////
   xpm_memory_dpdistram #(
      .ADDR_WIDTH_A(ADDR_WIDTH),               // DECIMAL
      .ADDR_WIDTH_B(ADDR_WIDTH),               // DECIMAL
      .BYTE_WRITE_WIDTH_A(DATA_WIDTH),        // DECIMAL
      .CLOCKING_MODE("common_clock"), // String
      .MEMORY_INIT_FILE("none"),      // String
      .MEMORY_INIT_PARAM("0"),        // String
      .MEMORY_OPTIMIZATION("true"),   // String
      .MEMORY_SIZE(MEMORY_SIZE),             // DECIMAL
      .MESSAGE_CONTROL(0),            // DECIMAL
      .READ_DATA_WIDTH_A(DATA_WIDTH),         // DECIMAL
      .READ_DATA_WIDTH_B(DATA_WIDTH),         // DECIMAL
      .READ_LATENCY_A(1),             // DECIMAL
      .READ_LATENCY_B(1),             // DECIMAL
      .READ_RESET_VALUE_A("0"),       // String
      .READ_RESET_VALUE_B("0"),       // String
      .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
      .USE_MEM_INIT(1),               // DECIMAL
      .WRITE_DATA_WIDTH_A(DATA_WIDTH)         // DECIMAL
   )
   xpm_memory_dpdistram_inst (
      .douta(),   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
      .doutb(qdpo),   // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
      .addra(a),   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
      .addrb(dpra),   // ADDR_WIDTH_B-bit input: Address for port B write and read operations.
      .clka(clk),     // 1-bit input: Clock signal for port A. Also clocks port B when parameter CLOCKING_MODE
                       // is "common_clock".

      .clkb(clk),     // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                       // "independent_clock". Unused when parameter CLOCKING_MODE is "common_clock".

      .dina(d),     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      .ena(1'b1),       // 1-bit input: Memory enable signal for port A. Must be high on clock cycles when read
                       // or write operations are initiated. Pipelined internally.

      .enb(1'b1),       // 1-bit input: Memory enable signal for port B. Must be high on clock cycles when read
                       // or write operations are initiated. Pipelined internally.

      .regcea(1'b0), // 1-bit input: Clock Enable for the last register stage on the output data path.
      .regceb(1'b0), // 1-bit input: Do not change from the provided value.
      .rsta(1'b0),     // 1-bit input: Reset signal for the final port A output register stage. Synchronously
                       // resets output port douta to the value specified by parameter READ_RESET_VALUE_A.

      .rstb(1'b0),     // 1-bit input: Reset signal for the final port B output register stage. Synchronously
                       // resets output port doutb to the value specified by parameter READ_RESET_VALUE_B.

      .wea(we)        // WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input data port dina. 1
                       // bit wide when word-wide writes are used. In byte-wide write configurations, each bit
                       // controls the writing one byte of dina to address addra. For example, to synchronously
                       // write only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be 4'b0010.

   );




/////////////////////////////////////////////////////////////////////////////
endmodule
