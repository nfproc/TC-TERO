// TERO-based TRNG (TERO ring and its controller)
// 2019-10-26 Naoki F., AIT
// New BSD License is applied. See COPYING file for details.

module tero_rng (CLK_100M, CTR, RO_SEL, OUT, OE);
    input             CLK_100M, CTR;
    input      [19:0] RO_SEL;
    output reg  [7:0] OUT;
    output reg        OE;

    parameter  [1:0] TERO_UNIT = 2'd0;

    wire       ctr_buf;
    wire       loop_out, loop_out_buf;
    wire       oeff_q;
    reg  [8:0] count;
    reg  [7:0] count_oe;
    reg        oeff_pre;

    // TERO loop
    generate if (TERO_UNIT == 2'd0) begin : TERO
        tero_loop LOOP (ctr_buf, loop_out);
    end else if (TERO_UNIT == 2'd1) begin : C_TERO
        c_tero_loop LOOP (ctr_buf, RO_SEL, loop_out);
    end else begin : TC_TERO
        tc_tero_loop LOOP (ctr_buf, RO_SEL, loop_out);
    end endgenerate

    // Input FF to Capture CTR
    (* U_SET = "rng", RLOC = "X0Y0" *)
    FD INFF (.Q(ctr_buf), .C(CLK_100M), .D(CTR));

    // Buffer to put the TERO output into a clock-dedicated route
    BUFR OUTBUF (.CE(1'b1), .CLR(1'b0), .I(loop_out), .O(loop_out_buf));

    // 9-bit Counter (driven by TERO output)
    always @(posedge loop_out_buf or negedge ctr_buf) begin
        if (~ctr_buf) begin
            count <= 9'h000;
        end else begin
            count <= count + 1'b1;
        end
    end

    // Output Register
    always @(posedge CLK_100M) begin
        if (count[8]) begin
            OUT <= 8'hff;
        end else begin
            OUT <= count[7:0];
        end
    end

    // Output Enable (detect the end of oscillation)
    (* U_SET = "rng", RLOC = "X1Y0" *)
    FDPE OEFF(.Q(oeff_q), .C(loop_out_buf), .CE(1'b1), .PRE(oeff_pre), .D(count[8]));

    // Output Enable Controller
    always @(posedge CLK_100M) begin
        if (~CTR) begin
            OE       <= 1'b0;
            count_oe <= 8'd0;
            oeff_pre <= 1'b1;
        end else begin
            OE       <= ((count_oe[1:0] == 2'd3 && oeff_q == 1'b1) || count_oe == 8'd199);
            count_oe <= count_oe + 1'b1;
            oeff_pre <= (count_oe[1:0] == 2'd3);
        end
    end    
endmodule
