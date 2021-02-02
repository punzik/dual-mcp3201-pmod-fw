`timescale 1ns/100ps
`default_nettype none

module spi_sclk_gen #(parameter CLOCK_FREQ = 12000000,
                      parameter SCLK_FREQ = 50000)
    (input wire clock,
     input wire reset,
     output reg sclk_o);

    localparam SCLK_PERIOD = integer'($floor(real'(CLOCK_FREQ)/real'(SCLK_FREQ) + 0.5));
    localparam SCLK_HPER = SCLK_PERIOD/2;
    localparam SCLK_CW = $clog2(SCLK_PERIOD);

    logic [SCLK_CW-1:0] sclk_cnt;

    always_ff @(posedge clock)
      if (reset) begin
          sclk_cnt <= '0;
          sclk_o <= 1'b0;
      end
      else begin
          if (sclk_cnt == '0)
            sclk_o <= 1'b0;
          else
            if (sclk_cnt == SCLK_CW'(SCLK_HPER))
              sclk_o <= 1'b1;

          if (sclk_cnt == SCLK_CW'(SCLK_PERIOD-1))
            sclk_cnt <= '0;
          else
            sclk_cnt <= sclk_cnt + 1'b1;
      end

endmodule // spi_sclk_gen
