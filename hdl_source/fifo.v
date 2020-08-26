// FIFO module (generic)
// 2020-03-12 Naoki F., AIT
// New BSD License is applied. See COPYING file for details.

module fifo #(
    parameter WIDTH = 8,
    parameter SIZE  = 2048,
    parameter LOG_SIZE = 11)
    (
    input  wire              CLK, RST,
    input  wire  [WIDTH-1:0] DATA_W,
    output wire  [WIDTH-1:0] DATA_R,
    input  wire              WE, RE,
    output reg               EMPTY, FULL,
    input  wire              SOFT_RST);

    reg     [WIDTH-1:0] fifo_ram [0:SIZE-1];
    reg     [WIDTH-1:0] ram_out, d_data_w;
    reg                 ram_select;
    wire                write_valid, read_valid;
    reg  [LOG_SIZE-1:0] head, tail;
    wire [LOG_SIZE-1:0] n_head, n_tail;
    reg                 near_empty, near_full;
    wire                n_empty, n_near_empty;
    wire                n_full , n_near_full;

    // RAM: handling special case of n_head == tail
    assign DATA_R     = (ram_select) ? ram_out : d_data_w;
    
    always @ (posedge CLK) begin
        if (write_valid) begin
            ram_select <= (n_head != tail);
            d_data_w   <= DATA_W;
        end else begin
            ram_select <= 1'b1;
        end
    end

    always @ (posedge CLK) begin
        ram_out <= fifo_ram[n_head];
        if (write_valid) begin
            fifo_ram[tail] <= DATA_W;
        end
    end

    // combinatorial logic for read/write control
    assign read_valid   = RE & ~EMPTY;
    assign write_valid  = WE & ~FULL;
    assign n_head       = (read_valid)  ? head + 1'b1 : head;
    assign n_tail       = (write_valid) ? tail + 1'b1 : tail;
    assign n_empty      = ~ write_valid & (EMPTY | (read_valid & near_empty));
    assign n_full       = ~ read_valid  & (FULL  | (write_valid & near_full));
    assign n_near_empty = (n_head + 1'b1 == n_tail);
    assign n_near_full  = (n_head == n_tail + 1'b1);

    // register update
    always @ (posedge CLK) begin
        if (RST) begin
            head       <= 0;
            tail       <= 0;
            EMPTY      <= 1'b1;
            FULL       <= 1'b0;
            near_empty <= 1'b0;
            near_full  <= 1'b0;
        end else if (SOFT_RST) begin
            head       <= 0;
            tail       <= 0;
            EMPTY      <= 1'b1;
            FULL       <= 1'b0;
            near_empty <= 1'b0;
            near_full  <= 1'b0;
        end else begin
            head       <= n_head;
            tail       <= n_tail;
            EMPTY      <= n_empty;
            FULL       <= n_full;
            near_empty <= n_near_empty;
            near_full  <= n_near_full;
        end
    end
endmodule
