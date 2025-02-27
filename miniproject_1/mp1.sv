// Blink
// Video of blink working: https://youtube.com/shorts/uR9XzXu5kk4

module top(
    input logic     clk, 
    output logic RGB_R,     // Red channel (active low)
    output logic RGB_G,     // Green channel (active low)
    output logic RGB_B      // Blue channel (active low)
);

    // CLK frequency is 12MHz, so 6,000,000 cycles is 0.5s
    parameter CHANGE_INTERVAL = 2000000;
    logic [$clog2(CHANGE_INTERVAL) - 1:0] count = 0;
    logic [2:0] color_state;

    // Initialize variables
    initial begin
        count = 0;
        color_state = 0;
    end

    // Change color_state every CHANGE_INTERVAL cycles
    always_ff @(posedge clk) begin
        if (count == CHANGE_INTERVAL - 1) begin
            count <= 0;
            if (color_state == 5) begin
                color_state <= 0;
            end
            else begin
                color_state <= color_state + 1;
            end
        end
        else begin
            count <= count + 1;
        end
    end

    // Change the LED based on the color_state
    always_comb begin 

        case(color_state)
            3'd0: begin
                RGB_R = 1'b0;
                RGB_B = 1'b1;
                RGB_G = 1'b1;
            end
            3'd1: begin
                RGB_R = 1'b0;
                RGB_B = 1'b1;
                RGB_G = 1'b0;
            end
            3'd2: begin
                RGB_R = 1'b1;
                RGB_B = 1'b1;
                RGB_G = 1'b0;
            end
            3'd3: begin
                RGB_R = 1'b1;
                RGB_B = 1'b0;
                RGB_G = 1'b0;
            end
            3'd4: begin
                RGB_R = 1'b1;
                RGB_B = 1'b0;
                RGB_G = 1'b1;
            end
            3'd5: begin
                RGB_R = 1'b0;
                RGB_B = 1'b0;
                RGB_G = 1'b1;
            end
            default: begin
                RGB_R = 1'b1;
                RGB_B = 1'b1;
                RGB_G = 1'b1;
            end

        endcase
        
    end

endmodule
