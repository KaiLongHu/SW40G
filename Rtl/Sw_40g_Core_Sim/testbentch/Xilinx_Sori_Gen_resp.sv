
`timescale 1ps/1ps

module Xilinx_Sori_Gen_resp (
        input             log_clk,
        input             log_rst,

        input      [15:0] deviceid,
        input      [15:0] source_id,
        input             id_override,

        output reg        val_tresp_tvalid,
        input             val_tresp_tready,
        output reg        val_tresp_tlast,
        output reg [63:0] val_tresp_tdata,
        output      [7:0] val_tresp_tkeep,
        output     [31:0] val_tresp_tuser,

        input             val_treq_tvalid,
        output reg        val_treq_tready,
        input             val_treq_tlast,
        input      [63:0] val_treq_tdata,
        input       [7:0] val_treq_tkeep,
        input      [31:0] val_treq_tuser
    );

    // {{{ local parameters -----------------

    localparam [3:0] NREAD  = 4'h2;
    localparam [3:0] NWRITE = 4'h5;
    localparam [3:0] SWRITE = 4'h6;
    localparam [3:0] DOORB  = 4'hA;
    localparam [3:0] MESSG  = 4'hB;
    localparam [3:0] RESP   = 4'hD;

    localparam [3:0] TNWR   = 4'h4;
    localparam [3:0] TNWR_R = 4'h5;
    localparam [3:0] TNRD   = 4'h4;

    localparam [3:0] TNDATA = 4'h0;
    localparam [3:0] MSGRSP = 4'h1;
    localparam [3:0] TWDATA = 4'h8;

    // }}} End local parameters -------------


    // {{{ wire declarations ----------------
    reg  [15:0] log_rst_shift;
    wire        log_rst_q = log_rst_shift[15];
    wire        log_rst_q0 = log_rst_shift[2];

    wire        treq_advance_condition  = val_treq_tready && val_treq_tvalid;
    wire        tresp_advance_condition = val_tresp_tready && val_tresp_tvalid;

    // request side
    wire [63:0] response_data_in_d;
    reg  [63:0] response_data_in;
    reg  [8:0]  response_wr_address;

    reg         generate_a_response;
    reg         first_beat;

    // data storage
    reg         capture_data;
    reg   [8:0] data_store_waddr;
    reg   [8:0] data_store_raddr;
    wire        data_store_wen;
    wire        data_store_ren;
    wire [63:0] data_store_dout;

    // incoming packet fields
    wire  [7:0] current_tid;
    wire  [3:0] current_ftype;
    wire  [3:0] current_ttype;
    wire  [7:0] current_size;
    wire  [1:0] current_prio;
    wire [33:0] current_addr;
    wire [15:0] current_srcid;
    
    wire [15:0] dest_id;
    wire [15:0] src_id;
    // outgoing packet fields
    wire  [7:0] response_tid;
    wire  [3:0] response_ftype;
    wire  [3:0] response_ttype;
    wire  [7:0] response_size;
    wire  [1:0] response_prio;
    wire [63:0] response_data_out_d;
    reg  [46:0] response_data_out; // upper 63:47 unused
    wire [8:0]  starting_read_addr;
    wire        pull_from_store;
    reg         pull_from_store_q;
    reg  [8:0]  response_rd_address;
    reg         addresses_differ;
    reg         out_of_packet;
    wire        rd_increment;
    reg         rd_increment_q, rd_increment_qq, rd_increment_qqq, rd_increment_qqqq;
    reg         before_first_beat;
    reg         first_packet_transfer;
    reg         first_packet_transfer_q;

    wire  [3:0] responding_ttype;
    wire [63:0] header_beat;
    wire  [4:0] number_of_data_beats;
    reg   [4:0] number_of_data_beats_q;
    reg   [5:0] current_beat_cnt;
    reg   [7:0] data_beat, data_beat_q;

    // }}} End wire declarations ------------


    // {{{ Common-use Signals ---------------

    // Simple Assignments
    assign val_tresp_tkeep  = 8'hFF;
    assign src_id           = id_override ? source_id : deviceid;
    assign val_tresp_tuser  = {src_id, dest_id};
    // End Simple Assignments

    //always @(posedge log_clk or posedge log_rst) begin
    always @(posedge log_clk)
    begin
        if (log_rst)
            log_rst_shift <= 16'hFFFF;
        else
            log_rst_shift <= {log_rst_shift[14:0], 1'b0};
    end

    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            number_of_data_beats_q   <= 5'h0;
            rd_increment_q           <= 1'b0;
            rd_increment_qq          <= 1'b0;
            rd_increment_qqq         <= 1'b0;
            rd_increment_qqqq        <= 1'b0;
        end
        else
        begin
            number_of_data_beats_q   <= number_of_data_beats;
            rd_increment_q           <= rd_increment;
            rd_increment_qq          <= rd_increment_q;
            rd_increment_qqq         <= rd_increment_qq;
            rd_increment_qqqq        <= rd_increment_qqq;
        end
    end
    // }}} End Common-use Signals -----------

    // {{{ Request Logic --------------------
    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            val_treq_tready     <= 1'b0;
            // buffer full condition
        end
        else if (((response_wr_address + 16'h1) == response_rd_address) ||   
                 ((response_wr_address + 16'h2) == response_rd_address))
        begin
            val_treq_tready     <= 1'b0;
        end
        else
        begin
            val_treq_tready     <= 1'b1;
        end
    end

    //   always @(posedge log_clk) begin
    //     val_treq_tready<=1'b1;
    //   end
    ///////////////////////////////////////////////////////////////////////////////////////////////
    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            first_beat <= 1'b1;
        end
        else if (treq_advance_condition && val_treq_tlast)
        begin
            first_beat <= 1'b1;
        end
        else if (treq_advance_condition)
        begin
            first_beat <= 1'b0;
        end
    end
    assign current_tid   = val_treq_tdata[63:56];
    assign current_ftype = val_treq_tdata[55:52];
    assign current_ttype = val_treq_tdata[51:48];
    assign current_size  = val_treq_tdata[43:36];

    assign current_prio  = val_treq_tdata[46:45] + 2'b01;
    // assign current_addr  = val_treq_tdata[33:0];
    assign current_addr  = {2'b0,val_treq_tdata[33:2]};//.fix
    assign current_srcid = val_treq_tuser[31:16];


    // collect incoming requests that require a response, queue them
    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            generate_a_response <= 1'b0;
        end
        else if (first_beat && treq_advance_condition)
        begin
            generate_a_response <= (current_ftype == NREAD) ||
                                (current_ftype == DOORB) ||
                                (current_ftype == MESSG) ||
                                ((current_ftype == NWRITE) && (current_ttype == TNWR_R));
        end
        else
        begin
            generate_a_response <= 1'b0;
        end
    end
    // }}} End Request Logic ----------------


    // {{{ Local Data Storage ---------------
    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            capture_data <= 1'b0;
        end
        else if (first_beat && treq_advance_condition && current_addr[23:16] == 8'h12)
        begin
            capture_data <= (current_ftype == SWRITE) || (current_ftype == NWRITE);
        end
        else if (treq_advance_condition && val_treq_tlast)
        begin
            capture_data <= 1'b0;
        end
    end

    assign data_store_wen = capture_data && treq_advance_condition;

    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            data_store_waddr <= 9'h0;
        end
        else if (first_beat && treq_advance_condition)
        begin
            data_store_waddr <= {1'b0, current_addr[10:3]};
        end
        else if (treq_advance_condition)
        begin
            data_store_waddr <= data_store_waddr + 1;
        end
    end

    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            data_store_raddr  <= 9'h0;
            pull_from_store_q <= 1'b0;
        end
        else if (pull_from_store && current_beat_cnt == 0 && !tresp_advance_condition &&
                 (rd_increment_qqq || first_packet_transfer))
        begin
            data_store_raddr  <= starting_read_addr;
            pull_from_store_q <= 1'b1;
        end
        else if ((pull_from_store_q && tresp_advance_condition) || first_packet_transfer_q || rd_increment_qqqq)
        begin
            data_store_raddr  <= data_store_raddr + 1;
            pull_from_store_q <= !(val_tresp_tlast && !rd_increment_qqqq);
        end
    end

    assign data_store_ren = val_tresp_tready || !val_tresp_tvalid;


    RAMB36SDP #(
                  .SIM_COLLISION_CHECK("NONE"),
                  .EN_ECC_READ("FALSE"),
                  .EN_ECC_WRITE("FALSE")
              )
              local_data_store (
                  .DI        (val_treq_tdata),
                  .DIP       (8'h0),
                  .RDADDR    (data_store_raddr),
                  .RDCLK     (log_clk),
                  .RDEN      (data_store_ren),
                  .REGCE     (1'b1),
                  .SSR       (log_rst_q0),
                  .WE        ({8{data_store_wen}}), //equal-->keep
                  .WRADDR    (data_store_waddr),
                  .WRCLK     (log_clk),
                  .WREN      (data_store_wen),

                  .DO        (data_store_dout),
                  .DOP       (),

                  .ECCPARITY (),
                  .SBITERR   (),
                  .DBITERR   ()
              );
    // }}} End Local Data Storage -----------


    // {{{ Request Queue --------------------
    assign response_data_in_d = {17'h0, current_srcid, current_addr[23:16] == 8'h12, current_addr[10:3],
                                 current_prio, current_tid, current_ftype, current_size};
    always @ (posedge log_clk)
    begin
        response_data_in <= response_data_in_d;
    end

    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            out_of_packet <= 1'b0;
        end
        else if (rd_increment)
        begin
            out_of_packet <= 1'b0;
        end
        else if (tresp_advance_condition && val_tresp_tlast)
        begin
            out_of_packet <= 1'b1;
        end
    end
    assign rd_increment  = ((tresp_advance_condition && val_tresp_tlast) || (out_of_packet)) &&
           (response_rd_address != response_wr_address) &&
           (response_rd_address + 1 != response_wr_address);
    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            response_wr_address <= 9'h0;
            response_rd_address <= 9'h0;
        end
        else
        begin
            if (generate_a_response)
                response_wr_address <= response_wr_address + 1;
            if (rd_increment)
                response_rd_address <= response_rd_address + 1;
        end
    end

    RAMB36SDP #(
                  .SIM_COLLISION_CHECK("NONE"),
                  .EN_ECC_READ("FALSE"),
                  .EN_ECC_WRITE("FALSE")
              )
              response_queue_inst (
                  .DI        (response_data_in),
                  .DIP       (8'h0),
                  .RDADDR    (response_rd_address),
                  .RDCLK     (log_clk),
                  .RDEN      (1'b1),
                  .REGCE     (1'b1),
                  .SSR       (log_rst_q0),
                  .WE        ({8{generate_a_response}}),
                  .WRADDR    (response_wr_address),
                  .WRCLK     (log_clk),
                  .WREN      (generate_a_response),

                  .DO        (response_data_out_d),
                  .DOP       (),

                  .ECCPARITY (),
                  .SBITERR   (),
                  .DBITERR   ()
              );

    always @ (posedge log_clk)
    begin
        response_data_out  <= response_data_out_d[46:0];
    end
    assign response_tid   = response_data_out[19:12];
    assign response_ftype = response_data_out[11:8];
    assign response_size  = response_data_out[7:0];
    assign response_prio  = response_data_out[21:20];
    assign dest_id        = response_data_out[46:31];
    assign starting_read_addr = {1'b0, response_data_out[29:22]};
    assign pull_from_store = response_data_out[30];

    assign header_beat = {response_tid, RESP, responding_ttype, 1'b0, response_prio, 45'h0};//..ori
    // }}} End of Request Queue -------------


    // {{{ Response Logic -------------------
    assign number_of_data_beats = current_beat_cnt == 0 ? response_size[7:3] : number_of_data_beats_q;

    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            current_beat_cnt <= 6'h0;
        end
        else if (tresp_advance_condition && val_tresp_tlast)
        begin
            current_beat_cnt <= 6'h0;
        end
        else if (tresp_advance_condition)
        begin
            current_beat_cnt <= current_beat_cnt + 1;
        end
    end

    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            val_tresp_tlast  <= 1'b0;
        end
        else if (responding_ttype == TNDATA || responding_ttype == MSGRSP)
        begin
            val_tresp_tlast  <= !(tresp_advance_condition && val_tresp_tlast);
        end
        else if (current_beat_cnt == {1'b0, number_of_data_beats} && tresp_advance_condition)
        begin
            val_tresp_tlast  <= !val_tresp_tlast;
        end
        else if (val_tresp_tready || !val_tresp_tvalid)
        begin
            val_tresp_tlast  <= 1'b0;
        end
    end

    assign responding_ttype = (response_ftype == NREAD) ? TWDATA : (response_ftype == MESSG) ? MSGRSP : TNDATA;
    
    always @(posedge log_clk)
    begin
        if (current_beat_cnt == 0 && !tresp_advance_condition)
        begin
            val_tresp_tdata  <= header_beat;
        end
        else if (pull_from_store || pull_from_store_q) //..
        begin
            if (tresp_advance_condition)
            begin
                // val_tresp_tdata  <= data_store_dout;
                val_tresp_tdata  <= 64'h5555_5555;//.fix
            end
        end
        else
        begin
            val_tresp_tdata  <= {8{data_beat}};
        end
    end
    always @*
    begin
        data_beat = data_beat_q;
        if (tresp_advance_condition && current_beat_cnt != 0)
        begin
            data_beat = data_beat_q + 1;
        end
    end
    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            data_beat_q <= 8'h00;
        end
        else
        begin
            data_beat_q <= data_beat;
        end
    end

    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            before_first_beat     <= 1'b1;
        end
        else if (addresses_differ)
        begin
            before_first_beat     <= 1'b0;
        end
    end
    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            addresses_differ     <= 1'b0;
        end
        else if (response_rd_address != response_wr_address)
        begin
            addresses_differ      <= 1'b1;
        end
    end
    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            first_packet_transfer <= 1'b0;
        end
        else if (before_first_beat && addresses_differ)
        begin
            first_packet_transfer <= 1'b1;
        end
        else
        begin
            first_packet_transfer <= 1'b0;
        end
    end
    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            first_packet_transfer_q <= 1'b0;
        end
        else
        begin
            first_packet_transfer_q <= first_packet_transfer;
        end
    end
    always @(posedge log_clk)
    begin
        if (log_rst_q)
        begin
            val_tresp_tvalid <= 1'b0;
        end
        else if (first_packet_transfer_q)
        begin
            val_tresp_tvalid <= 1'b1;
        end
        else if (rd_increment_qqqq)
        begin
            val_tresp_tvalid <= 1'b1;
        end
        else if (tresp_advance_condition && val_tresp_tlast)
        begin
            val_tresp_tvalid <= 1'b0;
        end
    end

    // }}} End Response Logic ---------------


endmodule


