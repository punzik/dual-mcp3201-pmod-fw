`timescale 1ns/100ps
`default_nettype none

module dual_mcp3201_pmod #(parameter CLOCK_FREQ = 25000000,
             parameter SAMPLE_RATE = 50000)
    (input wire clock,
     input wire reset,

     output wire radc_ssn,
     output wire radc_clk,
     input wire  radc_dat,

     output wire ladc_ssn,
     output wire ladc_clk,
     input wire  ladc_dat,

     output wire [11:0] rdata,
     output wire        rstrb,
     output wire [11:0] ldata,
     output wire        lstrb);

    localparam MCP3201_CLOCK_PER_SAMPLE = 17;
    localparam SCLK_FREQ = SAMPLE_RATE * MCP3201_CLOCK_PER_SAMPLE;

    logic spi_clk;

    spi_sclk_gen #(.CLOCK_FREQ(CLOCK_FREQ),
                   .SCLK_FREQ(SCLK_FREQ)) spi_sclk_gen_impl
      (.clock, .reset,
       .sclk_o(spi_clk));

    mcp3201 adc_left
      (.clock, .reset,
       .spi_clk_i(spi_clk),
       .spi_ssn_o(ladc_ssn),
       .spi_miso_i(ladc_dat),
       .data_o(ldata),
       .strb_o(lstrb));

    mcp3201 adc_right
      (.clock, .reset,
       .spi_clk_i(spi_clk),
       .spi_ssn_o(radc_ssn),
       .spi_miso_i(radc_dat),
       .data_o(rdata),
       .strb_o(rstrb));

    assign ladc_clk = spi_clk;
    assign radc_clk = spi_clk;

endmodule // dual_mcp3201_pmod
