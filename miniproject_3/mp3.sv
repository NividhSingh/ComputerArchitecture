module mp3 #(
    parameter TOTAL_SAMPLES   = 512,    // Total number of samples in one full sine wave cycle
    parameter QUARTER_SAMPLES = 128     // Number of samples in one quarter cycle of the sine wave
)(
    input  logic clk,             // Clock input
    output logic dac_bit9,        // DAC bit 9 (MSB)
    output logic dac_bit8,        // DAC bit 8
    output logic dac_bit7,        // DAC bit 7
    output logic dac_bit6,        // DAC bit 6
    output logic dac_bit5,        // DAC bit 5
    output logic dac_bit4,        // DAC bit 4
    output logic dac_bit3,        // DAC bit 3
    output logic dac_bit2,        // DAC bit 2
    output logic dac_bit1,        // DAC bit 1
    output logic dac_bit0         // DAC bit 0 (LSB)
);

    // 9-bit counter for the sine wave samples (0 to 511)
    logic [8:0] sampleCounter = 0;

    // ROM that stores one quarter (128 values) of a 10-bit sine wave sample
    logic [9:0] quarterWaveROM [0:QUARTER_SAMPLES-1];

    // 10-bit register holding the current DAC output value
    logic [9:0] dacValue;

    // Read quarter sine wave data from external hex file into quarterWaveROM
    initial begin
        $readmemh("quarter.txt", quarterWaveROM);
    end

    // Increment sample counter on each clock cycle, wrap around after a full cycle
    always_ff @(posedge clk) begin
        if (sampleCounter == TOTAL_SAMPLES - 1)
            sampleCounter <= 0;
        else
            sampleCounter <= sampleCounter + 1;
    end

    // Compute the DAC output using symmetry across the four quadrants of the sine wave
    always_comb begin
        if (sampleCounter < QUARTER_SAMPLES) begin
            // First quadrant: rising from baseline to peak
            dacValue = quarterWaveROM[sampleCounter];
        end else if (sampleCounter < 2 * QUARTER_SAMPLES) begin
            // Second quadrant: falling from peak back to baseline
            dacValue = quarterWaveROM[QUARTER_SAMPLES - 1 - (sampleCounter - QUARTER_SAMPLES)];
        end else if (sampleCounter < 3 * QUARTER_SAMPLES) begin
            // Third quadrant: mirror of first quadrant, descending from baseline
            dacValue = 1024 - quarterWaveROM[sampleCounter - 2 * QUARTER_SAMPLES];
        end else begin
            // Fourth quadrant: mirror of second quadrant, rising back to baseline
            dacValue = 1024 - quarterWaveROM[QUARTER_SAMPLES - 1 - (sampleCounter - 3 * QUARTER_SAMPLES)];
        end
    end

    // Assign each bit of the 10-bit dacValue to its corresponding DAC output pin (MSB to LSB)
    assign {dac_bit9, dac_bit8, dac_bit7, dac_bit6, dac_bit5, dac_bit4, dac_bit3, dac_bit2, dac_bit1, dac_bit0} = dacValue;

endmodule
