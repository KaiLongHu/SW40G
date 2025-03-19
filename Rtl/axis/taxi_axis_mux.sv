// SPDX-License-Identifier: CERN-OHL-S-2.0
/*

Copyright (c) 2014-2025 FPGA Ninja, LLC

Authors:
- Alex Forencich

*/

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * AXI4-Stream multiplexer
 */
module taxi_axis_mux #
(
    // Number of AXI stream inputs
    parameter S_COUNT = 4
)
(
    input  wire logic                        clk,
    input  wire logic                        rst,


    /*
     * AXI4-Stream inputs (sinks)
     */
    taxi_axis_if.snk                         s_axis[S_COUNT],

    /*
     * AXI4-Stream output (source)
     */
    taxi_axis_if.src                         m_axis,

    /*
     * Control
     */
    input  wire logic                        enable,
    input  wire logic [$clog2(S_COUNT)-1:0]  select
);

// extract parameters
localparam DATA_W = s_axis.DATA_W;
localparam logic KEEP_EN = s_axis.KEEP_EN && m_axis.KEEP_EN;
localparam KEEP_W = s_axis.KEEP_W;
localparam logic STRB_EN = s_axis.STRB_EN && m_axis.STRB_EN;
localparam logic LAST_EN = s_axis.LAST_EN && m_axis.LAST_EN;
localparam logic ID_EN = s_axis.ID_EN && m_axis.ID_EN;
localparam ID_W = s_axis.ID_W;
localparam logic DEST_EN = s_axis.DEST_EN && m_axis.DEST_EN;
localparam DEST_W = s_axis.DEST_W;
localparam logic USER_EN = s_axis.USER_EN && m_axis.USER_EN;
localparam USER_W = s_axis.USER_W;

// check configuration
if (m_axis.DATA_W != DATA_W)
    $fatal(0, "Error: Interface DATA_W parameter mismatch (instance %m)");

if (KEEP_EN && m_axis.KEEP_W != KEEP_W)
    $fatal(0, "Error: Interface KEEP_W parameter mismatch (instance %m)");

parameter CL_S_COUNT = $clog2(S_COUNT);

reg [CL_S_COUNT-1:0] select_reg = 2'd0, select_next;
reg frame_reg = 1'b0, frame_next;

reg [S_COUNT-1:0] s_axis_tready_reg = 0, s_axis_tready_next;

// internal datapath
reg  [DATA_W-1:0]  m_axis_tdata_int;
reg  [KEEP_W-1:0]  m_axis_tkeep_int;
reg  [KEEP_W-1:0]  m_axis_tstrb_int;
reg                m_axis_tvalid_int;
reg                m_axis_tready_int_reg = 1'b0;
reg                m_axis_tlast_int;
reg  [ID_W-1:0]    m_axis_tid_int;
reg  [DEST_W-1:0]  m_axis_tdest_int;
reg  [USER_W-1:0]  m_axis_tuser_int;
wire               m_axis_tready_int_early;

// unpack interface array
wire [DATA_W-1:0]   s_axis_tdata[S_COUNT];
wire [KEEP_W-1:0]   s_axis_tkeep[S_COUNT];
wire [KEEP_W-1:0]   s_axis_tstrb[S_COUNT];
wire [S_COUNT-1:0]  s_axis_tvalid;
wire [S_COUNT-1:0]  s_axis_tready;
wire [S_COUNT-1:0]  s_axis_tlast;
wire [ID_W-1:0]     s_axis_tid[S_COUNT];
wire [DEST_W-1:0]   s_axis_tdest[S_COUNT];
wire [USER_W-1:0]   s_axis_tuser[S_COUNT];

for (genvar n = 0; n < S_COUNT; n = n + 1) begin
    assign s_axis_tdata[n] = s_axis[n].tdata;
    assign s_axis_tkeep[n] = s_axis[n].tkeep;
    assign s_axis_tstrb[n] = s_axis[n].tstrb;
    assign s_axis_tvalid[n] = s_axis[n].tvalid;
    assign s_axis[n].tready = s_axis_tready[n];
    assign s_axis_tlast[n] = s_axis[n].tlast;
    assign s_axis_tid[n] = s_axis[n].tid;
    assign s_axis_tdest[n] = s_axis[n].tdest;
    assign s_axis_tuser[n] = s_axis[n].tuser;
end

assign s_axis_tready = s_axis_tready_reg;

// mux for incoming packet
wire [DATA_W-1:0]  current_s_tdata  = s_axis_tdata[select_reg];
wire [KEEP_W-1:0]  current_s_tkeep  = s_axis_tkeep[select_reg];
wire [KEEP_W-1:0]  current_s_tstrb  = s_axis_tstrb[select_reg];
wire               current_s_tvalid = s_axis_tvalid[select_reg];
wire               current_s_tready = s_axis_tready[select_reg];
wire               current_s_tlast  = s_axis_tlast[select_reg];
wire [ID_W-1:0]    current_s_tid    = s_axis_tid[select_reg];
wire [DEST_W-1:0]  current_s_tdest  = s_axis_tdest[select_reg];
wire [USER_W-1:0]  current_s_tuser  = s_axis_tuser[select_reg];

always_comb begin
    select_next = select_reg;
    frame_next = frame_reg;

    s_axis_tready_next = 0;

    if (current_s_tvalid & current_s_tready) begin
        // end of frame detection
        if (current_s_tlast) begin
            frame_next = 1'b0;
        end
    end

    if (!frame_reg && enable && s_axis_tvalid[select]) begin
        // start of frame, grab select value
        frame_next = 1'b1;
        select_next = select;
    end

    // generate ready signal on selected port
    s_axis_tready_next[select_next] = m_axis_tready_int_early && frame_next;

    // pass through selected packet data
    m_axis_tdata_int  = current_s_tdata;
    m_axis_tkeep_int  = current_s_tkeep;
    m_axis_tstrb_int  = current_s_tstrb;
    m_axis_tvalid_int = current_s_tvalid && current_s_tready && frame_reg;
    m_axis_tlast_int  = current_s_tlast;
    m_axis_tid_int    = current_s_tid;
    m_axis_tdest_int  = current_s_tdest;
    m_axis_tuser_int  = current_s_tuser;
end

always_ff @(posedge clk) begin
    select_reg <= select_next;
    frame_reg <= frame_next;
    s_axis_tready_reg <= s_axis_tready_next;

    if (rst) begin
        select_reg <= 0;
        frame_reg <= 1'b0;
        s_axis_tready_reg <= 0;
    end
end

// output datapath logic
reg [DATA_W-1:0]  m_axis_tdata_reg  = '0;
reg [KEEP_W-1:0]  m_axis_tkeep_reg  = '0;
reg [KEEP_W-1:0]  m_axis_tstrb_reg  = '0;
reg               m_axis_tvalid_reg = 1'b0, m_axis_tvalid_next;
reg               m_axis_tlast_reg  = 1'b0;
reg [ID_W-1:0]    m_axis_tid_reg    = '0;
reg [DEST_W-1:0]  m_axis_tdest_reg  = '0;
reg [USER_W-1:0]  m_axis_tuser_reg  = '0;

reg [DATA_W-1:0]  temp_m_axis_tdata_reg  = '0;
reg [KEEP_W-1:0]  temp_m_axis_tkeep_reg  = '0;
reg [KEEP_W-1:0]  temp_m_axis_tstrb_reg  = '0;
reg               temp_m_axis_tvalid_reg = 1'b0, temp_m_axis_tvalid_next;
reg               temp_m_axis_tlast_reg  = 1'b0;
reg [ID_W-1:0]    temp_m_axis_tid_reg    = '0;
reg [DEST_W-1:0]  temp_m_axis_tdest_reg  = '0;
reg [USER_W-1:0]  temp_m_axis_tuser_reg  = '0;

// datapath control
reg store_axis_int_to_output;
reg store_axis_int_to_temp;
reg store_axis_temp_to_output;

assign m_axis.tdata  = m_axis_tdata_reg;
assign m_axis.tkeep  = KEEP_EN ? m_axis_tkeep_reg : '1;
assign m_axis.tstrb  = STRB_EN ? m_axis_tstrb_reg : m_axis.tkeep;
assign m_axis.tvalid = m_axis_tvalid_reg;
assign m_axis.tlast  = m_axis_tlast_reg;
assign m_axis.tid    = ID_EN   ? m_axis_tid_reg   : '0;
assign m_axis.tdest  = DEST_EN ? m_axis_tdest_reg : '0;
assign m_axis.tuser  = USER_EN ? m_axis_tuser_reg : '0;

// enable ready input next cycle if output is ready or the temp reg will not be filled on the next cycle (output reg empty or no input)
assign m_axis_tready_int_early = m_axis.tready || (!temp_m_axis_tvalid_reg && (!m_axis_tvalid_reg || !m_axis_tvalid_int));

always_comb begin
    // transfer sink ready state to source
    m_axis_tvalid_next = m_axis_tvalid_reg;
    temp_m_axis_tvalid_next = temp_m_axis_tvalid_reg;

    store_axis_int_to_output = 1'b0;
    store_axis_int_to_temp = 1'b0;
    store_axis_temp_to_output = 1'b0;

    if (m_axis_tready_int_reg) begin
        // input is ready
        if (m_axis.tready || !m_axis_tvalid_reg) begin
            // output is ready or currently not valid, transfer data to output
            m_axis_tvalid_next = m_axis_tvalid_int;
            store_axis_int_to_output = 1'b1;
        end else begin
            // output is not ready, store input in temp
            temp_m_axis_tvalid_next = m_axis_tvalid_int;
            store_axis_int_to_temp = 1'b1;
        end
    end else if (m_axis.tready) begin
        // input is not ready, but output is ready
        m_axis_tvalid_next = temp_m_axis_tvalid_reg;
        temp_m_axis_tvalid_next = 1'b0;
        store_axis_temp_to_output = 1'b1;
    end
end

always_ff @(posedge clk) begin
    m_axis_tvalid_reg <= m_axis_tvalid_next;
    m_axis_tready_int_reg <= m_axis_tready_int_early;
    temp_m_axis_tvalid_reg <= temp_m_axis_tvalid_next;

    // datapath
    if (store_axis_int_to_output) begin
        m_axis_tdata_reg <= m_axis_tdata_int;
        m_axis_tkeep_reg <= m_axis_tkeep_int;
        m_axis_tstrb_reg <= m_axis_tstrb_int;
        m_axis_tlast_reg <= m_axis_tlast_int;
        m_axis_tid_reg   <= m_axis_tid_int;
        m_axis_tdest_reg <= m_axis_tdest_int;
        m_axis_tuser_reg <= m_axis_tuser_int;
    end else if (store_axis_temp_to_output) begin
        m_axis_tdata_reg <= temp_m_axis_tdata_reg;
        m_axis_tkeep_reg <= temp_m_axis_tkeep_reg;
        m_axis_tstrb_reg <= temp_m_axis_tstrb_reg;
        m_axis_tlast_reg <= temp_m_axis_tlast_reg;
        m_axis_tid_reg   <= temp_m_axis_tid_reg;
        m_axis_tdest_reg <= temp_m_axis_tdest_reg;
        m_axis_tuser_reg <= temp_m_axis_tuser_reg;
    end

    if (store_axis_int_to_temp) begin
        temp_m_axis_tdata_reg <= m_axis_tdata_int;
        temp_m_axis_tkeep_reg <= m_axis_tkeep_int;
        temp_m_axis_tstrb_reg <= m_axis_tstrb_int;
        temp_m_axis_tlast_reg <= m_axis_tlast_int;
        temp_m_axis_tid_reg   <= m_axis_tid_int;
        temp_m_axis_tdest_reg <= m_axis_tdest_int;
        temp_m_axis_tuser_reg <= m_axis_tuser_int;
    end

    if (rst) begin
        m_axis_tvalid_reg <= 1'b0;
        m_axis_tready_int_reg <= 1'b0;
        temp_m_axis_tvalid_reg <= 1'b0;
    end
end

endmodule

`resetall
