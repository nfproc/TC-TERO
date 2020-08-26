// an implementation of configurable TERO (FPL 2019)
// 2019-10-24 Naoki F., AIT
// New BSD License is applied. See COPYING file for details.

module c_tero_loop (CTR, RO_SEL, OUT);
    input        CTR;
    input [19:0] RO_SEL;
    output       OUT;

    (* ALLOW_COMBINATORIAL_LOOPS = "true", DONT_TOUCH = "true" *)
    wire [3:0] nand_o1, nand_o2;
    (* ALLOW_COMBINATORIAL_LOOPS = "true", DONT_TOUCH = "true" *)
    wire [3:0] buf_o11, buf_o12, buf_o13, buf_o14, buf_o15;
    (* ALLOW_COMBINATORIAL_LOOPS = "true", DONT_TOUCH = "true" *)
    wire [3:0] buf_o21, buf_o22, buf_o23;

    (* U_SET = "rng", RLOC = "X1Y0" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_OUT (.I0(nand_o1[0]), .I1(nand_o1[1]), .I2(nand_o1[2]), .I3(nand_o1[3]), 
                 .I4(RO_SEL[0]), .I5(RO_SEL[1]), .O(OUT));

    // Configurable TERO Loop - Two NANDs and Buffers/multiplexers
    (* U_SET = "rng", RLOC = "X0Y0", BEL = "A6LUT" *)
    LUT2 #(.INIT(4'b0111)) NAND_1_0 (.O(nand_o1[0]), .I0(buf_o23[0]), .I1(CTR));
    (* U_SET = "rng", RLOC = "X0Y0", BEL = "B6LUT" *)
    LUT2 #(.INIT(4'b0111)) NAND_1_1 (.O(nand_o1[1]), .I0(buf_o23[1]), .I1(CTR));
    (* U_SET = "rng", RLOC = "X0Y0", BEL = "C6LUT" *)
    LUT2 #(.INIT(4'b0111)) NAND_1_2 (.O(nand_o1[2]), .I0(buf_o23[2]), .I1(CTR));
    (* U_SET = "rng", RLOC = "X0Y0", BEL = "D6LUT" *)
    LUT2 #(.INIT(4'b0111)) NAND_1_3 (.O(nand_o1[3]), .I0(buf_o23[2]), .I1(CTR));

    (* U_SET = "rng", RLOC = "X0Y1", BEL = "A6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_1_0 (.I0(nand_o1[0]), .I1(nand_o1[1]), .I2(nand_o1[2]), .I3(nand_o1[3]), 
                   .I4(RO_SEL[0]), .I5(RO_SEL[1]), .O(buf_o11[0]));
    (* U_SET = "rng", RLOC = "X0Y1", BEL = "B6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_1_1 (.I0(nand_o1[0]), .I1(nand_o1[1]), .I2(nand_o1[2]), .I3(nand_o1[3]), 
                   .I4(RO_SEL[0]), .I5(RO_SEL[1]), .O(buf_o11[1]));
    (* U_SET = "rng", RLOC = "X0Y1", BEL = "C6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_1_2 (.I0(nand_o1[0]), .I1(nand_o1[1]), .I2(nand_o1[2]), .I3(nand_o1[3]), 
                   .I4(RO_SEL[0]), .I5(RO_SEL[1]), .O(buf_o11[2]));
    (* U_SET = "rng", RLOC = "X0Y1", BEL = "D6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_1_3 (.I0(nand_o1[0]), .I1(nand_o1[1]), .I2(nand_o1[2]), .I3(nand_o1[3]), 
                   .I4(RO_SEL[0]), .I5(RO_SEL[1]), .O(buf_o11[3]));

    (* U_SET = "rng", RLOC = "X0Y2", BEL = "A6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_2_0 (.I0(buf_o11[0]), .I1(buf_o11[1]), .I2(buf_o11[2]), .I3(buf_o11[3]), 
                   .I4(RO_SEL[2]), .I5(RO_SEL[3]), .O(buf_o12[0]));
    (* U_SET = "rng", RLOC = "X0Y2", BEL = "B6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_2_1 (.I0(buf_o11[0]), .I1(buf_o11[1]), .I2(buf_o11[2]), .I3(buf_o11[3]), 
                   .I4(RO_SEL[2]), .I5(RO_SEL[3]), .O(buf_o12[1]));
    (* U_SET = "rng", RLOC = "X0Y2", BEL = "C6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_2_2 (.I0(buf_o11[0]), .I1(buf_o11[1]), .I2(buf_o11[2]), .I3(buf_o11[3]), 
                   .I4(RO_SEL[2]), .I5(RO_SEL[3]), .O(buf_o12[2]));
    (* U_SET = "rng", RLOC = "X0Y2", BEL = "D6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_2_3 (.I0(buf_o11[0]), .I1(buf_o11[1]), .I2(buf_o11[2]), .I3(buf_o11[3]), 
                   .I4(RO_SEL[2]), .I5(RO_SEL[3]), .O(buf_o12[3]));
                 
    (* U_SET = "rng", RLOC = "X0Y3", BEL = "A6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_3_0 (.I0(buf_o12[0]), .I1(buf_o12[1]), .I2(buf_o12[2]), .I3(buf_o12[3]), 
                   .I4(RO_SEL[4]), .I5(RO_SEL[5]), .O(buf_o13[0]));
    (* U_SET = "rng", RLOC = "X0Y3", BEL = "B6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_3_1 (.I0(buf_o12[0]), .I1(buf_o12[1]), .I2(buf_o12[2]), .I3(buf_o12[3]), 
                   .I4(RO_SEL[4]), .I5(RO_SEL[5]), .O(buf_o13[1]));
    (* U_SET = "rng", RLOC = "X0Y3", BEL = "C6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_3_2 (.I0(buf_o12[0]), .I1(buf_o12[1]), .I2(buf_o12[2]), .I3(buf_o12[3]), 
                   .I4(RO_SEL[4]), .I5(RO_SEL[5]), .O(buf_o13[2]));
    (* U_SET = "rng", RLOC = "X0Y3", BEL = "D6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_3_3 (.I0(buf_o12[0]), .I1(buf_o12[1]), .I2(buf_o12[2]), .I3(buf_o12[3]), 
                   .I4(RO_SEL[4]), .I5(RO_SEL[5]), .O(buf_o13[3]));

    (* U_SET = "rng", RLOC = "X0Y4", BEL = "A6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_4_0 (.I0(buf_o13[0]), .I1(buf_o13[1]), .I2(buf_o13[2]), .I3(buf_o13[3]), 
                   .I4(RO_SEL[6]), .I5(RO_SEL[7]), .O(buf_o14[0]));
    (* U_SET = "rng", RLOC = "X0Y4", BEL = "B6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_4_1 (.I0(buf_o13[0]), .I1(buf_o13[1]), .I2(buf_o13[2]), .I3(buf_o13[3]), 
                   .I4(RO_SEL[6]), .I5(RO_SEL[7]), .O(buf_o14[1]));
    (* U_SET = "rng", RLOC = "X0Y4", BEL = "C6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_4_2 (.I0(buf_o13[0]), .I1(buf_o13[1]), .I2(buf_o13[2]), .I3(buf_o13[3]), 
                   .I4(RO_SEL[6]), .I5(RO_SEL[7]), .O(buf_o14[2]));
    (* U_SET = "rng", RLOC = "X0Y4", BEL = "D6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_4_3 (.I0(buf_o13[0]), .I1(buf_o13[1]), .I2(buf_o13[2]), .I3(buf_o13[3]), 
                   .I4(RO_SEL[6]), .I5(RO_SEL[7]), .O(buf_o14[3]));

    (* U_SET = "rng", RLOC = "X0Y5", BEL = "A6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_5_0 (.I0(buf_o14[0]), .I1(buf_o14[1]), .I2(buf_o14[2]), .I3(buf_o14[3]), 
                   .I4(RO_SEL[8]), .I5(RO_SEL[9]), .O(buf_o15[0]));
    (* U_SET = "rng", RLOC = "X0Y5", BEL = "B6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_5_1 (.I0(buf_o14[0]), .I1(buf_o14[1]), .I2(buf_o14[2]), .I3(buf_o14[3]), 
                   .I4(RO_SEL[8]), .I5(RO_SEL[9]), .O(buf_o15[1]));
    (* U_SET = "rng", RLOC = "X0Y5", BEL = "C6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_5_2 (.I0(buf_o14[0]), .I1(buf_o14[1]), .I2(buf_o14[2]), .I3(buf_o14[3]), 
                   .I4(RO_SEL[8]), .I5(RO_SEL[9]), .O(buf_o15[2]));
    (* U_SET = "rng", RLOC = "X0Y5", BEL = "D6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_1_5_3 (.I0(buf_o14[0]), .I1(buf_o14[1]), .I2(buf_o14[2]), .I3(buf_o14[3]), 
                   .I4(RO_SEL[8]), .I5(RO_SEL[9]), .O(buf_o15[3]));

    (* U_SET = "rng", RLOC = "X1Y1", BEL = "A6LUT" *)
    LUT2 #(.INIT(4'b0111)) NAND_2_0 (.O(nand_o2[0]), .I0(buf_o15[0]), .I1(CTR));
    (* U_SET = "rng", RLOC = "X1Y1", BEL = "B6LUT" *)
    LUT2 #(.INIT(4'b0111)) NAND_2_1 (.O(nand_o2[1]), .I0(buf_o15[1]), .I1(CTR));
    (* U_SET = "rng", RLOC = "X1Y1", BEL = "C6LUT" *)
    LUT2 #(.INIT(4'b0111)) NAND_2_2 (.O(nand_o2[2]), .I0(buf_o15[2]), .I1(CTR));
    (* U_SET = "rng", RLOC = "X1Y1", BEL = "D6LUT" *)
    LUT2 #(.INIT(4'b0111)) NAND_2_3 (.O(nand_o2[3]), .I0(buf_o15[3]), .I1(CTR));

    (* U_SET = "rng", RLOC = "X1Y2", BEL = "A6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_2_1_0 (.I0(nand_o2[0]), .I1(nand_o2[1]), .I2(nand_o2[2]), .I3(nand_o2[3]), 
                   .I4(RO_SEL[10]), .I5(RO_SEL[11]), .O(buf_o21[0]));
    (* U_SET = "rng", RLOC = "X1Y2", BEL = "B6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_2_1_1 (.I0(nand_o2[0]), .I1(nand_o2[1]), .I2(nand_o2[2]), .I3(nand_o2[3]), 
                   .I4(RO_SEL[10]), .I5(RO_SEL[11]), .O(buf_o21[1]));
    (* U_SET = "rng", RLOC = "X1Y2", BEL = "C6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_2_1_2 (.I0(nand_o2[0]), .I1(nand_o2[1]), .I2(nand_o2[2]), .I3(nand_o2[3]), 
                   .I4(RO_SEL[10]), .I5(RO_SEL[11]), .O(buf_o21[2]));
    (* U_SET = "rng", RLOC = "X1Y2", BEL = "D6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_2_1_3 (.I0(nand_o2[0]), .I1(nand_o2[1]), .I2(nand_o2[2]), .I3(nand_o2[3]), 
                   .I4(RO_SEL[10]), .I5(RO_SEL[11]), .O(buf_o21[3]));

    (* U_SET = "rng", RLOC = "X1Y3", BEL = "A6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_2_2_0 (.I0(buf_o21[0]), .I1(buf_o21[1]), .I2(buf_o21[2]), .I3(buf_o21[3]), 
                   .I4(RO_SEL[12]), .I5(RO_SEL[13]), .O(buf_o22[0]));
    (* U_SET = "rng", RLOC = "X1Y3", BEL = "B6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_2_2_1 (.I0(buf_o21[0]), .I1(buf_o21[1]), .I2(buf_o21[2]), .I3(buf_o21[3]), 
                   .I4(RO_SEL[12]), .I5(RO_SEL[13]), .O(buf_o22[1]));
    (* U_SET = "rng", RLOC = "X1Y3", BEL = "C6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_2_2_2 (.I0(buf_o21[0]), .I1(buf_o21[1]), .I2(buf_o21[2]), .I3(buf_o21[3]), 
                   .I4(RO_SEL[12]), .I5(RO_SEL[13]), .O(buf_o22[2]));
    (* U_SET = "rng", RLOC = "X1Y3", BEL = "D6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_2_2_3 (.I0(buf_o21[0]), .I1(buf_o21[1]), .I2(buf_o21[2]), .I3(buf_o21[3]), 
                   .I4(RO_SEL[12]), .I5(RO_SEL[13]), .O(buf_o22[3]));
                 
    (* U_SET = "rng", RLOC = "X1Y4", BEL = "A6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_2_3_0 (.I0(buf_o22[0]), .I1(buf_o22[1]), .I2(buf_o22[2]), .I3(buf_o22[3]), 
                   .I4(RO_SEL[14]), .I5(RO_SEL[15]), .O(buf_o23[0]));
    (* U_SET = "rng", RLOC = "X1Y4", BEL = "B6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_2_3_1 (.I0(buf_o22[0]), .I1(buf_o22[1]), .I2(buf_o22[2]), .I3(buf_o22[3]), 
                   .I4(RO_SEL[14]), .I5(RO_SEL[15]), .O(buf_o23[1]));
    (* U_SET = "rng", RLOC = "X1Y4", BEL = "C6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_2_3_2 (.I0(buf_o22[0]), .I1(buf_o22[1]), .I2(buf_o22[2]), .I3(buf_o22[3]), 
                   .I4(RO_SEL[14]), .I5(RO_SEL[15]), .O(buf_o23[2]));
    (* U_SET = "rng", RLOC = "X1Y4", BEL = "D6LUT" *)
    LUT6 #(.INIT(64'hff00f0f0ccccaaaa))
        BUF_2_3_3 (.I0(buf_o22[0]), .I1(buf_o22[1]), .I2(buf_o22[2]), .I3(buf_o22[3]), 
                   .I4(RO_SEL[14]), .I5(RO_SEL[15]), .O(buf_o23[3]));

endmodule