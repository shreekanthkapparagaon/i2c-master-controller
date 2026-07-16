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
    localparam IDLE          = 4'd0;
    localparam START         = 4'd1;
    localparam START_HOLD    = 4'd2;
    localparam SCL_LOW       = 4'd3;
    localparam LOAD_ADDRESS  = 4'd4;
    localparam SEND_ADDRESS  = 4'd5;
    localparam ADDRESS_ACK   = 4'd6;
    localparam WRITE_BYTE    = 4'd7;
    localparam READ_BYTE     = 4'd8;
    localparam DATA_ACK      = 4'd9;
    localparam STOP          = 4'd10;
    localparam DONE          = 4'd11;

    //------------------------------------------------------------
    // Registers
    //------------------------------------------------------------
    reg [3:0] state;
    reg [3:0] next_state;

    //------------------------------------------------------------
    // Address Shift Registers
    //------------------------------------------------------------
    reg [7:0] shift_reg;
    reg [2:0] bit_cnt;

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
    // Moore FSM - State Register
    //------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n)
            state <= IDLE;
        else if (tick)
            state <= next_state;

    end

    //------------------------------------------------------------
    // Moore FSM - Datapath Register
    //------------------------------------------------------------
    // Stores transaction-related data.
    // The FSM controls *when* updates occur,
    // while this block performs the actual register updates.
    //
    // Current implementation:
    //   - Placeholder only.
    //
    // Future versions:
    //   - LOAD_ADDRESS  : Load {slave_addr, rw}
    //   - SEND_ADDRESS  : Shift address bits
    //   - WRITE_BYTE    : Shift TX data
    //   - READ_BYTE     : Capture RX data
    //   - ACK Handling  : Bit counter management
    //------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            shift_reg <= 8'd0;
            bit_cnt   <= 3'd0;
        end
        else if (tick) begin

            case (state)

                //------------------------------------------------
                // LOAD_ADDRESS
                //------------------------------------------------
                LOAD_ADDRESS: begin
                    shift_reg <= {slave_addr, rw};
                    bit_cnt   <= 3'd7;
                end

                default: begin
                    shift_reg <= shift_reg;
                    bit_cnt   <= bit_cnt;
                end

            endcase

        end

    end

    //------------------------------------------------------------
    // Moore FSM - Next-State Logic
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
                next_state = SCL_LOW;
            end

            SCL_LOW: begin
                next_state = LOAD_ADDRESS;
            end

            LOAD_ADDRESS: begin
                next_state = SEND_ADDRESS;
            end

            SEND_ADDRESS: begin
                // Temporary until address shifting is implemented
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
    // Moore FSM - Output Logic
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
                
                // Prepare START condition.
                // SDA is driven low in START_HOLD.
                scl_reg       = 1'b1;
                sda_drive_low = 1'b0;
            end
            START_HOLD: begin

                busy = 1'b1;

                // Generate START condition
                scl_reg       = 1'b1;
                sda_drive_low = 1'b1;
            end
            SCL_LOW: begin

                busy = 1'b1;

                // Hold SDA LOW after START
                sda_drive_low = 1'b1;

                // Pull SCL LOW
                scl_reg = 1'b0;

            end
            LOAD_ADDRESS: begin
                busy = 1'b1;

                // Hold bus while datapath prepares
                // the address shift register.
                scl_reg       = 1'b0;
                sda_drive_low = 1'b1;
            end
            SEND_ADDRESS: begin
                busy = 1'b1;

                // Address transmission handled by datapath logic.
                scl_reg       = 1'b0;
                sda_drive_low = 1'b1;
            end

            DONE: begin
                done = 1'b1;

                // Return the I²C bus to the idle state.
                scl_reg       = 1'b1;
                sda_drive_low = 1'b0;
            end

        endcase

    end

endmodule   