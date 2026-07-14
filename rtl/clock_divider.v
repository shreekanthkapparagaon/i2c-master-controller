`timescale 1ns / 1ps

module clock_divider #(
    parameter integer CLK_FREQ = 50_000_000,
    parameter integer I2C_FREQ = 100_000
)(
    input  wire clk,
    input  wire rst_n,
    output reg  tick
);

    localparam integer DIVIDER = CLK_FREQ / (I2C_FREQ * 4);
    localparam integer WIDTH = $clog2(DIVIDER);

    reg [WIDTH-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            tick    <= 1'b0;
        end
        else begin
            tick <= 1'b0;

            if (counter == DIVIDER - 1) begin
                counter <= 0;
                tick    <= 1'b1;
            end
            else begin
                counter <= counter + 1'b1;
            end
        end
    end

endmodule