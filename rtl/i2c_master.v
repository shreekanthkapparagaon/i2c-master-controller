`timescale 1ns / 1ps

module i2c_master #(
    parameter CLK_FREQ = 50_000_000,
    parameter I2C_FREQ = 100_000
)(
    input  wire        clk,
    input  wire        rst_n,

    // Control Interface
    input  wire        start,
    input  wire        rw,
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

    //------------------------------------------------------------
    // State Encoding
    //------------------------------------------------------------
    localparam IDLE         = 4'd0;
    localparam START        = 4'd1;
    localparam SEND_ADDRESS = 4'd2;
    localparam ADDRESS_ACK  = 4'd3;
    localparam WRITE_BYTE   = 4'd4;
    localparam READ_BYTE    = 4'd5;
    localparam DATA_ACK     = 4'd6;
    localparam STOP         = 4'd7;
    localparam DONE         = 4'd8;

    //------------------------------------------------------------
    // Registers
    //------------------------------------------------------------
    reg [3:0] state;
    reg [3:0] next_state;

    //------------------------------------------------------------
    // Clock Divider
    //------------------------------------------------------------
    wire tick;

    clock_divider #(
        .CLK_FREQ(CLK_FREQ),
        .I2C_FREQ(I2C_FREQ)
    ) u_clock_divider (
        .clk   (clk),
        .rst_n (rst_n),
        .tick  (tick)
    );

    //------------------------------------------------------------
    // Temporary I2C Bus
    //------------------------------------------------------------
    assign scl = 1'b1;
    assign sda = 1'bz;

    //------------------------------------------------------------
    // State Register
    //------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n)
            state <= IDLE;
        else if (tick)
            state <= next_state;

    end

    //------------------------------------------------------------
    // Next-State Logic
    //------------------------------------------------------------
    always @(*) begin

        next_state = state;

        case (state)

            IDLE: begin
                if (start)
                    next_state = START;
            end

            START: begin
                next_state = DONE;
            end

            DONE: begin
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase

    end

    //------------------------------------------------------------
    // Output Logic (Moore FSM)
    //------------------------------------------------------------
    always @(*) begin

        //--------------------------------------------------------
        // Default Outputs
        //--------------------------------------------------------
        busy      = 1'b0;
        done      = 1'b0;
        ack_error = 1'b0;
        rx_data   = 8'h00;

        case (state)

            IDLE: begin
                busy = 1'b0;
            end

            START: begin
                busy = 1'b1;
            end

            DONE: begin
                done = 1'b1;
            end

        endcase

    end

endmodule   