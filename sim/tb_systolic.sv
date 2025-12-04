// tb_systolic.sv
`timescale 1ns/1ps

module tb_systolic;

    localparam WIDTH = 8;

    reg                      clk;
    reg                      rst;
    reg  signed [WIDTH-1:0]  x_in;
    reg  signed [WIDTH-1:0]  y_prev_0;
    wire signed [WIDTH-1:0]  y_out_2;

    // DUT
    systolic_top #(.WIDTH(WIDTH)) dut (
        .clk       (clk),
        .rst       (rst),
        .x_in      (x_in),
        .y_prev_0  (y_prev_0),
        .y_out_2   (y_out_2)
    );

    // 10 ns period clock
    always #5 clk = ~clk;

    // Simple monitor to see behavior every posedge
	 always @(posedge clk) begin
		  if (!rst) begin
			   $display("t=%0t  x_in=%0d  y_prev_0=%0d  y_out_2=%0d",
					  	  $time, x_in, y_prev_0, y_out_2);
		  end
	 end



	initial begin
		 clk       = 0;
		 rst       = 1;
		 x_in      = 0;
		 y_prev_0  = 0;

		 // ===== Global reset at start =====
		 repeat (3) @(posedge clk);
		 rst = 0;

		 // ======================
		 // Case 1: y_prev_0 = 0
		 // ======================
		 $display("\n=== Case 1: y_prev_0 = 0 ===");
		 y_prev_0 = 0;

		 // x: 1,2,3,0  (same as Python)
		 x_in = 8'sd1; @(posedge clk);
		 x_in = 8'sd2; @(posedge clk);
		 x_in = 8'sd3; @(posedge clk);
		 x_in = 8'sd0; @(posedge clk);

		 // 4 flush cycles (x=0)
		 x_in = 0;
		 repeat (4) @(posedge clk);

		 // ======================
		 // Reset between cases
		 // ======================
		 $display("\n--- Resetting before Case 2 ---");
		 rst      = 1;
		 x_in     = 0;
		 y_prev_0 = 0;
		 repeat (2) @(posedge clk);
		 rst = 0;

		 // ===========================
		 // Case 2: y_prev_0 = 5
		 // ===========================
		 $display("\n=== Case 2: y_prev_0 = 5 ===");
		 y_prev_0 = 8'sd5;

		 // x: 1,2,3,0  (same as Python)
		 x_in = 8'sd1; @(posedge clk);
		 x_in = 8'sd2; @(posedge clk);
		 x_in = 8'sd3; @(posedge clk);
		 x_in = 8'sd0; @(posedge clk);

		 // 4 flush cycles again
		 x_in = 0;
		 repeat (4) @(posedge clk);

		 // ======================
		 // Reset between cases
		 $display("\n--- Resetting before Case 3 ---");
		 rst      = 1;
		 x_in     = 0;
		 y_prev_0 = 0;
		 repeat (2) @(posedge clk);
		 rst = 0;


		 // ========================================
		 // Case 3: interleaving two input streams
		 // ========================================
		 $display("\n=== Case 3: interleaved streams ===");
		 y_prev_0 = 0;

		 // x: 10,20,11,21,12,22,0 (same as Python)
		 x_in = 8'sd10; @(posedge clk); // A1
		 x_in = 8'sd20; @(posedge clk); // B1
		 x_in = 8'sd11; @(posedge clk); // A2
		 x_in = 8'sd21; @(posedge clk); // B2
		 x_in = 8'sd12; @(posedge clk); // A3
		 x_in = 8'sd22; @(posedge clk); // B3
		 x_in = 8'sd0;  @(posedge clk); // stop feeding

		 // 6 flush cycles (x=0) – matches Python flush_cycles=6
		 x_in = 0;
		 repeat (6) @(posedge clk);

		 $display("\nSimulation finished.");
		 $finish;
	end



endmodule
