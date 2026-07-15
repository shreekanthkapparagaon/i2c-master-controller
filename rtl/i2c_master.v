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
    // FSM State Encoding
    //------------------------------------------------------------
    localparam IDLE         = 4'd0;
    localparam START        = 4'd1;
    localparam START_HOLD   = 4'd2;
    localparam SEND_ADDRESS = 4'd3;
    localparam ADDRESS_ACK  = 4'd4;
    localparam WRITE_BYTE   = 4'd5;
    localparam READ_BYTE    = 4'd6;
    localparam DATA_ACK     = 4'd7;
    localparam STOP         = 4'd8;
    localparam DONE         = 4'd9;

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
    // I2C Bus Registers
    //------------------------------------------------------------
    reg scl_reg;
    reg sda_drive_low;

    // Open-drain I2C bus
    assign scl = scl_reg;
    assign sda = sda_drive_low ? 1'b0 : 1'bz;

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
                next_state = START_HOLD;
            end

            START_HOLD: begin
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

        //--------------------------------------------------------
        // Default Bus State
        //--------------------------------------------------------
        scl_reg       = 1'b1;
        sda_drive_low = 1'b0;

        case (state)

            IDLE: begin
                busy = 1'b0;

                // Bus Idle
                scl_reg       = 1'b1;
                sda_drive_low = 1'b0;
            end

            START: begin
                busy = 1'b1;

                // Bus remains idle for now.
                // START condition will be generated in the next commit.
                scl_reg       = 1'b1;
                sda_drive_low = 1'b0;
            end
            START_HOLD: begin
                busy = 1'b1;

                // Hold START condition
                scl_reg       = 1'b1;
                sda_drive_low = 1'b0;   // We'll change this in the next step to generate a real START
            end

            DONE: begin
                done = 1'b1;

                // Release bus
                scl_reg       = 1'b1;
                sda_drive_low = 1'b0;
            end

        endcase

    end

endmodule   