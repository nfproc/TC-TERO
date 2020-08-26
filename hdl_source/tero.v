// An implementation of Transition Effect Ring Oscillator (TERO)
// 2019-10-24 Naoki F., AIT
// New BSD License is applied. See COPYING file for details.

module tero_loop (CTR, OUT);
    input        CTR;
    output       OUT;

    (* ALLOW_COMBINATORIAL_LOOPS = "true", DONT_TOUCH = "true" *)
    wire       nand_o1, nand_o2;
    (* ALLOW_COMBINATORIAL_LOOPS = "true", DONT_TOUCH = "true" *)
    wire [4:0] buf_o1;
    (* ALLOW_COMBINATORIAL_LOOPS = "true", DONT_TOUCH = "true" *)
    wire [2:0] buf_o2;

    assign OUT = nand_o1;

    // TERO Loop - Two NANDs and Buffers
    (* U_SET = "rng", RLOC = "X0Y0" *)
    LUT2 #(.INIT(4'b0111)) NAND_1 (.O(nand_o1), .I0(buf_o2[2]), .I1(CTR));
    (* U_SET = "rng", RLOC = "X0Y0" *)
    LUT2 #(.INIT(4'b0111)) NAND_2 (.O(nand_o2), .I0(buf_o1[4]), .I1(CTR));

    (* U_SET = "rng", RLOC = "X0Y1" *)
    LUT1 #(.INIT(2'b10)) BUF_1_0 (.O(buf_o1[0]), .I0(nand_o1));
    (* U_SET = "rng", RLOC = "X0Y2" *)
    LUT1 #(.INIT(2'b10)) BUF_1_1 (.O(buf_o1[1]), .I0(buf_o1[0]));
    (* U_SET = "rng", RLOC = "X0Y3" *)
    LUT1 #(.INIT(2'b10)) BUF_1_2 (.O(buf_o1[2]), .I0(buf_o1[1]));
    (* U_SET = "rng", RLOC = "X0Y4" *)
    LUT1 #(.INIT(2'b10)) BUF_1_3 (.O(buf_o1[3]), .I0(buf_o1[2]));
    (* U_SET = "rng", RLOC = "X0Y5" *)
    LUT1 #(.INIT(2'b10)) BUF_1_4 (.O(buf_o1[4]), .I0(buf_o1[3]));

    (* U_SET = "rng", RLOC = "X0Y1" *)
    LUT1 #(.INIT(2'b10)) BUF_2_0 (.O(buf_o2[0]), .I0(nand_o2));
    (* U_SET = "rng", RLOC = "X0Y2" *)
    LUT1 #(.INIT(2'b10)) BUF_2_1 (.O(buf_o2[1]), .I0(buf_o2[0]));
    (* U_SET = "rng", RLOC = "X0Y3" *)
    LUT1 #(.INIT(2'b10)) BUF_2_2 (.O(buf_o2[2]), .I0(buf_o2[1]));

endmodule