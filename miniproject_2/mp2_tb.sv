`timescale 1ns/1ns // Running the simulation at 1 nanosecond intervals
`include "mp2.sv" // Include the main system varilog file for the test bench

module mp2_tb; // Test bench module

    logic clk = 0; // Set clock to 0
    logic RGB_R, RGB_G, RGB_B; // Signals that store Output from main file


    // Instatiate mp2 module from main and connect signals
    mp2 mp2 (
        .clk(clk),
        .RGB_R(RGB_R),
        .RGB_G(RGB_G),
        .RGB_B(RGB_B)
    );

    // Run for one second
    initial begin
        $dumpfile("mp2_tb.vcd");
        $dumpvars(1, mp2);
        #1000000000;
        $finish;
    end

    // About 12 MHz half-period
    always begin
        #41.6667 clk = ~clk; 
    end
endmodule
