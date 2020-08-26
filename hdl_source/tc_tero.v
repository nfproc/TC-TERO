// Three-path configurable TERO (TC-TERO)
// 2019-10-24 Naoki F., AIT
// New BSD License is applied. See COPYING file for details.

module tc_tero_loop (CTR, RO_SEL, OUT);
    input        CTR;
    input [19:0] RO_SEL;
    output       OUT;
    
    (* ALLOW_COMBINATORIAL_LOOPS = "true", DONT_TOUCH = "true" *)
    wire [2:0] nand_o1, nand_o2;
    (* ALLOW_COMBINATORIAL_LOOPS = "true", DONT_TOUCH = "true" *)
    wire [2:0] buf_o11, buf_o12, buf_o13, buf_o14, buf_o15;
    (* ALLOW_COMBINATORIAL_LOOPS = "true", DONT_TOUCH = "true" *)
    wire [2:0] buf_o21, buf_o22, buf_o23;

    (* U_SET = "rng", RLOC = "X1Y0" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_OUT (.I0(nand_o1[0]), .I1(nand_o1[1]), .I2(nand_o1[2]),
                 .I3(RO_SEL[0]), .I4(RO_SEL[1]), .O(OUT));

    // Tiny and Configurable TERO Loop 
    (* U_SET = "rng", RLOC = "X0Y0", BEL = "A6LUT" *)
    LUT6 #(.INIT(64'h3333550fffffffff))
        NAND_1_D (.I0(buf_o23[0]), .I1(buf_o23[1]), .I2(buf_o23[2]), .I3(RO_SEL[18]), 
                  .I4(RO_SEL[19]), .I5(CTR), .O(nand_o1[0]));
    (* U_SET = "rng", RLOC = "X0Y0", BEL = "B6LUT" *)
    LUT6 #(.INIT(64'h3333550fffffffff))
        NAND_1_U (.I0(buf_o23[0]), .I1(buf_o23[1]), .I2(buf_o23[2]), .I3(RO_SEL[18]), 
                  .I4(RO_SEL[19]), .I5(CTR), .O(nand_o1[2]));
    (* U_SET = "rng", RLOC = "X0Y0" *)
    MUXF7 NAND_1_C (.O(nand_o1[1]), .I0(nand_o1[2]), .I1(nand_o1[0]), .S(RO_SEL[0]));

    (* U_SET = "rng", RLOC = "X0Y1", BEL = "A6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_1_1_D (.I0(nand_o1[0]), .I1(nand_o1[1]), .I2(nand_o1[2]),
                   .I3(RO_SEL[0]), .I4(RO_SEL[1]), .O(buf_o11[0]));
    (* U_SET = "rng", RLOC = "X0Y1", BEL = "B6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_1_1_U (.I0(nand_o1[0]), .I1(nand_o1[1]), .I2(nand_o1[2]),
                   .I3(RO_SEL[0]), .I4(RO_SEL[1]), .O(buf_o11[2]));
    (* U_SET = "rng", RLOC = "X0Y1" *)
    MUXF7 BUF_1_1_C (.O(buf_o11[1]), .I0(buf_o11[2]), .I1(buf_o11[0]), .S(RO_SEL[2]));

    (* U_SET = "rng", RLOC = "X0Y2", BEL = "A6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_1_2_D (.I0(buf_o11[0]), .I1(buf_o11[1]), .I2(buf_o11[2]),
                   .I3(RO_SEL[2]), .I4(RO_SEL[3]), .O(buf_o12[0]));
    (* U_SET = "rng", RLOC = "X0Y2", BEL = "B6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_1_2_U (.I0(buf_o11[0]), .I1(buf_o11[1]), .I2(buf_o11[2]),
                   .I3(RO_SEL[2]), .I4(RO_SEL[3]), .O(buf_o12[2]));
    (* U_SET = "rng", RLOC = "X0Y2" *)
    MUXF7 BUF_1_2_C (.O(buf_o12[1]), .I0(buf_o12[2]), .I1(buf_o12[0]), .S(RO_SEL[4]));

    (* U_SET = "rng", RLOC = "X0Y3", BEL = "A6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_1_3_D (.I0(buf_o12[0]), .I1(buf_o12[1]), .I2(buf_o12[2]),
                   .I3(RO_SEL[4]), .I4(RO_SEL[5]), .O(buf_o13[0]));
    (* U_SET = "rng", RLOC = "X0Y3", BEL = "B6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_1_3_U (.I0(buf_o12[0]), .I1(buf_o12[1]), .I2(buf_o12[2]),
                   .I3(RO_SEL[4]), .I4(RO_SEL[5]), .O(buf_o13[2]));
    (* U_SET = "rng", RLOC = "X0Y3" *)
    MUXF7 BUF_1_3_C (.O(buf_o13[1]), .I0(buf_o13[2]), .I1(buf_o13[0]), .S(RO_SEL[6]));

    (* U_SET = "rng", RLOC = "X0Y4", BEL = "A6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_1_4_D (.I0(buf_o13[0]), .I1(buf_o13[1]), .I2(buf_o13[2]),
                   .I3(RO_SEL[6]), .I4(RO_SEL[7]), .O(buf_o14[0]));
    (* U_SET = "rng", RLOC = "X0Y4", BEL = "B6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_1_4_U (.I0(buf_o13[0]), .I1(buf_o13[1]), .I2(buf_o13[2]),
                   .I3(RO_SEL[6]), .I4(RO_SEL[7]), .O(buf_o14[2]));
    (* U_SET = "rng", RLOC = "X0Y4" *)
    MUXF7 BUF_1_4_C (.O(buf_o14[1]), .I0(buf_o14[2]), .I1(buf_o14[0]), .S(RO_SEL[8]));

    (* U_SET = "rng", RLOC = "X0Y5", BEL = "A6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_1_5_D (.I0(buf_o14[0]), .I1(buf_o14[1]), .I2(buf_o14[2]),
                   .I3(RO_SEL[8]), .I4(RO_SEL[9]), .O(buf_o15[0]));
    (* U_SET = "rng", RLOC = "X0Y5", BEL = "B6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_1_5_U (.I0(buf_o14[0]), .I1(buf_o14[1]), .I2(buf_o14[2]),
                   .I3(RO_SEL[8]), .I4(RO_SEL[9]), .O(buf_o15[2]));
    (* U_SET = "rng", RLOC = "X0Y5" *)
    MUXF7 BUF_1_5_C (.O(buf_o15[1]), .I0(buf_o15[2]), .I1(buf_o15[0]), .S(RO_SEL[10]));

    (* U_SET = "rng", RLOC = "X0Y0", BEL = "C6LUT" *)
    LUT6 #(.INIT(64'h3333550fffffffff))
        NAND_2_D (.I0(buf_o15[0]), .I1(buf_o15[1]), .I2(buf_o15[2]), .I3(RO_SEL[10]), 
                  .I4(RO_SEL[11]), .I5(CTR), .O(nand_o2[0]));
    (* U_SET = "rng", RLOC = "X0Y0", BEL = "D6LUT" *)
    LUT6 #(.INIT(64'h3333550fffffffff))
        NAND_2_U (.I0(buf_o15[0]), .I1(buf_o15[1]), .I2(buf_o15[2]), .I3(RO_SEL[10]), 
                  .I4(RO_SEL[11]), .I5(CTR), .O(nand_o2[2]));
    (* U_SET = "rng", RLOC = "X0Y0" *)
    MUXF7 NAND_2_C (.O(nand_o2[1]), .I0(nand_o2[2]), .I1(nand_o2[0]), .S(RO_SEL[12]));
                
    (* U_SET = "rng", RLOC = "X0Y1", BEL = "C6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_2_1_D (.I0(nand_o2[0]), .I1(nand_o2[1]), .I2(nand_o2[2]),
                   .I3(RO_SEL[12]), .I4(RO_SEL[13]), .O(buf_o21[0]));
    (* U_SET = "rng", RLOC = "X0Y1", BEL = "D6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_2_1_U (.I0(nand_o2[0]), .I1(nand_o2[1]), .I2(nand_o2[2]),
                   .I3(RO_SEL[12]), .I4(RO_SEL[13]), .O(buf_o21[2]));
    (* U_SET = "rng", RLOC = "X0Y1" *)
    MUXF7 BUF_2_1_C (.O(buf_o21[1]), .I0(buf_o21[2]), .I1(buf_o21[0]), .S(RO_SEL[14]));

    (* U_SET = "rng", RLOC = "X0Y2", BEL = "C6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_2_2_D (.I0(buf_o21[0]), .I1(buf_o21[1]), .I2(buf_o21[2]),
                   .I3(RO_SEL[14]), .I4(RO_SEL[15]), .O(buf_o22[0]));
    (* U_SET = "rng", RLOC = "X0Y2", BEL = "D6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_2_2_U (.I0(buf_o21[0]), .I1(buf_o21[1]), .I2(buf_o21[2]),
                   .I3(RO_SEL[14]), .I4(RO_SEL[15]), .O(buf_o22[2]));
    (* U_SET = "rng", RLOC = "X0Y2" *)
    MUXF7 BUF_2_2_C (.O(buf_o22[1]), .I0(buf_o22[2]), .I1(buf_o22[0]), .S(RO_SEL[16]));

    (* U_SET = "rng", RLOC = "X0Y3", BEL = "C6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_2_3_D (.I0(buf_o22[0]), .I1(buf_o22[1]), .I2(buf_o22[2]),
                   .I3(RO_SEL[16]), .I4(RO_SEL[17]), .O(buf_o23[0]));
    (* U_SET = "rng", RLOC = "X0Y3", BEL = "D6LUT" *)
    LUT5 #(.INIT(32'hccccaaf0))
        BUF_2_3_U (.I0(buf_o22[0]), .I1(buf_o22[1]), .I2(buf_o22[2]),
                   .I3(RO_SEL[16]), .I4(RO_SEL[17]), .O(buf_o23[2]));
    (* U_SET = "rng", RLOC = "X0Y3" *)
    MUXF7 BUF_2_3_C (.O(buf_o23[1]), .I0(buf_o23[2]), .I1(buf_o23[0]), .S(RO_SEL[18]));

endmodule