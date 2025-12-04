// slice.sv
// One systolic array processing element (PE)
// y_out = y_prev + (x_delayed * w)

module slice #(
    parameter WIDTH = 8
)(
    input  wire                      clk,
    input  wire                      rst,      // synchronous reset (active high)
    input  wire signed [WIDTH-1:0]   x_in,     // input data X
    input  wire signed [WIDTH-1:0]   w,        // weight (stationary in this PE)
    input  wire signed [WIDTH-1:0]   y_prev,   // partial sum from neighbor

    output wire signed [WIDTH-1:0]   x_out,    // X passed to next PE
    output wire signed [WIDTH-1:0]   y_out     // partial sum output
);

    // Internal registers to create one pipeline stage
    reg signed [WIDTH-1:0] x_reg;
    reg signed [WIDTH-1:0] y_reg;

    // Connect regs to outputs
    assign x_out = x_reg;
    assign y_out = y_reg;

    always @(posedge clk) begin
        if (rst) begin
            x_reg <= '0;
            y_reg <= '0;
        end else begin
            // Move x forward one stage
            x_reg <= x_in;

            // Accumulate using *previous* x_reg (non-blocking semantics)
            // This creates the systolic pipeline behavior
            y_reg <= y_prev + (x_reg * w);
        end
    end

endmodule
