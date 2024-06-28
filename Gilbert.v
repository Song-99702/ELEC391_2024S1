module Gilbert(
    input wire clk,
    input wire reset,
    input wire signed [15:0] input_signal,
    output reg signed [15:0] output_signal,
    output reg [4:0] SNR,
    output reg state // 0: Good, 1: Bad
);

    parameter P_GB = 8'd8;  // 0.03 * 256 ≈ 8
    parameter P_BG = 8'd64; // 0.25 * 256 = 64
    parameter SNR_G = 5'd21; // SNR for good state
    parameter SNR_B = 5'd9;  // SNR for bad state

    wire [7:0] rand_num;
    reg [15:0] count;
    reg [15:0] Ts;

    // Instantiate LFSR to generate random number
    LFSR lfsr_inst (
        .clk(clk),
        .reset(reset),
        .random(rand_num)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            count <= 0;
            Ts <= 16'd10000; // state transition frequency 10kHz
        end else begin
            // Update count
            count <= count + 1;

            // Gilbert model logic with state transition frequency
            if (count >= Ts) begin
                count <= 0;

                if (state == 0) begin
                    if (rand_num < P_GB) begin
                        state <= 1;
                    end
                end else begin
                    if (rand_num < P_BG) begin
                        state <= 0;
                    end
                end
            end

            // Determine current state
            if (state == 0) begin
                SNR <= SNR_G;
            end else begin
                SNR <= SNR_B;
            end

            // Output the unchanged input signal
            output_signal <= input_signal;
        end
    end
endmodule

