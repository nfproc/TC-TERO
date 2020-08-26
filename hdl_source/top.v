// Top module for evaluation of TERO-based TRNGs
// 2019-10-26 -> 2020-08-26 Naoki F., AIT
// New BSD License is applied. See COPYING file for details.

module tero_top (CLK, RST, MODE, SW, LED, TXD);
    input        CLK, RST;
    input  [1:0] MODE;
    input  [3:0] SW;
    output [7:0] LED;
    output       TXD;

    reg         op_mode, sel_mode;
    reg   [1:0] out_mode;
    reg         mode_d;
    reg   [2:0] state;
    reg  [19:0] cnt;
    reg   [2:0] sel_cnt;
    reg  [19:0] ro_sel;
    wire        ctr;
    wire  [7:0] tero_out;
    wire        tero_oe;
    wire [31:0] uart_data;
    wire        uart_we;
    wire        uart_ready, uart_empty, uart_full;
 
    localparam STATE_MODE   = 3'd0; // check the operation mode
    localparam STATE_WAIT   = 3'd1; // wait for ROSEL (M1)
    localparam STATE_START  = 3'd2; // start TERO oscillation
    localparam STATE_OSC    = 3'd3; // wair for end of TERO oscillation
    localparam STATE_DRAIN  = 3'd4; // wait for UART
    localparam STATE_NEXT   = 3'd5; // try next value of ROSEL (M0)
    localparam STATE_FINI   = 3'd6; // finish operation (M0)
  
    assign ctr       = (state == STATE_OSC);
    assign LED[7]    = (sel_cnt == 3'd3);
    assign LED[6]    = (sel_cnt == 3'd2);
    assign LED[5]    = (sel_cnt == 3'd1);
    assign LED[4]    = (sel_cnt == 3'd0);
    assign LED[3:0]  = (sel_cnt == 3'd0) ? ro_sel[ 3: 0] :
                       (sel_cnt == 3'd1) ? ro_sel[ 7: 4] :
                       (sel_cnt == 3'd2) ? ro_sel[11: 8] :
                       (sel_cnt == 3'd3) ? ro_sel[15:12] : ro_sel[19:16];
  
    (* RLOC_ORIGIN = "X8Y80" *)
    tero_rng      #(.TERO_UNIT(2'd2))
               RNG (.CLK_100M(CLK), .CTR(ctr), .RO_SEL(ro_sel), .OUT(tero_out), .OE(tero_oe));
    seripara   SP  (.CLK(CLK), .RST(RST), .MODE(out_mode), .UART_READY(uart_ready),
                    .DIN(tero_out), .WE(tero_oe), .DOUT(uart_data), .OE(uart_we));
    uartsender UART(.CLK(CLK), .RST(RST), .DATA(uart_data), .WE(uart_we),
                    .MODE(op_mode), .TXD(TXD), .READY(uart_ready), 
                    .EMPTY(uart_empty), .FULL(uart_full));
  
    always @(posedge CLK) begin
        if (RST) begin
            op_mode   <= 1'b0;
            out_mode  <= 2'b00;
            sel_mode  <= 1'b0;
            mode_d    <= 1'b0;
            state     <= STATE_MODE;
            cnt       <= 20'h00000;
            sel_cnt   <= 3'd0;
            ro_sel    <= 20'h00000;
        end else begin
            if (state == STATE_MODE) begin
                op_mode   <= MODE[0]; // 0 - all parameters, 1 - fixed parameters
                out_mode  <= MODE;    // x0 - average and variable, 01 - counter, 11 - LSB
                sel_mode  <= MODE[1]; // 0 - RO_SEL is 20 bits, 1 - RO_SEL is 16 bits
                mode_d    <= MODE[0];
                sel_cnt   <= (MODE[0]) ? 3'd0 : (MODE[1]) ? 3'd3 : 3'd4;
                state     <= (MODE[0]) ? STATE_WAIT : STATE_START;
            end else if (state == STATE_WAIT) begin
                cnt      <= cnt + 1'b1;
                if (cnt == 20'hfffff) begin
                    mode_d   <= MODE[0];
                    if (MODE[0] & ~mode_d) begin
                        if (sel_cnt == 3'd0)
                            ro_sel[19:16] <= SW;
                        else if (sel_cnt == 3'd4)
                            ro_sel[15:12] <= SW;
                        else if (sel_cnt == 3'd3)
                            ro_sel[11: 8] <= SW;
                        else if (sel_cnt == 3'd2)
                            ro_sel[ 7: 4] <= SW;
                        else
                            ro_sel[ 3: 0] <= SW;
                        sel_cnt  <= (sel_cnt != 3'd0) ? sel_cnt - 1'b1 : 3'd4;
                        state    <= (sel_cnt != 3'd1) ? STATE_WAIT     : STATE_START;
                    end
                end
            end else if (state == STATE_START) begin
                state    <= STATE_OSC;
            end else if (state == STATE_OSC) begin
                if (tero_oe) begin
                    state    <= (uart_full)            ? STATE_DRAIN :
                                (op_mode == 1'b1)      ? STATE_START :
                                (cnt[11:0] == 12'hfff) ? STATE_NEXT  : STATE_START;
                    if (cnt == 20'hfffff && op_mode == 1'd1) begin
                        sel_cnt  <= (sel_cnt != 3'd0) ? sel_cnt - 1'b1 : 3'd4;
                    end
                    cnt      <= cnt + 1'b1;
                end
            end else if (state == STATE_DRAIN) begin
                if (uart_empty) begin
                    state    <= (op_mode == 1'b1)      ? STATE_START :
                                (cnt[11:0] == 12'h000) ? STATE_NEXT  : STATE_START;
                end
            end else if (state == STATE_NEXT) begin
                if (uart_ready) begin
                    ro_sel   <= ro_sel + 1'b1;
                    state    <= (ro_sel == ((sel_mode) ? 16'hffff : 20'hfffff)) ? STATE_FINI : STATE_START;
                end
            end
        end
    end    
endmodule