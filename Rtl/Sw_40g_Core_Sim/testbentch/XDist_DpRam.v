/****************************************************************
*Company:  CETC54
*Engineer: liyuan

*Create Date   : Thursday, the 29 of August, 2019  11:30:11
*Design Name   :
*Module Name   : XDist_DpRam.v
*Project Name  :
*Target Devices: K7
*Tool versions : Vivado 2018
*Description   :  
*Revision:     : 1.0.0
*Revision 0.01 - File Created
*Additional Comments: 
*Modification Record :
*****************************************************************/
`define U_DLY                                    1
`define FF_RESET_EDGE                            negedge
`define RESET_TRIGGER_LVL                        1'b0

// synopsys translate_off
`timescale 1ns/1ns
// synopsys translate_on
module XDist_DpRam #(
  parameter DEPTH    = 1024,
  parameter ADDR_TOP = 10'd1023,
  parameter DEPTH_W  = 10,
  parameter WIDTH    = 2,
  parameter WIDTH_W  = 2
)(
   input                             auto_init   ,
   input  wire  [WIDTH_W - 1:0]      init_val    ,
   input                             rst_n       ,
   output reg                        init_done   ,

    input                             clk_a       ,
    input                             wren_a      ,
    input  wire  [DEPTH_W - 1:0]      addr_a      ,
    input  wire  [WIDTH_W - 1:0]      wrdata_a    ,
    output wire  [WIDTH_W - 1:0]      rddata_a    ,

    input                             clk_b       ,     
    input  wire  [DEPTH_W - 1:0]      addr_b      ,
    output wire  [WIDTH_W - 1:0]      rddata_b    

);

//--------------------------------------------------
//define signal
//--------------------------------------------------
wire                            wren_a_i    ;
wire    [DEPTH_W - 1 : 0]       addr_a_i    ;
wire    [WIDTH_W - 1 : 0]       wrdata_a_i  ;

wire                            conflict_b_tmp  ;
reg                             conflict_b  ;

reg                             init_en     ;
reg     [DEPTH_W - 1 : 0]       init_addr   ;

reg     [WIDTH_W - 1 : 0]       wrdata_a_dly1   ;
reg     [WIDTH_W - 1 : 0]       wrdata_a_dly2   ;
reg                             wren_a_dly1     ;
wire    [WIDTH_W - 1 : 0]       rddata_a_i  ;
wire    [WIDTH_W - 1 : 0]       rddata_b_i  ;
reg    [WIDTH_W - 1 : 0]       rddata_a_i_r;
reg    [WIDTH_W - 1 : 0]       rddata_b_i_r;
 ////--------------------------------------------------
//main code
//--------------------------------------------------
always @ (posedge clk_a or `FF_RESET_EDGE rst_n) begin
    if (rst_n == `RESET_TRIGGER_LVL) begin
        init_en <= #`U_DLY 1'b0;
    end
    else begin
        if (init_addr == ADDR_TOP) begin
            init_en <= #`U_DLY 1'b0;
        end
        else if (auto_init == 1'b1 && init_addr < ADDR_TOP) begin
            init_en <= #`U_DLY 1'b1;
        end
        else ;
    end
end

always @ (posedge clk_a or `FF_RESET_EDGE rst_n) begin
    if (rst_n == `RESET_TRIGGER_LVL) begin
        init_addr <= #`U_DLY {DEPTH_W{1'b0}};   
    end
    else begin
        if (init_en == 1'b1 && init_addr != ADDR_TOP) begin
            init_addr <= #`U_DLY init_addr + 1'b1;
        end
        else ;
    end
end

always  @(posedge clk_a or `FF_RESET_EDGE rst_n) begin
    if (rst_n == `RESET_TRIGGER_LVL) begin
        init_done <= #`U_DLY 1'b0;
    end
    else begin
        if (init_en == 1'b1 && init_addr == ADDR_TOP) begin
            init_done <= #`U_DLY 1'b1;
        end
        else ;
    end
end
assign wren_a_i   = wren_a | init_en;
assign addr_a_i   = (init_en == 1'b1) ? init_addr : addr_a  ;
assign wrdata_a_i = (init_en == 1'b1) ? init_val  : wrdata_a;

always  @(posedge clk_a or `FF_RESET_EDGE rst_n) begin
    if (rst_n == `RESET_TRIGGER_LVL) begin
        wrdata_a_dly1 <= #`U_DLY {WIDTH_W{1'b0}};
        wren_a_dly1   <= #`U_DLY 1'b0;
    end
    else begin
        wrdata_a_dly1 <= #`U_DLY wrdata_a_i   ;
        wren_a_dly1   <= #`U_DLY wren_a_i   ;
    end
end

assign conflict_b_tmp = (wren_a_i == 1'b1 && addr_a_i == addr_b) ? 1'b1 : 1'b0;
always @ (posedge clk_b or `FF_RESET_EDGE rst_n) begin
    if (rst_n == `RESET_TRIGGER_LVL) begin
        conflict_b     <= #`U_DLY 1'b0;
    end 
    else begin
        conflict_b     <= #`U_DLY conflict_b_tmp;
    end
end

//////////////////////////////////////////////////////////////////////////////////////////////////
   function integer power2; 
   input integer value;
   
   integer i;
     
     begin
     	 power2 = 1;
     	  
       for(i=0; i<value; i=i+1) begin
         power2 = power2*2;	
       end	
     	
     end
   
  endfunction 
 
////////////////////////////////////////////////////////////////////////////////////////////////// 
  localparam BRAM_DEPTH  = power2(DEPTH_W);
  localparam MEMORY_SIZE = BRAM_DEPTH*WIDTH_W; 

  xpm_memory_dpdistram #(
      .ADDR_WIDTH_A(DEPTH_W),               // DECIMAL
      .ADDR_WIDTH_B(DEPTH_W),               // DECIMAL
      .BYTE_WRITE_WIDTH_A(WIDTH_W),        // DECIMAL
      .CLOCKING_MODE("common_clock"), // String
      .MEMORY_INIT_FILE("none"),      // String
      .MEMORY_INIT_PARAM("0"),        // String
      .MEMORY_OPTIMIZATION("true"),   // String
      .MEMORY_SIZE(MEMORY_SIZE),             // DECIMAL
      .MESSAGE_CONTROL(0),            // DECIMAL
      .READ_DATA_WIDTH_A(WIDTH_W),         // DECIMAL
      .READ_DATA_WIDTH_B(WIDTH_W),         // DECIMAL
      .READ_LATENCY_A(1),             // DECIMAL
      .READ_LATENCY_B(1),             // DECIMAL
      .READ_RESET_VALUE_A("0"),       // String
      .READ_RESET_VALUE_B("0"),       // String
      .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
      .USE_MEM_INIT(0),               // DECIMAL
      .WRITE_DATA_WIDTH_A(WIDTH_W)         // DECIMAL
   )
   xpm_memory_dpdistram_inst (
      .douta(rddata_a_i),   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
      .doutb(rddata_b_i),   // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
      .addra(addr_a_i),   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
      .addrb(addr_b),   // ADDR_WIDTH_B-bit input: Address for port B write and read operations.
      .clka(clk_a),     // 1-bit input: Clock signal for port A. Also clocks port B when parameter CLOCKING_MODE
                       // is "common_clock".

      .clkb(clk_b),     // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                       // "independent_clock". Unused when parameter CLOCKING_MODE is "common_clock".

      .dina(wrdata_a_i),     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
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

      .wea(wren_a_i)        // WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input data port dina. 1
                       // bit wide when word-wide writes are used. In byte-wide write configurations, each bit
                       // controls the writing one byte of dina to address addra. For example, to synchronously
                       // write only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be 4'b0010.

   );
//////////////////////////////////////////////////////////////////////////////////////////////////
//rddata_a_i_r
//rddata_b_i_r

 always@(posedge clk_a) begin
   rddata_a_i_r<= rddata_a_i;	
 end
 
 always@(posedge clk_b) begin
 	 rddata_b_i_r<= rddata_b_i;
 end

//////////////////////////////////////////////////////////////////////////////////////////////////

assign rddata_a = (wren_a_dly1 == 1'b1) ? wrdata_a_dly1 : rddata_a_i;
assign rddata_b = (conflict_b == 1'b1) ? wrdata_a_dly1 : rddata_b_i;

///////////////////////////////////////////////////////////////////////////////////////////////////

endmodule
