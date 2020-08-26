// UART data sender (simplified)
// 2020-08-26 Naoki F., AIT
// New BSD License is applied. See COPYING file for details.

module uartsender (
    input wire        CLK, RST,
    input wire [31:0] DATA,
    input wire        WE, MODE,
    output wire       TXD, READY,
    output wire       EMPTY, FULL);

    // decode from 0-9, 10-15 to '0'-'9', 'a'-'f'
    function [7:0] px;
        input [3:0] hex;
        px = hex + ((hex >= 4'd10) ? 8'd87 : 8'd48);
    endfunction

    wire [63:0]       data_in;
    wire  [7:0]       valid_in;
    reg  [63:0]       data_reg;
    reg   [7:0]       valid_reg;

    wire  [7:0]       fifo_data_w, fifo_data_r;
    wire              fifo_we, fifo_re;
    wire              ser_busy;

    assign READY       = ~ (|valid_reg);
    assign data_in     = (MODE) ? {56'h0, DATA[7:0]} :
                         {px(DATA[ 3: 0]), px(DATA[ 7: 4]), px(DATA[11: 8]), 
                          px(DATA[15:12]), px(DATA[19:16]), px(DATA[23:20]), 
                          px(DATA[27:24]), px(DATA[31:28])};
    assign valid_in    = (MODE) ? 8'b00000001 : 8'b11111111;
    assign fifo_data_w = data_reg[7:0];
    assign fifo_we     = valid_reg[0];
    assign fifo_re     = ~ EMPTY & ~ ser_busy;

    fifo #(.WIDTH(8), .SIZE(4096), .LOG_SIZE(12)) send_fifo (
        .CLK(CLK), .RST(RST), .DATA_W(fifo_data_w), .DATA_R(fifo_data_r),
        .WE(fifo_we), .RE(fifo_re), .EMPTY(EMPTY), .FULL(FULL),
        .SOFT_RST(1'b0));
    
    serial_send tx (
        .CLK(CLK), .RST(RST), .DATA_IN(fifo_data_r), .WE(fifo_re),
        .DATA_OUT(TXD), .BUSY(ser_busy));

    always @ (posedge CLK) begin
        if (RST) begin
            data_reg  <= 64'h0000000000000000;
            valid_reg <= 8'h00;
        end else if (READY) begin
            if (WE) begin
                data_reg  <= data_in;
                valid_reg <= valid_in;
            end
        end else begin
            if (~ FULL) begin
                data_reg  <= {8'h00, data_reg[63:8]};
                valid_reg <= {1'b0, valid_reg[7:1]};
            end
        end
    end
endmodule

///////////////////////////////////////////////////////////////////////
module serial_send (
    input  wire       CLK, RST,
    input  wire [7:0] DATA_IN,
    input  wire       WE,
    output wire       DATA_OUT,
    output reg        BUSY);

    localparam WAIT_DIV = 33; // 100 MHz / 3 Mbps
    localparam WAIT_LEN = 6;

    localparam STATE_IDLE = 1'b0;
    localparam STATE_SEND = 1'b1;
    reg                state, n_state;
    reg          [9:0] data_reg, n_data_reg;
    reg [WAIT_LEN-1:0] wait_cnt, n_wait_cnt;
    reg          [3:0] bit_cnt, n_bit_cnt;

    assign DATA_OUT = data_reg[0];

    always @* begin
        BUSY       = 1'b0;
        n_state    = state;
        n_wait_cnt = wait_cnt;
        n_bit_cnt  = bit_cnt;
        n_data_reg = data_reg;
        if (state == STATE_IDLE) begin
            if (WE) begin
                n_state    = STATE_SEND;
                n_data_reg = {1'b1, DATA_IN, 1'b0};
            end
        end else if (state == STATE_SEND) begin
            BUSY       = 1'b1;
            if (wait_cnt == WAIT_DIV - 1) begin
                if (bit_cnt == 4'd9) begin
                    n_state    = STATE_IDLE;
                    n_wait_cnt = 0;
                    n_bit_cnt  = 4'd0;
                end else begin
                    n_data_reg = {1'b1, data_reg[9:1]};
                    n_wait_cnt = 0;
                    n_bit_cnt  = bit_cnt + 1'b1;
                end
            end else begin
                n_wait_cnt = wait_cnt + 1'b1;
            end
        end
    end

    always @ (posedge CLK) begin
        if (RST) begin
            state    <= STATE_IDLE;
            wait_cnt <= 0;
            bit_cnt  <= 4'd0;
            data_reg <= 10'h3ff;
        end else begin
            state    <= n_state;
            wait_cnt <= n_wait_cnt;
            bit_cnt  <= n_bit_cnt;
            data_reg <= n_data_reg;
        end
    end
endmodule