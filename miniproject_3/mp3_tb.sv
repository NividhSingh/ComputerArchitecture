`timescale 10ns/10ns
`include "mp3.sv"

module sine_tb;

    // Clock signal initialization
    logic clk = 0;

    // DAC output signals corresponding to bits 9 (MSB) to 0 (LSB)
    logic dac_bit9, dac_bit8, dac_bit7, dac_bit6, dac_bit5,
          dac_bit4, dac_bit3, dac_bit2, dac_bit1, dac_bit0;

    // Instantiate the mp3 module which generates a sine wave via DAC outputs
    mp3 u_mp3 (
        .clk      (clk),
        .dac_bit9 (dac_bit9),
        .dac_bit8 (dac_bit8),
        .dac_bit7 (dac_bit7),
        .dac_bit6 (dac_bit6),
        .dac_bit5 (dac_bit5),
        .dac_bit4 (dac_bit4),
        .dac_bit3 (dac_bit3),
        .dac_bit2 (dac_bit2),
        .dac_bit1 (dac_bit1),
        .dac_bit0 (dac_bit0)
    );

    // Simulation initialization: dump waveforms and finish after a fixed time
    initial begin
        $dumpfile("mp3.vcd");      // VCD file to view simulation waveforms
        $dumpvars(0, sine_tb);       // Dump all variables within this testbench
        #10000;                     // Run simulation for a fixed duration (10000 time units)
        $finish;                    // Terminate simulation
    end

    // Clock generation: Toggle the clock every 4 time units to create a periodic signal
    always begin
        #4 clk = ~clk;
    end

endmodule
