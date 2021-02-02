`timescale 1ns/100ps
`default_nettype none

/*
 * MCP3201 controller
 * Make one sample per 17 clock periods.
 */

module mcp3201
  (input wire clock,
   input wire reset,

   input wire spi_clk_i,
   output reg spi_ssn_o,
   input wire spi_miso_i,

   output reg [11:0] data_o,
   output reg strb_o);

    logic sclk_posedge;
    logic sclk_prev;

    always_ff @(posedge clock)
      if (reset) sclk_prev <= 1'b0;
      else       sclk_prev <= spi_clk_i;

    assign sclk_posedge = { sclk_prev, spi_clk_i } == 2'b01 ? 1'b1 : 1'b0;

    /* Receive data FSM */
    enum int unsigned {
        ST_RELAX = 0,
        ST_SHIFT,
        ST_STROBE
    } state;

    logic [3:0] bit_cnt;
    logic [11:0] data_sr;

    always_ff @(posedge clock)
      if (reset) begin
          state     <= ST_RELAX;
          bit_cnt   <= '0;
          spi_ssn_o <= 1'b1;
          data_o    <= '0;
          strb_o    <= 1'b0;
      end
      else begin
          strb_o <= 1'b0;

          case (state)
            ST_RELAX:
              if (sclk_posedge) begin
                  bit_cnt   <= '0;
                  spi_ssn_o <= 1'b0;
                  state     <= ST_SHIFT;
              end

            ST_SHIFT:
              if (sclk_posedge) begin
                  data_sr <= { data_sr[10:0], spi_miso_i };
                  bit_cnt <= bit_cnt + 1'b1;

                  if (bit_cnt == 4'd14) begin
                      spi_ssn_o <= 1'b1;
                      state <= ST_STROBE;
                  end
              end

            ST_STROBE: begin
                data_o <= data_sr;
                strb_o <= 1'b1;
                state  <= ST_RELAX;
            end
          endcase
      end

endmodule // mcp3201
