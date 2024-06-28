
// module Transmitter(
//     input wire clk,
//     input wire reset,
//     input wire signed [10:0] input_signal,
//     output reg signed [15:0] encoded_signal
// );

//     // Parameters for Square Root Raised Cosine Filter
//     parameter FILTER_TAPS = 33;
//     reg signed [31:0] FILTER_COEFFS [0:FILTER_TAPS-1];
//     reg signed [10:0] delay_line [0:FILTER_TAPS-1];
//     reg signed [47:0] temp;  // Intermediate result with higher bit-width
//     integer i;

//     initial begin
//         // Initialize filter coefficients (scaled by 32768)
//         FILTER_COEFFS[0]  = -32'd165;  // -0.00505281304553084 * 32768
//         FILTER_COEFFS[1]  = -32'd63;   // -0.00191087927654681 * 32768
//         FILTER_COEFFS[2]  = 32'd176;   // 0.00535931755284406 * 32768
//         FILTER_COEFFS[3]  = 32'd269;   // 0.00822646167623590 * 32768
//         FILTER_COEFFS[4]  = 32'd50;    // 0.00151584391365925 * 32768
//         FILTER_COEFFS[5]  = -32'd269;  // -0.00822646167623590 * 32768
//         FILTER_COEFFS[6]  = -32'd246;  // -0.00750304457398167 * 32768
//         FILTER_COEFFS[7]  = 32'd253;   // 0.00773451135745139 * 32768
//         FILTER_COEFFS[8]  = 32'd694;   // 0.0212218147912295 * 32768
//         FILTER_COEFFS[9]  = 32'd253;   // 0.00773451135745138 * 32768
//         FILTER_COEFFS[10] = -32'd1230; // -0.0375152228699084 * 32768
//         FILTER_COEFFS[11] = -32'd2566; // -0.0784256013134489 * 32768
//         FILTER_COEFFS[12] = -32'd1736; // -0.0530545369780738 * 32768
//         FILTER_COEFFS[13] = 32'd2566;  // 0.0784256013134490 * 32768
//         FILTER_COEFFS[14] = 32'd9473;  // 0.289331991458557 * 32768
//         FILTER_COEFFS[15] = 32'd15988; // 0.487274215519437 * 32768
//         FILTER_COEFFS[16] = 32'd18622; // 0.568340837283330 * 32768
//         FILTER_COEFFS[17] = 32'd15988; // 0.487274215519437 * 32768
//         FILTER_COEFFS[18] = 32'd9473;  // 0.289331991458557 * 32768
//         FILTER_COEFFS[19] = 32'd2566;  // 0.0784256013134490 * 32768
//         FILTER_COEFFS[20] = -32'd1736; // -0.0530545369780738 * 32768
//         FILTER_COEFFS[21] = -32'd2566; // -0.0784256013134489 * 32768
//         FILTER_COEFFS[22] = -32'd1230; // -0.0375152228699084 * 32768
//         FILTER_COEFFS[23] = 32'd253;   // 0.00773451135745138 * 32768
//         FILTER_COEFFS[24] = 32'd694;   // 0.0212218147912295 * 32768
//         FILTER_COEFFS[25] = 32'd253;   // 0.00773451135745139 * 32768
//         FILTER_COEFFS[26] = -32'd246;  // -0.00750304457398167 * 32768
//         FILTER_COEFFS[27] = -32'd269;  // -0.00822646167623590 * 32768
//         FILTER_COEFFS[28] = 32'd50;    // 0.00151584391365925 * 32768
//         FILTER_COEFFS[29] = 32'd269;   // 0.00822646167623590 * 32768
//         FILTER_COEFFS[30] = 32'd176;   // 0.00535931755284406 * 32768
//         FILTER_COEFFS[31] = -32'd63;   // -0.00191087927654681 * 32768
//         FILTER_COEFFS[32] = -32'd165;  // -0.00505281304553084 * 32768
//     end

//     always @(posedge clk ) begin
//         if (reset) begin
//             encoded_signal <= 0;
//             for (i = 0; i < FILTER_TAPS; i = i + 1) begin
//                 delay_line[i] <= 0;
//             end
//         end else begin
//             // Shift delay line and insert new input sample
//             for (i = FILTER_TAPS-1; i > 0; i = i - 1) begin
//                 delay_line[i] <= delay_line[i-1];
//             end
//             delay_line[0] <= input_signal;

//             // Convolve input with filter coefficients
//             temp = 0;
//             for (i = 0; i < FILTER_TAPS; i = i + 1) begin
//                 temp = temp + (delay_line[i] * FILTER_COEFFS[i]);
//             end
//             // Scale back the result to 16-bit signed value
//             encoded_signal <= temp >>> 15;
//         end
//     end

// endmodule

module Transmitter(
    input wire clk,
    input wire reset,
    input wire signed [10:0] input_signal,
    output reg signed [15:0] encoded_signal
);

    // Parameters for Square Root Raised Cosine Filter
    parameter FILTER_TAPS = 33;
    reg signed [31:0] FILTER_COEFFS [0:FILTER_TAPS-1];
    reg signed [10:0] delay_line [0:FILTER_TAPS-1];
    reg signed [47:0] temp;  // Intermediate result with higher bit-width
    integer i;

    initial begin
        // Initialize filter coefficients (scaled by 32768)
        FILTER_COEFFS[0]  = -32'd165;  // -0.00505281304553084 * 32768
        FILTER_COEFFS[1]  = -32'd63;   // -0.00191087927654681 * 32768
        FILTER_COEFFS[2]  = 32'd176;   // 0.00535931755284406 * 32768
        FILTER_COEFFS[3]  = 32'd269;   // 0.00822646167623590 * 32768
        FILTER_COEFFS[4]  = 32'd50;    // 0.00151584391365925 * 32768
        FILTER_COEFFS[5]  = -32'd269;  // -0.00822646167623590 * 32768
        FILTER_COEFFS[6]  = -32'd246;  // -0.00750304457398167 * 32768
        FILTER_COEFFS[7]  = 32'd253;   // 0.00773451135745139 * 32768
        FILTER_COEFFS[8]  = 32'd694;   // 0.0212218147912295 * 32768
        FILTER_COEFFS[9]  = 32'd253;   // 0.00773451135745138 * 32768
        FILTER_COEFFS[10] = -32'd1230; // -0.0375152228699084 * 32768
        FILTER_COEFFS[11] = -32'd2566; // -0.0784256013134489 * 32768
        FILTER_COEFFS[12] = -32'd1736; // -0.0530545369780738 * 32768
        FILTER_COEFFS[13] = 32'd2566;  // 0.0784256013134490 * 32768
        FILTER_COEFFS[14] = 32'd9473;  // 0.289331991458557 * 32768
        FILTER_COEFFS[15] = 32'd15988; // 0.487274215519437 * 32768
        FILTER_COEFFS[16] = 32'd18622; // 0.568340837283330 * 32768
        FILTER_COEFFS[17] = 32'd15988; // 0.487274215519437 * 32768
        FILTER_COEFFS[18] = 32'd9473;  // 0.289331991458557 * 32768
        FILTER_COEFFS[19] = 32'd2566;  // 0.0784256013134490 * 32768
        FILTER_COEFFS[20] = -32'd1736; // -0.0530545369780738 * 32768
        FILTER_COEFFS[21] = -32'd2566; // -0.0784256013134489 * 32768
        FILTER_COEFFS[22] = -32'd1230; // -0.0375152228699084 * 32768
        FILTER_COEFFS[23] = 32'd253;   // 0.00773451135745138 * 32768
        FILTER_COEFFS[24] = 32'd694;   // 0.0212218147912295 * 32768
        FILTER_COEFFS[25] = 32'd253;   // 0.00773451135745139 * 32768
        FILTER_COEFFS[26] = -32'd246;  // -0.00750304457398167 * 32768
        FILTER_COEFFS[27] = -32'd269;  // -0.00822646167623590 * 32768
        FILTER_COEFFS[28] = 32'd50;    // 0.00151584391365925 * 32768
        FILTER_COEFFS[29] = 32'd269;   // 0.00822646167623590 * 32768
        FILTER_COEFFS[30] = 32'd176;   // 0.00535931755284406 * 32768
        FILTER_COEFFS[31] = -32'd63;   // -0.00191087927654681 * 32768
        FILTER_COEFFS[32] = -32'd165;  // -0.00505281304553084 * 32768
    end

    always @(posedge clk) begin
        if (reset) begin
            encoded_signal <= 0;
            for (i = 0; i < FILTER_TAPS; i = i + 1) begin
                delay_line[i] <= 0;
            end
        end else begin
            // Shift delay line and insert new input sample
            for (i = FILTER_TAPS-1; i > 0; i = i - 1) begin
                delay_line[i] <= delay_line[i-1];
            end
            delay_line[0] <= input_signal;

            // Convolve input with filter coefficients
            temp = 0;
            for (i = 0; i < FILTER_TAPS; i = i + 1) begin
                temp = temp + (delay_line[i] * FILTER_COEFFS[i]);
            end
            // Scale back the result to 16-bit signed value
            encoded_signal <= temp >>> 15;
        end
    end

endmodule