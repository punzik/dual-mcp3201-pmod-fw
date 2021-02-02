`timescale 1ns/100ps
`default_nettype none

`define MULTICHANNEL_VERSION

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

`ifdef MULTICHANNEL_VERSION
    /* Multichannel and sample rate accurate version */

    localparam SPI_SCLK_FREQ = 1000000;

    mcp3201_ma #(.CHANNELS(2),
                 .CLOCK_FREQ(CLOCK_FREQ),
                 .SCLK_FREQ(SPI_SCLK_FREQ),
                 .SAMPLE_RATE(SAMPLE_RATE)) adcs
      (.clock, .reset,
       .spi_clk_o(radc_clk),
       .spi_ssn_o(radc_ssn),
       .spi_miso_i({ radc_dat, ladc_dat }),
       .data_o({ rdata, ldata }),
       .strb_o(rstrb));

    assign ladc_clk = radc_clk;
    assign ladc_ssn = radc_ssn;
    assign lstrb = rstrb;

`else
    /* Single channel inaccurate version */

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
`endif

endmodule // dual_mcp3201_pmod
