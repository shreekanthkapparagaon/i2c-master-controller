`timescale 1ns / 1ps

module tb_i2c_master;

    //------------------------------------------------------------
    // Testbench Signals
    //------------------------------------------------------------
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

    tri1 sda;
    wire scl;

    //------------------------------------------------------------
    // DUT
    //------------------------------------------------------------
    //------------------------------------------------------------
    // Simulation Parameters
    //------------------------------------------------------------
    localparam TB_CLK_FREQ = 100;
    localparam TB_I2C_FREQ = 25;

    //------------------------------------------------------------
    // DUT
    //------------------------------------------------------------
    i2c_master #(
        .CLK_FREQ(TB_CLK_FREQ),
        .I2C_FREQ(TB_I2C_FREQ)
    ) dut (
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

    //------------------------------------------------------------
    // Clock Generation (100 MHz)
    //------------------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //------------------------------------------------------------
    // Waveform Dump
    //------------------------------------------------------------
    initial begin
        $dumpfile("wave/i2c_master.vcd");
        $dumpvars(0, tb_i2c_master);
    end

    //------------------------------------------------------------
    // FSM State Monitor
    //------------------------------------------------------------
    always @(dut.state) begin
        case (dut.state)
            4'd0: $display("[%0t] State -> IDLE", $time);
            4'd1: $display("[%0t] State -> START", $time);
            4'd2: $display("[%0t] State -> START_HOLD", $time);
            4'd3:  $display("[%0t] State -> SCL_LOW", $time);
            4'd4: $display("[%0t] State -> SEND_ADDRESS", $time);
            4'd5: $display("[%0t] State -> ADDRESS_ACK", $time);
            4'd6: $display("[%0t] State -> WRITE_BYTE", $time);
            4'd7: $display("[%0t] State -> READ_BYTE", $time);
            4'd8: $display("[%0t] State -> DATA_ACK", $time);
            4'd9: $display("[%0t] State -> STOP", $time);
            4'd10: $display("[%0t] State -> DONE", $time);
            default: $display("[%0t] State -> UNKNOWN", $time);
        endcase
    end

    //------------------------------------------------------------
    // Test Statistics
    //------------------------------------------------------------
    integer total_tests;
    integer passed_tests;
    integer failed_tests;

    task check;
        input condition;
        input [255:0] test_name;
    begin
        total_tests = total_tests + 1;

        if (condition) begin
            passed_tests = passed_tests + 1;
            $display("[PASS] %0s", test_name);
        end
        else begin
            failed_tests = failed_tests + 1;
            $display("[FAIL] %0s", test_name);
        end
    end
    endtask

    //------------------------------------------------------------
    // Test Sequence
    //------------------------------------------------------------
    initial begin

        total_tests  = 0;
        passed_tests = 0;
        failed_tests = 0;

        //--------------------------------------------------------
        // Initialize Inputs
        //--------------------------------------------------------
        rst_n      = 0;
        start      = 0;
        rw         = 0;
        slave_addr = 7'h50;
        tx_data    = 8'hA5;

        //--------------------------------------------------------
        // Apply Reset
        //--------------------------------------------------------
        #20;
        rst_n = 1;

        @(posedge clk);
        #1;

        check(dut.state == 4'd0, "FSM enters IDLE after reset");
        check(busy == 1'b0,      "Busy is LOW after reset");

        //--------------------------------------------------------
        // Start Transaction
        //--------------------------------------------------------
        start = 1;

        @(posedge clk);
        #1;

        check(dut.state == 4'd1, "FSM enters START state");
        check(busy == 1'b1,      "Busy asserted");

        start = 0;

        //--------------------------------------------------------
        // START_HOLD State
        //--------------------------------------------------------
        @(posedge clk);
        #1;

        check(dut.state == 4'd2, "FSM enters START_HOLD state");
        check(busy == 1'b1,      "Busy remains asserted");
        // New checks
        check(scl == 1'b1, "SCL HIGH during START");
        check(sda == 1'b0, "SDA LOW during START");

        //--------------------------------------------------------
        // SCL_LOW State
        //--------------------------------------------------------
        @(posedge clk);
        #1;

        check(dut.state == 4'd3, "FSM enters SCL_LOW state");
        check(busy == 1'b1,      "Busy remains asserted");
        check(scl == 1'b0,       "SCL driven LOW");
        check(sda == 1'b0,       "SDA remains LOW");

        //--------------------------------------------------------
        // DONE State
        //--------------------------------------------------------
        @(posedge clk);
        #1;

        check(dut.state == 4'd10, "FSM enters DONE state");
        check(done == 1'b1,      "Done asserted");

        //--------------------------------------------------------
        // Return to IDLE
        //--------------------------------------------------------
        @(posedge clk);
        #1;

        check(dut.state == 4'd0, "FSM returns to IDLE");
        check(busy == 1'b0,      "Busy deasserted");

        //--------------------------------------------------------
        // Summary
        //--------------------------------------------------------
        $display("");
        $display("======================================");
        $display("          TEST SUMMARY");
        $display("======================================");
        $display("Total Tests : %0d", total_tests);
        $display("Passed      : %0d", passed_tests);
        $display("Failed      : %0d", failed_tests);

        if (failed_tests == 0)
            $display("RESULT      : PASS");
        else
            $display("RESULT      : FAIL");

        $display("======================================");

        $finish;

    end

endmodule