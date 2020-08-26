// Serial-Parallel converter for TERO-based TRNG
// 2019-10-24 Naoki F., AIT
// New BSD License is applied. See COPYING file for details.

module seripara (CLK, RST, MODE, UART_READY, DIN, WE, DOUT, OE);
    input             CLK, RST;
    input       [1:0] MODE;
    input             UART_READY;
    input       [7:0] DIN;
    input             WE;
    output reg [31:0] DOUT;
    output reg        OE;

    reg           out_mode;
    reg           sat;
    wire          sat_new;
    reg    [19:0] sum;
    reg    [27:0] ssum;
    wire   [19:0] sum_new;
    wire   [27:0] ssum_new;
    wire    [7:0] data_new;
    reg     [6:0] data_reg;
    reg    [11:0] cnt;

    assign sat_new  = sat || (DIN == 8'hff);
    assign sum_new  = sum  + DIN;
    assign ssum_new = ssum + DIN * DIN;
    assign data_new = {data_reg, DIN[0]};

    always @(*) begin
        if (~MODE[0]) begin
            if (out_mode) begin
                DOUT = {4'h0, ssum};
                OE   = UART_READY;
            end else begin
                DOUT = {sat, 11'h000, sum};
                OE   = (cnt == 12'hfff && WE);
            end
        end else if (MODE[1]) begin
            DOUT = {24'h0, data_new};
            OE   = (cnt[2:0] == 3'd7 && WE);
        end else begin
            DOUT = {24'h0, DIN};
            OE   = WE;
        end
    end

    always @(posedge CLK) begin
        if (RST) begin
            out_mode <= 1'b0;
            sat      <= 1'b0;
            sum      <= 0;
            ssum     <= 0;
            data_reg <= 7'h00;
            cnt      <= 12'h000;
        end else begin
            if (~out_mode & WE) begin
                out_mode <= (~MODE[0] && cnt == 12'hfff);
                sat      <= sat_new;
                sum      <= sum_new;
                ssum     <= ssum_new;
                if (MODE != 2'b11 || DIN != 8'hff) begin
                    data_reg <= data_new;
                    cnt      <= cnt + 1'b1;
                end
            end else if (out_mode & UART_READY) begin
                sat      <= 1'b0;
                sum      <= 0;
                ssum     <= 0;
                out_mode <= 1'b0;
            end
        end
    end
endmodule