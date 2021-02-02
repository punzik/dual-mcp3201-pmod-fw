`timescale 1ns/100ps

module tb_mcp3201_ma;
    logic clock = 1'b0;
    logic reset = 1'b1;

    /* Master clock 50MHz (20ns period) */
    always #(20ns/2) clock <= ~clock;

    localparam ITERATIONS = 10;
    localparam CHANNELS = 3;

    logic spi_clk;
    logic spi_ssn;
    logic [CHANNELS-1:0] spi_miso;

    logic [CHANNELS*12-1:0] data;
    logic strb;

    mcp3201_ma #(.CHANNELS(CHANNELS),
                 .CLOCK_FREQ(50000000),
                 .SCLK_FREQ(1000000),
                 .SAMPLE_RATE(44100)) DUT
      (.clock, .reset,
       .spi_clk_o(spi_clk),
       .spi_ssn_o(spi_ssn),
       .spi_miso_i(spi_miso),
       .data_o(data),
       .strb_o(strb));

    always_ff @ (posedge clock)
      if (strb) begin
          $display("");

          for (int i = 0; i < CHANNELS; i ++)
            $display("o_CH%d: %15b", i, data[i*12 +: 12]);
      end

    logic [14:0] ds[CHANNELS];

    initial begin
        reset = 1'b1;
        repeat(10) @(posedge clock);
        reset = 1'b0;

        repeat(50) @(posedge clock);

        for (int i = 0; i < ITERATIONS; i ++) begin

            wait(spi_ssn == 1'b0);

            $display("");

            for (int c = 0; c < CHANNELS; c ++) begin
                ds[c][14:13] = 2'bzz;
                ds[c][12] = 1'b0;
                ds[c][11:0] = $random;

                $display("i_CH%d: %15b", c, ds[c][11:0]);
            end

            for (int n = 0; n < 15; n ++) begin
                @(negedge spi_clk);

                for (int c = 0; c < CHANNELS; c ++) begin
                    spi_miso[c] = ds[c][14];
                    ds[c] = ds[c] << 1;
                end
            end

            wait(spi_ssn == 1'b1);
        end

        repeat(50) @(posedge clock);
        $finish;
    end

    initial begin
        $dumpfile("tb_mcp3201_ma.vcd");
        $dumpvars;
    end

endmodule // tb_mcp3201_ma
