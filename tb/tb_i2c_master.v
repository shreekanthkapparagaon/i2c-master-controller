`timescale 1ns / 1ps

module tb_i2c_master;

    reg clk;
    reg rst_n;

    reg start;
    reg rw;
    reg [6:0] slave_addr;
    reg [7:0] tx_data;

    wire [7:0] rx_data;
    wire busy;
    wire done;
    wire ack_error;

    wire sda;
    wire scl;

    i2c_master dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .rw(rw),
        .slave_addr(slave_addr),
        .tx_data(tx_data),
        .rx_data(rx_data),
        .busy(busy),
        .done(done),
        .ack_error(ack_error),
        .sda(sda),
        .scl(scl)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

endmodule