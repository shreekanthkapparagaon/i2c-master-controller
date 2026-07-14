`timescale 1ns / 1ps

module tb_clock_divider;

    reg clk;
    reg rst_n;
    wire tick;

    clock_divider #(
        .CLK_FREQ(100),
        .I2C_FREQ(10)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .tick(tick)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        #20;
        rst_n = 1;

        #500;

        $finish;
    end

    initial begin
        $dumpfile("wave/clock_divider.vcd");
        $dumpvars(0, tb_clock_divider);
    end

endmodule