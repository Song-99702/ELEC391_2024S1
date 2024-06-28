module clock_divider (
    input wire clk_in,    // 0.6 MHz input clock
    input wire reset,     // Asynchronous reset
    output reg clk_out    // 40 kHz output clock
);

    // Define the counter width
    reg [3:0] counter;    // 4-bit counter to count from 0 to 14

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 4'd0;
            clk_out <= 1'b0;
        end else begin
            if (counter == 4'd14) begin
                counter <= 4'd0;
                clk_out <= ~clk_out;  // Toggle the output clock
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
