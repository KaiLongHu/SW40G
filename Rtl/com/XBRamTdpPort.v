/****************************************************************
*Company:  CETC54
*Engineer: liyuan

*Create Date   : Wednesday, the 03 of April, 2019  15:35:08
*Design Name   :
*Module Name   : XBRamTdpPort.v
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
module XBRamTdpPort #(
  parameter
  BRAM_DEPTH_A = 64,
  DATA_WIDTH_A = 32,
  READ_LATENCY_A =2,
  DATA_WIDTH_B = 32,
  READ_LATENCY_B = 2,
  CLOCKING_MODE  = "common_clock",   // common_clock --> clka, clkb same as clka; independent_clock --> clka, clkb diffrent
  ADDR_WIDTH_A = log2(BRAM_DEPTH_A), 
  ADDR_WIDTH_B = log2((BRAM_DEPTH_A*DATA_WIDTH_A)/DATA_WIDTH_B)
)(
  
    input  wire clka,
    input  wire wea,
    input  wire [ADDR_WIDTH_A - 1 : 0] addra,
    input  wire [DATA_WIDTH_A - 1 : 0] dina,
    output wire [DATA_WIDTH_A - 1 : 0] douta,
    input  wire clkb,
    input  wire web,
    input  wire [ADDR_WIDTH_B - 1 : 0] addrb,
    input  wire [DATA_WIDTH_B - 1 : 0] dinb,
    output wire [DATA_WIDTH_B - 1 : 0] doutb
);

///////////////////////////////Signal Define/////////////////////////////////
   localparam MEMORY_SIZE = BRAM_DEPTH_A * DATA_WIDTH_A;

//////////////////////////////////////////////////////////////////////////////
  function integer log2;  
     input integer value;
           begin
               for (log2=0; value>0; log2=log2+1)
                   value = value>>1;
               log2 = log2 - 1;
           end
 endfunction
//////////////////////////////////////////////////////////////////////////////
     xpm_memory_tdpram #(
      .ADDR_WIDTH_A(ADDR_WIDTH_A),               // DECIMAL
      .ADDR_WIDTH_B(ADDR_WIDTH_B),               // DECIMAL
      .AUTO_SLEEP_TIME(0),            // DECIMAL
      .BYTE_WRITE_WIDTH_A(DATA_WIDTH_A),        // DECIMAL
      .BYTE_WRITE_WIDTH_B(DATA_WIDTH_B),        // DECIMAL
      .CLOCKING_MODE(CLOCKING_MODE), // String
      .ECC_MODE("no_ecc"),            // String
      .MEMORY_INIT_FILE("none"),      // String
      .MEMORY_INIT_PARAM("0"),        // String
      .MEMORY_OPTIMIZATION("true"),   // String
      .MEMORY_PRIMITIVE("auto"),      // String
      .MEMORY_SIZE(MEMORY_SIZE),             // DECIMAL
      .MESSAGE_CONTROL(0),            // DECIMAL
      .READ_DATA_WIDTH_A(DATA_WIDTH_A),         // DECIMAL
      .READ_DATA_WIDTH_B(DATA_WIDTH_B),         // DECIMAL
      .READ_LATENCY_A(READ_LATENCY_A),             // DECIMAL
      .READ_LATENCY_B(READ_LATENCY_B),             // DECIMAL
      .READ_RESET_VALUE_A("0"),       // String
      .READ_RESET_VALUE_B("0"),       // String
      .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
      .USE_MEM_INIT(1),               // DECIMAL
      .WAKEUP_TIME("disable_sleep"),  // String
      .WRITE_DATA_WIDTH_A(DATA_WIDTH_A),        // DECIMAL
      .WRITE_DATA_WIDTH_B(DATA_WIDTH_B),        // DECIMAL
      .WRITE_MODE_A("no_change"),     // String
      .WRITE_MODE_B("no_change")      // String
   )
   xpm_memory_tdpram_inst (
      .dbiterra(),             // 1-bit output: Status signal to indicate double bit error occurrence
                                       // on the data output of port A.

      .dbiterrb(),             // 1-bit output: Status signal to indicate double bit error occurrence
                                       // on the data output of port A.

      .douta(douta),                   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
      .doutb(doutb),                   // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
      .sbiterra(),             // 1-bit output: Status signal to indicate single bit error occurrence
                                       // on the data output of port A.

      .sbiterrb(),             // 1-bit output: Status signal to indicate single bit error occurrence
                                       // on the data output of port B.

      .addra(addra),                   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
      .addrb(addrb),                   // ADDR_WIDTH_B-bit input: Address for port B write and read operations.
      .clka(clka),                     // 1-bit input: Clock signal for port A. Also clocks port B when
                                       // parameter CLOCKING_MODE is "common_clock".

      .clkb(clkb),                     // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                                       // "independent_clock". Unused when parameter CLOCKING_MODE is
                                       // "common_clock".

      .dina(dina),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      .dinb(dinb),                     // WRITE_DATA_WIDTH_B-bit input: Data input for port B write operations.
      .ena(1'b1),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
                                       // cycles when read or write operations are initiated. Pipelined
                                       // internally.

      .enb(1'b1),                       // 1-bit input: Memory enable signal for port B. Must be high on clock
                                       // cycles when read or write operations are initiated. Pipelined
                                       // internally.

      .injectdbiterra(1'b0), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .injectdbiterrb(1'b0), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .injectsbiterra(1'b0), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .injectsbiterrb(1'b0), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .regcea(1'b0),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

      .regceb(1'b0),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

      .rsta(1'b0),                     // 1-bit input: Reset signal for the final port A output register stage.
                                       // Synchronously resets output port douta to the value specified by
                                       // parameter READ_RESET_VALUE_A.

      .rstb(1'b0),                     // 1-bit input: Reset signal for the final port B output register stage.
                                       // Synchronously resets output port doutb to the value specified by
                                       // parameter READ_RESET_VALUE_B.

      .sleep(1'b0),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
      .wea(wea),                       // WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input
                                       // data port dina. 1 bit wide when word-wide writes are used. In
                                       // byte-wide write configurations, each bit controls the writing one
                                       // byte of dina to address addra. For example, to synchronously write
                                       // only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be
                                       // 4'b0010.

      .web(web)                        // WRITE_DATA_WIDTH_B-bit input: Write enable vector for port B input
                                       // data port dinb. 1 bit wide when word-wide writes are used. In
                                       // byte-wide write configurations, each bit controls the writing one
                                       // byte of dinb to address addrb. For example, to synchronously write
                                       // only bits [15-8] of dinb when WRITE_DATA_WIDTH_B is 32, web would be
                                       // 4'b0010.

   );
/////////////////////////////////////////////////////////////////////////////
endmodule
