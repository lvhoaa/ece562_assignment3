// systolic_top.sv
// Three-slice systolic array (W1-like variant)

module systolic_top #(
    parameter WIDTH = 8
)(
    input  wire                      clk,
    input  wire                      rst,
    input  wire signed [WIDTH-1:0]   x_in,      // stream of X values
    input  wire signed [WIDTH-1:0]   y_prev_0,  // initial partial sum to first PE

    output wire signed [WIDTH-1:0]   y_out_2    // final partial sum from last PE
);

    // Internal interconnect wires
    wire signed [WIDTH-1:0] x_0, x_1, x_2;
    wire signed [WIDTH-1:0] y_0, y_1, y_2;

    // Example constant weights per PE (adjust if you like)
    localparam signed [WIDTH-1:0] W0 = 8'sd2;
    localparam signed [WIDTH-1:0] W1 = 8'sd3;
    localparam signed [WIDTH-1:0] W2 = 8'sd4;

    // PE 0
    slice #(.WIDTH(WIDTH)) pe0 (
        .clk    (clk),
        .rst    (rst),
        .x_in   (x_in),
        .w      (W0),
        .y_prev (y_prev_0),

        .x_out  (x_0),
        .y_out  (y_0)
    );

    // PE 1
    slice #(.WIDTH(WIDTH)) pe1 (
        .clk    (clk),
        .rst    (rst),
        .x_in   (x_0),
        .w      (W1),
        .y_prev (y_0),

        .x_out  (x_1),
        .y_out  (y_1)
    );

    // PE 2
    slice #(.WIDTH(WIDTH)) pe2 (
        .clk    (clk),
        .rst    (rst),
        .x_in   (x_1),
        .w      (W2),
        .y_prev (y_1),

        .x_out  (x_2),
        .y_out  (y_2)
    );

    assign y_out_2 = y_2;

endmodule
