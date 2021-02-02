`timescale 1ns/100ps
`default_nettype none

/* verilator lint_off TIMESCALEMOD */

module cmod_a7
  (input wire GCLK_i,
   input wire [1:0] BTN_i,

   inout wire [3:0] PMOD0,
   inout wire [3:0] PMOD1);

    /* Clock and reset */
    logic clock;
    logic reset;
    logic pll_lock;

    main_pll main_pll_inst
      (.clk_12(GCLK_i),
       .reset(BTN_i[1]),
       .locked(pll_lock),
       .clk_50(clock));

    pll_lock_reset #(.RESET_LEN(16)) reset_gen_impl
      (.pll_clock(clock),
       .pll_lock(pll_lock & (~BTN_i[1])),
       .reset(reset));

    /* ADCs connection */
    logic [11:0] ldata, rdata;
    logic lstrb, rstrb;

    dual_mcp3201_pmod #(.CLOCK_FREQ(50000000),
                        .SAMPLE_RATE(50000)) brd
    (.clock, .reset,

     .ladc_ssn(PMOD0[0]),
     .ladc_clk(PMOD0[3]),
     .ladc_dat(PMOD0[2]),

     .radc_ssn(PMOD1[0]),
     .radc_clk(PMOD1[3]),
     .radc_dat(PMOD1[2]),

     .rdata, .rstrb,
     .ldata, .lstrb);

    /* Logic analyzer */
    ila ila_impl
      (.clk(clock),
       .probe0({ lstrb, ldata }),
       .probe1({ rstrb, rdata }));

endmodule // cmod_a7
