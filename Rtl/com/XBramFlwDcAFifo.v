/****************************************************************
*Company:  CETC54
*Engineer: liyuan

*Create Date   : Wednesday, the 03 of April, 2019  09:11:48
*Design Name   :
*Module Name   : XBramFlwDcAFifo.v
*Project Name  :
*Target Devices: K7
*Tool versions : Vivado 2016
*Description   :  
*Revision:     : 1.0.0
*Revision 0.01 - File Created
*Additional Comments: 
*Modification Record :

// | Designate the fifo memory primitive (resource type) to use-                                                         
// |                                                                                                                     
// |  "auto"- Allow Vivado Synthesis to choose                                                                           
// |   "block"- Block RAM FIFO                                                                                           
// |   "distributed"- Distributed RAM FIFO                                                                               
*****************************************************************/

// synopsys translate_off
`timescale 1ns/1ns
// synopsys translate_on
module XBramFlwDcAFifo #(
  parameter
   FIFO_WRITE_DEPTH = 4096,
   WRITE_DATA_WIDTH = 8,
   READ_DATA_WIDTH  = 8,
   READ_MODE        = "fwft",   // std
   FIFO_MEMORY_TYPE = "block",  //  "auto"- Allow Vivado Synthesis to choose;  "block"- Block RAM FIFO  ; "distributed"- Distributed RAM FIFO   
   FIFO_READ_LATENCY = 1,
   W_HALF_LEVEL   = 2048,
   W_ALMOST_LEVEL   = 2578
)(
  input wire rst,
	input wire wr_clk,
  input wire wr_en,
  input wire [WRITE_DATA_WIDTH - 1 : 0] din,
	output reg half_full,
  output wire prog_full,
	
	input wire rd_clk,
  input wire rd_en,    
  output wire [READ_DATA_WIDTH - 1 : 0] dout,
  output wire empty

);
//////////////////////////////////////////////////////////////////////////////////////
  function integer log2;  
     input integer value;
           begin
               for (log2=0; value>0; log2=log2+1)
                   value = value>>1;
               log2 = log2 - 1;
           end
 endfunction
//////////////////////////////////////////////////////////////////////////////////////
localparam WR_DATA_COUNT_WIDTH = log2(FIFO_WRITE_DEPTH);
 
wire [WR_DATA_COUNT_WIDTH - 1 : 0] wrusedw;
wire wr_half_full;

assign wr_half_full = (wrusedw > W_HALF_LEVEL)? 1'b1 : 1'b0;

always@(posedge rst or posedge wr_clk) begin
  if(rst) begin
  	half_full<=1'b0;
  end
  else begin
    half_full<= wr_half_full;
  end
end

//----------------------------------------------------------------
//Xilinx Fifo
 xpm_fifo_async #(
      .CDC_SYNC_STAGES(2),       // DECIMAL
      .DOUT_RESET_VALUE("0"),    // String
      .ECC_MODE("no_ecc"),       // String
      .FIFO_MEMORY_TYPE(FIFO_MEMORY_TYPE), // String
      .FIFO_READ_LATENCY(FIFO_READ_LATENCY),     // DECIMAL
      .FIFO_WRITE_DEPTH(FIFO_WRITE_DEPTH),   // DECIMAL
      .FULL_RESET_VALUE(0),      // DECIMAL
      .PROG_EMPTY_THRESH(10),    // DECIMAL
      .PROG_FULL_THRESH(W_ALMOST_LEVEL),     // DECIMAL
      .RD_DATA_COUNT_WIDTH(1),   // DECIMAL
      .READ_DATA_WIDTH(READ_DATA_WIDTH),      // DECIMAL
      .READ_MODE(READ_MODE),         // String
      .RELATED_CLOCKS(0),        // DECIMAL
      .USE_ADV_FEATURES("0707"), // String
      .WAKEUP_TIME(0),           // DECIMAL
      .WRITE_DATA_WIDTH(WRITE_DATA_WIDTH),     // DECIMAL
      .WR_DATA_COUNT_WIDTH(WR_DATA_COUNT_WIDTH)    // DECIMAL
   )
   xpm_fifo_async_inst (
      .almost_empty(),   // 1-bit output: Almost Empty : When asserted, this signal indicates that
                                     // only one more read can be performed before the FIFO goes to empty.

      .almost_full(),     // 1-bit output: Almost Full: When asserted, this signal indicates that
                                     // only one more write can be performed before the FIFO is full.

      .data_valid(),       // 1-bit output: Read Data Valid: When asserted, this signal indicates
                                     // that valid data is available on the output bus (dout).

      .dbiterr(),             // 1-bit output: Double Bit Error: Indicates that the ECC decoder detected
                                     // a double-bit error and data in the FIFO core is corrupted.

      .dout(dout),                   // READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven
                                     // when reading the FIFO.

      .empty(empty),                 // 1-bit output: Empty Flag: When asserted, this signal indicates that the
                                     // FIFO is empty. Read requests are ignored when the FIFO is empty,
                                     // initiating a read while empty is not destructive to the FIFO.

      .full(full),                   // 1-bit output: Full Flag: When asserted, this signal indicates that the
                                     // FIFO is full. Write requests are ignored when the FIFO is full,
                                     // initiating a write when the FIFO is full is not destructive to the
                                     // contents of the FIFO.

      .overflow(),           // 1-bit output: Overflow: This signal indicates that a write request
                                     // (wren) during the prior clock cycle was rejected, because the FIFO is
                                     // full. Overflowing the FIFO is not destructive to the contents of the
                                     // FIFO.

      .prog_empty(),       // 1-bit output: Programmable Empty: This signal is asserted when the
                                     // number of words in the FIFO is less than or equal to the programmable
                                     // empty threshold value. It is de-asserted when the number of words in
                                     // the FIFO exceeds the programmable empty threshold value.

      .prog_full(prog_full),         // 1-bit output: Programmable Full: This signal is asserted when the
                                     // number of words in the FIFO is greater than or equal to the
                                     // programmable full threshold value. It is de-asserted when the number of
                                     // words in the FIFO is less than the programmable full threshold value.

      .rd_data_count(), // RD_DATA_COUNT_WIDTH-bit output: Read Data Count: This bus indicates the
                                     // number of words read from the FIFO.

      .rd_rst_busy(),     // 1-bit output: Read Reset Busy: Active-High indicator that the FIFO read
                                     // domain is currently in a reset state.

      .sbiterr(),             // 1-bit output: Single Bit Error: Indicates that the ECC decoder detected
                                     // and fixed a single-bit error.

      .underflow(),         // 1-bit output: Underflow: Indicates that the read request (rd_en) during
                                     // the previous clock cycle was rejected because the FIFO is empty. Under
                                     // flowing the FIFO is not destructive to the FIFO.

      .wr_ack(),               // 1-bit output: Write Acknowledge: This signal indicates that a write
                                     // request (wr_en) during the prior clock cycle is succeeded.

      .wr_data_count(wrusedw), // WR_DATA_COUNT_WIDTH-bit output: Write Data Count: This bus indicates
                                     // the number of words written into the FIFO.

      .wr_rst_busy(),     // 1-bit output: Write Reset Busy: Active-High indicator that the FIFO
                                     // write domain is currently in a reset state.

      .din(din),                     // WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when
                                     // writing the FIFO.

      .injectdbiterr(1'b0), // 1-bit input: Double Bit Error Injection: Injects a double bit error if
                                     // the ECC feature is used on block RAMs or UltraRAM macros.

      .injectsbiterr(1'b0), // 1-bit input: Single Bit Error Injection: Injects a single bit error if
                                     // the ECC feature is used on block RAMs or UltraRAM macros.

      .rd_clk(rd_clk),               // 1-bit input: Read clock: Used for read operation. rd_clk must be a free
                                     // running clock.

      .rd_en(rd_en),                 // 1-bit input: Read Enable: If the FIFO is not empty, asserting this
                                     // signal causes data (on dout) to be read from the FIFO. Must be held
                                     // active-low when rd_rst_busy is active high. .

      .rst(rst),                     // 1-bit input: Reset: Must be synchronous to wr_clk. Must be applied only
                                     // when wr_clk is stable and free-running.

      .sleep(1'b0),                 // 1-bit input: Dynamic power saving: If sleep is High, the memory/fifo
                                     // block is in power saving mode.

      .wr_clk(wr_clk),               // 1-bit input: Write clock: Used for write operation. wr_clk must be a
                                     // free running clock.

      .wr_en(wr_en)                  // 1-bit input: Write Enable: If the FIFO is not full, asserting this
                                     // signal causes data (on din) to be written to the FIFO. Must be held
                                     // active-low when rst or wr_rst_busy is active high. .

   );



//----------------------------------------------------------------


endmodule
