module mp2 #(
    parameter CLOCK_FREQUENCY = 12000000, // The clock frequency is 12MHz
    parameter INTERVAL = CLOCK_FREQUENCY / 360  // interval is how often to change the color, and since theres 360 degrees in a circle, its CLOCK_FREQUENCY / 360
)(
    input logic clk, // Clock input
    output logic RGB_R, // Red LED Output
    output logic RGB_G, // Green LED Output
    output logic RGB_B // Blue LED Output
);
    logic [31:0] clock_counter; // Counter go keep track of clock
    logic [8:0] hue; // 9 bits to store the 0-360 angle

    logic [7:0] pwm_r; // 8 bits to store PWM Cycle for RED (range is 0-255)
    logic [7:0] pwm_g; // 8 bits to store PWM Cycle for GREEN (range is 0-255)
    logic [7:0] pwm_b; // 8 bits to store PWM Cycle for BLUE (range is 0-255)
    logic [7:0] pwm_counter; // 8 bits to allow color to change smoothly, not rapidly

    // Initialize Variables
    initial begin
        pwm_counter = 0;
        hue = 0;
        clock_counter = 0;
    end

    // Logic to handle hue transitions
    always_ff @(posedge clk) begin
        if (clock_counter >= INTERVAL) begin // If counter is more than interval, resent counter and increment hue
            clock_counter <= 0;
            hue <= (hue == 359) ? 0 : hue + 1;  // increment hue, reset after 360°
        end else begin // Otherwise increment counter
            clock_counter <= clock_counter + 1;
        end
    end

    // Logic to update PWM Sigals
    always_comb begin
        pwm_r = (hue > 300) || (hue < 60) ? 255 : // When the signal is 255
                (hue >= 120) && (hue < 240) ? 0 : // When the signal is 0
                (hue < 120) ? (255 * (120 - hue) / 60) : // When signal is decreasing from 255 to  0
                (255 * (hue-240) / 60); // When signal is increasing from 0 to 255

        pwm_g = (hue >= 60) && (hue < 180) ? 255 : // When the signal is 255
                (hue >= 240) ? 0 : // When the signal is 0
                (hue < 60) ? (255 * hue / 60) : // When signal is decreasing from 255 to  0
                (255 * (240 - hue) / 60); // When signal is increasing from 0 to 255

        pwm_b = (hue > 180) && (hue < 300) ? 255 : // When the signal is 255
                (hue < 120) ? 0 : // When the signal is 0
                (hue < 180) ? (255 * (hue - 120) / 60) : // When signal is decreasing from 255 to  0
                (255 * (360 - hue) / 60); // When signal is increasing from 0 to 255
    end

    always_ff @(posedge clk) begin
        pwm_counter <= pwm_counter + 1; // Update pwm counter
    end

    // Assigning PWM 
    assign RGB_R = pwm_counter < pwm_r;
    assign RGB_G = pwm_counter < pwm_g;
    assign RGB_B = pwm_counter < pwm_b;

endmodule
