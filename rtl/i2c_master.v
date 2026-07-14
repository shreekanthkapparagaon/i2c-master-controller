`timescale 1ns / 1ps

module i2c_master #(
    parameter CLK_FREQ = 50_000_000,
    parameter I2C_FREQ = 100_000
)(
    input  wire        clk,
    input  wire        rst_n,

    // Control Interface
    input  wire        start,
    input  wire        rw,             // 0 = Write, 1 = Read
    input  wire [6:0]  slave_addr,
    input  wire [7:0]  tx_data,
    output reg  [7:0]  rx_data,

    // Status
    output reg         busy,
    output reg         done,
    output reg         ack_error,

    // I2C Bus
    inout  wire        sda,
    output wire        scl
);

    // Implementation will be added in future versions.

endmodule