module AWGN_Channel(
    input wire clk,
    input wire reset,
    input wire signed [15:0] input_signal,
    input wire [4:0] SNR,
    input wire state, // 0: Good, 1: Bad
    output reg signed [15:0] output_signal
);

    reg signed [15:0] noise;
    wire [7:0] random1, random2;
    reg signed [31:0] noise_accum;
    reg signed [31:0] gaussian_noise;

    // Instantiate LFSR modules to generate random numbers
    LFSR lfsr1(
        .clk(clk),
        .reset(reset),
        .random(random1)
    );

    LFSR lfsr2(
        .clk(clk),
        .reset(reset),
        .random(random2)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            noise_accum <= 0;
            output_signal <= 0;
        end else begin
            if (state == 1) begin // Only add noise in bad state
                // Approximate Gaussian noise
                gaussian_noise <= (random1 + random2) >>> 1; // Simple average to approximate Gaussian noise
                noise <= gaussian_noise[7:0];
                
                // Adjust noise strength based on SNR
                if (SNR == 9) begin
                    noise_accum <= (noise * 1024) / 32768;// SNR 9dB
                end else begin
                    noise_accum <= 0;
                end
                
                // Add noise to input signal
                output_signal <= input_signal + noise_accum[15:0];
            end else begin
                output_signal <= input_signal; // No noise in good state
            end
        end
    end
endmodule
