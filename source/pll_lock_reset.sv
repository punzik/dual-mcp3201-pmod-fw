`timescale 1ns/100ps
`default_nettype none

module pll_lock_reset #(parameter RESET_LEN = 8)
  (input wire pll_clock,
   input wire pll_lock,
   output wire reset);

    logic [RESET_LEN:0] rst_sr;

    always_ff @(posedge pll_clock, negedge pll_lock)
      if (~pll_lock) rst_sr <= '0;
      else           rst_sr <= { 1'b1, rst_sr[RESET_LEN:1] };

    assign reset = ~rst_sr[0];

endmodule // pll_lock_reset
