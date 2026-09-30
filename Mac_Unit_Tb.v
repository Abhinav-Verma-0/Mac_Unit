`timescale 1ns/1ps
module tb_mac_int8;
    reg              clk;
    reg              rst_n;
    reg              en;
    reg              clear_acc;
    reg  signed [7:0]  a;
    reg  signed [7:0]  b;
    wire signed [31:0] acc;
    wire               valid_out;
 
    // Golden/expected accumulator value, computed in the testbench
    reg signed [31:0] expected_acc;
 
    integer i;
    integer errors;
 
    // -------------------------------------------------------------
    // Instantiate the DUT (Device Under Test)
    // -------------------------------------------------------------
    mac_int8 #(
        .DATA_WIDTH(8),
        .ACC_WIDTH(32)
    ) dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .en         (en),
        .clear_acc  (clear_acc),
        .a          (a),
        .b          (b),
        .acc        (acc),
        .valid_out  (valid_out)
    );
    initial clk = 0;
    always #5 clk = ~clk;
    
    task do_mac(input signed [7:0] in_a, input signed [7:0] in_b);
        begin
            @(negedge clk);          // set up inputs away from clock edge
            a  = in_a;
            b  = in_b;
            en = 1'b1;
 
            @(posedge clk);          // let DUT capture and compute
            #1;                      // small delta delay so acc has updated
 
            // Update golden model: expected_acc grows by a*b
            expected_acc = expected_acc + (in_a * in_b);
 
            if (acc !== expected_acc) begin
                $display("FAIL: a=%0d b=%0d  DUT_acc=%0d  EXPECTED_acc=%0d",
                          in_a, in_b, acc, expected_acc);
                errors = errors + 1;
            end else begin
                $display("PASS: a=%0d b=%0d  acc=%0d", in_a, in_b, acc);
            end
        end
    endtask
 
    // -------------------------------------------------------------
    // Main test sequence
    // -------------------------------------------------------------
    initial begin
        // Set up waveform dump for GTKWave
        $dumpfile("mac_int8_tb.vcd");
        $dumpvars(0, tb_mac_int8);
 
        // Initialize
        rst_n        = 0;
        en           = 0;
        clear_acc    = 0;
        a            = 0;
        b            = 0;
        expected_acc = 0;
        errors       = 0;
        #12 rst_n = 1;
 
        $display("---------------------------------------------------");
        $display(" Starting INT8 MAC unit test");
        $display("---------------------------------------------------");
        do_mac(5, 10);
        do_mac(3, 7);
        do_mac(-4, 6);
        do_mac(-8, -8);
        do_mac(0, 99);
        do_mac(127, 127);
        do_mac(-128, -128);    
        do_mac(-128, 127);      
 
        @(negedge clk);
        clear_acc = 1;
        @(posedge clk);
        #1;
        clear_acc    = 0;
        expected_acc = 0;
        if (acc !== 32'sd0) begin
            $display("FAIL: clear_acc did not reset accumulator, acc=%0d", acc);
            errors = errors + 1;
        end else begin
            $display("PASS: clear_acc correctly reset accumulator to 0");
        end
        for (i = 0; i < 10; i = i + 1) begin
            do_mac($random % 128, $random % 128);
        end
        $display("---------------------------------------------------");
        if (errors == 0)
            $display(" ALL TESTS PASSED");
        else
            $display(" TEST FAILED: %0d error(s) found", errors);
        $display("---------------------------------------------------");
 
        #10 $finish;
    end
 
endmodule
