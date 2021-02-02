`timescale 1ps/1ps

module tb_mcp3201;
    logic clock = 1'b0;
    logic reset = 1'b1;

    /* Master clock 10MHz (100ns period) */
    always #(100ns/2) clock <= ~clock;

    logic spi_clk;
    logic spi_ssn;
    logic spi_miso;

    logic [11:0] data;
    logic strb;

    spi_sclk_gen #(.CLOCK_FREQ(10000000), .SCLK_FREQ(50000 * 17)) spi_clk_g
      (.clock, .reset,
       .sclk_o(spi_clk));

    mcp3201 DUT
      (.clock, .reset,
       .spi_clk_i(spi_clk),
       .spi_ssn_o(spi_ssn),
       .spi_miso_i(spi_miso),
       .data_o(data),
       .strb_o(strb));

    always_ff @ (posedge clock)
      if (strb)
        $display("%15b", data);

    logic [14:0] ds;

    initial begin
        reset = 1'b1;
        repeat(10) @(posedge clock);
        reset = 1'b0;

        /* Send word 0 */
        wait(spi_ssn == 1'b0);

        ds = 15'bzz0_1010_1010_1010;
        for (int i = 0; i < 15; i ++) begin
            @(negedge spi_clk) spi_miso = ds[14];
            ds = ds << 1;
        end

        /* Send word 1 */
        wait(spi_ssn == 1'b1);
        wait(spi_ssn == 1'b0);

        ds = 15'bzz0_0101_0101_0101;
        for (int i = 0; i < 15; i ++) begin
            @(negedge spi_clk) spi_miso = ds[14];
            ds = ds << 1;
        end

        wait(spi_ssn == 1'b1);

        repeat(10) @(posedge clock);
        $finish;
    end

    initial begin
        $dumpfile("tb_mcp3201.vcd");
        $dumpvars;
    end

endmodule // tb_mcp3201
